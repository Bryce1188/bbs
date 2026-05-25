package com.lindong.controller;

import com.lindong.domain.Plate;
import com.lindong.domain.Post;
import com.lindong.domain.PostDetails;
import com.lindong.domain.UserCollect;
import com.lindong.exception.ApiResult;
import com.lindong.exception.CustomException;
import com.lindong.exception.ResultCode;
import com.lindong.service.IPlateService;
import com.lindong.service.IPostBrowseCommentService;
import com.lindong.service.IPostShareService;
import com.lindong.service.IUserCollectService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("bbs/postBrowse")
public class PostBrowseCommentController {
//    处理帖子浏览、评论、收藏、分享等功能
    @Resource
    private IPostBrowseCommentService postBrowseService;
    @Resource
    private IUserCollectService userCollectService;
    @Resource
    private IPlateService plateService;
    @Resource
    private IPostShareService postShareService;

    @RequestMapping("/findNewestPost")
    @ResponseBody
    public Map findNewestPost(){
//        获取最新帖子

        Map<String,String> map = new HashMap<>();
        //最新热度
        map.put("orderBy","post_heat");
        List<Post> postHeats = postBrowseService.selectNewestPosts(map);
        //最新发表
        map.put("orderBy","id");
        List<Post> postPublishs = postBrowseService.selectNewestPosts(map);
        //最新回复
        map.put("orderBy","last_reply_time");
        List<Post> postlastReplys = postBrowseService.selectNewestPosts(map);
        //最新精华
        map.put("orderBy","id");
        map.put("post_status","4");
        List<Post> postEssences = postBrowseService.selectNewestPosts(map);
        Map resultMap = new HashMap();
        resultMap.put("postHeats",postHeats);
        resultMap.put("postPublishs",postPublishs);
        resultMap.put("postlastReplys",postlastReplys);
        resultMap.put("postEssences",postEssences);
        //System.out.println("============="+JSON.toJSONString(resultMap));
        return resultMap;
    }

    @RequestMapping(value = "listPosts",method = RequestMethod.POST)
    @ResponseBody
    public Map listPosts(@RequestBody(required = true) Map map){    //必须为post请求
//        帖子分页列表
        int total = postBrowseService.getCount(map);
        List<Post> data = postBrowseService.paging(map);
        for (Post datum : data) {
            Integer uid = datum.getUser_id();
            Integer experience = postBrowseService.getExperienceById(uid);
            datum.setTotal_experience(experience);
            datum.setThemeCount(postBrowseService.getThemeCountById(uid));
            datum.setPostsCount(postBrowseService.getPostsCountById(uid));
            datum.setGrade(postBrowseService.getGrade(experience));
            for (PostDetails listPost : datum.getListPosts()) {
                Integer pd_uid = listPost.getPd_uid();
                Integer pd_experience = postBrowseService.getExperienceById(pd_uid);
                listPost.setTotal_experience(pd_experience);
                listPost.setThemeCount(postBrowseService.getThemeCountById(pd_uid));
                listPost.setPostsCount(postBrowseService.getPostsCountById(pd_uid));
                listPost.setGrade(postBrowseService.getGrade(pd_experience));
            }
        }
        Map resultMap = new HashMap();
        resultMap.put("total",total);
        resultMap.put("data",data);
        //System.out.println("========="+JSON.toJSONString(resultMap));
        return resultMap;
    }

