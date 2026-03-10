-- 数据库导出
-- 日期: 2026-03-10T14:24:20.465Z
-- 数据库: cssell

USE cssell;

-- ----------------------------
-- 表结构: bufftoken
-- ----------------------------

CREATE TABLE `bufftoken` (
  `buffToken` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- 数据: bufftoken
-- ----------------------------

INSERT INTO bufftoken VALUES ('vinfo_n_f_l_n3=dfb9f0a2a86625b5.1.0.1748071821767.0.1748071823132; Device-Id=3gMjgBFf51rDwxJBt11j; _ga=GA1.1.431341601.1763874296; _ga_C6TGHFPQ1H=GS2.1.s1763874296$o1$g0$t1763874301$j55$l0$h0; _gcl_au=1.1.834087297.1770364403; hb_MA-BFB6-AC673A756684_source=mail.163.com; NTES_P_UTID=LHRXyr6HQquWbEqNE6yd4aftagJDZEli|1772445917; P_INFO=m13686977947@163.com|1772445917|0|mail163|00&99|gud&1770364330&mail163#CN&null#10#0#0|136947&0||13686977947@163.com; nts_mail_user=m13686977947@163.com:-1:1; Locale-Supported=zh-Hans; game=csgo; remember_me=U1088840259|sVJMgZrtmGmgyLiHQ0DiHpl1BXFALCFz; session=1-WkDfoARj5e1E1zV5EUZMYrQnmKAjNmzb_46QEzNPQa8b2015952155; inventory_fold_result_switch=; csrf_token=IjgzOTYxM2Q1Zjk1OGRkM2IxM2EzOGNmZWNhMWNjNmZmNDZjZWVmOTEi.aasZ6Q.EQYW5g2D7HFARotWHM7ex3lZGFo');

-- ----------------------------
-- 表结构: c5token
-- ----------------------------

CREATE TABLE `c5token` (
  `c5Token` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- 数据: c5token
-- ----------------------------

INSERT INTO c5token VALUES ('d173e19900d444f2bccb4ee5b70f1264');

-- ----------------------------
-- 表结构: record
-- ----------------------------

CREATE TABLE `record` (
  `name` varchar(255) DEFAULT NULL,
  `wear` text NOT NULL,
  `type` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `price` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- 数据: record
-- ----------------------------

INSERT INTO record VALUES ('截短霰弹枪 | 赤红蜡染 (崭新出厂)

', '0.00-0.01', 'C5', Tue Mar 10 2026 19:23:34 GMT+0800 (中国标准时间), '[1.94,1.94,1.94,1.95,1.95,1.95,1.96,1.98,1.98,1.98]');
INSERT INTO record VALUES ('截短霰弹枪 | 赤红蜡染 (崭新出厂)

', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:23:34 GMT+0800 (中国标准时间), '["1.97","1.97","1.98","1.99","1.99","2","2.05","2.09","2.1","2.16"]');
INSERT INTO record VALUES ('M249 | 冻雨 (崭新出厂)', '0.00-0.01', 'C5', Tue Mar 10 2026 19:29:00 GMT+0800 (中国标准时间), '[2.2,2.5]');
INSERT INTO record VALUES ('M249 | 冻雨 (崭新出厂)', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:29:00 GMT+0800 (中国标准时间), '["1.85","1.86","1.86","1.86","1.87","1.88","1.96","1.96","1.96","1.96"]');
INSERT INTO record VALUES ('M249 | 冻雨 (崭新出厂)', '0.01-0.02', 'C5', Tue Mar 10 2026 19:30:21 GMT+0800 (中国标准时间), '[]');
INSERT INTO record VALUES ('M249 | 冻雨 (崭新出厂)', '0.01-0.02', 'BUFF', Tue Mar 10 2026 19:30:21 GMT+0800 (中国标准时间), '["1.85","1.85","1.85","1.86","1.86","1.87","1.87","1.87","2.1","2.1"]');
INSERT INTO record VALUES ('M249 | 冻雨 (崭新出厂)', '0.01-0.02', 'C5', Tue Mar 10 2026 19:30:25 GMT+0800 (中国标准时间), '[]');
INSERT INTO record VALUES ('M249 | 冻雨 (崭新出厂)', '0.01-0.02', 'BUFF', Tue Mar 10 2026 19:30:25 GMT+0800 (中国标准时间), '["1.85","1.85","1.85","1.86","1.86","1.87","1.87","1.87","2.1","2.1"]');
INSERT INTO record VALUES ('MAC-10 | 雪溅 (崭新出厂)', '0.00-0.01', 'C5', Tue Mar 10 2026 19:32:30 GMT+0800 (中国标准时间), '[10,11,11.92,19.99,20,20,20.74,25,29.5,39.5]');
INSERT INTO record VALUES ('MAC-10 | 雪溅 (崭新出厂)', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:32:31 GMT+0800 (中国标准时间), '["7","7.01","7.01","7.02","7.02","7.02","7.03","7.05","7.07","7.07"]');
INSERT INTO record VALUES ('M4A4 | 风蚀幽冥 (崭新出厂)
', '0.00-0.01', 'C5', Tue Mar 10 2026 19:33:50 GMT+0800 (中国标准时间), '[14.5,14.5,14.92,15.32,15.32,15.32,15.32,15.32,15.32,15.32]');
INSERT INTO record VALUES ('M4A4 | 风蚀幽冥 (崭新出厂)
', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:33:51 GMT+0800 (中国标准时间), '["17.28","17.37","17.37","17.38","17.39","17.39","17.41","17.41","17.48","17.49"]');
INSERT INTO record VALUES ('SG 553 | 狩猎印花 (崭新出厂)
', '0.01-0.02', 'C5', Tue Mar 10 2026 19:34:32 GMT+0800 (中国标准时间), '[1.69,1.87,1.87,1.87,1.88,2,2.3,2.5,3,3]');
INSERT INTO record VALUES ('SG 553 | 狩猎印花 (崭新出厂)
', '0.01-0.02', 'BUFF', Tue Mar 10 2026 19:34:32 GMT+0800 (中国标准时间), '["1.65","1.68","1.68","1.68","1.68","1.68","1.68","1.68","1.7","2.99"]');
INSERT INTO record VALUES ('SG 553 | 狩猎印花 (崭新出厂)
', '0.00-0.01', 'C5', Tue Mar 10 2026 19:35:00 GMT+0800 (中国标准时间), '[2.87,2.99,3,3.2,3.6,4.2,4.2,4.3,6]');
INSERT INTO record VALUES ('SG 553 | 狩猎印花 (崭新出厂)
', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:35:00 GMT+0800 (中国标准时间), '["2.18","2.2","2.33","2.33","2.33","2.34","2.35","2.35","2.48","2.5"]');
INSERT INTO record VALUES ('SCAR-20 | 锌元素 (崭新出厂)
', '0.00-0.01', 'C5', Tue Mar 10 2026 19:36:21 GMT+0800 (中国标准时间), '[2.9]');
INSERT INTO record VALUES ('SCAR-20 | 锌元素 (崭新出厂)
', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:36:21 GMT+0800 (中国标准时间), '["1.69","1.69","1.89","1.89","1.9","1.92","2","2","2","2"]');
INSERT INTO record VALUES ('新星 | 气流 (崭新出厂)', '0.00-0.01', 'C5', Tue Mar 10 2026 19:36:46 GMT+0800 (中国标准时间), '[1.4,1.87,1.87,1.88,2.1,2.2]');
INSERT INTO record VALUES ('新星 | 气流 (崭新出厂)', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:36:46 GMT+0800 (中国标准时间), '["1.29","1.29","1.29","1.29","1.3","1.3","1.3","1.3","1.31","1.31"]');
INSERT INTO record VALUES ('新星 | 气流 (崭新出厂)', '0.01-0.02', 'C5', Tue Mar 10 2026 19:37:25 GMT+0800 (中国标准时间), '[]');
INSERT INTO record VALUES ('新星 | 气流 (崭新出厂)', '0.01-0.02', 'BUFF', Tue Mar 10 2026 19:37:25 GMT+0800 (中国标准时间), '["1.17","1.17","1.17","1.17","1.17","1.17","1.17","1.17","1.19","1.19"]');
INSERT INTO record VALUES ('新星 | 气流 (崭新出厂)', '0.01-0.02', 'C5', Tue Mar 10 2026 19:37:28 GMT+0800 (中国标准时间), '[]');
INSERT INTO record VALUES ('新星 | 气流 (崭新出厂)', '0.01-0.02', 'BUFF', Tue Mar 10 2026 19:37:28 GMT+0800 (中国标准时间), '["1.17","1.17","1.17","1.17","1.17","1.17","1.17","1.17","1.19","1.19"]');
INSERT INTO record VALUES ('MP9 | 眩晕 (崭新出厂)
', '0.00-0.01', 'C5', Tue Mar 10 2026 19:38:35 GMT+0800 (中国标准时间), '[1.71,1.71,1.72,1.72,1.78,2.3,2.5]');
INSERT INTO record VALUES ('MP9 | 眩晕 (崭新出厂)
', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:38:35 GMT+0800 (中国标准时间), '["1.47","1.48","1.6","1.7","1.7","1.7","1.76","1.77","1.9","1.9"]');
INSERT INTO record VALUES ('MP9 | 眩晕 (崭新出厂)
', '0.01-0.02', 'C5', Tue Mar 10 2026 19:38:54 GMT+0800 (中国标准时间), '[]');
INSERT INTO record VALUES ('MP9 | 眩晕 (崭新出厂)
', '0.01-0.02', 'BUFF', Tue Mar 10 2026 19:38:54 GMT+0800 (中国标准时间), '["1.47","1.47","1.47","1.48","1.5","1.59","2.98","2.98","2.99","2.99"]');
INSERT INTO record VALUES ('MP9 | 眩晕 (崭新出厂)
', '0.01-0.02', 'C5', Tue Mar 10 2026 19:38:56 GMT+0800 (中国标准时间), '[]');
INSERT INTO record VALUES ('MP9 | 眩晕 (崭新出厂)
', '0.01-0.02', 'BUFF', Tue Mar 10 2026 19:38:56 GMT+0800 (中国标准时间), '["1.47","1.47","1.47","1.48","1.5","1.59","2.98","2.98","2.99","2.99"]');
INSERT INTO record VALUES ('MP5-SD | 雪溅 (崭新出厂)', '0.00-0.01', 'C5', Tue Mar 10 2026 19:39:21 GMT+0800 (中国标准时间), '[6,6.64,6.64,15.9,18.82]');
INSERT INTO record VALUES ('MP5-SD | 雪溅 (崭新出厂)', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:39:21 GMT+0800 (中国标准时间), '["5.86","5.87","5.87","5.89","5.89","5.89","5.89","5.96","5.96","5.97"]');
INSERT INTO record VALUES ('MAC-10 | 雪溅 (崭新出厂)', '0.00-0.01', 'C5', Tue Mar 10 2026 19:39:40 GMT+0800 (中国标准时间), '[9.99,9.99,10,11,11.92,19.99,20,20,20.74,25]');
INSERT INTO record VALUES ('MAC-10 | 雪溅 (崭新出厂)', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:39:41 GMT+0800 (中国标准时间), '["7","7.01","7.01","7.02","7.02","7.02","7.03","7.05","7.07","7.07"]');
INSERT INTO record VALUES ('Tec-9 | 芭蕉叶 (崭新出厂)
', '0.00-0.01', 'C5', Tue Mar 10 2026 19:39:55 GMT+0800 (中国标准时间), '[8.99,9,9.9,10,16.42,20,20,38.88,40.2,44]');
INSERT INTO record VALUES ('Tec-9 | 芭蕉叶 (崭新出厂)
', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:39:56 GMT+0800 (中国标准时间), '["10.57","10.57","10.57","10.57","10.57","10.57","10.57","10.58","10.58","10.6"]');
INSERT INTO record VALUES ('双持贝瑞塔 | 银流 (崭新出厂)
', '0.00-0.01', 'C5', Tue Mar 10 2026 19:40:08 GMT+0800 (中国标准时间), '[2.5,2.99]');
INSERT INTO record VALUES ('双持贝瑞塔 | 银流 (崭新出厂)
', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:40:08 GMT+0800 (中国标准时间), '["1.93","1.94","1.94","1.94","1.94","1.95","1.96","1.96","1.96","1.97"]');
INSERT INTO record VALUES ('PP-野牛 | 变焦 (崭新出厂)
', '0.00-0.01', 'C5', Tue Mar 10 2026 19:40:31 GMT+0800 (中国标准时间), '[1.3,1.4,2.9,3.8,3.8]');
INSERT INTO record VALUES ('PP-野牛 | 变焦 (崭新出厂)
', '0.00-0.01', 'BUFF', Tue Mar 10 2026 19:40:31 GMT+0800 (中国标准时间), '["1.42","1.42","1.45","1.45","1.45","1.45","1.46","1.48","1.48","1.48"]');
INSERT INTO record VALUES ('R8左轮手枪 | 暗室 (崭新出厂)
', '0.01-0.02', 'C5', Tue Mar 10 2026 19:40:47 GMT+0800 (中国标准时间), '[11.11,11.11,11.36,11.36]');
INSERT INTO record VALUES ('R8左轮手枪 | 暗室 (崭新出厂)
', '0.01-0.02', 'BUFF', Tue Mar 10 2026 19:40:47 GMT+0800 (中国标准时间), '["4.64","4.64","4.65","4.65","4.65","4.67","4.69","4.7","5","5.41"]');
INSERT INTO record VALUES ('法玛斯 | 副产品 (崭新出厂)', '0.01-0.02', 'C5', Tue Mar 10 2026 19:41:15 GMT+0800 (中国标准时间), '[1.69,1.7,1.77,1.9,5.55]');
INSERT INTO record VALUES ('法玛斯 | 副产品 (崭新出厂)', '0.01-0.02', 'BUFF', Tue Mar 10 2026 19:41:15 GMT+0800 (中国标准时间), '["2.41","2.41","2.42","2.48","2.48","2.48","2.48","2.48","2.48","2.48"]');
INSERT INTO record VALUES ('R8左轮手枪 | 暗室 (略有磨损)
', '0.07-0.08', 'C5', Tue Mar 10 2026 19:41:51 GMT+0800 (中国标准时间), '[1.99,2,2,2,2.25,2.25,2.7,3.5,3.5,4.99]');
INSERT INTO record VALUES ('R8左轮手枪 | 暗室 (略有磨损)
', '0.07-0.08', 'BUFF', Tue Mar 10 2026 19:41:51 GMT+0800 (中国标准时间), '["1.89","1.9","1.9","1.9","1.94","1.94","1.95","1.96","1.99","2"]');
INSERT INTO record VALUES ('M4A4 | 风蚀幽冥 (略有磨损)', '0.07-0.08', 'C5', Tue Mar 10 2026 19:42:33 GMT+0800 (中国标准时间), '[2.79,2.8,2.8,2.95,3,3,3,3.72,3.72,3.72]');
INSERT INTO record VALUES ('M4A4 | 风蚀幽冥 (略有磨损)', '0.07-0.08', 'BUFF', Tue Mar 10 2026 19:42:33 GMT+0800 (中国标准时间), '["1.8","1.8","1.82","1.83","1.83","1.83","1.83","1.83","1.83","1.83"]');
INSERT INTO record VALUES ('MP9 | 创世蜂鸣 (略有磨损)
', '0.07-0.08', 'C5', Tue Mar 10 2026 19:43:20 GMT+0800 (中国标准时间), '[0.8,0.99,0.99,0.99,1,1,1,1,1,1]');
INSERT INTO record VALUES ('MP9 | 创世蜂鸣 (略有磨损)
', '0.07-0.08', 'BUFF', Tue Mar 10 2026 19:43:20 GMT+0800 (中国标准时间), '["0.73","0.73","0.73","0.73","0.73","0.73","0.74","0.74","0.74","0.74"]');
INSERT INTO record VALUES ('加利尔AR | 天空曼陀罗 (略有磨损)
', '0.07-0.08', 'C5', Tue Mar 10 2026 19:44:21 GMT+0800 (中国标准时间), '[22.8,22.9,23,23.66,24,25,30,48,99]');
INSERT INTO record VALUES ('加利尔AR | 天空曼陀罗 (略有磨损)
', '0.07-0.08', 'BUFF', Tue Mar 10 2026 19:44:21 GMT+0800 (中国标准时间), '["21.86","21.86","21.87","21.87","21.88","21.88","21.88","21.88","21.88","21.99"]');
INSERT INTO record VALUES ('MAC-10 | 雪溅 (略有磨损)

', '0.07-0.08', 'C5', Tue Mar 10 2026 19:44:45 GMT+0800 (中国标准时间), '[1.2,1.24,1.24,1.24,1.24,1.24,1.24,1.24,1.24,1.24]');
INSERT INTO record VALUES ('MAC-10 | 雪溅 (略有磨损)

', '0.07-0.08', 'BUFF', Tue Mar 10 2026 19:44:46 GMT+0800 (中国标准时间), '["1.21","1.21","1.22","1.24","1.24","1.24","1.24","1.24","1.24","1.24"]');
INSERT INTO record VALUES ('法玛斯 | 复仇 (略有磨损)
', '0.07-0.08', 'C5', Tue Mar 10 2026 19:44:58 GMT+0800 (中国标准时间), '[1.36,1.36,1.37,1.39,1.4,1.43,1.5,1.59,2,2]');
INSERT INTO record VALUES ('法玛斯 | 复仇 (略有磨损)
', '0.07-0.08', 'BUFF', Tue Mar 10 2026 19:44:58 GMT+0800 (中国标准时间), '["0.88","1.19","1.2","1.2","1.2","1.2","1.2","1.2","1.2","1.2"]');
INSERT INTO record VALUES ('AUG | 蔓延 (略有磨损)
', '0.07-0.08', 'C5', Tue Mar 10 2026 19:45:20 GMT+0800 (中国标准时间), '[19,19.79,19.85,19.88,20.3,21.82,22.87,23,24.56]');
INSERT INTO record VALUES ('AUG | 蔓延 (略有磨损)
', '0.07-0.08', 'BUFF', Tue Mar 10 2026 19:45:20 GMT+0800 (中国标准时间), '["20.91","20.91","20.95","20.96","20.96","20.96","20.96","20.97","20.97","20.99"]');
INSERT INTO record VALUES ('Tec-9 | 芭蕉叶 (久经沙场)
', '0.15-0.18', 'C5', Tue Mar 10 2026 19:45:49 GMT+0800 (中国标准时间), '[1.39,1.39,1.39,1.39,1.39,1.4,1.4,1.43,2,2.66]');
INSERT INTO record VALUES ('Tec-9 | 芭蕉叶 (久经沙场)
', '0.15-0.18', 'BUFF', Tue Mar 10 2026 19:45:49 GMT+0800 (中国标准时间), '["1.18","1.18","1.19","1.19","1.19","1.19","1.19","1.19","1.19","1.2"]');
INSERT INTO record VALUES ('M4A4 | 风蚀幽冥 (久经沙场)', '0.15-0.18', 'C5', Tue Mar 10 2026 19:47:27 GMT+0800 (中国标准时间), '[1,1,1.06,1.1,1.2,1.28,1.28,1.28,1.28,1.4]');
INSERT INTO record VALUES ('M4A4 | 风蚀幽冥 (久经沙场)', '0.15-0.18', 'BUFF', Tue Mar 10 2026 19:47:27 GMT+0800 (中国标准时间), '["0.55","0.59","0.59","0.6","0.61","0.61","0.62","0.63","0.64","0.66"]');
INSERT INTO record VALUES ('MAC-10 | 雪溅 (久经沙场)
', '0.15-0.18', 'C5', Tue Mar 10 2026 19:48:05 GMT+0800 (中国标准时间), '[0.55,0.55,0.57,0.69,0.69,0.7,0.7,0.74,0.8,0.94]');
INSERT INTO record VALUES ('MAC-10 | 雪溅 (久经沙场)
', '0.15-0.18', 'BUFF', Tue Mar 10 2026 19:48:05 GMT+0800 (中国标准时间), '["0.47","0.49","0.49","0.49","0.5","0.5","0.51","0.51","0.51","0.57"]');
INSERT INTO record VALUES ('MP5-SD | 野餐区 (久经沙场)', '0.15-0.18', 'C5', Tue Mar 10 2026 19:48:51 GMT+0800 (中国标准时间), '[2.98,2.99,2.99,3,3,4,4]');
INSERT INTO record VALUES ('MP5-SD | 野餐区 (久经沙场)', '0.15-0.18', 'BUFF', Tue Mar 10 2026 19:48:51 GMT+0800 (中国标准时间), '["1.63","1.63","1.64","1.64","1.64","1.65","1.66","1.68","1.68","1.68"]');
INSERT INTO record VALUES ('XM1014 | 电光明黄 (久经沙场)', '0.15-0.18', 'C5', Tue Mar 10 2026 19:49:22 GMT+0800 (中国标准时间), '[1.39,1.39,1.39,1.4,1.4,1.44,1.5,1.63,1.68,2]');
INSERT INTO record VALUES ('XM1014 | 电光明黄 (久经沙场)', '0.15-0.18', 'BUFF', Tue Mar 10 2026 19:49:22 GMT+0800 (中国标准时间), '["0.99","0.99","0.99","0.99","0.99","1.18","1.18","1.19","1.19","1.2"]');
INSERT INTO record VALUES ('R8左轮手枪 | 暗室 (久经沙场)
', '0.15-0.18', 'C5', Tue Mar 10 2026 19:49:57 GMT+0800 (中国标准时间), '[0.79,0.8,0.8,0.85,0.86,0.87,1,2,2,2]');
INSERT INTO record VALUES ('R8左轮手枪 | 暗室 (久经沙场)
', '0.15-0.18', 'BUFF', Tue Mar 10 2026 19:49:57 GMT+0800 (中国标准时间), '["0.75","0.75","0.75","0.75","0.75","0.75","0.75","0.76","0.76","0.76"]');
INSERT INTO record VALUES ('FN57 | 鹤吻莓 (久经沙场)
', '0.15-0.18', 'C5', Tue Mar 10 2026 19:50:38 GMT+0800 (中国标准时间), '[10.87,10.88,11,13,14.78,14.82,15,15.17,16,19]');
INSERT INTO record VALUES ('FN57 | 鹤吻莓 (久经沙场)
', '0.15-0.18', 'BUFF', Tue Mar 10 2026 19:50:38 GMT+0800 (中国标准时间), '["10.83","10.83","10.83","10.83","10.84","11.74","11.74","11.74","11.74","11.75"]');
INSERT INTO record VALUES ('P90 | 风蚀流光 (久经沙场)
', '0.15-0.18', 'C5', Tue Mar 10 2026 19:51:07 GMT+0800 (中国标准时间), '[7,7.1,7.1,7.1,7.2,7.25,7.28,7.29,7.3,7.32]');
INSERT INTO record VALUES ('P90 | 风蚀流光 (久经沙场)
', '0.15-0.18', 'BUFF', Tue Mar 10 2026 19:51:07 GMT+0800 (中国标准时间), '["7.1","7.38","9.25","9.5","9.79","10","13","14.3","14.3","16.88"]');
INSERT INTO record VALUES ('P2000 | 防滑胶带 (久经沙场)
', '0.15-0.18', 'C5', Tue Mar 10 2026 19:52:10 GMT+0800 (中国标准时间), '[6.98,7.7,7.7,7.79,7.8,7.94,7.97,7.98,7.98,7.98]');
INSERT INTO record VALUES ('P2000 | 防滑胶带 (久经沙场)
', '0.15-0.18', 'BUFF', Tue Mar 10 2026 19:52:10 GMT+0800 (中国标准时间), '["6.85","6.85","6.87","6.87","6.87","6.9","6.95","7.14","7.2","7.2"]');
INSERT INTO record VALUES ('MP5-SD | 雪溅 (久经沙场)
', '0.15-0.18', 'C5', Tue Mar 10 2026 19:52:28 GMT+0800 (中国标准时间), '[0.56,0.56,0.57,0.59,0.6,0.6,0.69,0.7,0.74,2]');
INSERT INTO record VALUES ('MP5-SD | 雪溅 (久经沙场)
', '0.15-0.18', 'BUFF', Tue Mar 10 2026 19:52:28 GMT+0800 (中国标准时间), '["0.48","0.48","0.48","0.48","0.48","0.48","0.48","0.48","0.48","0.48"]');
INSERT INTO record VALUES ('SSG 08 | 仿书法 (久经沙场)', '0.15-0.18', 'C5', Tue Mar 10 2026 19:52:53 GMT+0800 (中国标准时间), '[1.99,2,2,2,2.2,2.4,2.4,2.49,5,50]');
INSERT INTO record VALUES ('SSG 08 | 仿书法 (久经沙场)', '0.15-0.18', 'BUFF', Tue Mar 10 2026 19:52:53 GMT+0800 (中国标准时间), '["1.7","1.71","1.71","1.71","1.72","1.73","1.73","1.74","1.76","1.78"]');
INSERT INTO record VALUES ('加利尔AR | 冰核聚变 (略有磨损)
', '0.07-0.08', 'C5', Tue Mar 10 2026 19:53:28 GMT+0800 (中国标准时间), '[1.3,1.3,1.3,1.3,1.3,1.48,1.49,1.5,2.76,2.77]');
INSERT INTO record VALUES ('加利尔AR | 冰核聚变 (略有磨损)
', '0.07-0.08', 'BUFF', Tue Mar 10 2026 19:53:28 GMT+0800 (中国标准时间), '["1.2","1.2","1.21","1.21","1.21","1.21","1.21","1.21","1.21","1.21"]');
INSERT INTO record VALUES ('FN57 | 青空 (久经沙场)
', '0.15-0.18', 'C5', Tue Mar 10 2026 19:58:03 GMT+0800 (中国标准时间), '[0.46,0.47,0.47,0.48,0.48,0.48,0.48,0.48,0.48,0.48]');
INSERT INTO record VALUES ('FN57 | 青空 (久经沙场)
', '0.15-0.18', 'BUFF', Tue Mar 10 2026 19:58:04 GMT+0800 (中国标准时间), '["0.44","0.45","0.45","0.45","0.45","0.45","0.45","0.45","0.46","0.46"]');

-- ----------------------------
-- 表结构: sell
-- ----------------------------

CREATE TABLE `sell` (
  `name` varchar(255) NOT NULL,
  `enName` varchar(255) DEFAULT NULL,
  `buffID` int DEFAULT NULL,
  `uuID` int DEFAULT NULL,
  `c5ID` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- 数据: sell
-- ----------------------------

INSERT INTO sell VALUES ('P250 | 绛络 (久经沙场)
', NULL, 1115689, 110832, '1380987841384583168');
INSERT INTO sell VALUES ('M249 | 鳄鱼网格 (略有磨损)
', NULL, 35123, 2030, '23117');
INSERT INTO sell VALUES ('内格夫 | 舱壁 (略有磨损)
', NULL, 762076, 874, '553479361');
INSERT INTO sell VALUES ('内格夫 | 酸葡萄 (久经沙场)
', NULL, 1115890, 111056, '1381030058748092416');
INSERT INTO sell VALUES ('内格夫 | 墙临弹雨 (略有磨损)
', NULL, 968152, 109749, '1315796081554743296');
INSERT INTO sell VALUES ('新星 | 松石流彩 (久经沙场)
', NULL, 1115966, 110963, '1381042058191372288');
INSERT INTO sell VALUES ('XM1014 | 口香糖迷彩 (久经沙场)
', NULL, 1115940, 110703, '1381019921161461761');
INSERT INTO sell VALUES ('MAG-7 | 野树林 (略有磨损)
', NULL, 968018, 109639, '1315791084448157696');
INSERT INTO sell VALUES ('MAG-7 | 氧化铜 (崭新出厂)
', NULL, 1115761, 111088, '1381034432170754048');
INSERT INTO sell VALUES ('新星 | 松石流彩 (略有磨损)
', NULL, 1115878, 110964, '1381051443990794240');
INSERT INTO sell VALUES ('MAG-7 | 野树林 (崭新出厂)
', NULL, 968063, 109672, '1315800751547342848');
INSERT INTO sell VALUES ('新星 | 松石流彩 (崭新出厂)
', NULL, 1115918, 111021, '1381056351652610048');
INSERT INTO sell VALUES ('MP5-SD | 青柠蜂巢 (崭新出厂)
', NULL, 1115853, 111013, '1381046846097989632');
INSERT INTO sell VALUES ('MAC-10 | 古铜 (崭新出厂)
', NULL, 1116033, 111136, '1381042874649485312');
INSERT INTO sell VALUES ('MP9 | 褪色蓝痕 (崭新出厂)
', NULL, 1116023, 111080, '1381024857333891072');
INSERT INTO sell VALUES ('P90 | 海蓝战术 (崭新出厂)
', NULL, 1115818, 110912, '1381006706767634432');
INSERT INTO sell VALUES ('MP9 | 松 (崭新出厂)
', NULL, 1116019, 111099, '1381043527665328128');
INSERT INTO sell VALUES ('P90 | 满昏作品 (久经沙场)
', NULL, 1115576, 110677, '1380979899390267393');
INSERT INTO sell VALUES ('UMP-45 | 碧漩 (崭新出厂)
', NULL, 1115982, 111024, '1381021387812831232');
INSERT INTO sell VALUES ('MP9 | 创世蜂鸣 (略有磨损)
', NULL, 1133046, 120550, '1488247049664339968');
INSERT INTO sell VALUES ('MP9 | 眩晕 (崭新出厂)
', NULL, 1133123, 120588, '1488252492000272384');
INSERT INTO sell VALUES ('P90 | 芥子气 (久经沙场)
', NULL, 1115831, 110947, '1381012347531624448');
INSERT INTO sell VALUES ('MAC-10 | 酸蚀蜂巢 (久经沙场)
', NULL, 1115770, 111083, '1381009235992416256');
INSERT INTO sell VALUES ('PP-野牛 | 冷室 (崭新出厂)
', NULL, 968023, 109587, '1315788575986147328');
INSERT INTO sell VALUES ('P90 | 擦擦 (崭新出厂)
', NULL, 968092, 109613, '1315814260167184385');
INSERT INTO sell VALUES ('P90 | 满昏作品 (略有磨损)
', NULL, 1115525, 110689, '1380971233227374593');
INSERT INTO sell VALUES ('MP7 | 主板 (略有磨损)
', NULL, 762094, 1906, '553479284');
INSERT INTO sell VALUES ('MAC-10 | 小牛皮 (略有磨损)
', NULL, 762095, 1957, '553479215');
INSERT INTO sell VALUES ('MP7 | 主板 (崭新出厂)
', NULL, 762105, 401, '553479373');
INSERT INTO sell VALUES ('MP7 | 赭石短调 (崭新出厂)
', NULL, 1115823, 110916, '1381000418302173184');
INSERT INTO sell VALUES ('USP消音版 | 森林之叶 (略有磨损)
', NULL, 42175, 3781, '23226');
INSERT INTO sell VALUES ('P2000 | 草泽 (久经沙场)
', NULL, 1116009, 111152, '1381035155662868481');
INSERT INTO sell VALUES ('P250 | 沉积 (久经沙场)
', NULL, 1115855, 110922, '1381018915924934656');
INSERT INTO sell VALUES ('P250 | 建构主义者 (略有磨损)
', NULL, 1115520, 110661, '1380979899377684483');
INSERT INTO sell VALUES ('P250 | 沉积 (略有磨损)
', NULL, 1115906, 110883, '1381074520258678784');
INSERT INTO sell VALUES ('P250 | 绛络 (崭新出厂)
', NULL, 1115829, 110988, '1381061547426652160');
INSERT INTO sell VALUES ('P250 | 交换机 (略有磨损)
', NULL, 762104, 46595, '553479371');
INSERT INTO sell VALUES ('FN57 | 青空 (久经沙场)
', NULL, 1115880, 111182, '1381059820304539648');
INSERT INTO sell VALUES ('FN57 | 秋日灌木 (崭新出厂)
', NULL, 1115983, 110846, '1381037483157364736');
INSERT INTO sell VALUES ('FN57 | 午夜喷涂 (崭新出厂)
', NULL, 968118, 109656, '1315802276996546560');
INSERT INTO sell VALUES ('FN57 | 青空 (崭新出厂)
', NULL, 1115930, 111132, '1381030463356280832');
INSERT INTO sell VALUES ('R8 左轮手枪 | 叶蝉 (久经沙场)
', NULL, 1115952, 110972, '1381004100544569344');
INSERT INTO sell VALUES ('R8 左轮手枪 | 钴蓝握把 (崭新出厂)
', NULL, 1115972, 110921, '1381089750375997440');
INSERT INTO sell VALUES ('R8左轮手枪 | 淡紫旁白 (略有磨损)
', NULL, 1133052, 120589, '1488247474801713152');
INSERT INTO sell VALUES ('R8 左轮手枪 | 叶蝉 (略有磨损)
', NULL, 1115729, 110982, '1381034454735659008');
INSERT INTO sell VALUES ('Tec-9 | 柠檬酸 (久经沙场)
', NULL, 1115893, 110970, '1381032904085143552');
INSERT INTO sell VALUES ('Tec-9 | 虎纹模板 (略有磨损)
', NULL, 968037, 109631, '1315777739302768640');
INSERT INTO sell VALUES ('Tec-9 | 生瓷 (崭新出厂)
', NULL, 1116061, 111003, '1381078577769648128');
INSERT INTO sell VALUES ('Tec-9 | 柠檬酸 (略有磨损)
', NULL, 1115852, 110890, '1381037886006951936');
INSERT INTO sell VALUES ('Tec-9 | 多变迷彩 (略有磨损)
', NULL, 42062, 45206, '23941');
INSERT INTO sell VALUES ('Tec-9 | 芭蕉叶 (久经沙场)
', NULL, 1133126, 120605, '1488268827723833344');
INSERT INTO sell VALUES ('Tec-9 | 柠檬酸 (崭新出厂)
', NULL, 1115881, 110854, '1381040636825473024');
INSERT INTO sell VALUES ('Tec-9 | 束带-9 (久经沙场)
', NULL, 1116030, 111008, '1381044849425027072');
INSERT INTO sell VALUES ('Tec-9 | 虎纹模板 (崭新出厂)
', NULL, 968066, 109535, '1315782352205025280');
INSERT INTO sell VALUES ('Tec-9 | 束带-9 (崭新出厂)
', NULL, 1115903, 111139, '1381042235690123265');
INSERT INTO sell VALUES ('Tec-9 | 束带-9 (略有磨损)
', NULL, 1115942, 111121, '1381007847757484032');
INSERT INTO sell VALUES ('双持贝瑞塔 | 第二边界 (崭新出厂)
', NULL, 1116129, 111247, '1381123410764046336');
INSERT INTO sell VALUES ('双持贝瑞塔 | 蔷薇珠母 (久经沙场)
', NULL, 1115826, 111164, '1381043130142228480');
INSERT INTO sell VALUES ('双持贝瑞塔 | 精琢孔雀石 (久经沙场)
', NULL, 1115851, 111032, '1381043914484555776');
INSERT INTO sell VALUES ('CZ75 | 粉玑 (崭新出厂)
', NULL, 1116049, 111022, '1380985144831967232');
INSERT INTO sell VALUES ('CZ75 | 铜芯纤维 (略有磨损)
', NULL, 1115506, 110686, '1380980112938770433');
INSERT INTO sell VALUES ('CZ75自动型 | 蜜金佩斯利 (略有磨损)
', NULL, 1133125, 120614, '1488251532477313024');
INSERT INTO sell VALUES ('宙斯 X27 电击枪 | 沼泽DDPAT (崭新出厂)
', NULL, 1115891, 111097, '1381035775949807616');
INSERT INTO sell VALUES ('宙斯 X27 电击枪 | 电光幽蓝 (久经沙场)
', NULL, 1116053, 111108, '1381041025549082624');
INSERT INTO sell VALUES ('AK-47 | 狩猎网格 (略有磨损)
', NULL, 33966, 266, '23169');
INSERT INTO sell VALUES ('M4A4 | 钢铁红流 (久经沙场)
', NULL, 1115622, 110851, '1381011070500544512');
INSERT INTO sell VALUES ('M4A4 | 钢铁红流 (略有磨损)
', NULL, 1115987, 111076, '1381037784359014400');
INSERT INTO sell VALUES ('M4A4 | 主机 (略有磨损)
', NULL, 762064, 43562, '553479324');
INSERT INTO sell VALUES ('AUG | 特种兵连 (崭新出厂)
', NULL, 1115934, 111197, '1381043688290394112');
INSERT INTO sell VALUES ('AUG | 钢铁哨兵 (久经沙场)
', NULL, 1115497, 110693, '1380979899386073093');
INSERT INTO sell VALUES ('SG 553 | 暗夜迷彩 (崭新出厂)
', NULL, 1115868, 110966, '1381045578391027712');
INSERT INTO sell VALUES ('SG 553 | 篮纹半调 (略有磨损)
', NULL, 1115996, 111017, '1381041999177064448');
INSERT INTO sell VALUES ('法玛斯 | 半袖式 (久经沙场)
', NULL, 968179, 109554, '1315791084443963392');
INSERT INTO sell VALUES ('法玛斯 | 半袖式 (略有磨损)
', NULL, 968041, 109594, '1315785498609979392');
INSERT INTO sell VALUES ('法玛斯 | 灰色幽灵 (略有磨损)
', NULL, 1115824, 111053, '1381051963417595904');
INSERT INTO sell VALUES ('加利尔 AR | 鸲珠 (久经沙场)
', NULL, 1115946, 110981, '1381051412901593088');
INSERT INTO sell VALUES ('加利尔 AR | 血橙游骑兵 (久经沙场)
', NULL, 1115798, 111030, '1381001266075869184');
INSERT INTO sell VALUES ('加利尔AR | 多变迷彩 (略有磨损)
', NULL, 34980, 43306, '23766');
INSERT INTO sell VALUES ('加利尔 AR | 灰色烟幕 (崭新出厂)
', NULL, 1115788, 110861, '1381032517479206912');
INSERT INTO sell VALUES ('加利尔 AR | 酸蚀镖 (略有磨损)
', NULL, 1115933, 111045, '1381001386008256512');
INSERT INTO sell VALUES ('加利尔 AR | 血橙游骑兵 (略有磨损)
', NULL, 1115913, 110905, '1381047843650732032');
INSERT INTO sell VALUES ('加利尔 AR | 酸蚀镖 (久经沙场)
', NULL, 1115990, 111103, '1381032626010267648');
INSERT INTO sell VALUES ('SSG 08 | 灰色烟幕 (崭新出厂)
', NULL, 1116073, 111151, '1381037114478493696');
INSERT INTO sell VALUES ('SSG 08 | 绿陶 (崭新出厂)
', NULL, 1116133, 111249, '1380989121846583296');
INSERT INTO sell VALUES ('SSG 08 | 虎噬 (久经沙场)
', NULL, 1115859, 110973, '1381038075778236416');
INSERT INTO sell VALUES ('SSG 08 | 虎噬 (略有磨损)
', NULL, 1116138, 111218, '1381036599539437578');
INSERT INTO sell VALUES ('SSG 08 | 虎噬 (崭新出厂)
', NULL, 1116147, 111257, '1381006729655681024');
INSERT INTO sell VALUES ('G3SG1 | 绿色细胞 (崭新出厂)
', NULL, 1115786, 110804, '1381060063252119552');
INSERT INTO sell VALUES ('G3SG1 | 红碧玉 (崭新出厂)
', NULL, 1115883, 111086, '1381015057766219776');
INSERT INTO sell VALUES ('SCAR-20 | 赭石短调 (崭新出厂)
', NULL, 1115963, 111137, '1381008615885541376');
INSERT INTO sell VALUES ('内格夫 | 舱壁 (崭新出厂)', NULL, 762137, 2432, '553479329');
INSERT INTO sell VALUES ('MAG-7 | 外表生锈 (崭新出厂)
', NULL, 762050, 45927, '553479355');
INSERT INTO sell VALUES ('MAC-10 | 风暴迷彩 (崭新出厂)
', NULL, 1115874, 111039, '1381025599323045888');
INSERT INTO sell VALUES ('P250 | 重构 (略有磨损)', NULL, 921451, 103186, '1098057026415800320');
INSERT INTO sell VALUES ('内格夫 | 墙临弹雨 (久经沙场)
', NULL, 968067, 109635, '1315793858491547648');
INSERT INTO sell VALUES ('MP5-SD | 霓虹榨汁机 (久经沙场)
', NULL, 968078, 109544, '1467099614703558656');
INSERT INTO sell VALUES ('SSG 08 | 半调轮纹 (久经沙场)', NULL, 968163, 109621, '1315791131971649536');
INSERT INTO sell VALUES ('截短霰弹枪 | 赤红蜡染', NULL, 1133061, 120539, '1488256801196326912');
INSERT INTO sell VALUES ('MAC-10 | 雪溅 (久经沙场)
', NULL, 1133194, 120612, '1488251971168378880');
INSERT INTO sell VALUES ('PP-野牛 | 热气流 (略有磨损)', NULL, 1133068, 120585, '1488261498550886400');
INSERT INTO sell VALUES ('PP-野牛 | 热气流 (崭新出厂)', NULL, 1133084, 120558, '1488250005106835456');
INSERT INTO sell VALUES ('PP-野牛 | 变焦 (崭新出厂)
', NULL, 1133114, 120567, '1488263057818443776');
INSERT INTO sell VALUES ('MP5-SD | 野餐区 (久经沙场)', NULL, 1133184, 120596, '1488270003029254144');
INSERT INTO sell VALUES ('P250 | 冻雨 (崭新出厂)', NULL, 1133094, 120644, '1488271860997926912');
INSERT INTO sell VALUES ('R8左轮手枪 | 淡紫旁白 (略有磨损)
', NULL, 1133052, 120589, '1488247474801713152');
INSERT INTO sell VALUES ('R8左轮手枪 | 暗室 (久经沙场)
', NULL, 1133081, 120546, '1488250949051727872');
INSERT INTO sell VALUES ('双持贝瑞塔 | 银流 (崭新出厂)
', NULL, 1133129, 120576, '1488268000828252160');
INSERT INTO sell VALUES ('CZ75自动型 | 蜜金佩斯利 (崭新出厂)
', NULL, 1133110, 120537, '1488249269486727168');
INSERT INTO sell VALUES ('M4A4 | 风蚀幽冥 (久经沙场)', NULL, 1133056, 120542, '1488255849909301248');
INSERT INTO sell VALUES ('法玛斯 | 副产品 (崭新出厂)', NULL, 1133109, 120570, '1488254859443101843');
INSERT INTO sell VALUES ('SCAR-20 | 锌元素 (崭新出厂)
', NULL, 1133080, 120533, '1488257159530393600');
INSERT INTO sell VALUES ('法玛斯 | 复仇 (久经沙场)
', NULL, 1133170, 120606, '1488272503892877312');
INSERT INTO sell VALUES ('SSG 08 | 无漫风格 (崭新出厂)', NULL, 1133072, 120617, '1488246626664165376');
INSERT INTO sell VALUES ('法玛斯 | 复仇 (略有磨损)
', NULL, 1133188, 120532, '1488282028149497856');
INSERT INTO sell VALUES ('截短霰弹枪 | 赤红蜡染 (崭新出厂)

', NULL, 1133061, 120539, '1488256801196326912');
INSERT INTO sell VALUES ('MP7 | 珊瑚佩斯利 (久经沙场)', NULL, 1133124, 120640, '1488245910149120000');
INSERT INTO sell VALUES ('SSG 08 | 仿书法 (久经沙场)', NULL, 1133144, 120568, '1488285528525488128');
INSERT INTO sell VALUES ('MAC-10 | 雪溅 (略有磨损)

', NULL, 1133048, 120623, '1488253365174673408');
INSERT INTO sell VALUES ('内格夫 | 酸葡萄 (略有磨损)', NULL, 1115920, 111067, '1381036751720349696');
INSERT INTO sell VALUES ('法玛斯 | 复仇 (崭新出厂)
', NULL, 1133165, NULL, '1488254122519175168');
INSERT INTO sell VALUES ('M249 | 冻雨 (崭新出厂)', NULL, 1133120, NULL, '1488252303301599232');
INSERT INTO sell VALUES ('XM1014 | 电光明黄 (略有磨损)
', NULL, 1133115, NULL, '1488269251228393472');
INSERT INTO sell VALUES ('M4A4 | 风蚀幽冥 (略有磨损)', NULL, 1133069, NULL, '1488262139260182528');
INSERT INTO sell VALUES ('Tec-9 | 芭蕉叶 (略有磨损)', NULL, 1133161, NULL, '1488274112439500800');
INSERT INTO sell VALUES ('MP5-SD | 雪溅 (略有磨损)', NULL, 1133095, NULL, '1488260052486569984');
INSERT INTO sell VALUES ('XM1014 | 电光明黄 (久经沙场)', NULL, 1133136, NULL, '1488252018618540032');
INSERT INTO sell VALUES ('新星 | 气流 (崭新出厂)', NULL, 1133172, NULL, '1488258655304998912');
INSERT INTO sell VALUES ('R8左轮手枪 | 淡紫旁白 (崭新出厂)
', NULL, 1133169, NULL, '1488257717437841408');
INSERT INTO sell VALUES ('MP5-SD | 雪溅 (崭新出厂)', NULL, 1133220, NULL, '1488282050689343488');
INSERT INTO sell VALUES ('MP5-SD | 野餐区 (略有磨损)
', NULL, 1133102, NULL, '1488285090163384320');
INSERT INTO sell VALUES ('SG 553 | 篮纹半调 (久经沙场)', NULL, 1115646, NULL, '1380996845795811328');
INSERT INTO sell VALUES ('法玛斯 | 灰色幽灵 (久经沙场)
', NULL, 1115860, NULL, '1381019997905551360');
INSERT INTO sell VALUES ('P90 | 芥子气 (略有磨损)
', NULL, 1116008, NULL, '1381063905133920256');
INSERT INTO sell VALUES ('新星 | 夜雨月台 (略有磨损)
', NULL, 1115533, NULL, '1380971233227374594');
INSERT INTO sell VALUES ('XM1014 | 口香糖迷彩 (略有磨损)
', NULL, 1116050, NULL, '1381059185992466432');
INSERT INTO sell VALUES ('P2000 | 草泽 (略有磨损)
', NULL, 1115939, NULL, '1381039200930664448');
INSERT INTO sell VALUES ('加利尔AR | 鸲珠 (略有磨损)
', NULL, 1115926, NULL, '1381002453936046080');
INSERT INTO sell VALUES ('MP5-SD | 雪溅 (久经沙场)
', NULL, 1133067, NULL, '1488275527207411712');
INSERT INTO sell VALUES ('MAC-10 | 雪溅 (崭新出厂)', NULL, 1133134, NULL, '1488250019066519552');
INSERT INTO sell VALUES ('加利尔AR | 天空曼陀罗 (略有磨损)
', NULL, 1133132, NULL, '1488264231328686085');
INSERT INTO sell VALUES ('宙斯x27电击枪 | 大地曼陀罗 (略有磨损)
', NULL, 1133196, NULL, '1488242105530900480');
INSERT INTO sell VALUES ('R8左轮手枪 | 暗室 (崭新出厂)
', NULL, 1133082, NULL, '1488255179544182784');
INSERT INTO sell VALUES ('M4A4 | 风蚀幽冥 (崭新出厂)
', NULL, 1133223, NULL, '1488271002983841792');
INSERT INTO sell VALUES ('P90 | 风蚀流光 (略有磨损)
', NULL, 1133179, NULL, '1488267977407258624');
INSERT INTO sell VALUES ('R8左轮手枪 | 暗室 (略有磨损)
', NULL, 1133111, NULL, '1488254085344636929');
INSERT INTO sell VALUES ('加利尔AR | 天空曼陀罗 (久经沙场)
', NULL, 1133105, NULL, '1488282199149887488');
INSERT INTO sell VALUES ('P90 | 风蚀流光 (久经沙场)
', NULL, 1133157, NULL, '1488255109120139264');
INSERT INTO sell VALUES ('加利尔AR | 血橙游骑兵 (崭新出厂)
', NULL, 1115986, NULL, '1381046637024968705');
INSERT INTO sell VALUES ('SG 553 | 篮纹半调 (崭新出厂)
', NULL, 1116001, NULL, '1381048064031887360');
INSERT INTO sell VALUES ('Tec-9 | 多变迷彩 (崭新出厂)
', NULL, 42060, NULL, '23671');
INSERT INTO sell VALUES ('双持贝瑞塔 | 蔷薇珠母 (崭新出厂)
', NULL, 1116035, NULL, '1381082957596262402');
INSERT INTO sell VALUES ('P250 | 沉积 (崭新出厂)
', NULL, 1115944, NULL, '1381020099922427904');
INSERT INTO sell VALUES ('加利尔 AR | 酸蚀镖 (崭新出厂)
', NULL, 1116046, NULL, '1381006829794689024');
INSERT INTO sell VALUES ('加利尔 AR | 鸲珠 (崭新出厂)', NULL, 1116114, NULL, '1381028942740267008');
INSERT INTO sell VALUES ('法玛斯 | 灰色幽灵 (崭新出厂)
', NULL, 1116016, NULL, '1381030087969808384');
INSERT INTO sell VALUES ('内格夫 | 酸葡萄 (崭新出厂)
', NULL, 1115961, NULL, '1381118070769590272');
INSERT INTO sell VALUES ('MAC-10 | 酸蚀蜂巢 (崭新出厂)
', NULL, 1115887, NULL, '1380977795392872448');
INSERT INTO sell VALUES ('XM1014 | 口香糖迷彩 (崭新出厂)
', NULL, 1115834, NULL, '1381042104533057536');
INSERT INTO sell VALUES ('新星 | 夜雨月台 (崭新出厂)', NULL, 1115519, NULL, '1380979899377684481');
INSERT INTO sell VALUES ('M4A4 | 主机 (崭新出厂)
', NULL, 762102, NULL, '553479304');
INSERT INTO sell VALUES ('双持贝瑞塔 | 精琢孔雀石 (略有磨损)
', NULL, 1115825, NULL, '1381028799093473280');
INSERT INTO sell VALUES ('FN57 | 青空 (略有磨损)', NULL, 1116014, NULL, '1381031858175541249');
INSERT INTO sell VALUES ('MAC-10 | 白杨丛 (略有磨损)
', NULL, 1115924, NULL, '1381005153462583296');
INSERT INTO sell VALUES ('内格夫 | 酸葡萄 (略有磨损)
', NULL, 1115920, NULL, '1381036751720349696');
INSERT INTO sell VALUES ('MAC-10 | 酸蚀蜂巢 (略有磨损)
', NULL, 1115898, NULL, '1381052164765159424');
INSERT INTO sell VALUES ('双持贝瑞塔 | 蔷薇珠母 (略有磨损)
', NULL, 1115932, NULL, '1381022875796971520');
INSERT INTO sell VALUES ('XM1014 | 铜斑迷彩 (略有磨损)
', NULL, 1116164, NULL, '1381156226957348864');
INSERT INTO sell VALUES ('MP5-SD | 黄金榕 (略有磨损)
', NULL, 1115889, NULL, '1381134238923481095');
INSERT INTO sell VALUES ('AUG | 钢铁哨兵 (略有磨损)
', NULL, 1115606, NULL, '1380979899390267395');
INSERT INTO sell VALUES ('M4A4 | 海军虎纹迷彩 (久经沙场)
', NULL, 1115867, NULL, '1381008978470248448');
INSERT INTO sell VALUES ('MP5-SD | 黄金榕 (久经沙场)
', NULL, 1116157, NULL, '1381101201853063168');
INSERT INTO sell VALUES ('MAC-10 | 白杨丛 (久经沙场)
', NULL, 1116058, NULL, '1381099892941266944');
INSERT INTO sell VALUES ('Tec-9 | 芭蕉叶 (崭新出厂)
', NULL, 1133198, NULL, '1488277379718242326');
INSERT INTO sell VALUES ('XM1014 | 电光明黄 (崭新出厂)
', NULL, 1133193, NULL, '1488290865757396992');
INSERT INTO sell VALUES ('USP消音版 | 一颗入眠 (久经沙场)
', NULL, 1133191, NULL, '1488261558919503872');
INSERT INTO sell VALUES ('FN57 | 鹤吻莓 (久经沙场)
', '1133142', 1133142, NULL, '1488254031703683072');
INSERT INTO sell VALUES ('AUG | 蔓延 (略有磨损)
', NULL, 1133221, NULL, '1488289820709859330');
INSERT INTO sell VALUES ('P2000 | 草泽 (崭新出厂)
', NULL, 1116105, NULL, '1381033236970115072');
INSERT INTO sell VALUES ('加利尔AR | 冰核聚变 (略有磨损)
', NULL, 762090, NULL, '553479396');
INSERT INTO sell VALUES ('XM1014 | 铜斑迷彩 (久经沙场)', NULL, 1116099, NULL, '1381042141698785280');
INSERT INTO sell VALUES ('SG 553 | 狩猎印花 (崭新出厂)
', NULL, 1133040, NULL, '1488273773692116992');
INSERT INTO sell VALUES ('P2000 | 防滑胶带 (久经沙场)
', NULL, 1133181, NULL, '1488283164967886848');

-- ----------------------------
-- 表结构: uutoken
-- ----------------------------

CREATE TABLE `uutoken` (
  `uuToken` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- 数据: uutoken
-- ----------------------------

INSERT INTO uutoken VALUES ('babd002c6be6486d87d601d207a0cc8f', Wed Feb 11 2026 04:37:42 GMT+0800 (中国标准时间), Wed Feb 11 2026 04:37:42 GMT+0800 (中国标准时间));

