-- Patch missing schema objects required by application mappers.
USE bbs;

ALTER TABLE `user`
    MODIFY COLUMN `username` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '账号',
    MODIFY COLUMN `email` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '邮箱',
    MODIFY COLUMN `register_ip` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '注册ip',
    MODIFY COLUMN `last_login_ip` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '最后登录ip';

SET @has_profession := (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'bbs' AND TABLE_NAME = 'user' AND COLUMN_NAME = 'profession'
);
SET @alter_sql := IF(@has_profession = 0,
    'ALTER TABLE `user` ADD COLUMN `profession` varchar(50) NULL DEFAULT NULL COMMENT ''profession'' AFTER `address`',
    'SELECT 1'
);
PREPARE stmt_profession FROM @alter_sql;
EXECUTE stmt_profession;
DEALLOCATE PREPARE stmt_profession;

SET @has_personalized_sign := (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'bbs' AND TABLE_NAME = 'user' AND COLUMN_NAME = 'personalized_sign'
);
SET @alter_sql2 := IF(@has_personalized_sign = 0,
    'ALTER TABLE `user` ADD COLUMN `personalized_sign` varchar(255) NULL DEFAULT NULL COMMENT ''personalized sign'' AFTER `picture`',
    'SELECT 1'
);
PREPARE stmt_sign FROM @alter_sql2;
EXECUTE stmt_sign;
DEALLOCATE PREPARE stmt_sign;

CREATE TABLE IF NOT EXISTS `integral` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` int NOT NULL,
    `user_integral` int NULL DEFAULT 0,
    `last_time` datetime NULL DEFAULT NULL,
    `total_integral` int NULL DEFAULT 0,
    `reserve1` varchar(100) NULL DEFAULT NULL,
    `reserve2` varchar(100) NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_integral_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `experience` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` int NOT NULL,
    `user_experience` int NULL DEFAULT 0,
    `time` datetime NULL DEFAULT NULL,
    `total_experience` int NULL DEFAULT 0,
    `reserve1` varchar(100) NULL DEFAULT NULL,
    `reserve2` varchar(100) NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_experience_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `sign` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` int NOT NULL,
    `continuous_days` varchar(20) NULL DEFAULT '0',
    `total_days` int NULL DEFAULT 0,
    `month_days` int NULL DEFAULT 0,
    `last_sign_time` datetime NULL DEFAULT NULL,
    `last_award` varchar(50) NULL DEFAULT NULL,
    `sign_status` char(1) NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_sign_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `friend_group` (
    `group_id` int NOT NULL AUTO_INCREMENT,
    `group_name` varchar(64) NULL DEFAULT NULL,
    `user_id` int NOT NULL,
    PRIMARY KEY (`group_id`),
    KEY `idx_friend_group_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `user_friend` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` int NOT NULL,
    `friend_id` int NOT NULL,
    `group_id` int NULL DEFAULT NULL,
    `status` char(1) NULL DEFAULT '0',
    `apply_time` datetime NULL DEFAULT NULL,
    `postscript` varchar(255) NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_user_friend_user_id` (`user_id`),
    KEY `idx_user_friend_friend_id` (`friend_id`),
    KEY `idx_user_friend_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `private_msg` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `src_user_id` int NOT NULL,
    `tar_user_id` int NOT NULL,
    `content` text,
    `img` varchar(255) NULL DEFAULT NULL,
    `msg_time` bigint NOT NULL,
    `is_read` tinyint(1) NOT NULL DEFAULT 0,
    `src_deleted` tinyint(1) NOT NULL DEFAULT 0,
    `tar_deleted` tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_pm_src_tar_time` (`src_user_id`, `tar_user_id`, `msg_time`),
    KEY `idx_pm_tar_src_time` (`tar_user_id`, `src_user_id`, `msg_time`),
    KEY `idx_pm_tar_unread` (`tar_user_id`, `is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `grade` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(32) NULL DEFAULT NULL,
    `img` varchar(120) NULL DEFAULT NULL,
    `g_condition` int NULL DEFAULT 0,
    `reserve1` varchar(100) NULL DEFAULT NULL,
    `reserve2` varchar(100) NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `leave_word` (
    `id` int NOT NULL AUTO_INCREMENT,
    `leave_u_id` int NULL DEFAULT NULL,
    `leave_name` varchar(64) NULL DEFAULT NULL,
    `leave_photo` varchar(255) NULL DEFAULT NULL,
    `leave_content` text,
    `to_u_id` int NULL DEFAULT NULL,
    `leave_time` datetime NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `permission` (
    `id` int NOT NULL AUTO_INCREMENT,
    `permission_name` varchar(100) NULL DEFAULT NULL,
    `description` varchar(255) NULL DEFAULT NULL,
    `url` varchar(255) NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `role_permission` (
    `id` int NOT NULL AUTO_INCREMENT,
    `permission_id` int NOT NULL,
    `role_id` int NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_role_permission_permission_id` (`permission_id`),
    KEY `idx_role_permission_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `post_report` (
    `id` int NOT NULL AUTO_INCREMENT,
    `uid` int NOT NULL,
    `pid` int NOT NULL,
    `r_type` varchar(100) NULL DEFAULT NULL,
    `r_content` varchar(255) NULL DEFAULT NULL,
    `rp_type` varchar(20) NULL DEFAULT NULL,
    `r_time` datetime NULL DEFAULT NULL,
    `r_status` char(1) NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    KEY `idx_post_report_uid` (`uid`),
    KEY `idx_post_report_pid` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `sys_warn` (
    `id` int NOT NULL AUTO_INCREMENT,
    `uid` int NOT NULL,
    `title` varchar(100) NULL DEFAULT NULL,
    `content` text,
    `w_time` datetime NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `u_log` (
    `id` int NOT NULL AUTO_INCREMENT,
    `u_id` int NOT NULL,
    `log_type` varchar(32) NULL DEFAULT NULL,
    `content` varchar(255) NULL DEFAULT NULL,
    `log_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_u_log_u_id` (`u_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `grade` (`id`, `name`, `img`, `g_condition`, `reserve1`, `reserve2`)
SELECT 1, 'Newbie', 'statics/images/grade_img/1.gif', 0, NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM `grade` WHERE `id` = 1);
INSERT INTO `grade` (`id`, `name`, `img`, `g_condition`, `reserve1`, `reserve2`)
SELECT 2, 'Junior', 'statics/images/grade_img/2.gif', 30, NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM `grade` WHERE `id` = 2);
INSERT INTO `grade` (`id`, `name`, `img`, `g_condition`, `reserve1`, `reserve2`)
SELECT 3, 'Intermediate', 'statics/images/grade_img/3.gif', 100, NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM `grade` WHERE `id` = 3);
INSERT INTO `grade` (`id`, `name`, `img`, `g_condition`, `reserve1`, `reserve2`)
SELECT 4, 'Advanced', 'statics/images/grade_img/4.gif', 300, NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM `grade` WHERE `id` = 4);
INSERT INTO `grade` (`id`, `name`, `img`, `g_condition`, `reserve1`, `reserve2`)
SELECT 5, 'Expert', 'statics/images/grade_img/5.gif', 800, NULL, NULL
WHERE NOT EXISTS (SELECT 1 FROM `grade` WHERE `id` = 5);