    @RequestMapping(value = "/postReply",method = RequestMethod.POST)
    @ResponseBody
    public ApiResult postReply(@RequestBody(required = true) Map map){
//        发表回复
        int count = postBrowseService.getCount(map);    //获取指定主题总回复条数
        PostDetails postDetails = new PostDetails();
        //map.put("id",postDetails.getPost_id());
        postDetails.setPd_uid((Integer) map.get("pd_uid"));
        postDetails.setPost_id((Integer) map.get("post_id"));
        postDetails.setPd_content((String) map.get("pd_content"));
        postDetails.setSeat(++count+"");
        postBrowseService.insertPostDetails(postDetails);
        map.put("id",map.get("post_id"));
        map.put("reply_count",1);
        map.put("last_reply_time",1);
        postBrowseService.updatePost(map);      //更新主题数据
        Plate plate = new Plate();
        plate.setId((Integer) map.get("plate_id"));
        plate.setPosts(1);
        plateService.updatePlate(plate);    //更新板块中的帖子数
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping("/updatePosts")
    @ResponseBody
    public ApiResult updatePosts(@RequestBody Map map){
//        帖子点赞切换
        boolean isOperation = postBrowseService.selectThemeOperation(map);
        if (isOperation){
            postBrowseService.deleteThemeOperation(map);
            map.put("post_grade",1);
            map.put("post_grade_op","sub");
            postBrowseService.updatePost(map);
            ApiResult result = ApiResult.of(ResultCode.SUCCESS);
            result.setMsg("UNLIKE_SUCCESS");
            return result;
        }
        postBrowseService.insertThemeOperation(map);
        map.put("post_grade",1);
        map.put("post_grade_op","add");
        postBrowseService.updatePost(map);
        ApiResult result = ApiResult.of(ResultCode.SUCCESS);
        result.setMsg("LIKE_SUCCESS");
        return result;
    }

    @RequestMapping(value = "/postsCollect",method = RequestMethod.POST)
    @ResponseBody
    public ApiResult postsCollect(@RequestBody Map map){
//        收藏帖子切换
        if (userCollectService.hasCollectByMap(map)){
            userCollectService.deleteCollectByMap(map);
            map.put("post_collect",1);
            map.put("post_collect_op","sub");
            postBrowseService.updatePost(map);
            ApiResult result = ApiResult.of(ResultCode.SUCCESS);
            result.setMsg("UNCOLLECT_SUCCESS");
            return result;
        }
        UserCollect userCollect = new UserCollect();
        userCollect.setU_id((Integer)map.get("u_id"));
        userCollect.setAll_id((Integer)map.get("id"));
        userCollect.setTitle((String)map.get("title"));
        userCollect.setSource_plate((String)map.get("source_plate"));
        userCollect.setType((String)map.get("type"));
        userCollectService.insertUserCollect(userCollect);
        map.put("post_collect",1);
        map.put("post_collect_op","add");
        postBrowseService.updatePost(map);
        ApiResult result = ApiResult.of(ResultCode.SUCCESS);
        result.setMsg("COLLECT_SUCCESS");
        return result;
    }

    @RequestMapping(value = "/postsShare",method = RequestMethod.POST)
    @ResponseBody
    public ApiResult postsShare(@RequestBody Map<String,String> map){
//        分享帖子
        //判断帖子是否已分享过,否则抛异常
        postShareService.selectPostShareExist(map);
         //添加帖子分享数据
        postShareService.insertPostShare(map);
        map.put("id",map.get("post_id"));   //帖子主题id
        map.put("share_count","1"); //表示分享次数+1
        //更新帖子分享数
        postBrowseService.updatePost(map);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping(value = "/addAttention",method =RequestMethod.POST)
    @ResponseBody
    public ApiResult addAttention(@RequestBody Map map){
        Integer uid = (Integer) map.get("uid");
        Integer aid = (Integer) map.get("aid");
        if (uid == null || aid == null){
            throw new CustomException(ResultCode.DATA_ERROR);
        }
        if (uid.equals(aid)){
            throw new CustomException(ResultCode.AUTHORITY_ERROR);
        }
        postBrowseService.insertAttention(uid, aid);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping("/clickAddBrowseCount")
    @ResponseBody
    public Integer clickAddBrowseCount(@RequestParam("id") Integer id ){
        return postBrowseService.clickAddBrowseCount(id);
    }

    @RequestMapping("/getSearchPosts")
    @ResponseBody
    public Map getSearchPosts(@RequestBody Map map){
        return postBrowseService.getSearchPosts(map);
    }

}
