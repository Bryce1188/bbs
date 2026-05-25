-- Patch missing schema objects required by application mappers.
USE bbs;

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

DELETE FROM `attention`;
DELETE FROM `notice`;
DELETE FROM `post_details`;
DELETE FROM `post_operation`;
DELETE FROM `post_share`;
DELETE FROM `post_report`;
DELETE FROM `u_collect`;
DELETE FROM `sys_log`;
DELETE FROM `sys_warn`;
DELETE FROM `u_log`;
DELETE FROM `leave_word`;
DELETE FROM `user_friend`;
DELETE FROM `friend_group`;
DELETE FROM `post`;

DELETE FROM `integral` WHERE `user_id` NOT IN (@admin_id, @root_id, @ljj_id, @lp_id, @xzr_id);
DELETE FROM `experience` WHERE `user_id` NOT IN (@admin_id, @root_id, @ljj_id, @lp_id, @xzr_id);
DELETE FROM `sign` WHERE `user_id` NOT IN (@admin_id, @root_id, @ljj_id, @lp_id, @xzr_id);
DELETE FROM `user_role` WHERE `user_id` NOT IN (@admin_id, @root_id, @ljj_id, @lp_id, @xzr_id);
DELETE FROM `user` WHERE `username` NOT IN ('admin', 'root', 'ljj', 'lp', 'xzr');

UPDATE `plate` SET `theme` = 0, `posts` = 0, `collect_total` = '0';

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

INSERT INTO `post` (
    `title`, `content`, `user_id`, `browse_count`, `reply_count`, `publish_time`,
    `first_post`, `post_status`, `post_heat`, `share_count`, `post_grade`,
    `post_collect`, `post_top`, `post_tread`, `post_author`, `plate_id`, `last_reply`, `last_reply_time`
) VALUES
('部门周会纪要模板，拿去直接改', '我把周会模板做成了三段：本周进展、风险点、下周计划。大家可以直接按这个格式提报，省很多时间。', @ljj_id, 76, 7, NOW() - INTERVAL 44 HOUR, 0, '1', 24, 1, '1', '4', '5', '1', 'ljj', 1, 'lp', NOW() - INTERVAL 40 HOUR),
('摄影初学者避坑：先学构图再追器材', '我试了两周，先把光线和构图练好确实更值。预算不多的同学，先别急着上全套器材。', @lp_id, 63, 5, NOW() - INTERVAL 38 HOUR, 0, '1', 19, 1, '1', '3', '4', '1', 'lp', 2, 'xzr', NOW() - INTERVAL 35 HOUR),
('你们最近在食堂吃到的宝藏窗口是哪个？', '我先投三楼砂锅饭一票，出餐快味道也稳。欢迎大家来个真实测评，避雷也欢迎。', @xzr_id, 88, 10, NOW() - INTERVAL 33 HOUR, 0, '1', 27, 2, '1', '6', '6', '1', 'xzr', 3, 'ljj', NOW() - INTERVAL 31 HOUR),
('今晚开黑差两人，主打沟通不甩锅', '8点到11点，段位不限，能听麦就行。上分其次，心态第一。', @ljj_id, 71, 6, NOW() - INTERVAL 29 HOUR, 0, '1', 22, 1, '1', '4', '5', '1', 'ljj', 4, 'lp', NOW() - INTERVAL 27 HOUR),
('告白墙匿名提问：怎么自然开启聊天', '不是土味情话那种，就想正常认识一下。有没有一句不尴尬的开场白推荐？', @lp_id, 95, 12, NOW() - INTERVAL 25 HOUR, 0, '1', 30, 2, '1', '7', '7', '1', 'lp', 5, 'xzr', NOW() - INTERVAL 23 HOUR),
('周末兼职信息汇总（更新版）', '整理了校内外相对靠谱的兼职渠道，时薪和时间我都标了。需要表格版可以回帖。', @xzr_id, 67, 5, NOW() - INTERVAL 21 HOUR, 0, '1', 20, 1, '1', '4', '4', '1', 'xzr', 6, 'ljj', NOW() - INTERVAL 19 HOUR),
('高数和数据结构复习资料打包', '把我期中复习用过的讲义、题单和错题思路整理好了，想要的同学留邮箱。', @ljj_id, 109, 14, NOW() - INTERVAL 17 HOUR, 0, '1', 35, 3, '1', '8', '9', '1', 'ljj', 7, 'lp', NOW() - INTERVAL 15 HOUR),
('SpringBoot 接口偶发 500，已定位一半', '目前怀疑是并发下对象复用导致的空指针，贴了日志关键段，欢迎懂后端的同学一起看看。', @lp_id, 83, 8, NOW() - INTERVAL 13 HOUR, 0, '1', 26, 2, '1', '5', '6', '1', 'lp', 8, 'xzr', NOW() - INTERVAL 12 HOUR),
('最近状态有点低，求一份作息自救方案', '总觉得白天效率低，晚上又睡不早。有没有同学实践过能坚持的节奏，给我抄个作业。', @xzr_id, 74, 9, NOW() - INTERVAL 10 HOUR, 0, '1', 23, 1, '1', '5', '5', '1', 'xzr', 9, 'ljj', NOW() - INTERVAL 9 HOUR),
('课程设计需求不明确，怎么和老师沟通更有效', '我现在最大问题是边界太模糊。想问问大家一般怎么准备问题清单，避免沟通后还返工。', @ljj_id, 79, 7, NOW() - INTERVAL 7 HOUR, 0, '1', 24, 1, '1', '5', '5', '1', 'ljj', 10, 'lp', NOW() - INTERVAL 6 HOUR),
('寻物启事：灰色保温杯，杯盖有贴纸', '地点大概在实验楼一层自习区。杯子里有茶包，如果捡到麻烦联系我，真的感谢。', @lp_id, 58, 4, NOW() - INTERVAL 4 HOUR, 0, '1', 16, 0, '1', '3', '3', '1', 'lp', 11, 'xzr', NOW() - INTERVAL 3 HOUR),
('今天不卷了，来个轻松话题：你最爱的宵夜', '我先说：炒粉加一杯冰豆奶。最近加班有点多，想看看大家都靠什么回血。', @xzr_id, 69, 6, NOW() - INTERVAL 2 HOUR, 0, '1', 21, 1, '1', '4', '4', '1', 'xzr', 12, 'ljj', NOW() - INTERVAL 80 MINUTE);

UPDATE `plate` p
SET
    p.`theme` = (SELECT COUNT(*) FROM `post` t WHERE t.`plate_id` = p.`id` AND t.`post_status` <> '0'),
    p.`posts` = (SELECT COUNT(*) FROM `post` t WHERE t.`plate_id` = p.`id` AND t.`post_status` <> '0');
