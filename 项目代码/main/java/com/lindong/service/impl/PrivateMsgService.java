package com.lindong.service.impl;

import com.lindong.dao.IPrivateMsgDao;
import com.lindong.service.IPrivateMsgService;
import org.springframework.stereotype.Service;

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
    public boolean savePrivateMsg(Map<String, Object> msg) {
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
}

