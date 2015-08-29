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

LevelConfig.STEP = 'step'
LevelConfig.TIME = 'time'

LevelConfig.BossConfig = {
	[1] = {"1","1",},
	[2] = {"1","1",},
	[3] = {"1","1",},
}

LevelConfig.WordConfig = {
	[1] = 10,
	[2] = 10,
	[3] = 10,
}

LevelConfig.PointConfig = {
	[1] = {2,0,0,0,0},
	[2] = {2,0,0,0,0},
	[3] = {2,0,0,0,0},
}

LevelConfig.LimitConfig = {
	[1] = {LevelConfig.STEP,20},
	[2] = {LevelConfig.TIME,100},
	[3] = {LevelConfig.STEP,20},
}

LevelConfig.RewardConfig = {
	[1] = 3,
	[2] = 3,
	[3] = 3,
}

return LevelConfig