INSERT INTO `user` (`username`, `password`, `another_name`, `email`, `register_time`, `register_ip`, `online_status`, `user_status`, `picture`, `personalized_sign`)
SELECT 'root', '123456', 'root', 'root@example.com', NOW(), '127.0.0.1', '0', '1', 'statics/images/01_small.gif', ''
WHERE NOT EXISTS (SELECT 1 FROM `user` WHERE `username` = 'root');
INSERT INTO `user` (`username`, `password`, `another_name`, `email`, `register_time`, `register_ip`, `online_status`, `user_status`, `picture`, `personalized_sign`)
SELECT 'ljj', 'ljj', 'ljj', 'ljj@example.com', NOW(), '127.0.0.1', '0', '1', 'statics/images/01_small.gif', ''
WHERE NOT EXISTS (SELECT 1 FROM `user` WHERE `username` = 'ljj');
INSERT INTO `user` (`username`, `password`, `another_name`, `email`, `register_time`, `register_ip`, `online_status`, `user_status`, `picture`, `personalized_sign`)
SELECT 'lp', 'lp', 'lp', 'lp@example.com', NOW(), '127.0.0.1', '0', '1', 'statics/images/01_small.gif', ''
WHERE NOT EXISTS (SELECT 1 FROM `user` WHERE `username` = 'lp');
INSERT INTO `user` (`username`, `password`, `another_name`, `email`, `register_time`, `register_ip`, `online_status`, `user_status`, `picture`, `personalized_sign`)
SELECT 'xzr', 'xzr', 'xzr', 'xzr@example.com', NOW(), '127.0.0.1', '0', '1', 'statics/images/01_small.gif', ''
WHERE NOT EXISTS (SELECT 1 FROM `user` WHERE `username` = 'xzr');

INSERT INTO `integral` (`user_id`, `user_integral`, `last_time`, `total_integral`)
SELECT `id`, 0, NOW(), 0 FROM `user`
WHERE `id` NOT IN (SELECT `user_id` FROM `integral`);

