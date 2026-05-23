package com.lindong.controller;


import com.lindong.domain.Post;
import com.lindong.domain.SysWarn;
import com.lindong.domain.UserFriend;
import com.lindong.exception.ApiResult;
import com.lindong.exception.ResultCode;
import com.lindong.service.INotificationService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("bbs/notification")
public class NotificationController {
//    帖子回复、好友申请和系统警告
    @Resource
    private INotificationService notificationService;

    @RequestMapping("/selectNewestReply")
    @ResponseBody
    public Map selectNewestReply(@RequestBody Map map){
//        最新回复查询
        int total = notificationService.getCount(map);
        List<Post> lists = notificationService.paging(map);
        map.put("total",total);
        map.put("data",lists);
        return map;
    }

    @RequestMapping(value = "/alterReply",method = RequestMethod.POST)
    @ResponseBody
    public ApiResult alterReply(@RequestBody List<Integer> ids){
//        回复状态更新(如标记为已读)
        notificationService.alterPostDetails(ids);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping(value = "/listFriendApply",method = RequestMethod.POST)
    @ResponseBody
    public Map listFriendApply(@RequestBody Map map){
        // 好友申请列表
        int total = notificationService.getApplyCount(map);
        List<UserFriend> lists = notificationService.selectFriendApply(map);
        map.put("total",total);
        map.put("lists",lists);
        return map;
    }

    @RequestMapping(value = "/alterApply",method = RequestMethod.POST)
    @ResponseBody
    public ApiResult alterApply(@RequestBody List<Integer> ids){
//        好友申请处理
        notificationService.alterUserFriend(ids);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping(value = "/insertUserFriend",method = RequestMethod.POST)
    @ResponseBody
    public ApiResult insertUserFriend(@RequestBody UserFriend userFriend){
//        添加好友关系
        notificationService.insertUserFriend(userFriend);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping("listSysWarn")
    @ResponseBody
    public Map listSysWarn(@RequestBody Map map){
//        系统警告
        int total = notificationService.getCountSysWarn(map);
        List<SysWarn> data = notificationService.listSysWarn(map);
        map.put("data",data);
        map.put("total",total);
        return map;
    }

    @RequestMapping(value = "deleteSysWarnList",method = RequestMethod.POST)
    @ResponseBody
    public ApiResult deleteSysWarnList(@RequestBody List<Integer> ids){
//        删除系统警告
        notificationService.deleteSysWarnByList(ids);
        return ApiResult.of(ResultCode.SUCCESS);
    }

}
