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
INSERT INTO `attention` VALUES (21, 21, 23);
INSERT INTO `attention` VALUES (22, 25, 24);
INSERT INTO `attention` VALUES (24, 28, 23);
INSERT INTO `attention` VALUES (25, 27, 19);

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
INSERT INTO `notice` VALUES (1, '测试公告', 'xdtrcftvgybhunjmk', '2025-05-14 11:43:07', '游戏交流', 1, 4);
INSERT INTO `notice` VALUES (2, 'dfgyh', 'cdftvgbnjkm<img src=\"http://localhost:8080/leek_bbs/statics/layui/images/face/1.gif\" alt=\"[嘻嘻]\">', '2025-06-17 09:27:13', '校园趣事', 1, 3);
INSERT INTO `notice` VALUES (3, '测试表白墙公告', '<p>测试表白墙公告测试表白墙公告</p>', '2025-01-04 13:56:47', '告白墙', 1, 5);

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
INSERT INTO `plate` VALUES (1, '部门交融', 'common_2_icon.png', 7, 3, '325', '企业专区', '各部门交流讨论', NULL);
INSERT INTO `plate` VALUES (2, '特长爱好', 'common_37_icon.png', 3, 0, '325', '企业专区', '兴趣特长', NULL);
INSERT INTO `plate` VALUES (3, '坊间趣事', 'common_38_icon.png', 7, 4, '325', '企业专区', '各类八卦', NULL);
INSERT INTO `plate` VALUES (4, '游戏交流', 'common_43_icon.png', 22, 2, '325', '交流与讨论', '游戏开黑', NULL);
INSERT INTO `plate` VALUES (5, '告白墙', 'common_49_icon.png', 6, 0, '325', '交流与讨论', '相亲角', NULL);
INSERT INTO `plate` VALUES (6, '兼职', 'common_41_icon.png', 2, 1, '325', '交流与讨论', '赚零花钱', NULL);
INSERT INTO `plate` VALUES (7, '资源共享', 'common_52_icon.png', 4, 1, '325', '交流与讨论', '学习资源共享', NULL);
INSERT INTO `plate` VALUES (8, '编程开发', 'common_53_icon.png', 3, 3, '325', '交流与讨论', '程序猿', NULL);
INSERT INTO `plate` VALUES (9, '综合交流', 'common_44_icon.png', 2, 1, '325', '交流与讨论', '爱聊啥聊啥', NULL);
INSERT INTO `plate` VALUES (10, '求助问答', 'common_40_icon.png', 1, 1, '325', '交流与讨论', '互帮互助', NULL);
INSERT INTO `plate` VALUES (11, '寻物启事', 'common_56_icon.jpg', 0, 0, '325', '交流与讨论', '寻找丢失物品', NULL);
INSERT INTO `plate` VALUES (12, '休闲灌水', 'common_50_icon.png', 3, 1, '325', '交流与讨论', '圈地自萌', NULL);

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
INSERT INTO `post` VALUES (38, '我期中考试过辣', '<p>一支笔一个夜晚一个奇迹<img src=\"http://img.t.sinajs.cn/t4/appstyle/expression/ext/normal/40/pcmoren_tian_org.png\" alt=\"[舔屏]\" data-w-e=\"1\"></p>', 1, 0, 3, '2025-05-21 15:13:01', 0, '1', 0, 0, '1', '4', '2', '1', '001-1号', 9, 'user', '2025-05-21 20:43:57');
INSERT INTO `post` VALUES (39, '赛尔号没了', '<p>太伤心了</p>', 1, 0, 2, '2025-05-21 15:13:24', 0, '1', 0, 0, '1', '1', '1', '1', '001-1号', 4, 'user', '2025-05-21 17:13:38');
INSERT INTO `post` VALUES (41, '计电院', '<p>我今天做完了软工课设</p>', 8, 0, 3, '2025-05-21 15:17:31', 0, '1', 0, 0, '2', '2', '1', '1', '008-8号', 1, 'user', '2025-05-21 17:13:09');
INSERT INTO `post` VALUES (42, 'python', '<p>人生苦短我学python</p>', 8, 0, 0, '2025-05-21 15:18:01', 0, '1', 0, 0, '1', '1', '1', '1', '008-8号', 8, '008-8号', '2025-05-21 15:18:01');
INSERT INTO `post` VALUES (43, '篮球', '<p>来个篮球搭子</p>', 8, 0, 3, '2025-05-21 15:18:32', 0, '1', 0, 0, '1', '1', '1', '1', '008-8号', 12, 'sfd', '2025-05-21 15:38:49');
INSERT INTO `post` VALUES (44, '大众书局', '<p>大众书局二楼瑞幸咖啡真好喝</p>', 8, 0, 1, '2025-05-21 15:19:00', 0, '1', 0, 0, '1', '1', '1', '1', '008-8号', 7, 'fggg', '2025-05-21 15:31:56');
INSERT INTO `post` VALUES (45, '520', '<p>不会有人520还在做软工吧</p>', 8, 0, 1, '2025-05-21 15:19:39', 0, '1', 0, 0, '1', '1', '1', '1', '008-8号', 3, 'fggg', '2025-05-21 15:24:03');
INSERT INTO `post` VALUES (46, 'javaspring怎么学', '<p>前后端axios怎么联调，总是对不上</p>', 23, 0, 1, '2025-05-21 15:27:39', 0, '1', 0, 0, '1', '1', '1', '1', 'zhang', 10, 'qjl', '2025-05-21 15:43:51');
INSERT INTO `post` VALUES (47, '管理员审核太慢了', '<p>能不能审核快一点</p>', 23, 0, 0, '2025-05-21 15:28:15', 0, '1', 0, 0, '1', '1', '1', '1', 'zhang', 15, 'zhang', '2025-05-21 15:28:15');
INSERT INTO `post` VALUES (48, 'mc那个钻石怎么挖', '<p>我挖了好几天了怎么还挖不到</p>', 23, 0, 0, '2025-05-21 15:30:29', 0, '1', 0, 0, '1', '2', '1', '1', 'zhang', 4, 'zhang', '2025-05-21 15:30:29');
INSERT INTO `post` VALUES (49, 'mysql', '<p>MySQL数据库服务是一个完全托管的数据库服务，可使用世界上最受欢迎的开源数据库来部署云原生应用程序。 它是百分百由MySQL原厂开发，管理和提供支持。</p>', 19, 0, 0, '2025-05-21 15:35:11', 0, '1', 0, 0, '1', '1', '1', '1', 'Ye~fbew', 8, 'Ye~fbew', '2025-05-21 15:35:11');
INSERT INTO `post` VALUES (50, 'redis', '<p>设置临时密码（server重启后就无效了）<br>./redis-cli # 进入连接<br><br>config get requirepass #查看现在的需要密码<br>1) “requirepass”<br>2) “”<br>可以看出来现在还不需要密码<br>config set requirepass 123456 #设置临时密码<br>config get requirepass 再查看密码<br><br>上面设置完临时密码之后，关闭连接，重新进来之后如果需要访问数据就要认证了<br>————————————————<br><br>                            版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。<br>                        <br>原文链接：https://blog.csdn.net/weixin_38858749/article/details/124686796</p>', 19, 0, 0, '2025-05-21 15:36:20', 0, '1', 0, 0, '1', '1', '1', '1', 'Ye~fbew', 8, 'Ye~fbew', '2025-05-21 15:36:20');
INSERT INTO `post` VALUES (51, '大创', '<p>有没有组大创的，我带你们</p>', 24, 0, 0, '2025-05-21 15:41:10', 0, '1', 0, 0, '1', '1', '1', '1', 'qjl', 1, 'qjl', '2025-05-21 15:41:10');
INSERT INTO `post` VALUES (53, '蓝桥杯', '<p>有没有和我一起打蓝桥杯的，一起学习</p>', 24, 0, 0, '2025-05-21 15:42:09', 0, '1', 0, 0, '1', '1', '1', '1', 'qjl', 9, 'qjl', '2025-05-21 15:42:09');
INSERT INTO `post` VALUES (56, 'Test', '<p>测试</p>', 28, 0, 0, '2025-05-23 14:54:36', 0, '1', 0, 0, '1', '1', '1', '1', 'Test', 4, 'Test', '2025-05-23 14:54:36');
INSERT INTO `post` VALUES (60, 'Test2', '<p>123</p>', 27, 0, 0, '2025-05-23 17:07:39', 0, '1', 0, 0, '1', '1', '1', '1', '123123', 4, '123123', '2025-05-23 17:07:39');
INSERT INTO `post` VALUES (61, 'Test3', '<p>213</p>', 27, 0, 0, '2025-05-23 17:07:45', 0, '1', 0, 0, '1', '1', '1', '1', '123123', 4, '123123', '2025-05-23 17:07:45');

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
INSERT INTO `post_details` VALUES (63, 8, 38, '<p>哇塞，你好帅啊</p>', '1', '2025-05-21 15:16:52', '0');
INSERT INTO `post_details` VALUES (64, 8, 39, '<p>不是哥们</p>', '1', '2025-05-21 15:21:41', '0');
INSERT INTO `post_details` VALUES (65, 8, 40, '<p>带带我</p>', '1', '2025-05-21 15:21:54', '0');
INSERT INTO `post_details` VALUES (66, 8, 43, '<p>快来</p>', '1', '2025-05-21 15:22:07', '0');
INSERT INTO `post_details` VALUES (68, 23, 45, '<p>闭嘴</p>', '1', '2025-05-21 15:24:03', '0');
INSERT INTO `post_details` VALUES (69, 23, 43, '<p>我</p>', '1', '2025-05-21 15:24:11', '0');
INSERT INTO `post_details` VALUES (70, 23, 40, '<div class=\"citeReply\" style=\"margin-bottom: 20px;\">\n                                <div style=\"position: absolute;left:-8px;top:4px;font-size: 32px;opacity: .6;\">“</div>\n                                <spna style=\"margin-left:15px;opacity: 0.7\">008-8号&nbsp;&nbsp;发表于&nbsp;2025-05-21 15:21</spna><br>\n                                <div class=\"text-hidden\"><p>带带我</p></div>\n                                <div style=\"position:absolute;right:-6px;bottom:-12px;font-size: 32px;opacity: .6;\">”</div>\n                            </div><p>还有我</p>', '1', '2025-05-21 15:29:23', '0');
INSERT INTO `post_details` VALUES (71, 23, 41, '<p>巧了我也是</p>', '1', '2025-05-21 15:31:14', '0');
INSERT INTO `post_details` VALUES (72, 23, 44, '<p>9.9</p>', '1', '2025-05-21 15:31:56', '0');
INSERT INTO `post_details` VALUES (73, 19, 41, '<p>me too</p>', '1', '2025-05-21 15:37:28', '0');
INSERT INTO `post_details` VALUES (74, 19, 43, '<p>+1</p>', '1', '2025-05-21 15:38:49', '0');
INSERT INTO `post_details` VALUES (75, 24, 46, '<p>AJAX = Asynchronous JavaScript and XML（异步的 JavaScript 和 XML）。<br><br>—— 异步网络请求 —— Ajax能够让页面无刷新的请求数据 ——<br>AJAX 不是新的编程语言，而是一种使用现有标准的新方法。<br>AJAX 是与服务器交换数据并更新部分网页的艺术，在不重新加载整个页面的情况下 ;通过在后台与服务器进行少量数据交换，AJAX 可以使网页实现异步更新。这意味着可以在不重新加载整个网页的情况下，对网页的某部分进行更新<br><br><br>实现ajax的方式有多种，如jQuery封装的ajax，原生的XMLHttpRequest，以及axios都可以实现异步网络请求。<br><br><br>Ajax是一种技术方案，但并不是一种新技术。它依赖现有的CSS/HTML/JavaScript，而其中最核心的依赖是浏览器提供的XMLHttpRequest对象，是这个对象使得浏览器可以发出HTTP请求与接收HTTP响应。实现了在页面不刷新个情况下和服务器进行数据交互。 异步的javascript和xml AJAX 是一种用于创建快速动态网页的技术。 ajax用来与后台交互<br><br><br>所以，我们现在梳理一下三者之间的关系：<br><br>参考资料：ajax与XHR的理解和使用<br>参考资料：原生ajax和jquery的ajax有何区别<br><br>① Ajax的实现依赖于XMLHttpRequest对象，即XMLHttpRequest可以实现Ajax。<br><br><br>Asynchronous JavaScript + XML（异步JavaScript和XML）, 其本身不是一种新技术，而是一个在 2005年被Jesse James Garrett提出的新术语，用来描述一种使用现有技术集合‘新’方法，包括: HTML 或 XHTML， CSS，JavaScript， DOM, XML， XSLT， 以及最重要的 XMLHttpRequest。当使用结合了这些技术的AJAX模型以后， 网页应用能够快速地将增量更新呈现在用户界面上，而不需要重载（刷新）整个页面。这使得程序能够更快地回应用户的操作。<br><br>XMLHttpRequest是AJAX的基础，XMLHttpRequest API是Ajax的核心。XMLHttpRequest 用于在后台与服务器交换数据。这意味着可以在不重新加载整个网页的情况下，对网页的某部分进行更新。<br><br><br>② Axios在此基础上封装了XMLHttpRequest，即Axios可以实现Ajax<br><br>③ Jquery是对Javascript的一种轻量级封装的框架，而Ajax是JavaScript的一种应用，是异步JavaScript和XML——由XML+Javascript组合起来的一种异步请求技术，可实现动态局部刷新。也就是说Jquey是JavaScript的一个函数库，而JavaScript包含Ajax。 Jquery在原生Ajax的基础上进行了封装(说白了Jquey封装了Ajax，其实就是对原生XHR的封装——做了兼容处理，简化了使用)，也就是说在Jquery中可以用Ajax。<br><br>JQuery 提供了用于 AJAX 开发的丰富函数(方法)库。 通过 jQuery Ajax，使用 HTTP Get 和 HTTP Post，你都可以从远程服务器请求 TXT、HTML、XML 或 JSON。<br><br><br>但各种方式都有利弊：<br><br>原生的XMLHttpRequest的配置和调用方式都很繁琐，实现异步请求十分麻烦。<br>jQuery的ajax相对于原生的ajax是非常好用的，但是没有必要因为要用ajax异步网络请求而引用整个jQuery框架。<br>————————————————<br><br>                            版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。<br>                        <br>原文链接：https://blog.csdn.net/sunyctf/article/details/129002056</p>', '1', '2025-05-21 15:43:51', '0');
INSERT INTO `post_details` VALUES (76, 21, 41, '<p>那是什么，能吃吗<img src=\"http://img.t.sinajs.cn/t35/style/images/common/face/ext/normal/5c/yw_thumb.gif\" alt=\"[疑问]\" data-w-e=\"1\"></p>', '1', '2025-05-21 17:13:09', '0');
INSERT INTO `post_details` VALUES (77, 21, 39, '<p>不如我奥拉星一根</p>', '1', '2025-05-21 17:13:38', '0');
INSERT INTO `post_details` VALUES (78, 21, 38, '<p>那么期末呢</p>', '1', '2025-05-21 20:43:57', '0');
INSERT INTO `post_details` VALUES (80, 27, 55, '<p>111</p>', '1', '2025-05-22 08:45:31', '0');

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
INSERT INTO `post_operation` VALUES (1, 1, 3, 1);
INSERT INTO `post_operation` VALUES (2, 1, 4, 1);
INSERT INTO `post_operation` VALUES (3, 1, 5, 1);
INSERT INTO `post_operation` VALUES (4, 8, 3, 1);
INSERT INTO `post_operation` VALUES (5, 14, 4, 1);
INSERT INTO `post_operation` VALUES (6, 4, 3, 1);
INSERT INTO `post_operation` VALUES (7, 5, 3, 1);
INSERT INTO `post_operation` VALUES (8, 7, 3, 1);
INSERT INTO `post_operation` VALUES (9, 11, 6, 1);
INSERT INTO `post_operation` VALUES (10, 7, 4, 1);
INSERT INTO `post_operation` VALUES (11, 18, 3, 1);
INSERT INTO `post_operation` VALUES (12, 12, 3, 1);
INSERT INTO `post_operation` VALUES (13, 22, 3, 1);
INSERT INTO `post_operation` VALUES (14, 27, 18, 1);
INSERT INTO `post_operation` VALUES (15, 28, 3, 1);
INSERT INTO `post_operation` VALUES (16, 31, 3, 1);
INSERT INTO `post_operation` VALUES (17, 4, 21, 1);
INSERT INTO `post_operation` VALUES (18, 32, 21, 1);
INSERT INTO `post_operation` VALUES (19, 2, 4, 1);
INSERT INTO `post_operation` VALUES (20, 38, 8, 1);
INSERT INTO `post_operation` VALUES (21, 40, 23, 1);
INSERT INTO `post_operation` VALUES (22, 40, 19, 1);
INSERT INTO `post_operation` VALUES (23, 41, 19, 1);

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
INSERT INTO `post_share` VALUES (3, 3, 1, 'jvm的原理', '2025-04-17 17:05:50', '编程开发');
INSERT INTO `post_share` VALUES (4, 4, 1, 'java+websokect', '2025-04-24 17:05:56', '编程开发');
INSERT INTO `post_share` VALUES (5, 4, 14, 'jvm的原理3', '2025-05-21 13:18:50', '学院专区');
INSERT INTO `post_share` VALUES (6, 3, 14, 'jvm的原理3', '2025-05-21 13:22:43', '学院专区');
INSERT INTO `post_share` VALUES (7, 3, 4, 'jvm的原理', '2025-05-21 13:26:17', '学院专区');
INSERT INTO `post_share` VALUES (8, 3, 5, 'java+websokect应用', '2025-05-21 16:33:53', '兼职');
INSERT INTO `post_share` VALUES (9, 3, 7, '程序员：面试官，来你要是能说出ZooKeeper原理，我转身就走', '2024-05-23 17:04:13', '校园趣事');
INSERT INTO `post_share` VALUES (10, 6, 7, '程序员：面试官，来你要是能说出ZooKeeper原理，我转身就走', '2024-05-23 17:05:46', '校园趣事');
INSERT INTO `post_share` VALUES (11, 6, 1, '好用的工具', '2023-05-23 17:15:09', '游戏交流');
INSERT INTO `post_share` VALUES (12, 6, 11, '300行代码实现Spring核心原理（彻底搞懂IOC、DI）', '2022-05-24 13:13:56', '游戏交流');
INSERT INTO `post_share` VALUES (13, 3, 18, '游戏测试', '2023-06-01 16:26:23', '游戏交流');
INSERT INTO `post_share` VALUES (14, 3, 12, '好用的工具4', '2024-06-04 10:14:38', '校园趣事');
INSERT INTO `post_share` VALUES (15, 3, 22, '发话人换购', '2023-06-14 11:21:36', '游戏交流');
INSERT INTO `post_share` VALUES (16, 18, 27, 'fvggyhjb', '2024-06-17 09:07:07', '游戏交流');
INSERT INTO `post_share` VALUES (17, 3, 15, 'java+websokect应用3', '2022-06-18 22:45:35', '兼职');
INSERT INTO `post_share` VALUES (18, 21, 32, '表白墙', '2025-01-04 10:20:42', '告白墙');

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
INSERT INTO `sys_log` VALUES (1, 'aini00', '删除评论数据', 'stair/postsDetailsManagedeletePostsDetails', '127.0.0.1', '2025-05-21 21:36:45');
INSERT INTO `sys_log` VALUES (2, 'aini00', '处理举报数据', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 12:00:40');
INSERT INTO `sys_log` VALUES (3, 'aini00', '删除举报数据', 'stair/postReportManage/deletePostReport', '127.0.0.1', '2025-05-21 12:02:38');
INSERT INTO `sys_log` VALUES (4, 'aini00', '移动帖子所在版块', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 13:06:56');
INSERT INTO `sys_log` VALUES (5, 'aini00', '移动帖子所在版块', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 17:18:39');
INSERT INTO `sys_log` VALUES (6, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 10:31:38');
INSERT INTO `sys_log` VALUES (7, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 10:37:55');
INSERT INTO `sys_log` VALUES (8, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 10:40:09');
INSERT INTO `sys_log` VALUES (9, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 10:43:40');
INSERT INTO `sys_log` VALUES (10, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 20:42:34');
INSERT INTO `sys_log` VALUES (11, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 20:45:18');
INSERT INTO `sys_log` VALUES (12, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 20:46:23');
INSERT INTO `sys_log` VALUES (13, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 20:46:59');
INSERT INTO `sys_log` VALUES (14, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 20:48:25');
INSERT INTO `sys_log` VALUES (15, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 20:48:25');
INSERT INTO `sys_log` VALUES (16, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 20:49:42');
INSERT INTO `sys_log` VALUES (17, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 20:54:48');
INSERT INTO `sys_log` VALUES (18, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 08:37:03');
INSERT INTO `sys_log` VALUES (19, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 08:42:01');
INSERT INTO `sys_log` VALUES (20, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 09:04:10');
INSERT INTO `sys_log` VALUES (21, 'aini00', '修改用户角色信息', 'stair/roleManage/alterUserRoles', '127.0.0.1', '2025-05-21 09:07:15');
INSERT INTO `sys_log` VALUES (22, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 09:11:17');
INSERT INTO `sys_log` VALUES (23, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 09:13:21');
INSERT INTO `sys_log` VALUES (24, 'aini00', '修改用户角色信息', 'stair/roleManage/alterUserRoles', '127.0.0.1', '2025-05-21 09:13:54');
INSERT INTO `sys_log` VALUES (25, 'aini00', '修改用户角色信息', 'stair/roleManage/alterUserRoles', '127.0.0.1', '2025-05-21 09:26:59');
INSERT INTO `sys_log` VALUES (26, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 09:29:27');
INSERT INTO `sys_log` VALUES (27, 'aini00', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 09:40:54');
INSERT INTO `sys_log` VALUES (28, 'admin', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 15:22:10');
INSERT INTO `sys_log` VALUES (29, 'admin', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 15:22:58');
INSERT INTO `sys_log` VALUES (30, 'admin', NULL, 'stair/roleManage/listRole', '127.0.0.1', '2025-05-21 15:25:55');
INSERT INTO `sys_log` VALUES (35, 'admin', '修改用户角色信息', 'stair/userRoleManage/alterUserRoles', '127.0.0.1', '2025-05-21 16:07:36');
INSERT INTO `sys_log` VALUES (36, 'admin', '添加角色', 'stair/roleManage/insertRoles', '127.0.0.1', '2025-05-21 16:57:36');
INSERT INTO `sys_log` VALUES (37, 'admin', '删除角色', 'stair/roleManage/deleteRoles', '127.0.0.1', '2025-05-21 17:12:55');
INSERT INTO `sys_log` VALUES (38, 'admin', '修改用户角色信息', 'stair/userRoleManage/alterUserRoles', '127.0.0.1', '2025-05-21 08:17:07');
INSERT INTO `sys_log` VALUES (39, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 08:17:47');
INSERT INTO `sys_log` VALUES (44, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 08:33:56');
INSERT INTO `sys_log` VALUES (45, 'admin', '删除用户角色', 'stair/userRoleManage/deleteUserRoles', '127.0.0.1', '2025-05-21 09:06:44');
INSERT INTO `sys_log` VALUES (46, 'admin', '删除举报数据', 'stair/postReportManage/deletePostReport', '127.0.0.1', '2025-05-21 09:54:29');
INSERT INTO `sys_log` VALUES (47, 'aini00', '删除评论(回帖)数据', 'stair/postsDetailsManagedeletePostsDetails', '127.0.0.1', '2025-05-21 11:08:35');
INSERT INTO `sys_log` VALUES (48, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 11:12:20');
INSERT INTO `sys_log` VALUES (49, 'aini00', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 15:43:15');
INSERT INTO `sys_log` VALUES (50, 'aini00', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 15:59:23');
INSERT INTO `sys_log` VALUES (51, 'aini00', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 16:02:19');
INSERT INTO `sys_log` VALUES (52, 'aini00', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 16:05:47');
INSERT INTO `sys_log` VALUES (53, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 10:11:11');
INSERT INTO `sys_log` VALUES (54, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 10:42:04');
INSERT INTO `sys_log` VALUES (55, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 10:50:30');
INSERT INTO `sys_log` VALUES (56, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 11:21:00');
INSERT INTO `sys_log` VALUES (57, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 11:29:47');
INSERT INTO `sys_log` VALUES (58, 'admin', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 11:33:26');
INSERT INTO `sys_log` VALUES (59, 'admin', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 11:36:18');
INSERT INTO `sys_log` VALUES (60, 'aini00', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 11:36:44');
INSERT INTO `sys_log` VALUES (61, 'aini00', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 11:37:40');
INSERT INTO `sys_log` VALUES (62, 'aini00', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 11:39:04');
INSERT INTO `sys_log` VALUES (63, 'aini00', NULL, 'stair/noticeManage/publishNotice', '127.0.0.1', '2025-05-21 11:43:07');
INSERT INTO `sys_log` VALUES (64, 'aini00', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 11:43:14');
INSERT INTO `sys_log` VALUES (65, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 11:00:57');
INSERT INTO `sys_log` VALUES (66, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 11:02:28');
INSERT INTO `sys_log` VALUES (67, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 11:03:53');
INSERT INTO `sys_log` VALUES (68, 'aini00', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 11:04:07');
INSERT INTO `sys_log` VALUES (69, 'aini00', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 11:08:04');
INSERT INTO `sys_log` VALUES (70, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 15:03:14');
INSERT INTO `sys_log` VALUES (71, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 15:04:49');
INSERT INTO `sys_log` VALUES (72, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 15:06:45');
INSERT INTO `sys_log` VALUES (73, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 16:36:20');
INSERT INTO `sys_log` VALUES (74, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 16:37:54');
INSERT INTO `sys_log` VALUES (75, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 14:49:05');
INSERT INTO `sys_log` VALUES (76, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 14:50:39');
INSERT INTO `sys_log` VALUES (77, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 08:25:49');
INSERT INTO `sys_log` VALUES (78, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 09:06:27');
INSERT INTO `sys_log` VALUES (79, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 09:18:51');
INSERT INTO `sys_log` VALUES (80, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 09:19:01');
INSERT INTO `sys_log` VALUES (81, 'aini00', '用户信息修改', 'stair/userManage/updateUserState', '127.0.0.1', '2025-05-21 09:19:12');
INSERT INTO `sys_log` VALUES (82, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 09:19:12');
INSERT INTO `sys_log` VALUES (83, 'aini00', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 09:20:17');
INSERT INTO `sys_log` VALUES (84, 'aini00', '用户信息修改', 'stair/userManage/updateUserState', '127.0.0.1', '2025-05-21 09:20:21');
INSERT INTO `sys_log` VALUES (85, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 09:20:21');
INSERT INTO `sys_log` VALUES (86, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 09:21:33');
INSERT INTO `sys_log` VALUES (87, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 09:21:37');
INSERT INTO `sys_log` VALUES (88, 'admin', '添加用户角色', 'stair/userRoleManage/insertUserRoles', '127.0.0.1', '2025-05-21 09:21:46');
INSERT INTO `sys_log` VALUES (89, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 09:21:46');
INSERT INTO `sys_log` VALUES (90, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 09:22:35');
INSERT INTO `sys_log` VALUES (91, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 09:22:50');
INSERT INTO `sys_log` VALUES (92, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 09:23:38');
INSERT INTO `sys_log` VALUES (93, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-21 09:24:07');
INSERT INTO `sys_log` VALUES (94, 'admin', '删除评论(回帖)数据', 'stair/postsDetailsManagedeletePostsDetails', '127.0.0.1', '2025-05-21 09:25:06');
INSERT INTO `sys_log` VALUES (95, 'admin', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 09:25:59');
INSERT INTO `sys_log` VALUES (96, 'admin', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 09:26:29');
INSERT INTO `sys_log` VALUES (97, 'admin', '公告更新', 'stair/noticeManage/updateNoticeById', '127.0.0.1', '2025-05-21 09:26:38');
INSERT INTO `sys_log` VALUES (98, 'admin', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 09:26:38');
INSERT INTO `sys_log` VALUES (99, 'admin', '添加公告', 'stair/noticeManage/publishNotice', '127.0.0.1', '2025-05-21 09:27:13');
INSERT INTO `sys_log` VALUES (103, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 09:35:53');
INSERT INTO `sys_log` VALUES (104, 'admin', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 09:36:53');
INSERT INTO `sys_log` VALUES (105, 'aini00', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 10:33:09');
INSERT INTO `sys_log` VALUES (106, 'aini00', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 10:45:16');
INSERT INTO `sys_log` VALUES (107, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 10:39:12');
INSERT INTO `sys_log` VALUES (108, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 10:41:05');
INSERT INTO `sys_log` VALUES (109, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 10:42:33');
INSERT INTO `sys_log` VALUES (110, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 10:43:07');
INSERT INTO `sys_log` VALUES (111, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 10:43:10');
INSERT INTO `sys_log` VALUES (112, 'aini00', '删除评论(回帖)数据', 'stair/postsDetailsManagedeletePostsDetails', '127.0.0.1', '2025-05-21 10:46:47');
INSERT INTO `sys_log` VALUES (113, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 11:02:43');
INSERT INTO `sys_log` VALUES (114, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:34:24');
INSERT INTO `sys_log` VALUES (115, 'aini00', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 16:57:15');
INSERT INTO `sys_log` VALUES (116, 'aini00', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 16:59:07');
INSERT INTO `sys_log` VALUES (117, 'aini00', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 17:05:56');
INSERT INTO `sys_log` VALUES (118, 'aini00', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 17:18:20');
INSERT INTO `sys_log` VALUES (119, 'aini00', '删除举报数据', 'stair/postReportManage/deletePostReport', '127.0.0.1', '2025-05-21 17:24:00');
INSERT INTO `sys_log` VALUES (120, 'aini00', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 17:24:34');
INSERT INTO `sys_log` VALUES (121, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 23:20:59');
INSERT INTO `sys_log` VALUES (122, 'aini00', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 23:50:13');
INSERT INTO `sys_log` VALUES (123, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 23:53:12');
INSERT INTO `sys_log` VALUES (124, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 00:34:50');
INSERT INTO `sys_log` VALUES (125, 'aini00', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 00:37:35');
INSERT INTO `sys_log` VALUES (126, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 16:21:34');
INSERT INTO `sys_log` VALUES (127, 'aini00', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 16:21:48');
INSERT INTO `sys_log` VALUES (128, 'aini00', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 16:21:56');
INSERT INTO `sys_log` VALUES (129, 'aini00', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 16:22:38');
INSERT INTO `sys_log` VALUES (130, 'aini00', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 16:28:48');
INSERT INTO `sys_log` VALUES (131, 'aini00', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 16:30:07');
INSERT INTO `sys_log` VALUES (132, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 16:33:14');
INSERT INTO `sys_log` VALUES (133, 'admin', '用户信息修改', 'stair/userManage/updateUserState', '127.0.0.1', '2025-05-21 16:33:21');
INSERT INTO `sys_log` VALUES (134, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 16:33:21');
INSERT INTO `sys_log` VALUES (135, 'admin', '用户信息修改', 'stair/userManage/updateUserState', '127.0.0.1', '2025-05-21 16:33:24');
INSERT INTO `sys_log` VALUES (136, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 16:33:25');
INSERT INTO `sys_log` VALUES (137, 'admin', '添加用户', 'stair/userManage/addUser', '127.0.0.1', '2025-05-21 16:34:10');
INSERT INTO `sys_log` VALUES (138, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 16:34:12');
INSERT INTO `sys_log` VALUES (139, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 10:14:34');
INSERT INTO `sys_log` VALUES (140, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 10:15:24');
INSERT INTO `sys_log` VALUES (141, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 10:15:30');
INSERT INTO `sys_log` VALUES (142, 'admin', '添加用户角色', 'stair/userRoleManage/insertUserRoles', '127.0.0.1', '2025-05-21 10:16:01');
INSERT INTO `sys_log` VALUES (143, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 10:16:01');
INSERT INTO `sys_log` VALUES (144, 'admin', '添加用户', 'stair/userManage/addUser', '127.0.0.1', '2025-05-21 10:16:45');
INSERT INTO `sys_log` VALUES (145, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 10:16:48');
INSERT INTO `sys_log` VALUES (146, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 10:20:15');
INSERT INTO `sys_log` VALUES (147, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 13:48:59');
INSERT INTO `sys_log` VALUES (148, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 13:51:16');
INSERT INTO `sys_log` VALUES (149, 'admin', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 13:54:06');
INSERT INTO `sys_log` VALUES (150, 'admin', '公告更新', 'stair/noticeManage/updateNoticeById', '127.0.0.1', '2025-05-21 13:55:15');
INSERT INTO `sys_log` VALUES (151, 'admin', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 13:55:15');
INSERT INTO `sys_log` VALUES (152, 'admin', '公告更新', 'stair/noticeManage/updateNoticeById', '127.0.0.1', '2025-05-21 13:55:29');
INSERT INTO `sys_log` VALUES (153, 'admin', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 13:55:29');
INSERT INTO `sys_log` VALUES (154, 'admin', '添加公告', 'stair/noticeManage/publishNotice', '127.0.0.1', '2025-05-21 13:56:47');
INSERT INTO `sys_log` VALUES (155, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 19:41:51');
INSERT INTO `sys_log` VALUES (156, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 19:42:11');
INSERT INTO `sys_log` VALUES (157, 'admin', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 20:03:33');
INSERT INTO `sys_log` VALUES (158, 'admin', '举报处理', 'stair/postReportManage/disposePostReport', '127.0.0.1', '2025-05-21 20:11:48');
INSERT INTO `sys_log` VALUES (159, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 20:12:09');
INSERT INTO `sys_log` VALUES (160, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 21:02:40');
INSERT INTO `sys_log` VALUES (161, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 23:34:47');
INSERT INTO `sys_log` VALUES (162, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-21 23:45:29');
INSERT INTO `sys_log` VALUES (163, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-21 23:46:19');
INSERT INTO `sys_log` VALUES (164, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 23:46:58');
INSERT INTO `sys_log` VALUES (165, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:02:59');
INSERT INTO `sys_log` VALUES (166, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-21 15:03:07');
INSERT INTO `sys_log` VALUES (167, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 15:09:17');
INSERT INTO `sys_log` VALUES (168, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:09:22');
INSERT INTO `sys_log` VALUES (169, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:09:25');
INSERT INTO `sys_log` VALUES (170, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 15:09:33');
INSERT INTO `sys_log` VALUES (171, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 15:09:34');
INSERT INTO `sys_log` VALUES (172, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:09:40');
INSERT INTO `sys_log` VALUES (173, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:09:42');
INSERT INTO `sys_log` VALUES (174, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:09:44');
INSERT INTO `sys_log` VALUES (175, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:09:46');
INSERT INTO `sys_log` VALUES (176, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:09:48');
INSERT INTO `sys_log` VALUES (177, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:09:50');
INSERT INTO `sys_log` VALUES (178, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 15:09:50');
INSERT INTO `sys_log` VALUES (179, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:09:53');
INSERT INTO `sys_log` VALUES (180, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:09:55');
INSERT INTO `sys_log` VALUES (181, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:09:57');
INSERT INTO `sys_log` VALUES (182, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:09:59');
INSERT INTO `sys_log` VALUES (183, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:10:01');
INSERT INTO `sys_log` VALUES (184, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:10:03');
INSERT INTO `sys_log` VALUES (185, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:10:04');
INSERT INTO `sys_log` VALUES (186, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:10:06');
INSERT INTO `sys_log` VALUES (187, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 15:10:07');
INSERT INTO `sys_log` VALUES (188, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:10:10');
INSERT INTO `sys_log` VALUES (189, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:10:11');
INSERT INTO `sys_log` VALUES (190, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-21 15:10:13');
INSERT INTO `sys_log` VALUES (191, 'admin', NULL, 'stair/noticeManage/getNoticeInfo', '127.0.0.1', '2025-05-21 15:10:32');
INSERT INTO `sys_log` VALUES (192, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-21 15:11:01');
INSERT INTO `sys_log` VALUES (193, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-21 15:11:06');
INSERT INTO `sys_log` VALUES (194, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-21 15:11:09');
INSERT INTO `sys_log` VALUES (195, 'admin', '删除评论(回帖)数据', 'stair/postsDetailsManagedeletePostsDetails', '127.0.0.1', '2025-05-21 15:11:13');
INSERT INTO `sys_log` VALUES (196, 'admin', '删除评论(回帖)数据', 'stair/postsDetailsManagedeletePostsDetails', '127.0.0.1', '2025-05-21 15:11:16');
INSERT INTO `sys_log` VALUES (197, 'admin', '删除评论(回帖)数据', 'stair/postsDetailsManagedeletePostsDetails', '127.0.0.1', '2025-05-21 15:11:18');
INSERT INTO `sys_log` VALUES (198, 'admin', '删除评论(回帖)数据', 'stair/postsDetailsManagedeletePostsDetails', '127.0.0.1', '2025-05-21 15:11:21');
INSERT INTO `sys_log` VALUES (199, 'admin', '删除评论(回帖)数据', 'stair/postsDetailsManagedeletePostsDetails', '127.0.0.1', '2025-05-21 15:11:24');
INSERT INTO `sys_log` VALUES (200, 'admin', '删除举报数据', 'stair/postReportManage/deletePostReport', '127.0.0.1', '2025-05-21 15:11:27');
INSERT INTO `sys_log` VALUES (201, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:15:03');
INSERT INTO `sys_log` VALUES (202, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:15:06');
INSERT INTO `sys_log` VALUES (203, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:15:11');
INSERT INTO `sys_log` VALUES (204, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:15:22');
INSERT INTO `sys_log` VALUES (205, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:15:25');
INSERT INTO `sys_log` VALUES (206, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:19:55');
INSERT INTO `sys_log` VALUES (207, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:19:58');
INSERT INTO `sys_log` VALUES (208, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:20:01');
INSERT INTO `sys_log` VALUES (209, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:20:05');
INSERT INTO `sys_log` VALUES (210, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:20:10');
INSERT INTO `sys_log` VALUES (211, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:20:34');
INSERT INTO `sys_log` VALUES (212, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:20:39');
INSERT INTO `sys_log` VALUES (213, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:28:58');
INSERT INTO `sys_log` VALUES (214, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:29:02');
INSERT INTO `sys_log` VALUES (215, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:30:38');
INSERT INTO `sys_log` VALUES (216, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:36:36');
INSERT INTO `sys_log` VALUES (217, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:36:40');
INSERT INTO `sys_log` VALUES (218, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:42:26');
INSERT INTO `sys_log` VALUES (219, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:42:30');
INSERT INTO `sys_log` VALUES (220, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:42:35');
INSERT INTO `sys_log` VALUES (221, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:42:38');
INSERT INTO `sys_log` VALUES (222, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:42:41');
INSERT INTO `sys_log` VALUES (223, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 15:42:43');
INSERT INTO `sys_log` VALUES (224, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-21 15:43:14');
INSERT INTO `sys_log` VALUES (225, 'admin', '修改板块信息', 'stair/plateManage/alterPlate', '127.0.0.1', '2025-05-21 19:07:39');
INSERT INTO `sys_log` VALUES (226, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 19:52:01');
INSERT INTO `sys_log` VALUES (227, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 19:52:14');
INSERT INTO `sys_log` VALUES (228, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 19:52:15');
INSERT INTO `sys_log` VALUES (229, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 19:52:17');
INSERT INTO `sys_log` VALUES (230, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 20:07:59');
INSERT INTO `sys_log` VALUES (231, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 20:11:39');
INSERT INTO `sys_log` VALUES (232, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 20:11:53');
INSERT INTO `sys_log` VALUES (233, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 20:11:53');
INSERT INTO `sys_log` VALUES (234, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 20:11:54');
INSERT INTO `sys_log` VALUES (235, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 20:24:18');
INSERT INTO `sys_log` VALUES (236, 'admin', NULL, 'stair/plateManage/addPlate', '127.0.0.1', '2025-05-21 20:28:37');
INSERT INTO `sys_log` VALUES (237, 'admin', '删除版块', 'stair/plateManage/removePlate', '127.0.0.1', '2025-05-21 20:28:45');
INSERT INTO `sys_log` VALUES (238, 'admin', '删除版块', 'stair/plateManage/removePlate', '127.0.0.1', '2025-05-21 20:29:25');
INSERT INTO `sys_log` VALUES (239, 'admin', '删除版块', 'stair/plateManage/removePlate', '127.0.0.1', '2025-05-21 20:29:27');
INSERT INTO `sys_log` VALUES (240, 'admin', '删除版块', 'stair/plateManage/removePlate', '127.0.0.1', '2025-05-21 20:29:30');
INSERT INTO `sys_log` VALUES (241, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 20:32:04');
INSERT INTO `sys_log` VALUES (242, 'admin', NULL, 'stair/plateManage/addPlate', '127.0.0.1', '2025-05-21 20:33:20');
INSERT INTO `sys_log` VALUES (243, 'admin', '删除版块', 'stair/plateManage/removePlate', '127.0.0.1', '2025-05-21 20:33:44');
INSERT INTO `sys_log` VALUES (244, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-21 20:44:55');
INSERT INTO `sys_log` VALUES (245, 'admin', '删除评论(回帖)数据', 'stair/postsDetailsManagedeletePostsDetails', '127.0.0.1', '2025-05-21 20:45:15');
INSERT INTO `sys_log` VALUES (246, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 22:10:21');
INSERT INTO `sys_log` VALUES (247, 'admin', '用户信息修改', 'stair/userManage/updateUserState', '127.0.0.1', '2025-05-21 22:10:31');
INSERT INTO `sys_log` VALUES (248, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-21 22:10:31');
INSERT INTO `sys_log` VALUES (249, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-22 08:00:17');
INSERT INTO `sys_log` VALUES (250, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-22 08:00:19');
INSERT INTO `sys_log` VALUES (251, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-22 08:00:19');
INSERT INTO `sys_log` VALUES (252, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-22 08:09:33');
INSERT INTO `sys_log` VALUES (253, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-22 08:09:35');
INSERT INTO `sys_log` VALUES (254, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-22 08:11:57');
INSERT INTO `sys_log` VALUES (255, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-22 08:45:17');
INSERT INTO `sys_log` VALUES (256, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-22 08:45:56');
INSERT INTO `sys_log` VALUES (257, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-23 14:54:50');
INSERT INTO `sys_log` VALUES (258, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-23 16:06:08');
INSERT INTO `sys_log` VALUES (259, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-23 16:14:24');
INSERT INTO `sys_log` VALUES (260, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-23 16:19:42');
INSERT INTO `sys_log` VALUES (261, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-23 17:00:19');
INSERT INTO `sys_log` VALUES (262, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-23 17:03:36');
INSERT INTO `sys_log` VALUES (263, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-23 17:03:48');
INSERT INTO `sys_log` VALUES (264, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-23 17:05:34');
INSERT INTO `sys_log` VALUES (265, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-23 17:07:57');
INSERT INTO `sys_log` VALUES (266, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-23 17:08:00');
INSERT INTO `sys_log` VALUES (267, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-23 17:08:03');
INSERT INTO `sys_log` VALUES (268, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-23 17:09:34');
INSERT INTO `sys_log` VALUES (269, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-23 17:24:01');
INSERT INTO `sys_log` VALUES (270, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-23 17:24:02');
INSERT INTO `sys_log` VALUES (271, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-23 17:24:03');
INSERT INTO `sys_log` VALUES (272, 'admin', '用户信息修改', 'stair/userManage/updateUserState', '127.0.0.1', '2025-05-23 17:24:30');
INSERT INTO `sys_log` VALUES (273, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-23 17:24:30');
INSERT INTO `sys_log` VALUES (274, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-23 17:27:13');
INSERT INTO `sys_log` VALUES (275, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-23 17:27:15');
INSERT INTO `sys_log` VALUES (276, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-23 17:27:15');
INSERT INTO `sys_log` VALUES (277, 'admin', '用户信息修改', 'stair/userManage/updateUserState', '127.0.0.1', '2025-05-23 17:27:18');
INSERT INTO `sys_log` VALUES (278, 'admin', NULL, 'stair/userManage/getUserInfo', '127.0.0.1', '2025-05-23 17:27:18');
INSERT INTO `sys_log` VALUES (279, 'admin', NULL, 'stair/userManage/resetPassword', '127.0.0.1', '2025-05-23 17:27:20');
INSERT INTO `sys_log` VALUES (280, 'admin', '删除帖子', 'stair/postsManage/deletePosts', '127.0.0.1', '2025-05-23 17:28:54');
INSERT INTO `sys_log` VALUES (281, 'admin', '修改帖子', 'stair/postsManage/changPosts', '127.0.0.1', '2025-05-23 17:33:43');
INSERT INTO `sys_log` VALUES (282, 'admin', '删除评论(回帖)数据', 'stair/postsDetailsManagedeletePostsDetails', '127.0.0.1', '2025-05-23 19:51:39');

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
INSERT INTO `u_collect` VALUES (9, 3, 8, 'Java面试详解(2020版)：500+ 面试题和核心知识点详解', '社团专区', '2025-05-21 17:54:51', '1');
INSERT INTO `u_collect` VALUES (10, 4, 14, 'jvm的原理3', '学院专区', '2025-05-21 13:18:32', '1');
INSERT INTO `u_collect` VALUES (14, 3, 4, '游戏交流', '', '2025-05-21 8:09:43', '2');
INSERT INTO `u_collect` VALUES (16, 4, 1, '学院专区', '学院专区', '2025-05-21 22:36:42', '2');
INSERT INTO `u_collect` VALUES (18, 4, 4, '游戏交流', '游戏交流', '2025-05-21 15:28:02', '2');
INSERT INTO `u_collect` VALUES (20, 18, 27, 'fvggyhjb', '游戏交流', '2025-05-21 09:06:56', '1');
INSERT INTO `u_collect` VALUES (23, 4, 2, '好用的工具2', '游戏交流', '2025-05-21 20:13:21', '1');
INSERT INTO `u_collect` VALUES (24, 4, 3, '真实的故事', '社团专区', '2025-05-21 20:13:37', '1');
INSERT INTO `u_collect` VALUES (25, 8, 38, '我期中考试过辣', '校园趣事', '2025-05-21 15:16:34', '1');
INSERT INTO `u_collect` VALUES (26, 19, 40, '入职华为经验', '兼职', '2025-05-21 15:37:04', '1');
INSERT INTO `u_collect` VALUES (27, 19, 41, '计电院', '学院专区', '2025-05-21 15:37:35', '1');
INSERT INTO `u_collect` VALUES (28, 28, 48, 'mc那个钻石怎么挖', '游戏交流', '2025-05-23 15:38:17', '1');
INSERT INTO `u_collect` VALUES (31, 27, 38, '我期中考试过辣', '坊间趣事', '2025-05-23 17:12:34', '1');

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
INSERT INTO `user` VALUES (1, 'gone165', '999999', '001-1号', NULL, '男', '5646@qq.com', 15279515773, 'statics/images/u1.png', '2025-05-21 21:29:00', '127.0.0.1', '2025-05-21 15:12:09', '127.0.0.1', '', '0', '1');
INSERT INTO `user` VALUES (2, 'hoama1234', '666666', '002-2号', NULL, '女', '5465@qq.com', 15279515773, 'statics/images/u2.jpg', '2025-05-21 21:55:00', '127.0.0.1', '2025-05-21 20:02:33', '127.0.0.1', '', '0', '1');
INSERT INTO `user` VALUES (3, 'aini00', '789789', '迷失者', NULL, '男', '9898767@qq.com', 15279515773, 'statics/images/u4.jpg', '2025-05-21 22:01:00', '127.0.0.1', '2025-05-21 09:12:31', '127.0.0.1', '', '0', '1');
INSERT INTO `user` VALUES (4, 'admin', 'admin', '管理员', NULL, '男', '33321@qq.com', 15279515773, 'statics/images/toux2.jpg', '2025-05-21 13:38:00', '127.0.0.1', '2025-05-21 17:48:44', '127.0.0.1', '', '0', '1');
INSERT INTO `user` VALUES (5, 'zsan', '888555', '005-5号', NULL, '男', '87945@qq.com', 13479129250, 'statics/images/01_small.gif', '2025-05-21 15:30:00', '127.0.0.1', NULL, NULL, '', '0', '1');
INSERT INTO `user` VALUES (6, 'lis', '654654', '006-6号', NULL, '男', 'ssasa5@qq.com', 13479129250, 'statics/images/u3.jpg', '2025-05-21 15:30:00', '127.0.0.1', '2025-05-21 11:49:39', '127.0.0.1', '', '0', '1');
INSERT INTO `user` VALUES (7, 'wang', '888888', '007-7号', NULL, '男', '2345sa@qq.com', 18347920132, 'statics/images/u4.jpg', '2025-05-21 15:30:00', '127.0.01', NULL, NULL, '', '0', '1');
INSERT INTO `user` VALUES (8, 'zhaoliu', '323232', '008-8号', NULL, '男', 'sac@qq.com', 18024545382, 'statics/images/u5.jpg', '2025-05-21 15:30:00', '127.0.0.1', '2025-05-21 15:16:24', '127.0.0.1', '', '0', '0');
INSERT INTO `user` VALUES (9, '2309474', '566485', '也许!', NULL, NULL, 'aaa@qq.com', NULL, 'statics/images/01_small.gif', '2025-05-21 21:59:01', '127.0.0.1', NULL, NULL, NULL, NULL, '1');
INSERT INTO `user` VALUES (10, 'qwer', '111111', 'jf电商法', NULL, NULL, 'whfw@qq.com', NULL, 'statics/images/01_small.gif', '2025-05-21 16:12:02', '127.0.0.1', NULL, NULL, NULL, NULL, '1');
INSERT INTO `user` VALUES (11, '54628', '789789', '哈根温柔哥', NULL, NULL, '4156514@qq.com', NULL, 'statics/images/01_small.gif', '2025-05-21 17:34:53', '127.0.0.1', '2025-05-21 18:05:29', '127.0.0.1', NULL, NULL, '1');
INSERT INTO `user` VALUES (12, '7845', '653421', '回来了', NULL, '女', '16541142@qq.com', NULL, 'statics/images/01_small.gif', '2025-05-21 20:24:58', '127.0.0.1', '2025-05-21 12:02:33', '127.0.0.1', '', NULL, '1');
INSERT INTO `user` VALUES (13, 'ceshi00', '222222', '00者', NULL, NULL, 'safh@ef.com', NULL, 'statics/images/01_small.gif', '2025-05-21 09:34:27', '127.0.0.1', '2025-05-21 09:34:50', '127.0.0.1', NULL, NULL, '1');
INSERT INTO `user` VALUES (14, '007', '646464', '撒个坏的很', NULL, NULL, 'dgfaf@qq.com', NULL, 'statics/images/01_small.gif', '2025-05-21 10:28:11', '127.0.0.1', NULL, NULL, NULL, NULL, '1');
INSERT INTO `user` VALUES (15, '008', 'qwerqwer', '撒个坏的很2', NULL, NULL, 'fghf@qq.com', NULL, 'statics/images/01_small.gif', '2025-05-21 10:32:06', '127.0.0.1', '2025-05-21 10:32:45', '127.0.0.1', NULL, NULL, '1');
INSERT INTO `user` VALUES (16, '009', '123456', '哈撒给1', NULL, NULL, 'shff@df.com', NULL, 'statics/images/01_small.gif', '2025-05-21 10:44:01', '127.0.0.1', NULL, NULL, NULL, NULL, '1');
INSERT INTO `user` VALUES (17, '010', '122221', '哈撒给2', NULL, NULL, 'afhf@qq.com', NULL, 'uploadfiles/2020/6/0f985611c74d49cd939c43c8b9131120.jpg', '2025-05-21 10:49:46', '127.0.0.1', '2025-05-21 15:20:43', '127.0.0.1', NULL, NULL, '1');
INSERT INTO `user` VALUES (18, '123456', '444444', 'woai00', NULL, '男', '1625@gg.com', 15279515773, 'uploadfiles/2020/6/48c8c68121444b638d6a5fb965d59dd5.jpg', '2025-05-21 09:02:39', '127.0.0.1', '2025-05-21 09:20:35', '127.0.0.1', '', NULL, '1');
INSERT INTO `user` VALUES (19, 'sfd', '000000', 'Ye~fbew', NULL, NULL, 'fhhe@qq.com', NULL, 'statics/images/01_small.gif', '2025-05-21 16:51:14', '127.0.0.1', '2025-05-21 15:34:24', '127.0.0.1', NULL, NULL, '1');
INSERT INTO `user` VALUES (20, '0001', '101000', '也许吧', NULL, NULL, 'sdfh@qq.com', NULL, 'statics/images/01_small.gif', '2025-05-21 10:58:22', '127.0.0.1', '2025-05-21 22:44:15', '127.0.0.1', NULL, NULL, '1');
INSERT INTO `user` VALUES (21, 'user', '000000', '小白', NULL, NULL, '111@qq.com', NULL, 'uploadfiles/2025/5/a0d49a9274bc4131bde0580bcf770cbd.jpg', '2025-05-21 16:34:10', '127.0.0.1', '2025-05-22 08:11:50', '127.0.0.1', NULL, NULL, '1');
INSERT INTO `user` VALUES (22, 'user1', '321321', '小白1', NULL, NULL, '111@qq.cin', NULL, 'statics/images/01_small.gif', '2025-05-21 10:16:45', '127.0.0.1', '2025-05-21 13:42:42', '127.0.0.1', NULL, NULL, '1');
INSERT INTO `user` VALUES (23, 'fggg', '777777', 'zhang', NULL, NULL, '2872175983@qq.com', NULL, 'statics/images/01_small.gif', '2025-05-21 21:01:19', '127.0.0.1', '2025-05-21 15:23:10', '127.0.0.1', NULL, NULL, '1');
INSERT INTO `user` VALUES (24, 'qjl', '123123', 'qjl', NULL, NULL, 'asadasdasda@qq.com', NULL, 'statics/images/01_small.gif', '2025-05-21 15:39:50', '127.0.0.1', '2025-05-21 15:40:37', '127.0.0.1', NULL, NULL, '1');
INSERT INTO `user` VALUES (27, '123123', '000000', '123123', NULL, NULL, '123123@qq.com', NULL, 'statics/images/01_small.gif', '2025-05-22 08:44:38', '127.0.0.1', '2025-05-23 17:27:49', '127.0.0.1', NULL, NULL, '1');
INSERT INTO `user` VALUES (28, 'Test', '123123', 'Test', NULL, NULL, '123123@qq.com', NULL, 'statics/images/01_small.gif', '2025-05-23 14:17:14', '127.0.0.1', '2025-05-23 14:18:37', '127.0.0.1', NULL, NULL, '1');

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
INSERT INTO `user_role` VALUES (4, 3, 4);
INSERT INTO `user_role` VALUES (8, 6, 2);
INSERT INTO `user_role` VALUES (11, 3, 2);
INSERT INTO `user_role` VALUES (12, 3, 3);
INSERT INTO `user_role` VALUES (13, 4, 3);
INSERT INTO `user_role` VALUES (14, 21, 3);

SET FOREIGN_KEY_CHECKS = 1;
