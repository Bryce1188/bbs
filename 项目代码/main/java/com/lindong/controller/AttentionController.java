package com.lindong.controller;

import com.lindong.domain.Post;
import com.lindong.domain.User;
import com.lindong.exception.ApiResult;
import com.lindong.exception.CustomException;
import com.lindong.exception.ResultCode;
import com.lindong.service.IAttentionService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("bbs/care")
public class AttentionController {
    // 用户关注
    @Resource
    private IAttentionService attentionService;

    @RequestMapping("/listCare")
    @ResponseBody
    public Map listCare(@RequestBody Map map){
        int total = attentionService.getCount(map);         // 获取关注总数
        List<User> users = attentionService.paging(map);    // 获取分页的用户列表
        map.put("total",total);
        map.put("data",users);
        return map;
    }

    @RequestMapping(value = "/deleteCare",method = RequestMethod.POST)
    @ResponseBody
    public ApiResult deleteCare(@RequestBody Map map){
        // 取消关注
        System.out.println(map.get("uid") +"======"+ map.get("aid"));
        if (map.get("uid") != null && map.get("aid") != null && map.get("uid").toString().equals(map.get("aid").toString())){
            throw new CustomException(ResultCode.AUTHORITY_ERROR);
        }
        attentionService.deleteAttention((Integer)map.get("uid"),(Integer)map.get("aid"));
        return ApiResult.of(ResultCode.SUCCESS);
    }

//    获取关注用户帖子列表
    @RequestMapping(value = "/listCarePosts",method = RequestMethod.GET)
    @ResponseBody
    public List<Post> listCarePosts(Integer uid){
        return attentionService.getCarePosts(uid);
    }

//    关注用户
    @RequestMapping(value = "/selectCare",method = RequestMethod.POST)
    @ResponseBody
    public ApiResult selectCare(@RequestBody Map map){
        if (map.get("uid") != null && map.get("aid") != null && map.get("uid").toString().equals(map.get("aid").toString())){
            throw new CustomException(ResultCode.AUTHORITY_ERROR);
        }
        attentionService.selectCare(map);
        return ApiResult.of(ResultCode.SUCCESS);
    }

}
