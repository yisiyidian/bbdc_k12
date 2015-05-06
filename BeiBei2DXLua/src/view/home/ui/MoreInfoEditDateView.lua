-- 修改日期的界面
-- Author: whe
-- Date: 2015-05-05 15:15:52
--
local MoreInfoEditDateView = class("MoreInfoEditDateView", function()
	local layer = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	return layer
end)


function MoreInfoEditDateView:ctor()
	self:initUI()
end


function MoreInfoEditDateView:initUI()
	-- body
end

--设置回调
--data 日期 字符串类型  2015-01-30
--callback 回调
function MoreInfoEditDateView:setData(data,callback)
	self.data = data
	self.callback = callback
end


return MoreInfoEditDateView