package com.lindong.controller;

import com.lindong.exception.ApiResult;
import com.lindong.exception.ResultCode;
import com.lindong.service.IPrivateMsgService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("bbs/privateMsg")
public class PrivateMsgController {

    @Resource
    private IPrivateMsgService privateMsgService;

    @RequestMapping(value = "/listInbox", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> listInbox(@RequestBody Map<String, Object> params) {
        Integer userId = toInt(params.get("userId"));
        Integer pageNo = toInt(params.get("pageNo"));
        Integer pageSize = toInt(params.get("pageSize"));
        return privateMsgService.listInbox(userId, pageNo, pageSize);
    }

    @RequestMapping(value = "/listSession", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> listSession(@RequestBody Map<String, Object> params) {
        Integer userId = toInt(params.get("userId"));
        Integer peerId = toInt(params.get("peerId"));
        Map<String, Object> result = new HashMap<>();
        result.put("data", privateMsgService.listSession(userId, peerId));
        return result;
    }

    @RequestMapping(value = "/send", method = RequestMethod.POST)
    @ResponseBody
    public ApiResult send(@RequestBody Map<String, Object> msg) {
        if (msg.get("time") == null) {
            msg.put("time", System.currentTimeMillis());
        }
        privateMsgService.savePrivateMsg(msg);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping(value = "/unreadCount", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> unreadCount(@RequestBody Map<String, Object> params) {
        Integer userId = toInt(params.get("userId"));
        Map<String, Object> result = new HashMap<>();
        result.put("count", privateMsgService.unreadCount(userId));
        return result;
    }

    @RequestMapping(value = "/markSessionRead", method = RequestMethod.POST)
    @ResponseBody
    public ApiResult markSessionRead(@RequestBody Map<String, Object> params) {
        Integer userId = toInt(params.get("userId"));
        Integer peerId = toInt(params.get("peerId"));
        privateMsgService.markSessionRead(userId, peerId);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping(value = "/markAllRead", method = RequestMethod.POST)
    @ResponseBody
    public ApiResult markAllRead(@RequestBody Map<String, Object> params) {
        Integer userId = toInt(params.get("userId"));
        privateMsgService.markAllRead(userId);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping(value = "/deleteByIds", method = RequestMethod.POST)
    @ResponseBody
    public ApiResult deleteByIds(@RequestBody Map<String, Object> params) {
        Integer userId = toInt(params.get("userId"));
        List<Long> ids = toLongList(params.get("ids"));
        privateMsgService.deleteForUser(userId, ids);
        return ApiResult.of(ResultCode.SUCCESS);
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
