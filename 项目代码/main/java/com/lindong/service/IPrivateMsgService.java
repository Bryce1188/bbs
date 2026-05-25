package com.lindong.service;

import java.util.List;
import java.util.Map;

public interface IPrivateMsgService extends IBaseService {

    Map<String, Object> listInbox(Integer userId, Integer pageNo, Integer pageSize);

    Map<String, Object> listConversations(Integer userId, Integer pageNo, Integer pageSize);

    List<Map<String, Object>> listSession(Integer userId, Integer peerId);

    boolean savePrivateMsg(Map<String, Object> msg);

    int unreadCount(Integer userId);

    boolean markConversationUnread(Integer userId, Integer peerId);

    boolean hideConversation(Integer userId, Integer peerId);

    boolean markSessionRead(Integer userId, Integer peerId);

    boolean markAllRead(Integer userId);

    boolean deleteForUser(Integer userId, List<Long> ids);
}