INSERT INTO `experience` (`user_id`, `user_experience`, `time`, `total_experience`)
SELECT `id`, 0, NOW(), 0 FROM `user`
WHERE `id` NOT IN (SELECT `user_id` FROM `experience`);

INSERT INTO `sign` (`user_id`, `continuous_days`, `total_days`, `month_days`, `last_sign_time`, `last_award`, `sign_status`)
SELECT `id`, '0', 0, 0, NULL, NULL, '0' FROM `user`
WHERE `id` NOT IN (SELECT `user_id` FROM `sign`);

SET @root_id := (SELECT `id` FROM `user` WHERE `username` = 'root' LIMIT 1);
INSERT INTO `user_role` (`user_id`, `role_id`)
SELECT @root_id, 1
WHERE @root_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `user_role` WHERE `user_id` = @root_id AND `role_id` = 1);

SET @admin_id := (SELECT `id` FROM `user` WHERE `username` = 'admin' LIMIT 1);
SET @root_id := (SELECT `id` FROM `user` WHERE `username` = 'root' LIMIT 1);
SET @ljj_id := (SELECT `id` FROM `user` WHERE `username` = 'ljj' LIMIT 1);
SET @lp_id := (SELECT `id` FROM `user` WHERE `username` = 'lp' LIMIT 1);
SET @xzr_id := (SELECT `id` FROM `user` WHERE `username` = 'xzr' LIMIT 1);

INSERT INTO `private_msg` (`src_user_id`, `tar_user_id`, `content`, `img`, `msg_time`, `is_read`, `src_deleted`, `tar_deleted`)
SELECT @ljj_id, @lp_id, '你好，我先去看会话列表接口。', 'statics/images/01_small.gif', ROUND(UNIX_TIMESTAMP(NOW(3)) * 1000) - 4800000, 1, 0, 0
WHERE @ljj_id IS NOT NULL AND @lp_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `private_msg` LIMIT 1);
INSERT INTO `private_msg` (`src_user_id`, `tar_user_id`, `content`, `img`, `msg_time`, `is_read`, `src_deleted`, `tar_deleted`)
SELECT @lp_id, @ljj_id, '收到，我正在排查。', 'statics/images/01_small.gif', ROUND(UNIX_TIMESTAMP(NOW(3)) * 1000) - 4200000, 1, 0, 0
WHERE @ljj_id IS NOT NULL AND @lp_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `private_msg` WHERE `src_user_id` = @lp_id AND `tar_user_id` = @ljj_id);
INSERT INTO `private_msg` (`src_user_id`, `tar_user_id`, `content`, `img`, `msg_time`, `is_read`, `src_deleted`, `tar_deleted`)
SELECT @ljj_id, @lp_id, '对，发送后要立刻本地回显。', 'statics/images/01_small.gif', ROUND(UNIX_TIMESTAMP(NOW(3)) * 1000) - 3600000, 1, 0, 0
WHERE @ljj_id IS NOT NULL AND @lp_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `private_msg` WHERE `src_user_id` = @ljj_id AND `tar_user_id` = @lp_id AND `content` = '对，发送后要立刻本地回显。');

-- Keep real user data. The launcher must not wipe forum activity on every start.
-- Seed only missing demo records, then recompute counters from real detail tables.

INSERT INTO `user_role` (`user_id`, `role_id`)
SELECT @admin_id, 1
WHERE @admin_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `user_role` WHERE `user_id` = @admin_id AND `role_id` = 1);
INSERT INTO `user_role` (`user_id`, `role_id`)
SELECT @admin_id, 2
WHERE @admin_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `user_role` WHERE `user_id` = @admin_id AND `role_id` = 2);
INSERT INTO `user_role` (`user_id`, `role_id`)
SELECT @admin_id, 3
WHERE @admin_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `user_role` WHERE `user_id` = @admin_id AND `role_id` = 3);
INSERT INTO `user_role` (`user_id`, `role_id`)
SELECT @admin_id, 4
WHERE @admin_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `user_role` WHERE `user_id` = @admin_id AND `role_id` = 4);
INSERT INTO `user_role` (`user_id`, `role_id`)
SELECT @root_id, 1
WHERE @root_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `user_role` WHERE `user_id` = @root_id AND `role_id` = 1);
INSERT INTO `user_role` (`user_id`, `role_id`)
SELECT @ljj_id, 3
WHERE @ljj_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `user_role` WHERE `user_id` = @ljj_id AND `role_id` = 3);
INSERT INTO `user_role` (`user_id`, `role_id`)
SELECT @lp_id, 3
WHERE @lp_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `user_role` WHERE `user_id` = @lp_id AND `role_id` = 3);
INSERT INTO `user_role` (`user_id`, `role_id`)
SELECT @xzr_id, 3
WHERE @xzr_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `user_role` WHERE `user_id` = @xzr_id AND `role_id` = 3);

