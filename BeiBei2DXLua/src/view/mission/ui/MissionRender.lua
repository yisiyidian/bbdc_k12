-- 任务列表Render
-- Author: whe
-- Date: 2015-05-18 16:11:39
-- 
local MissionRender = class("MissionRender", function()
	local sp =  cc.Sprite:create()
	return sp
end)

function MissionRender:ctor()
	self:initUI()
end
--初始化UI
function MissionRender:initUI()
	--TODO 标题文本 进度文本 领取奖励按钮
end
--设置数据
function MissionRender:setData(data)
	self.data = data
	self:updateView()	
end

function MissionRender:updateView()
	--TODO 更新界面显示
end

return MissionRender