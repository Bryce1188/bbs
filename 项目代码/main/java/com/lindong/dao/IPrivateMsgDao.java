package com.lindong.dao;

import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface IPrivateMsgDao extends IBaseDao {

    List<Map<String, Object>> listInbox(Map<String, Object> params);

    int countInbox(Map<String, Object> params);

    List<Map<String, Object>> listSession(Map<String, Object> params);

    int insertPrivateMsg(Map<String, Object> params);

    int markSessionRead(Map<String, Object> params);

    int markAllRead(@Param("userId") Integer userId);

    int unreadCount(@Param("userId") Integer userId);

    int deleteAsReceiver(@Param("userId") Integer userId, @Param("ids") List<Long> ids);

    int deleteAsSender(@Param("userId") Integer userId, @Param("ids") List<Long> ids);
}

