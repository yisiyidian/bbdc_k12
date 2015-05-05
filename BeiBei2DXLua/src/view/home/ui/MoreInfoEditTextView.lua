-- 修改文本的界面
-- Author: whe
-- Date: 2015-05-05 15:15:22
--
local MoreInfoEditTextView = class("MoreInfoEditTextView", function()
	local layer = cc.Layer:create()
	return layer
end)

function MoreInfoEditTextView:ctor()
	self:initUI()
end

function MoreInfoEditTextView:initUI()
	
end

--设置回调
--data 文本
--callback 修改完成的回调
function MoreInfoEditTextView:setData(data,callback)
	self.data = data
	self.callback = callback
end

return MoreInfoEditTextView