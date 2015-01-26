require("cocos.init")
require("common.global")

local ShareBottom = class('ShareBottom',function ()
	return cc.Layer:create()
end)

function ShareBottom.create(target)
	local layer = ShareBottom.new()
	layer.target = target
	return layer
end

function ShareBottom:ctor()

	local function addTitle(button,str,x)
		local label = cc.Label:createWithSystemFont(str,'',20)
		label:setPosition(x * button:getContentSize().width, - 0.25 * button:getContentSize().height)
		button:addChild(label)
	end
	
	local bottom = cc.LayerColor:create(cc.c4b(0,0,0,87),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT * 0.21)
	bottom:ignoreAnchorPointForPosition(false)
	bottom:setAnchorPoint(0.5,1)
	bottom:setPosition(s_DESIGN_WIDTH / 2,0)
	self:addChild(bottom)
	bottom:runAction(cc.MoveBy:create(0.3,cc.p(0,s_DESIGN_HEIGHT * 0.21)))

	local save_button = ccui.Button:create('image/share/share_preserve.png','')
	save_button:setScale9Enabled(true)
	save_button:setPosition(0.26 * (s_RIGHT_X - s_LEFT_X),0.55 * bottom:getContentSize().height)
	bottom:addChild(save_button)
	addTitle(save_button,'保存',0.5)

	-- create a render texture, this is what we are going to draw into
    -- target = cc.RenderTexture:create(s_DESIGN_WIDTH * 1, s_DESIGN_HEIGHT * 1, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    -- target:retain()
    -- target:setPosition(cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2))

    local function saveImage(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
        	local png = string.format("image-saved%s.png",os.date('%X',os.time()))
            self.target:saveToFile(png, cc.IMAGE_FORMAT_PNG)
            self:getParent():shareEnd()
            local move = cc.MoveBy:create(0.3,cc.p(0,-s_DESIGN_HEIGHT * 0.21))
            local remove = cc.CallFunc:create(function ()
				self:removeFromParent()
			end)
            bottom:runAction(cc.Sequence:create(move,remove))
        end
    end
    

	save_button:addTouchEventListener(saveImage)

	local weixin_button = ccui.Button:create('image/share/share_weichat.png','')
	weixin_button:setScale9Enabled(true)
	weixin_button:setPosition(0.5 * (s_RIGHT_X - s_LEFT_X) + 5,0.55 * bottom:getContentSize().height)
	bottom:addChild(weixin_button)
	addTitle(weixin_button,'朋友圈',0.45)

	local qq_button = ccui.Button:create('image/share/share_QQ.png','')
	qq_button:setScale9Enabled(true)
	qq_button:setPosition(0.74 * (s_RIGHT_X - s_LEFT_X),0.55 * bottom:getContentSize().height)
	bottom:addChild(qq_button)
	addTitle(qq_button,'QQ好友',0.5)

	local close = ccui.Button:create('image/share/share_close_sharing.png','')
	close:setScale9Enabled(true)
	--close:setVisible(false)
	close:setAnchorPoint(1,1)
	close:setPosition((s_RIGHT_X - s_LEFT_X) * 0.99,s_DESIGN_HEIGHT * 0.99)
	self:addChild(close)

	local function closeShare(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			local remove = cc.CallFunc:create(function ()
				self:getParent():removeFromParent()
			end)
			bottom:runAction(remove)
		end
	end

	close:addTouchEventListener(closeShare)
	
end

return ShareBottom