require("cocos.init")
require("common.global")

local DataInfoLockedLayer = class('DataInfoLockedLayer',function ()
	return cc.Layer:create()
end)

function DataInfoLockedLayer.create(index)
	local layer = DataInfoLockedLayer.new()

	local item = cc.Sprite:create(string.format('image/shop/item%d.png',index + 1))
	item:setPosition((s_RIGHT_X - s_LEFT_X) / 2, s_DESIGN_HEIGHT / 2 - 80)
	layer:addChild(item)

	local buy_button = ccui.Button:create('image/shop/long_button.png','','')
	buy_button:setPosition((s_RIGHT_X - s_LEFT_X) / 2, 260)
	layer:addChild(buy_button)

	local bean = cc.Sprite:create('image/shop/been.png')
	bean:setPosition(buy_button:getContentSize().width * 0.2,buy_button:getContentSize().height * 0.5)
	buy_button:addChild(bean)
		
	return layer
end

return DataInfoLockedLayer