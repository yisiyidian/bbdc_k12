-- 词库功能UI
local WordCardView = class("WordCardView",function ()
	local layer = cc.Layer:create()
	return layer
end)

function WordCardView:ctor()
	self.listView = nil 
	
end

return WordCardView