package com.lindong.service;

import com.lindong.domain.UserCollect;

import java.util.List;
import java.util.Map;

public interface IUserCollectService extends IBaseService {

    /**
     * 添加用户收藏
     * @param userCollect
     * @return
     */
    boolean insertUserCollect(UserCollect userCollect);

    /**
     * 查询用户是否在已收藏该主题
     * @param map
     * @return
     */
    boolean selectCollectCountByMap(Map map);

    /**
     * 查询用户是否已收藏
     * @param map
     * @return
     */
    boolean hasCollectByMap(Map map);

    /**
     * 根据用户和业务id删除收藏
     * @param map
     * @return
     */
    boolean deleteCollectByMap(Map map);

    /**
     * 批量删除收藏数据
     * @param ids
     * @return
     */
    boolean deleteCollect(List<Integer> ids);

}
