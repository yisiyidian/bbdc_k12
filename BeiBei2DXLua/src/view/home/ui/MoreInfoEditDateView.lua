-- 修改日期的界面
-- Author: whe
-- Date: 2015-05-05 15:15:52
--
local MoreInfoEditDateView = class("MoreInfoEditDateView", function()
	local layer = cc.Layer:create()
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