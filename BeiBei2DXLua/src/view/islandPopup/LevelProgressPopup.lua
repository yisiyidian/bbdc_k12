local LevelProgressPopup = class ("LevelProgressPopup",function ()
    return cc.Layer:create()
end) 

local Button                = require("view.button.longButtonInStudy")

function LevelProgressPopup.create(index)
    local layer = LevelProgressPopup.new(index)
    layer:createInfo(index)
    return layer
end

local function addCloseButton(backPopup)
    local button_close_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
            local remove = cc.CallFunc:create(function() 
                  s_SCENE:removeAllPopups()
            end)
            backPopup:runAction(cc.Sequence:create(move,remove))
        end
    end

    local button_close = ccui.Button:create("image/friend/close.png","","")
    button_close:setScale9Enabled(true)
    button_close:setPosition(backPopup:getContentSize().width - 60 , backPopupßß:getContentSize().height - 60 )
    button_close:addTouchEventListener(button_close_clicked)
    return button_close
end 

function LevelProgressPopup:ctor(index)
    self.total_index = 7
    self.current_index = 1

    local boss = s_LocalDatabaseManager.getBossInfo(index)
    
    self.backPopup = cc.Sprite:create("image/islandPopup/subtask_bg.png")
    self.backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 - 10)
    self:addChild(self.backPopup)

    self.closeButton = addCloseButton(self.backPopup)
    self.backPopup:addChild(self.closeButton)

    local popup_title = cc.Label:createWithSystemFont('夏威夷-','Verdana-Bold',38)
    popup_title:setPosition(self.backPopup:getContentSize().width/2,self.backPopup:getContentSize().height-50)
    popup_title:setColor(cc.c3b(255,255,255))
    self.backPopup:addChild(popup_title,20)

    local last_button_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            self.changeToPage(false) 
        end
    end

    local last_button = ccui.Button:create("image/islandPopup/subtask_previous_button.png","image/islandPopup/subtask_previous_button.png","")
    last_button:setPosition(self.backPopup:getContentSize().width * 0.1,self.backPopup:getContentSize().height * 0.5)
    last_button:ignoreAnchorPointForPosition(false)
    last_button:setAnchorPoint(0.5,0.5)
    last_button:addTouchEventListener(last_button_clicked)
    self.backPopup:addChild(last_button)

    local next_button_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            self.changeToPage(true) 
        end
    end

    local next_button = ccui.Button:create("image/islandPopup/subtask_next_button.png","image/islandPopup/subtask_next_button.png","")
    next_button:setPosition(self.backPopup:getContentSize().width * 0.9,self.backPopup:getContentSize().height * 0.5)
    next_button:ignoreAnchorPointForPosition(false)
    next_button:setAnchorPoint(0.5,0.5)
    next_button:addTouchEventListener(next_button_clicked)
    self.backPopup:addChild(next_button)

    local onTouchBegan = function(touch, event)
        return true  
    end

    local onTouchEnded = function(touch, event)
        local location = self:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(backPopup:getBoundingBox(),location) then
            local move = cc.MoveBy:create(0.3, cc.p(0, s_DESIGN_HEIGHT))
            local remove = cc.CallFunc:create(function() 
                self:removeFromParent()
            end)
            self:runAction(cc.Sequence:create(move,remove))
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self) 


    onAndroidKeyPressed(self, function ()
        local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
        local remove = cc.CallFunc:create(function() 
            s_SCENE:removeAllPopups()
        end)
        self.backPopup:runAction(cc.Sequence:create(move,remove))
    end, function ()

    end)

end

function LevelProgressPopup:createInfo(index)
    local pageViewSize = cc.size(545, 683)
    local backgroundSize = cc.size(545, 683)

    local pageView = ccui.PageView:create()
    pageView:setTouchEnabled(true)
    pageView:setContentSize(pageViewSize)

    pageView:setPosition(cc.p((s_DESIGN_WIDTH - backgroundSize.width) / 2 +
        (backgroundSize.width - pageView:getContentSize().width) / 2,
        (s_DESIGN_HEIGHT - backgroundSize.height) / 2 +
        (backgroundSize.height - pageView:getContentSize().height) / 2))

    for i=1, self.total_index do  
        local layout = ccui.Layout:create()
        layout:setContentSize(pageViewSize)

        if i == 1 then
            local hammer_sprite = cc.Sprite:create("image/islandPopup/subtask_hammer.png")
            hammer_sprite:setPosition(layout:getContentSize().width / 2,layout:getContentSize().height / 2)
            layout:addChild(hammer_sprite)
        elseif i == 2 then
            local review_sprite = cc.Sprite:create("image/islandPopup/subtask_review_boss.png")
            review_sprite:setPosition(layout:getContentSize().width / 2,layout:getContentSize().height / 2)
            layout:addChild(review_sprite)
        elseif i == 3 then
            local summary_sprite = cc.Sprite:create("image/islandPopup/subtask_summary_boss.png")
            summary_sprite:setPosition(layout:getContentSize().width / 2,layout:getContentSize().height / 2)
            layout:addChild(summary_sprite)
        else
            local mysterious_sprite = cc.Sprite:create("image/islandPopup/subtask_mysterious _task.png")
            mysterious_sprite:setPosition(layout:getContentSize().width / 2,layout:getContentSize().height / 2)
            layout:addChild(mysterious_sprite)
        end

        pageView:addPage(layout)
    end

    -- change to current index
    pageView:scrollToPage(1) 

    self.changeToPage = function (bool) 
        if bool == true then
            local target = pageView:getCurPageIndex()
            if target ~= 7 then
                pageView:scrollToPage(target + 1)
            end
        elseif bool == false then
            local target = pageView:getCurPageIndex()
            if target ~= 1 then
                pageView:scrollToPage(target - 1)
            end
        end
    end

    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
        end
    end 
    pageView:addEventListener(pageViewEvent)
    self:addChild(pageView)
end

return LevelProgressPopup