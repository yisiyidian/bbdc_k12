-- 任务引导数据 配置文件
-- by 侯琪
-- 2015年06月05日11:47:47
--["guideToTask_id"] = 任务引导的步骤
--boxPos=箱子的位置
--isOpen=箱子状态	
--scaleTo=箱子大小
--guideId = 出现的label引导编号

local GuideToTaskConfig = {}

GuideToTaskConfig.data = {
	{["guideToTask_id"] = 1,	boxPos=cc.p(s_RIGHT_X-220,800)			,isOpen=false	,scaleTo = 1.2	,guideId = 13	,light = false	,labelTime = 0.8}, 			
	{["guideToTask_id"] = 2,	boxPos=cc.p(s_DESIGN_WIDTH / 2,600)		,isOpen=true	,scaleTo = 2	,guideId = 14	,light = true	,labelTime = 1.2}, 	
	{["guideToTask_id"] = 3,	boxPos=cc.p(s_RIGHT_X-180 ,180)							,scaleTo = 1.15	,guideId = 15	,light = false	,labelTime = 0.8},
	{["guideToTask_id"] = 4,	boxPos=cc.p(s_RIGHT_X-180 ,180)							,scaleTo = 1.12	,guideId = 16	,light = false	,labelTime = 0},
	{["guideToTask_id"] = 5,	boxPos=cc.p(s_RIGHT_X-180 ,180)							,scaleTo = 1.1	,guideId = 17	,light = false	,labelTime = 0.8},
	{["guideToTask_id"] = 6,	boxPos=cc.p(s_RIGHT_X-180 ,180)							,scaleTo = 1.08	,guideId = 18	,light = false	,labelTime = 0.8},
	{["guideToTask_id"] = 7,	boxPos=cc.p(s_RIGHT_X-180 ,180)							,scaleTo = 1.03	},
}

return GuideToTaskConfig