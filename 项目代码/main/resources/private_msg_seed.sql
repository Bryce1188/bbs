CREATE TABLE IF NOT EXISTS private_msg (
    id BIGINT NOT NULL AUTO_INCREMENT,
    src_user_id INT NOT NULL,
    tar_user_id INT NOT NULL,
    content TEXT,
    img VARCHAR(255) DEFAULT NULL,
    msg_time BIGINT NOT NULL,
    is_read TINYINT(1) NOT NULL DEFAULT 0,
    src_deleted TINYINT(1) NOT NULL DEFAULT 0,
    tar_deleted TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_pm_tar_read_time (tar_user_id, is_read, msg_time),
    KEY idx_pm_pair_time (src_user_id, tar_user_id, msg_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*
示例插入脚本（请将用户ID替换为实际ID）
insert into private_msg(src_user_id,tar_user_id,content,img,msg_time,is_read,src_deleted,tar_deleted)
values
(30,31,'今晚要不要一起看下接口文档？','statics/images/head_portrait/comiis_nologin.jpg',UNIX_TIMESTAMP(NOW())*1000,0,0,0);
*/

