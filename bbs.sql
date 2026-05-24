/*
 Navicat Premium Dump SQL

 Source Server         : Leek_bbs
 Source Server Type    : MySQL
 Source Server Version : 80031 (8.0.31)
 Source Host           : localhost:3306
 Source Schema         : tmp

 Target Server Type    : MySQL
 Target Server Version : 80031 (8.0.31)
 File Encoding         : 65001

 Date: 25/05/2025 22:22:57
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for attention
-- ----------------------------
DROP TABLE IF EXISTS `attention`;
CREATE TABLE `attention`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int NULL DEFAULT NULL COMMENT '用户id',
  `aid` int NULL DEFAULT NULL COMMENT '要关注的用户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '关注表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of attention
-- ----------------------------

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `n_id` int NOT NULL AUTO_INCREMENT,
  `n_title` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '公告标题',
  `n_content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '公告内容',
  `n_time` datetime NULL DEFAULT NULL COMMENT '发表时间',
  `n_in_plate_name` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '公告归属专区',
  `n_uid` int NULL DEFAULT NULL,
  `n_plate_id` int NULL DEFAULT NULL COMMENT '所属板块id',
  PRIMARY KEY (`n_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------

-- ----------------------------
-- Table structure for plate
-- ----------------------------
DROP TABLE IF EXISTS `plate`;
CREATE TABLE `plate`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `plate_name` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '板块名称',
  `plate_photo` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '板块图片',
  `theme` int NULL DEFAULT 0 COMMENT '板块主题数',
  `posts` int NULL DEFAULT 0 COMMENT '板块帖子数',
  `collect_total` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '0' COMMENT '板块被收藏数',
  `plate_vest` varchar(13) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '板块归属区',
  `reserve1` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '板块地址',
  `reserve2` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '预留字段2',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '板块表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of plate
-- ----------------------------
INSERT INTO `plate` VALUES (1, '部门交融', 'common_2_icon.png', 0, 0, '0', '企业专区', '各部门交流讨论', NULL);
INSERT INTO `plate` VALUES (2, '特长爱好', 'common_37_icon.png', 0, 0, '0', '企业专区', '兴趣特长', NULL);
INSERT INTO `plate` VALUES (3, '坊间趣事', 'common_38_icon.png', 0, 0, '0', '企业专区', '各类八卦', NULL);
INSERT INTO `plate` VALUES (4, '游戏交流', 'common_43_icon.png', 0, 0, '0', '交流与讨论', '游戏开黑', NULL);
INSERT INTO `plate` VALUES (5, '告白墙', 'common_49_icon.png', 0, 0, '0', '交流与讨论', '相亲角', NULL);
INSERT INTO `plate` VALUES (6, '兼职', 'common_41_icon.png', 0, 0, '0', '交流与讨论', '赚零花钱', NULL);
INSERT INTO `plate` VALUES (7, '资源共享', 'common_52_icon.png', 0, 0, '0', '交流与讨论', '学习资源共享', NULL);
INSERT INTO `plate` VALUES (8, '编程开发', 'common_53_icon.png', 0, 0, '0', '交流与讨论', '程序猿', NULL);
INSERT INTO `plate` VALUES (9, '综合交流', 'common_44_icon.png', 0, 0, '0', '交流与讨论', '爱聊啥聊啥', NULL);
INSERT INTO `plate` VALUES (10, '求助问答', 'common_40_icon.png', 0, 0, '0', '交流与讨论', '互帮互助', NULL);
INSERT INTO `plate` VALUES (11, '寻物启事', 'common_56_icon.jpg', 0, 0, '0', '交流与讨论', '寻找丢失物品', NULL);
INSERT INTO `plate` VALUES (12, '休闲灌水', 'common_50_icon.png', 0, 0, '0', '交流与讨论', '圈地自萌', NULL);

-- ----------------------------
-- Table structure for post
-- ----------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '帖子主题',
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '帖子内容',
  `user_id` int NULL DEFAULT NULL COMMENT '发帖者用户id',
  `browse_count` int UNSIGNED NULL DEFAULT 0 COMMENT '帖子被查看数',
  `reply_count` int UNSIGNED NULL DEFAULT 0 COMMENT '帖子回复数',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '帖子发表时间',
  `first_post` tinyint(1) NULL DEFAULT 0 COMMENT '是否新人帖(0.false,1.true)',
  `post_status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '6' COMMENT '帖子状态(0违规,1正常,2置顶,3推荐,4精华,5优秀,6未审核)',
  `post_heat` int UNSIGNED NULL DEFAULT 0 COMMENT '帖子热度(数量)',
  `share_count` int UNSIGNED NULL DEFAULT 0 COMMENT '帖子分享次数',
  `post_grade` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '1' COMMENT '帖子评分数',
  `post_collect` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '1' COMMENT '帖子被收藏数',
  `post_top` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '1' COMMENT '帖子被顶人数',
  `post_tread` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '1' COMMENT '帖子被踩人数',
  `post_author` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '帖子作者',
  `plate_id` int NULL DEFAULT NULL COMMENT '帖子所在板块',
  `last_reply` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '最后回复者',
  `last_reply_time` datetime NULL DEFAULT NULL COMMENT '最后回复时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '帖子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of post
-- ----------------------------

-- ----------------------------
-- Table structure for post_details
-- ----------------------------
DROP TABLE IF EXISTS `post_details`;
CREATE TABLE `post_details`  (
  `pid` int NOT NULL AUTO_INCREMENT,
  `pd_uid` int NULL DEFAULT NULL COMMENT '回复此帖子的用户id',
  `post_id` int NULL DEFAULT NULL COMMENT '帖子主题id',
  `pd_content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '帖子回复内容',
  `seat` varchar(6) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '位子(沙发,椅子,凳子,地毯,凉席,报纸,地板,地下室,下水道)',
  `reply_time` datetime NULL DEFAULT NULL COMMENT '帖子回复时间',
  `isLook` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '0' COMMENT '是否已查看',
  PRIMARY KEY (`pid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 81 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '帖子回复表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of post_details
-- ----------------------------

-- ----------------------------
-- Table structure for post_operation
-- ----------------------------
DROP TABLE IF EXISTS `post_operation`;
CREATE TABLE `post_operation`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `postId` int NULL DEFAULT NULL COMMENT '主题id',
  `uid` int NULL DEFAULT NULL COMMENT '用户id',
  `isCompletion` tinyint(1) NULL DEFAULT 1 COMMENT '是否已做操作(0.false,1.true)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '用户主题操作表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of post_operation
-- ----------------------------

-- ----------------------------
-- Table structure for post_share
-- ----------------------------
DROP TABLE IF EXISTS `post_share`;
CREATE TABLE `post_share`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL COMMENT '用户id',
  `post_id` int NULL DEFAULT NULL COMMENT '帖子主题id',
  `post_title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '帖子标题',
  `share_time` datetime NULL DEFAULT NULL,
  `plate_name` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '帖子所在板块',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '用户分享表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of post_share
-- ----------------------------

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '权限名称',
  `role_desc` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (1, 'admin', '超级管理员');
INSERT INTO `role` VALUES (2, 'boardmaster', '板块管理员');
INSERT INTO `role` VALUES (3, 'cuser', '系统用户');
INSERT INTO `role` VALUES (4, 'menu', '菜单管理员');

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '操作者',
  `operation` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '操作',
  `url` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '请求地址',
  `ip` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'ip',
  `create_time` datetime NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 283 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '系统日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_log
-- ----------------------------

-- ----------------------------
-- Table structure for u_collect
-- ----------------------------
DROP TABLE IF EXISTS `u_collect`;
CREATE TABLE `u_collect`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `u_id` int NULL DEFAULT NULL COMMENT '用户id',
  `all_id` int NULL DEFAULT NULL COMMENT '可以是帖子id,也可以是板块id,也可以是日志id',
  `title` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '标题',
  `source_plate` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '来源板块',
  `collect_time` varchar(19) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '收藏时间',
  `type` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '1.帖子,2.板块,3.日志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '用户所有收藏表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of u_collect
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '账号',
  `password` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '密码',
  `another_name` varchar(21) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '别名',
  `age` int NULL DEFAULT NULL COMMENT '年龄',
  `sex` char(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '性别',
  `email` varchar(21) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` bigint NULL DEFAULT NULL COMMENT '手机号码',
  `picture` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'statics/images/01_small.gif' COMMENT '用户头像',
  `register_time` datetime NULL DEFAULT NULL COMMENT '注册时间',
  `register_ip` varchar(17) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '注册ip',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(17) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '最后登录ip',
  `address` varchar(21) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '居住地址',
  `online_status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '在线状态(0不在线,1在线)',
  `user_status` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '1' COMMENT '用户状态(0禁止,1正常)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (4, 'admin', 'admin', '管理员', NULL, '男', '33321@qq.com', 15279515773, 'statics/images/toux2.jpg', '2025-05-21 13:38:00', '127.0.0.1', '2025-05-21 17:48:44', '127.0.0.1', '', '0', '1');

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL COMMENT '用户id',
  `role_id` int NULL DEFAULT NULL COMMENT '角色id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '用户角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO `user_role` VALUES (1, 4, 1);
INSERT INTO `user_role` VALUES (2, 4, 2);
INSERT INTO `user_role` VALUES (3, 4, 4);
INSERT INTO `user_role` VALUES (13, 4, 3);

SET FOREIGN_KEY_CHECKS = 1;
