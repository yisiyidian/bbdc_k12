require("cocos.init")
require("common.global")

local ShareCheckIn = class('ShareCheckIn',function ()
	return cc.Layer:create()
end)

function ShareCheckIn.create()
	local layer = ShareCheckIn.new()
	return layer
end

function ShareCheckIn:ctor()
	local background = cc.Sprite:create('image/share/share_background.png')
	background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
	self:addChild(background)

	local label = cc.Label:createWithSystemFont('贝贝单词，根本停不下来','',32)
	label:setColor(cc.c3b(0,255,255))
	label:setPosition(background:getContentSize().width / 2,s_DESIGN_HEIGHT * 7 / 8)
	background:addChild(label)

	local label2 = cc.Label:createWithSystemFont('今日搞定  ','',32)
	label2:setAnchorPoint(0.5,0)
	label2:setColor(cc.c3b(0,255,255))
	background:addChild(label2)
	local length2 = label2:getContentSize().width

	local label3 = cc.Label:createWithSystemFont(s_LocalDatabaseManager.getStudyWordsNum(os.date('%x',os.time())),'',64)
	label3:setAnchorPoint(0.5,0.2)
	label3:setColor(cc.c3b(255,0,0))
	background:addChild(label3)

	local label4 = cc.Label:createWithSystemFont('  个单词','',32)
	label4:setAnchorPoint(0.5,0)
	label4:setColor(cc.c3b(0,255,255))
	background:addChild(label4)

	local length2 = label2:getContentSize().width
	local length3 = label3:getContentSize().width
	local length4 = label4:getContentSize().width
	label2:setPosition(background:getContentSize().width / 2 - (length3 + length4) / 2,s_DESIGN_HEIGHT * 6.3 / 8)
	label3:setPosition(background:getContentSize().width / 2 + (length2 - length4) / 2,s_DESIGN_HEIGHT * 6.3 / 8)
	label4:setPosition(background:getContentSize().width / 2 + (length3 + length2) / 2,s_DESIGN_HEIGHT * 6.3 / 8)

	local close_button = ccui.Button:create('image/share/share_close_before_sharing.png')
	close_button:setScale9Enabled(true)
	close_button:setAnchorPoint(1,1)
	close_button:setPosition(s_RIGHT_X,s_DESIGN_HEIGHT)
	self:addChild(close_button)

	local function close(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			local remove = cc.CallFunc:create(function ()
				self:removeFromParent()
			end,{})
			local move = cc.MoveBy:create(0.3,cc.p(0,-s_DESIGN_HEIGHT))
			self:runAction(cc.Sequence:create(move,remove))
		end
	end

	close_button:addTouchEventListener(close)

	local share_button = ccui.Button:create('image/share/share_normal.png')
	share_button:setScale9Enabled(true)
	share_button:setTitleText("分 享")
    share_button:setTitleColor(cc.c4b(255,255,255,255))
    share_button:setTitleFontSize(36)
	share_button:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 8)
	self:addChild(share_button)

	local function share(sender,eventType)
		if eventType == ccui.TouchEventType.ended then

		end
	end

	share_button:addTouchEventListener(share)

	local onTouchBegan = function(touch, event)
        return true
    end    
    self.isOtherAlter = false
    
    local onTouchMoved = function(touch, event)
    end
    
    local onTouchEnded = function(touch, event)
    end
    
    self.listener = cc.EventListenerTouchOneByOne:create()
    
    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)
    self.listener:setSwallowTouches(true)

end

return ShareCheckIn
