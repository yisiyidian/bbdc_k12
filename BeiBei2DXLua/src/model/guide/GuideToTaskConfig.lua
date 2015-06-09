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
	{["guideToTask_id"] = 1,	boxPos=cc.p(s_RIGHT_X-220,800)			,isOpen=false	,scaleTo = 1	,guideId = 13}, 			
	{["guideToTask_id"] = 2,	boxPos=cc.p(s_DESIGN_WIDTH / 2,600)		,isOpen=true	,scaleTo = 2	,guideId = 14}, 	
	{["guideToTask_id"] = 3,	boxPos=cc.p(s_RIGHT_X-180 ,180)			,isOpen=false	,scaleTo = 1	,guideId = 15},
	{["guideToTask_id"] = 4,	boxPos=cc.p(s_RIGHT_X-180 ,180)			,isOpen=false	,scaleTo = 1	,guideId = 16},
	{["guideToTask_id"] = 5,	boxPos=cc.p(s_RIGHT_X-180 ,180)			,isOpen=false	,scaleTo = 1	,guideId = 17},
	{["guideToTask_id"] = 6,	boxPos=cc.p(s_RIGHT_X-180 ,180)			,isOpen=false	,scaleTo = 1	,guideId = 18},
	{["guideToTask_id"] = 7,	boxPos=cc.p(s_RIGHT_X-180 ,180)			,isOpen=false	,scaleTo = 1	},
}

return GuideToTaskConfig