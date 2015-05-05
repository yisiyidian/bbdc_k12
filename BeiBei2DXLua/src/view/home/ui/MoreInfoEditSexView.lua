-- 性别选择界面
-- Author: whe
-- Date: 2015-05-05 15:15:35
--

local MoreInfoEditSexView = class("MoreInfoEditSexView", function()
	local layer = cc.Layer:create()
	return layer
end)


function MoreInfoEditSexView:ctor()
	self:initUI()
end


function MoreInfoEditSexView:initUI()
	-- body
end

--设置回调
--data  性别数据 0 女  1 男
function MoreInfoEditSexView:setData(data,callback)
	self.data = data
	self.callback = callback
end


return MoreInfoEditSexView