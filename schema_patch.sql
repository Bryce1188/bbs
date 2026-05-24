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