CREATE TEMPORARY TABLE IF NOT EXISTS `_seed_posts` (
    `title` varchar(50) NOT NULL,
    `content` varchar(1000) NOT NULL,
    `username` varchar(11) NOT NULL,
    `plate_id` int NOT NULL,
    `browse_count` int NOT NULL,
    `hours_ago` int NOT NULL
) ENGINE=Memory DEFAULT CHARSET=utf8mb3;
DELETE FROM `_seed_posts`;
INSERT INTO `_seed_posts` (`title`, `content`, `username`, `plate_id`, `browse_count`, `hours_ago`) VALUES
('部门周会纪要模板，拿去直接改', '我把周会模板做成了三段：本周进展、风险点、下周计划。大家可以直接按这个格式提报，省很多时间。', 'ljj', 1, 76, 44),
('新来的实习同学怎么快速熟悉项目', '我们组最近来了新人，我整理了一份代码阅读顺序和接口联调清单，欢迎补充。', 'lp', 1, 58, 40),
('摄影初学者避坑：先学构图再追器材', '我试了两周，先把光线和构图练好确实更值。预算不多的同学，先别急着上全套器材。', 'lp', 2, 63, 38),
('跑步两周后膝盖有点不舒服', '配速不快，但是下楼梯会酸。有没有同学知道是不是鞋子或者姿势的问题？', 'xzr', 2, 42, 36),
('你们最近在食堂吃到的宝藏窗口是哪个？', '我先投三楼砂锅饭一票，出餐快味道也稳。欢迎大家来个真实测评，避雷也欢迎。', 'xzr', 3, 88, 33),
('校门口那家面馆是不是换师傅了', '上周吃还很香，今天汤底有点淡。想确认是我口味变了还是确实换了。', 'ljj', 3, 47, 31),
('今晚开黑差两人，主打沟通不甩锅', '8点到11点，段位不限，能听麦就行。上分其次，心态第一。', 'ljj', 4, 71, 29),
('有没有轻松一点的双人游戏推荐', '想和室友周末玩，不要太肝，最好一局半小时以内。', 'lp', 4, 39, 28),
('告白墙匿名提问：怎么自然开启聊天', '不是土味情话那种，就想正常认识一下。有没有一句不尴尬的开场白推荐？', 'lp', 5, 95, 25),
('图书馆三楼靠窗位置有人落了耳机', '黑色耳机盒，下午四点左右看到的。我交到前台了，失主可以去问一下。', 'xzr', 5, 52, 24),
('周末兼职信息汇总（更新版）', '整理了校内外相对靠谱的兼职渠道，时薪和时间我都标了。需要表格版可以回帖。', 'xzr', 6, 67, 21),
('家教面试会问什么问题', '第一次接家教，有点怕讲不清楚。有没有做过的同学分享一下流程？', 'ljj', 6, 44, 20),
('高数和数据结构复习资料打包', '把我期中复习用过的讲义、题单和错题思路整理好了，想要的同学留邮箱。', 'ljj', 7, 109, 17),
('英语六级听力怎么稳住心态', '一到听力就容易慌，尤其第二篇开始脑子发空。求一些真实有效的练法。', 'xzr', 7, 64, 16),
('SpringBoot 接口偶发 500，已定位一半', '目前怀疑是并发下对象复用导致的空指针，贴了日志关键段，欢迎懂后端的同学一起看看。', 'lp', 8, 83, 13),
('MySQL 联表查询突然变慢怎么排查', '数据量不大但 join 后很慢，explain 里 type 是 ALL。索引应该怎么加比较合适？', 'ljj', 8, 72, 12),
('最近状态有点低，求一份作息自救方案', '总觉得白天效率低，晚上又睡不早。有没有同学实践过能坚持的节奏，给我抄个作业。', 'xzr', 9, 74, 10),
('宿舍晚上总有人外放怎么沟通', '不想把关系弄僵，但确实影响睡觉。有没有比较不尴尬的说法？', 'lp', 9, 61, 9),
('课程设计需求不明确，怎么和老师沟通更有效', '我现在最大问题是边界太模糊。想问问大家一般怎么准备问题清单，避免沟通后还返工。', 'ljj', 10, 79, 7),
('毕设开题报告被打回一次', '老师说研究内容太散，我准备重新收束成两个模块。有没有类似经历的同学？', 'xzr', 10, 55, 6),
('寻物启事：灰色保温杯，杯盖有贴纸', '地点大概在实验楼一层自习区。杯子里有茶包，如果捡到麻烦联系我，真的感谢。', 'lp', 11, 58, 4),
('有人捡到校园卡吗，姓李', '大概在操场到食堂这一路丢的，已经挂失了，但还是想找回来。', 'ljj', 11, 49, 3),
('今天不卷了，来个轻松话题：你最爱的宵夜', '我先说：炒粉加一杯冰豆奶。最近加班有点多，想看看大家都靠什么回血。', 'xzr', 12, 69, 2),
('有没有适合雨天听的歌单', '今天下雨，写代码写到一半突然想听点安静的。大家丢几首歌吧。', 'lp', 12, 36, 1),
('服务器异常排查记录：NPE 复盘', '昨晚把线上空指针问题复盘了一遍，核心原因是返回对象判空遗漏。把排查链路整理给大家。', 'admin', 8, 92, 5),
('图书馆自习室临时维护通知', '今天晚间 8 点到 10 点东区自习室临时检修，建议大家提前换到南楼。', 'root', 11, 46, 8);

