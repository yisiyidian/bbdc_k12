-- 这个是关卡配置
-- ～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～
-- 配置说明：
-- 关卡目标 最多有3个 
-- boss数量 正确答对几个词 收集彩点的个数
-- boss需要配置血量

-- 限制条件 现在有两种
-- 分为步数限制 时间限制

-- 胜利后掉落的物品
-- 贝贝豆
-- ～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～

-- date 2015.7.21
-- by wing
local LevelConfig = {}

LevelConfig.BossCongfig = {
	[1] = 20,
	[2] = 30,
	[3] = 40,
}

LevelConfig.WordCongfig = {
	[1] = 3,
	[2] = 6,
	[3] = 9,
}

LevelConfig.PointConfig = {
	[1] = {0,0,0,0,20},
	[2] = {0,0,0,0,20},
	[3] = {0,0,0,0,20},
}

LevelConfig.LimitComfig = {
	[1] = {1,90},
	[2] = {2,20},
	[3] = {1,90},
}

LevelConfig.RewardConfig = {
	[1] = 3,
	[2] = 3,
	[3] = 3,
}

return LevelConfig