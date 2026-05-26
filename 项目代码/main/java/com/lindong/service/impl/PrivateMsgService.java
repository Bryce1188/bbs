package com.lindong.service.impl;

import com.lindong.dao.IAttentionDao;
import com.lindong.dao.IPrivateMsgDao;
import com.lindong.exception.CustomException;
import com.lindong.exception.ResultCode;
import com.lindong.service.IPrivateMsgService;
import com.lindong.utils.PrivateMsgCryptoUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PrivateMsgService implements IPrivateMsgService {

    private static final long CHAT_LIMIT_WINDOW_MS = 24L * 60L * 60L * 1000L;
    private static final int STRANGER_DAILY_REACH_LIMIT = 5;

    @Resource
    private IPrivateMsgDao privateMsgDao;
    @Resource
    private IAttentionDao attentionDao;

    @Override
    public Map<String, Object> listInbox(Integer userId, Integer pageNo, Integer pageSize) {
        if (userId == null) {
            return Collections.emptyMap();
        }
        int safePageNo = pageNo == null || pageNo < 1 ? 1 : pageNo;
        int safePageSize = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int index = (safePageNo - 1) * safePageSize;
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("index", index);
        params.put("pageSize", safePageSize);
        int total = privateMsgDao.countInbox(params);
        List<Map<String, Object>> list = privateMsgDao.listInbox(params);
        decryptField(list, "content");
        Map<String, Object> result = new HashMap<>();
        result.put("total", total);
        result.put("lists", list);
        result.put("pageNo", safePageNo);
        result.put("pageSize", safePageSize);
        return result;
    }

    @Override
    public Map<String, Object> listConversations(Integer userId, Integer pageNo, Integer pageSize) {
        if (userId == null) {
            return Collections.emptyMap();
        }
        int safePageNo = pageNo == null || pageNo < 1 ? 1 : pageNo;
        int safePageSize = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int index = (safePageNo - 1) * safePageSize;
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("index", index);
        params.put("pageSize", safePageSize);
        int total = privateMsgDao.countConversations(params);
        List<Map<String, Object>> list = privateMsgDao.listConversations(params);
        decryptField(list, "lastContent");
        Map<String, Object> result = new HashMap<>();
        result.put("total", total);
        result.put("lists", list);
        result.put("pageNo", safePageNo);
        result.put("pageSize", safePageSize);
        return result;
    }

    @Override
    public List<Map<String, Object>> listSession(Integer userId, Integer peerId) {
        if (userId == null || peerId == null) {
            return Collections.emptyList();
        }
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("peerId", peerId);
        List<Map<String, Object>> list = privateMsgDao.listSession(params);
        decryptField(list, "content");
        return list;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean savePrivateMsg(Map<String, Object> msg) {
        Integer srcUserId = toInt(msg.get("srcUserId"));
        Integer tarUserId = toInt(msg.get("tarUserId"));
        if (srcUserId == null || tarUserId == null) {
            throw new CustomException(ResultCode.DATA_ERROR);
        }
        if (srcUserId.equals(tarUserId)) {
            throw new CustomException(ResultCode.AUTHORITY_ERROR);
        }
        msg.put("srcUserId", srcUserId);
        msg.put("tarUserId", tarUserId);
        Object rawContent = msg.get("content");
        if (rawContent == null) {
            throw new CustomException(ResultCode.DATA_ERROR);
        }
        msg.put("content", PrivateMsgCryptoUtil.encrypt(String.valueOf(rawContent)));
        Long msgTime = toLong(msg.get("time"));
        if (msgTime == null) {
            msgTime = System.currentTimeMillis();
            msg.put("time", msgTime);
        }
        long sinceTime = msgTime - CHAT_LIMIT_WINDOW_MS;
        boolean isAdmin = toBoolean(msg.get("isAdmin"));

        // Level 3：互关好友，直接放行
        boolean sourceFollowTarget = isFollowing(srcUserId, tarUserId);
        boolean targetFollowSource = isFollowing(tarUserId, srcUserId);
        if (sourceFollowTarget && targetFollowSource) {
            return privateMsgDao.insertPrivateMsg(msg) > 0;
        }

        // Level 2：对方已回复过，直接放行
        boolean receiverHasMessagedSender = privateMsgDao.countDirectionalMessages(tarUserId, srcUserId) > 0;
        if (receiverHasMessagedSender) {
            return privateMsgDao.insertPrivateMsg(msg) > 0;
        }

        // Level 0 / Level 1：对方未回复前，24小时内同一对象仅允许1条
        if (privateMsgDao.countDirectionalMessagesSince(srcUserId, tarUserId, sinceTime) > 0) {
            throw new CustomException(ResultCode.CHAT_WAIT_REPLY);
        }

        // Level 0：陌生人触达人数限制（普通用户5人/24小时，管理员不限）
        boolean isStranger = !sourceFollowTarget && !targetFollowSource;
        if (isStranger && !isAdmin) {
            int strangerTouchedCount = privateMsgDao.countDistinctUnrepliedStrangersContactedSince(srcUserId, sinceTime);
            if (strangerTouchedCount >= STRANGER_DAILY_REACH_LIMIT) {
                throw new CustomException(ResultCode.CHAT_STRANGER_DAILY_LIMIT);
            }
        }

        return privateMsgDao.insertPrivateMsg(msg) > 0;
    }

    @Override
    public int unreadCount(Integer userId) {
        if (userId == null) {
            return 0;
        }
        return privateMsgDao.unreadCount(userId);
    }

    @Override
    public boolean markConversationUnread(Integer userId, Integer peerId) {
        if (userId == null || peerId == null) {
            return false;
        }
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("peerId", peerId);
        return privateMsgDao.markConversationUnread(params) > 0;
    }

    @Override
    public boolean hideConversation(Integer userId, Integer peerId) {
        if (userId == null || peerId == null) {
            return false;
        }
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("peerId", peerId);
        privateMsgDao.hideConversationAsReceiver(params);
        privateMsgDao.hideConversationAsSender(params);
        return true;
    }

    @Override
    public boolean markSessionRead(Integer userId, Integer peerId) {
        if (userId == null || peerId == null) {
            return false;
        }
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("peerId", peerId);
        privateMsgDao.markSessionRead(params);
        return true;
    }

    @Override
    public boolean markAllRead(Integer userId) {
        if (userId == null) {
            return false;
        }
        privateMsgDao.markAllRead(userId);
        return true;
    }

    @Override
    public boolean deleteForUser(Integer userId, List<Long> ids) {
        if (userId == null || ids == null || ids.isEmpty()) {
            return false;
        }
        privateMsgDao.deleteAsReceiver(userId, ids);
        privateMsgDao.deleteAsSender(userId, ids);
        return true;
    }

    @Override
    public List<Object> paging(Map<String, Object> param) {
        return null;
    }

    @Override
    public int getCount(Map<String, Object> param) {
        return 0;
    }

    @Override
    public Object getObjectById(Integer id) {
        return null;
    }

    @Override
    public Object getObjectByName(String name) {
        return null;
    }

    private Integer toInt(Object value) {
        if (value == null) {
            return null;
        }
        try {
            return Integer.parseInt(String.valueOf(value));
        } catch (Exception e) {
            return null;
        }
    }

    private Long toLong(Object value) {
        if (value == null) {
            return null;
        }
        try {
            return Long.parseLong(String.valueOf(value));
        } catch (Exception e) {
            return null;
        }
    }

    private boolean toBoolean(Object value) {
        if (value == null) {
            return false;
        }
        return Boolean.parseBoolean(String.valueOf(value));
    }

    private boolean isFollowing(Integer uid, Integer aid) {
        Map<String, Integer> params = new HashMap<>();
        params.put("uid", uid);
        params.put("aid", aid);
        return attentionDao.selectCare(params) > 0;
    }

    private void decryptField(List<Map<String, Object>> rows, String fieldName) {
        if (rows == null || rows.isEmpty() || fieldName == null) {
            return;
        }
        for (Map<String, Object> row : rows) {
            if (row == null) {
                continue;
            }
            Object raw = row.get(fieldName);
            if (raw == null) {
                continue;
            }
            row.put(fieldName, PrivateMsgCryptoUtil.decrypt(String.valueOf(raw)));
        }
    }

}