INSERT INTO `post` (
    `title`, `content`, `user_id`, `browse_count`, `reply_count`, `publish_time`,
    `first_post`, `post_status`, `post_heat`, `share_count`, `post_grade`,
    `post_collect`, `post_top`, `post_tread`, `post_author`, `plate_id`, `last_reply`, `last_reply_time`
)
SELECT sp.`title`, sp.`content`, u.`id`, sp.`browse_count`, 0, NOW() - INTERVAL sp.`hours_ago` HOUR,
       0, '1', sp.`browse_count`, 0, '0', '0', '0', '0', u.`username`, sp.`plate_id`, NULL, NULL
FROM `_seed_posts` sp
JOIN `user` u ON u.`username` = sp.`username`
WHERE NOT EXISTS (SELECT 1 FROM `post` p WHERE p.`title` = sp.`title`);

CREATE TEMPORARY TABLE IF NOT EXISTS `_seed_replies` (
    `title` varchar(50) NOT NULL,
    `username` varchar(11) NOT NULL,
    `content` varchar(255) NOT NULL,
    `minutes_ago` int NOT NULL,
    `seat` varchar(6) NOT NULL
) ENGINE=Memory DEFAULT CHARSET=utf8mb3;
DELETE FROM `_seed_replies`;
INSERT INTO `_seed_replies` (`title`, `username`, `content`, `minutes_ago`, `seat`) VALUES
('部门周会纪要模板，拿去直接改','lp','这个模板挺实用的，我准备把风险点那栏加一个负责人。',2310,'沙发'),
('部门周会纪要模板，拿去直接改','xzr','建议再加一列截止时间，不然后面追任务会忘。',2260,'椅子'),
('新来的实习同学怎么快速熟悉项目','ljj','可以先从接口文档和数据库表关系看，别一上来就啃所有代码。',2140,'沙发'),
('摄影初学者避坑：先学构图再追器材','xzr','同意，我之前买镜头买太早了，最后发现主要是不会找光。',2020,'沙发'),
('跑步两周后膝盖有点不舒服','lp','先降跑量吧，膝盖不舒服别硬顶，鞋底磨损也检查一下。',1940,'沙发'),
('你们最近在食堂吃到的宝藏窗口是哪个？','ljj','二楼麻辣拌最近也不错，少辣刚刚好。',1810,'沙发'),
('你们最近在食堂吃到的宝藏窗口是哪个？','lp','三楼砂锅我也投一票，就是饭点排队太久。',1760,'椅子'),
('校门口那家面馆是不是换师傅了','xzr','我昨天也觉得淡了，可能真换了，辣油味道不一样。',1680,'沙发'),
('今晚开黑差两人，主打沟通不甩锅','lp','我可以来，先说好我只会辅助，别嫌弃。',1600,'沙发'),
('今晚开黑差两人，主打沟通不甩锅','xzr','加我一个，输赢无所谓，别红温就行。',1540,'椅子'),
('有没有轻松一点的双人游戏推荐','ljj','双人成行挺合适，就是有些关卡会互相甩锅哈哈。',1500,'沙发'),
('告白墙匿名提问：怎么自然开启聊天','xzr','可以从共同课程或者活动聊起，比硬夸自然很多。',1380,'沙发'),
('告白墙匿名提问：怎么自然开启聊天','ljj','别一上来问太私人的，先轻松一点比较好。',1330,'椅子'),
('图书馆三楼靠窗位置有人落了耳机','lp','帮顶，这种能交前台真的很靠谱。',1280,'沙发'),
('周末兼职信息汇总（更新版）','ljj','求表格版，最好能标一下是否需要面试。',1130,'沙发'),
('家教面试会问什么问题','xzr','一般会问你擅长科目和能不能长期稳定，准备一个试讲思路。',1060,'沙发'),
('高数和数据结构复习资料打包','lp','想要数据结构部分，邮箱我私信你。',910,'沙发'),
('高数和数据结构复习资料打包','xzr','高数错题思路太需要了，感谢整理。',870,'椅子'),
('英语六级听力怎么稳住心态','ljj','我之前是每天固定二十分钟精听，别一次刷太猛。',820,'沙发'),
('SpringBoot 接口偶发 500，已定位一半','xzr','看起来像空对象没判，建议把异常栈第一行贴出来。',690,'沙发'),
('SpringBoot 接口偶发 500，已定位一半','ljj','如果是并发下才出现，可以先查共享变量和单例 Bean。',660,'椅子'),
('MySQL 联表查询突然变慢怎么排查','lp','先看 join 字段有没有索引，再看过滤条件是不是走了函数。',600,'沙发'),
('最近状态有点低，求一份作息自救方案','ljj','我试过固定起床时间，比强行早睡更容易坚持。',510,'沙发'),
('宿舍晚上总有人外放怎么沟通','xzr','可以先说自己最近睡眠不好，麻烦戴耳机，语气软一点。',470,'沙发'),
('课程设计需求不明确，怎么和老师沟通更有效','lp','带着三个具体方案去问，不要只问“怎么做”，老师更好回答。',350,'沙发'),
('毕设开题报告被打回一次','ljj','先把问题、方法、结果三件事写清楚，别急着堆功能。',300,'沙发'),
('寻物启事：灰色保温杯，杯盖有贴纸','xzr','帮顶，实验楼前台我下午路过可以顺便问一下。',190,'沙发'),
('有人捡到校园卡吗，姓李','lp','建议也去保卫处问问，校园卡经常会有人送过去。',150,'沙发'),
('今天不卷了，来个轻松话题：你最爱的宵夜','ljj','炒粉加豆奶这个组合太懂了，我再加一个烤冷面。',80,'沙发'),
('有没有适合雨天听的歌单','xzr','陈绮贞和落日飞车都挺适合雨天写代码。',45,'沙发'),
('服务器异常排查记录：NPE 复盘','root','这个复盘很完整，尤其是链路定位那段，值班同学可以照着走。',120,'沙发'),
('图书馆自习室临时维护通知','admin','收到，已经帮你转到班群，避免同学白跑。',95,'沙发');

