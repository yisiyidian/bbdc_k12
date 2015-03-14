require("cocos.init")

local PopupSoundDownloadSuccess = class("PopupSoundDownloadSuccess", function ()
    return cc.Layer:create()
end)

function PopupSoundDownloadSuccess.create()
    
    local layer = PopupSoundDownloadSuccess.new()
    local bookkey = s_CURRENT_USER.bookKey

    --add background
    layer:createBackground("image/soundLoadingBar/popup.png")

    --add beibei with earphone
    local beibei = cc.Sprite:create("image/soundLoadingBar/beibei_earphone.png")
    beibei:setAnchorPoint(cc.p(0.5,0.5))
    beibei:setPosition(cc.p(0,-25))
    layer:addChild(beibei)

    --add confirm button
    layer:addConfirmButton("image/soundLoadingBar/confirm_button.png","image/soundLoadingBar/confirm_button_press.png","知道了")
    
    --add title
    layer:addTitle(bookkey.."完成下载")
    
    --add description
    layer:addDescription("赞，你可以听见单词声音了")

    --disable the touch event under this layer
    --layer:disableTouchevent()
        
    return layer
end

function PopupSoundDownloadSuccess:createBackground(popupPath)

    --background
    local popup = cc.Sprite:create(popupPath)
    popup:setAnchorPoint(0.5,0.5)
    local popupContentSize = popup:getContentSize()
    
    --close button
    local closeBtn = ccui.Button:create("image/soundLoadingBar/close_button.png","image/soundLoadingBar/close_button.png","image/soundLoadingBar/close_button.png", ccui.TextureResType.localType)
    closeBtn:setAnchorPoint(cc.p(0.5,0.5))
    closeBtn:setPosition(cc.p(popupContentSize.width-15,popupContentSize.height-15))
    popup:addChild(closeBtn)
    
    --touch event of close button
    local close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect)
            self:runMoveOutAction()
        end
    end
    closeBtn:addTouchEventListener(close_clicked)
    self:addChild(popup)
    
    local onTouchBegan = function(touch, event)
        return true
    end    

    local onTouchMoved = function(touch, event)
        local location = self:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(popup:getBoundingBox(),location) then
           self:runMoveOutAction()
        end
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

function PopupSoundDownloadSuccess:addConfirmButton(confirmPath,confirmPressPath,text)
    
    local button = ccui.Button:create(confirmPath,confirmPressPath,"",ccui.TextureResType.localType)
    button:setPosition(0,-95)
    button:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(button)
    
    local button_clicked = function (sender, eventType)
    	if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect)
            self:runMoveOutAction()
    	end
    end
    
    local buttonLabel = cc.Label:create()
    buttonLabel:setString(text)
    buttonLabel:setColor(cc.c3b(255,255,255))
    buttonLabel:setSystemFontSize(35)
    buttonLabel:setAnchorPoint(0.5,0.5)
    buttonLabel:setPosition(button:getContentSize().width/2,button:getContentSize().height/2)
    
    button:addChild(buttonLabel)
    button:addTouchEventListener(button_clicked)
end

function PopupSoundDownloadSuccess:addTitle(text)
    
    local title = cc.Label:create()
    title:setString(text)
    title:setColor(cc.c3b(85,189,231))
    title:setSystemFontSize(35)
    title:setAnchorPoint(0.5,0.5)
    title:setPosition(0,120)
    
    self:addChild(title)
end

function PopupSoundDownloadSuccess:addDescription(text)

    local description = cc.Label:create()
    description:setString(text)
    description:setColor(cc.c3b(85,189,231))
    description:setSystemFontSize(26)
    description:setAnchorPoint(0.5,0.5)
    description:setPosition(0,82)

    self:addChild(description)
end

function PopupSoundDownloadSuccess:runMoveInAction()
    
    local parentNode = self:getParent() 
    local action1 = cc.MoveTo:create(0.3,cc.p(parentNode:getContentSize().width/2,s_DESIGN_HEIGHT/2-50))
    local action2 = cc.MoveTo:create(0.2,cc.p(parentNode:getContentSize().width/2,s_DESIGN_HEIGHT/2))

    self:runAction(cc.Sequence:create(action1,action2))
end

function PopupSoundDownloadSuccess:runMoveOutAction()

    local releaseSelf = function()
        self:removeFromParent()
    end
    
    local parentNode = self:getParent() 
    local action1 = cc.MoveTo:create(0.2,cc.p(parentNode:getContentSize().width/2,s_DESIGN_HEIGHT/2-50))
    local action2 = cc.MoveTo:create(0.3,cc.p(parentNode:getContentSize().width/2,s_DESIGN_HEIGHT/2+850))
    self:runAction(cc.Sequence:create(action1,action2, cc.CallFunc:create(releaseSelf)))
end

function PopupSoundDownloadSuccess:disableTouchevent()

    local onTouchBegan = function(touch, event)
        return true
    end    

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


return PopupSoundDownloadSuccess