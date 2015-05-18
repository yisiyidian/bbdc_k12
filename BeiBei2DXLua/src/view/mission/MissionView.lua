-- 任务面板View
-- Author: whe
-- Date: 2015-05-18 16:06:32
--
local MissionView = class("MissionView", function ()
	local layer = cc.Layer:create()
	layerHoldTouch(layer)
	return layer
end)

function MissionView:ctor()
	self:initData()
	self:initUI()
end
--初始化UI
function MissionView:initUI()
	
end
--初始化数据
function MissionView:initData()
	--获取当前的任务数据
	local mission_data = s_MissionManager:getMissionData()
	dump(mission_data,"任务数据",99)
end
--任务Render触摸事件
function MissionView:onMissionTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

end

return MissionView