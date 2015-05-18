-- 任务面板
-- Author: whe
-- Date: 2015-05-18 16:06:32
--
local MissionView = class("MissionView", function ()
	local layer = cc.Layer:create()
	layerHoldTouch(layer)
	return layer
end)


function MissionView:ctor()
	-- body
end

function MissionView:initUI()
	
end

function MissionView:initData()
	
end

--任务Render触摸事件
function MissionView:onMissionTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

end

return MissionView