-- 分享类型一共有3种。
-- 1计算时间，按照配置，时间短的时候分享
-- 2计算登陆日期，连续登录的时候分享
-- 3通过第一关时分享

SHARE_TYPE_TIME 	= "SHARE_TYPE_TIME"
SHARE_TYPE_DATE 	= "SHARE_TYPE_DATE"
SHARE_TYPE_FIRST_LEVEL 	= "SHARE_TYPE_FIRST_LEVEL"

local ShareConfig = {}

ShareConfig.score = {
	[1] = 90,
	[2] = 80,
	[3] = 70,
	[4] = 60,
}

return ShareConfig