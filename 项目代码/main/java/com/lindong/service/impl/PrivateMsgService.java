package com.lindong.service.impl;

import com.lindong.dao.IPrivateMsgDao;
import com.lindong.exception.CustomException;
import com.lindong.exception.ResultCode;
import com.lindong.service.IPrivateMsgService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PrivateMsgService implements IPrivateMsgService {

    @Resource
    private IPrivateMsgDao privateMsgDao;

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
        return privateMsgDao.listSession(params);
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

        // 对方已发过消息给我：判定为“已回复”，解除限制可继续聊天
        boolean receiverHasMessagedSender = privateMsgDao.countDirectionalMessages(tarUserId, srcUserId) > 0;
        if (receiverHasMessagedSender) {
            return privateMsgDao.insertPrivateMsg(msg) > 0;
        }

        // 未收到对方回复前：每个会话只允许先发一条
        if (privateMsgDao.countDirectionalMessages(srcUserId, tarUserId) > 0) {
            throw new CustomException(ResultCode.CHAT_WAIT_REPLY);
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

}