INSERT INTO `post_details` (`pd_uid`, `post_id`, `pd_content`, `seat`, `reply_time`, `isLook`)
SELECT u.`id`, p.`id`, sr.`content`, sr.`seat`, NOW() - INTERVAL sr.`minutes_ago` MINUTE, '0'
FROM `_seed_replies` sr
JOIN `post` p ON p.`title` = sr.`title`
JOIN `user` u ON u.`username` = sr.`username`
WHERE NOT EXISTS (
    SELECT 1 FROM `post_details` d WHERE d.`post_id` = p.`id` AND d.`pd_content` = sr.`content`
);

CREATE TEMPORARY TABLE IF NOT EXISTS `_seed_likes` (`title` varchar(50), `username` varchar(11)) ENGINE=Memory DEFAULT CHARSET=utf8mb3;
DELETE FROM `_seed_likes`;
INSERT INTO `_seed_likes` (`title`, `username`) VALUES
('部门周会纪要模板，拿去直接改','root'),('部门周会纪要模板，拿去直接改','lp'),('部门周会纪要模板，拿去直接改','xzr'),
('你们最近在食堂吃到的宝藏窗口是哪个？','root'),('你们最近在食堂吃到的宝藏窗口是哪个？','ljj'),('你们最近在食堂吃到的宝藏窗口是哪个？','lp'),
('今晚开黑差两人，主打沟通不甩锅','lp'),('今晚开黑差两人，主打沟通不甩锅','xzr'),
('告白墙匿名提问：怎么自然开启聊天','root'),('告白墙匿名提问：怎么自然开启聊天','ljj'),('告白墙匿名提问：怎么自然开启聊天','xzr'),
('周末兼职信息汇总（更新版）','root'),('周末兼职信息汇总（更新版）','ljj'),
('高数和数据结构复习资料打包','root'),('高数和数据结构复习资料打包','lp'),('高数和数据结构复习资料打包','xzr'),
('SpringBoot 接口偶发 500，已定位一半','root'),('SpringBoot 接口偶发 500，已定位一半','ljj'),('SpringBoot 接口偶发 500，已定位一半','xzr'),
('MySQL 联表查询突然变慢怎么排查','root'),('MySQL 联表查询突然变慢怎么排查','lp'),
('最近状态有点低，求一份作息自救方案','root'),('最近状态有点低，求一份作息自救方案','ljj'),
('今天不卷了，来个轻松话题：你最爱的宵夜','root'),('今天不卷了，来个轻松话题：你最爱的宵夜','ljj'),
('服务器异常排查记录：NPE 复盘','root'),('服务器异常排查记录：NPE 复盘','xzr'),
('图书馆自习室临时维护通知','admin'),('图书馆自习室临时维护通知','lp');

