package com.lindong.controller;

import com.lindong.exception.ApiResult;
import com.lindong.exception.ResultCode;
import com.lindong.service.IPostReportService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/bbs/postReport")
public class PostReportController {
    //  帖子举报/申诉
    @Resource
    private IPostReportService postReportSevice;

    @RequestMapping("/executeReport")
    @ResponseBody
    public ApiResult executeReport(@RequestBody Map params){
        Integer rpType = Integer.parseInt(params.get("rp_type").toString());
        // 申诉类型(11:主题申诉,12:回帖申诉)必须通过校验
        if (rpType == 11 || rpType == 12) {
            boolean allowed = postReportSevice.canAppeal(params);
            if (!allowed) {
                ApiResult result = new ApiResult();
                result.setCode("600099");
                result.setMsg("该内容未被举报，或您不是被举报人，不能申诉");
                return result;
            }
        }
        // 查询用户是否已经提交过同类举报/申诉
        postReportSevice.selectPostReport(params);
        // 插入举报/申诉数据
        postReportSevice.insertPostReport(params);
        return ApiResult.of(ResultCode.SUCCESS);
    }

    @RequestMapping("/canAppeal")
    @ResponseBody
    public Map<String,Object> canAppeal(@RequestBody Map params){
        boolean allowed = postReportSevice.canAppeal(params);
        Map<String,Object> result = new HashMap<>();
        result.put("code","500020");
        result.put("canAppeal",allowed);
        result.put("msg", allowed ? "ok" : "该内容未被举报，或您不是被举报人，不能申诉");
        return result;
    }
}
