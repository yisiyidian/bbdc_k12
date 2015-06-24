--砖块元素
local CocoView = class("CocoView", function()
	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(120,120))
	return layer
end)

function CocoView.create()
    local layer = CocoView.new()
    return layer
end

function CocoView:ctor()
    
end

return CocoView