INSERT INTO `post_operation` (`postId`, `uid`, `isCompletion`)
SELECT p.`id`, u.`id`, 1
FROM `_seed_likes` sl
JOIN `post` p ON p.`title` = sl.`title`
JOIN `user` u ON u.`username` = sl.`username`
WHERE NOT EXISTS (SELECT 1 FROM `post_operation` o WHERE o.`postId` = p.`id` AND o.`uid` = u.`id`);

CREATE TEMPORARY TABLE IF NOT EXISTS `_seed_collects` (`title` varchar(50), `username` varchar(11)) ENGINE=Memory DEFAULT CHARSET=utf8mb3;
DELETE FROM `_seed_collects`;
INSERT INTO `_seed_collects` (`title`, `username`) VALUES
('部门周会纪要模板，拿去直接改','root'),('摄影初学者避坑：先学构图再追器材','xzr'),
('你们最近在食堂吃到的宝藏窗口是哪个？','ljj'),('告白墙匿名提问：怎么自然开启聊天','xzr'),
('周末兼职信息汇总（更新版）','root'),('高数和数据结构复习资料打包','lp'),
('SpringBoot 接口偶发 500，已定位一半','ljj'),('MySQL 联表查询突然变慢怎么排查','root'),
('最近状态有点低，求一份作息自救方案','lp'),('课程设计需求不明确，怎么和老师沟通更有效','xzr'),
('寻物启事：灰色保温杯，杯盖有贴纸','root'),('今天不卷了，来个轻松话题：你最爱的宵夜','ljj'),
('服务器异常排查记录：NPE 复盘','admin'),('图书馆自习室临时维护通知','root');

INSERT INTO `u_collect` (`u_id`, `all_id`, `title`, `source_plate`, `collect_time`, `type`)
SELECT u.`id`, p.`id`, p.`title`, CAST(p.`plate_id` AS CHAR), DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'), '1'
FROM `_seed_collects` sc
JOIN `post` p ON p.`title` = sc.`title`
JOIN `user` u ON u.`username` = sc.`username`
WHERE NOT EXISTS (SELECT 1 FROM `u_collect` c WHERE c.`u_id` = u.`id` AND c.`all_id` = p.`id` AND c.`type` = '1');

CREATE TEMPORARY TABLE IF NOT EXISTS `_seed_attention` (`user_name` varchar(11), `follow_name` varchar(11)) ENGINE=Memory DEFAULT CHARSET=utf8mb3;
DELETE FROM `_seed_attention`;
INSERT INTO `_seed_attention` (`user_name`, `follow_name`) VALUES
('root','ljj'),('root','lp'),('root','xzr'),
('ljj','lp'),('ljj','xzr'),('lp','ljj'),('lp','xzr'),('xzr','ljj'),('xzr','lp');

INSERT INTO `attention` (`uid`, `aid`)
SELECT u.`id`, f.`id`
FROM `_seed_attention` sa
JOIN `user` u ON u.`username` = sa.`user_name`
JOIN `user` f ON f.`username` = sa.`follow_name`
WHERE u.`id` <> f.`id`
  AND NOT EXISTS (SELECT 1 FROM `attention` a WHERE a.`uid` = u.`id` AND a.`aid` = f.`id`);

-- Recompute visible counters from persisted rows. No fake likes/collects/replies.
UPDATE `post` p
SET p.`reply_count` = (SELECT COUNT(*) FROM `post_details` d WHERE d.`post_id` = p.`id`),
    p.`post_grade` = CAST((SELECT COUNT(*) FROM `post_operation` o WHERE o.`postId` = p.`id`) AS CHAR),
    p.`post_collect` = CAST((SELECT COUNT(*) FROM `u_collect` c WHERE c.`all_id` = p.`id` AND c.`type` = '1') AS CHAR),
    p.`last_reply` = ifnull((SELECT u.`username` FROM `post_details` d JOIN `user` u ON u.`id` = d.`pd_uid` WHERE d.`post_id` = p.`id` ORDER BY d.`reply_time` DESC, d.`pid` DESC LIMIT 1), p.`post_author`),
    p.`last_reply_time` = ifnull((SELECT MAX(d.`reply_time`) FROM `post_details` d WHERE d.`post_id` = p.`id`), p.`publish_time`);

