package com.lindong.service.impl;

import com.lindong.dao.IPostReportDao;
import com.lindong.dao.IPostsDetailsManageDao;
import com.lindong.dao.IPostsManageDao;
import com.lindong.domain.Post;
import com.lindong.exception.CustomException;
import com.lindong.exception.ResultCode;
import com.lindong.service.IPostReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PostReportService implements IPostReportService {

    @Autowired
    private IPostReportDao reportDao;
    @Autowired
    private IPostsDetailsManageDao postsDetailsManageDao;
    @Autowired
    private IPostsManageDao postsManageDao;

    @Override
    public boolean selectPostReport(Map<String, Integer> params) {
        int i = reportDao.selectPostReport(params);
        if (i > 0){
            throw new CustomException(ResultCode.REPORT_EXIST);
        }
        return true;
    }

    @Override
    public boolean insertPostReport(Map<String,String> map) {
        int i = reportDao.insertPostReport(map);
        if (i == 0){
            throw new CustomException(ResultCode.REPORT_ERROR);
        }
        return true;
    }

    @Override
    public boolean deletePostReport(List<Integer> ids) {
        int i = reportDao.deletePostReport(ids);
        if (i == 0){
            throw new CustomException(ResultCode.DELETE_ERROR);
        }
        return true;
    }

    @Override
    public Post getPost(Integer id) {
        return reportDao.getPost(id);
    }

    @Transactional(rollbackFor=CustomException.class)
    @Override
    public boolean disposeReport(Map<String, Object> params) {
        int id = Integer.parseInt(params.get("id").toString());
        int i1 = reportDao.alterPostReport(id);
        if (i1 == 0){
            throw new CustomException(ResultCode.REPORT_DISPOSE_ERROR);
        }
        String rpType = params.get("rp_type").toString();
        boolean approved = params.get("digit").equals("1");
        if (approved && (rpType.equals("1") || rpType.equals("2"))){     //举报通过,对举报数据进行处理
            Integer pid = Integer.parseInt(params.get("pid").toString());
            Integer ownerId = rpType.equals("1") ? reportDao.getPostOwnerId(pid) : reportDao.getPostDetailsOwnerId(pid);
            if (ownerId == null){
                throw new CustomException(ResultCode.REPORT_DISPOSE_ERROR);
            }
            String reason = params.get("r_type") == null ? "违规内容" : params.get("r_type").toString();
            String targetName = rpType.equals("1") ? "主题" : "回帖";
            params.put("uid", ownerId);
            params.put("title", "内容下架通知");
            params.put("content", "你的" + targetName + "因“" + reason + "”被举报，管理员审核通过后已下架。如你认为处理有误，可以在本通知中提交申诉。 [APPEAL:pid=" + pid + ",type=" + rpType + "]");
            List<Integer> ids = new ArrayList<>();
            if (rpType.equals("1")){       //对主题数据进行处理
                ids.add(pid);
                Map<String,Object> map = new HashMap();
                map.put("ids",ids);
                map.put("post_status","0");
                int i = postsManageDao.alterPosts(map);
                if (i == 0){
                    throw new CustomException(ResultCode.REPORT_DISPOSE_ERROR);
                }
            }else{                      //对帖子数据进行处理
                ids.add(pid);
                int i = postsDetailsManageDao.deletePostsDetails(ids);
                if (i == 0){
                    throw new CustomException(ResultCode.REPORT_DISPOSE_ERROR);
                }
            }
        }
        int i2 = reportDao.insertWarnList(params);
        if (i2 == 0){
            throw new CustomException(ResultCode.REPORT_DISPOSE_ERROR);
        }
        return true;
    }

    @Override
    public List<Object> paging(Map<String, Object> param) {
        Integer pageNo = (Integer) param.get("pageNo");
        Integer pageSize = (Integer) param.get("pageSize");
        Integer index = (pageNo - 1) * pageSize;
        param.put("index",index);
        return reportDao.paging(param);
    }

    @Override
    public int getCount(Map<String, Object> param) {
        return reportDao.getCount(param);
    }

    @Override
    public Object getObjectById(Integer id) {
        return reportDao.getObjectById(id);
    }

    @Override
    public Object getObjectByName(String name) {
        return reportDao.getObjectByName(name);
    }

    @Override
    public boolean canAppeal(Map<String, Object> params) {
        if (params == null) {
            return false;
        }
        Object uidObj = params.get("uid");
        Object pidObj = params.get("pid");
        Object rpTypeObj = params.get("rp_type");
        if (uidObj == null || pidObj == null || rpTypeObj == null) {
            return false;
        }
        Integer uid = Integer.parseInt(uidObj.toString());
        Integer pid = Integer.parseInt(pidObj.toString());
        Integer rpType = Integer.parseInt(rpTypeObj.toString());
        Integer baseType;
        if (rpType == 11) {
            baseType = 1;
        } else if (rpType == 12) {
            baseType = 2;
        } else if (rpType == 1 || rpType == 2) {
            baseType = rpType;
        } else {
            return false;
        }

        return reportDao.countAppealNotice(uid, pid, baseType) > 0;
    }
}
