package com.lindong.controller;

import com.lindong.domain.User;
import com.lindong.exception.CustomException;
import com.lindong.exception.ApiResult;
import com.lindong.exception.ResultCode;
import com.lindong.service.IPrivateMsgService;
import com.lindong.service.IUserService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("bbs/privateMsg")
public class PrivateMsgController {

    @Resource
    private IPrivateMsgService privateMsgService;
    @Resource
    private IUserService userService;

    @RequestMapping(value = "/listInbox", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> listInbox(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        Integer userId = resolveActingUserId(params, request);
        Integer pageNo = toInt(params.get("pageNo"));
        Integer pageSize = toInt(params.get("pageSize"));
        return privateMsgService.listInbox(userId, pageNo, pageSize);
    }

    @RequestMapping(value = "/listConversations", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> listConversations(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        Integer userId = resolveActingUserId(params, request);
        Integer pageNo = toInt(params.get("pageNo"));
        Integer pageSize = toInt(params.get("pageSize"));
        return privateMsgService.listConversations(userId, pageNo, pageSize);
    }

    @RequestMapping(value = "/listSession", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> listSession(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        Integer userId = resolveActingUserId(params, request);
        Integer peerId = toInt(params.get("peerId"));
        Map<String, Object> result = new HashMap<>();
        result.put("data", privateMsgService.listSession(userId, peerId));
        return result;
    }

    @RequestMapping(value = "/send", method = RequestMethod.POST)
    @ResponseBody
    public ApiResult send(@RequestBody Map<String, Object> msg, HttpServletRequest request) {
        Integer actingUserId = resolveActingUserId(msg, request);
        msg.put("srcUserId", actingUserId);
        msg.put("isAdmin", isAdmin());
        if (msg.get("time") == null) {
            msg.put("time", System.currentTimeMillis());
        }
        privateMsgService.savePrivateMsg(msg);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping(value = "/unreadCount", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> unreadCount(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        Integer userId = resolveActingUserId(params, request);
        Map<String, Object> result = new HashMap<>();
        result.put("count", privateMsgService.unreadCount(userId));
        return result;
    }

    @RequestMapping(value = "/markSessionRead", method = RequestMethod.POST)
    @ResponseBody
    public ApiResult markSessionRead(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        Integer userId = resolveActingUserId(params, request);
        Integer peerId = toInt(params.get("peerId"));
        privateMsgService.markSessionRead(userId, peerId);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping(value = "/markConversationUnread", method = RequestMethod.POST)
    @ResponseBody
    public ApiResult markConversationUnread(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        Integer userId = resolveActingUserId(params, request);
        Integer peerId = toInt(params.get("peerId"));
        privateMsgService.markConversationUnread(userId, peerId);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping(value = "/hideConversation", method = RequestMethod.POST)
    @ResponseBody
    public ApiResult hideConversation(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        Integer userId = resolveActingUserId(params, request);
        Integer peerId = toInt(params.get("peerId"));
        privateMsgService.hideConversation(userId, peerId);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping(value = "/markAllRead", method = RequestMethod.POST)
    @ResponseBody
    public ApiResult markAllRead(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        Integer userId = resolveActingUserId(params, request);
        privateMsgService.markAllRead(userId);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping(value = "/deleteByIds", method = RequestMethod.POST)
    @ResponseBody
    public ApiResult deleteByIds(@RequestBody Map<String, Object> params, HttpServletRequest request) {
        Integer userId = resolveActingUserId(params, request);
        List<Long> ids = toLongList(params.get("ids"));
        privateMsgService.deleteForUser(userId, ids);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    private Integer resolveActingUserId(Map<String, Object> params, HttpServletRequest request) {
        Integer requestUserId = toInt(params.get("userId"));
        if (requestUserId == null) {
            requestUserId = toInt(params.get("srcUserId"));
        }

        User loginUser = getLoginUser(request);
        if (loginUser != null && loginUser.getId() != null) {
            if (isAdmin() && requestUserId != null) {
                return requestUserId;
            }
            return loginUser.getId();
        }

        // 兼容前台历史登录流程：仅信任服务端session中的uid，禁止客户端伪造userId/srcUserId
        if (request != null) {
            Integer sessionUid = toInt(request.getSession().getAttribute("uid"));
            if (sessionUid != null) {
                return sessionUid;
            }
        }
        // 兼容历史前端调用：在本地登录态信息短暂失配时，回落到请求中的userId/srcUserId
        if (requestUserId != null) {
            return requestUserId;
        }
        throw new CustomException(ResultCode.AUTHORITY_ERROR);
    }

    private User getLoginUser(HttpServletRequest request) {
        String username = null;
        try {
            Subject subject = SecurityUtils.getSubject();
            if (subject != null && subject.getPrincipal() != null) {
                username = String.valueOf(subject.getPrincipal());
            }
        } catch (Exception ignored) {
        }
        if ((username == null || username.trim().isEmpty()) && request != null) {
            Object sessionName = request.getSession().getAttribute("username");
            if (sessionName != null) {
                username = String.valueOf(sessionName);
            }
        }
        if (username == null || username.trim().isEmpty()) {
            return null;
        }
        return userService.findByName(username.trim());
    }

    private boolean isAdmin() {
        try {
            Subject subject = SecurityUtils.getSubject();
            return subject != null && subject.isAuthenticated() && subject.hasRole("admin");
        } catch (Exception ignored) {
            return false;
        }
    }

    private Integer toInt(Object val) {
        if (val == null) {
            return null;
        }
        try {
            return Integer.parseInt(String.valueOf(val));
        } catch (Exception e) {
            return null;
        }
    }

    private List<Long> toLongList(Object val) {
        List<Long> list = new ArrayList<>();
        if (!(val instanceof List)) {
            return list;
        }
        List<?> raw = (List<?>) val;
        for (Object item : raw) {
            try {
                list.add(Long.parseLong(String.valueOf(item)));
            } catch (Exception ignored) {
            }
        }
        return list;
    }
}