UPDATE `post` p
SET p.`post_heat` = IFNULL(p.`browse_count`,0) + IFNULL(p.`reply_count`,0) + CAST(IFNULL(p.`post_grade`,'0') AS UNSIGNED) + CAST(IFNULL(p.`post_collect`,'0') AS UNSIGNED) + IFNULL(p.`share_count`,0);

UPDATE `plate` p
SET p.`theme` = (SELECT COUNT(*) FROM `post` t WHERE t.`plate_id` = p.`id` AND t.`post_status` <> '0'),
    p.`posts` = (SELECT COUNT(*) FROM `post_details` d JOIN `post` t ON t.`id` = d.`post_id` WHERE t.`plate_id` = p.`id` AND t.`post_status` <> '0'),
    p.`collect_total` = CAST((SELECT COUNT(*) FROM `u_collect` c WHERE c.`type` = '2' AND c.`all_id` = p.`id`) AS CHAR);

-- Recompute user experience/integral from real activity rows.
UPDATE `experience` e
JOIN `user` u ON u.`id` = e.`user_id`
LEFT JOIN (
    SELECT p.`user_id` uid,
           COUNT(p.`id`) post_cnt,
           IFNULL(SUM(p.`browse_count`),0) browse_sum
    FROM `post` p
    WHERE p.`post_status` not in ('0','6')
    GROUP BY p.`user_id`
) ps ON ps.uid = u.`id`
LEFT JOIN (
    SELECT d.`pd_uid` uid, COUNT(*) reply_cnt
    FROM `post_details` d
    GROUP BY d.`pd_uid`
) rs ON rs.uid = u.`id`
LEFT JOIN (
    SELECT p.`user_id` uid, COUNT(o.`id`) got_like_cnt
    FROM `post` p
    JOIN `post_operation` o ON o.`postId` = p.`id`
    GROUP BY p.`user_id`
) ls ON ls.uid = u.`id`
LEFT JOIN (
    SELECT p.`user_id` uid, COUNT(c.`id`) got_collect_cnt
    FROM `post` p
    JOIN `u_collect` c ON c.`all_id` = p.`id` AND c.`type` = '1'
    GROUP BY p.`user_id`
) cs ON cs.uid = u.`id`
LEFT JOIN (
    SELECT a.`aid` uid, COUNT(*) fans_cnt
    FROM `attention` a
    GROUP BY a.`aid`
) fs ON fs.uid = u.`id`
SET e.`total_experience` = ifnull(ps.post_cnt,0) * 10
                         + ifnull(rs.reply_cnt,0) * 3
                         + ifnull(ls.got_like_cnt,0) * 2
                         + ifnull(cs.got_collect_cnt,0) * 2
                         + ifnull(fs.fans_cnt,0) * 2,
    e.`time` = now();

UPDATE `integral` i
JOIN `user` u ON u.`id` = i.`user_id`
LEFT JOIN (
    SELECT p.`user_id` uid,
           COUNT(p.`id`) post_cnt,
           IFNULL(SUM(p.`browse_count`),0) browse_sum
    FROM `post` p
    WHERE p.`post_status` not in ('0','6')
    GROUP BY p.`user_id`
) ps ON ps.uid = u.`id`
LEFT JOIN (
    SELECT d.`pd_uid` uid, COUNT(*) reply_cnt
    FROM `post_details` d
    GROUP BY d.`pd_uid`
) rs ON rs.uid = u.`id`
LEFT JOIN (
    SELECT p.`user_id` uid, COUNT(o.`id`) got_like_cnt
    FROM `post` p
    JOIN `post_operation` o ON o.`postId` = p.`id`
    GROUP BY p.`user_id`
) ls ON ls.uid = u.`id`
LEFT JOIN (
    SELECT p.`user_id` uid, COUNT(c.`id`) got_collect_cnt
    FROM `post` p
    JOIN `u_collect` c ON c.`all_id` = p.`id` AND c.`type` = '1'
    GROUP BY p.`user_id`
) cs ON cs.uid = u.`id`
LEFT JOIN (
    SELECT a.`aid` uid, COUNT(*) fans_cnt
    FROM `attention` a
    GROUP BY a.`aid`
) fs ON fs.uid = u.`id`
SET i.`total_integral` = ifnull(ps.post_cnt,0) * 20
                      + ifnull(rs.reply_cnt,0) * 6
                      + ifnull(ls.got_like_cnt,0) * 5
                      + ifnull(cs.got_collect_cnt,0) * 5
                      + ifnull(fs.fans_cnt,0) * 4
                      + floor(ifnull(ps.browse_sum,0) / 8),
    i.`last_time` = now();

