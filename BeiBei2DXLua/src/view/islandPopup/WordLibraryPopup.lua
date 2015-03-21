local WordLibraryPopup = class ("WordLibraryPopup",function ()
    return cc.Layer:create()
end) 

local Listview         = require("view.islandPopup.WordLibraryListview")

function WordLibraryPopup.create(index)
    local layer = WordLibraryPopup.new(index)
    return layer
end

local function addCloseButton(top_sprite,backPopup)
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
    button_close:setPosition(top_sprite:getContentSize().width - 30 , top_sprite:getContentSize().height - 30 )
    button_close:addTouchEventListener(button_close_clicked)
    return button_close
end 

local function addBackButton(top_sprite,self,backPopup)
    local button_back_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            local action0 = cc.OrbitCamera:create(0.5,1, 0, 0, 90, 0, 0) 
            local action1 = cc.CallFunc:create(function() 
                self:removeFromParent()
            end)
            backPopup:runAction(cc.Sequence:create(action0,action1))
            self.close()
        end
    end

    local button_back = ccui.Button:create("image/islandPopup/backtopocess.png","","")
    button_back:setScale9Enabled(true)
    button_back:setPosition(top_sprite:getContentSize().width *0.1 , top_sprite:getContentSize().height *0.5 )
    button_back:addTouchEventListener(button_back_clicked)
    return button_back
end

local function addUnfamiliarButton(top_sprite)
    local unfamiliar_button = cc.Sprite:create("image/islandPopup/unfamiliarwordend.png")
    unfamiliar_button:setPosition(top_sprite:getContentSize().width * 0.5 - unfamiliar_button:getContentSize().width * 0.6 + 8,top_sprite:getContentSize().height * 0.5)
    unfamiliar_button:ignoreAnchorPointForPosition(false)
    unfamiliar_button:setAnchorPoint(0.5,0.5)

    local unfamiliar_label = cc.Label:createWithSystemFont("生词","",35)
    unfamiliar_label:setPosition(unfamiliar_button:getContentSize().width / 2,unfamiliar_button:getContentSize().height / 2)
    unfamiliar_button:addChild(unfamiliar_label)
    
    return unfamiliar_button
end

local function addfamiliarButton(top_sprite)
    local familiar_button = cc.Sprite:create("image/islandPopup/familiarwordbegin.png")
    familiar_button:setPosition(top_sprite:getContentSize().width * 0.5 + familiar_button:getContentSize().width * 0.6 - 9,top_sprite:getContentSize().height * 0.5)
    familiar_button:ignoreAnchorPointForPosition(false)
    familiar_button:setAnchorPoint(0.5,0.5)

    local familiar_label = cc.Label:createWithSystemFont("熟词","",35)
    familiar_label:setPosition(familiar_button:getContentSize().width / 2,familiar_button:getContentSize().height / 2)
    familiar_button:addChild(familiar_label)

    return familiar_button
end

local function addReviewButton(bottom_sprite,boss)

    local review_button_click = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local ReviewBoss = require("view.newreviewboss.NewReviewBossMainLayer")
            if boss.wrongWordList == nil then
                return 
            else
                local reviewBoss = ReviewBoss.create(boss.wrongWordList,Review_From_Word_Bank)
                s_SCENE:replaceGameLayer(reviewBoss)
                s_SCENE:removeAllPopups()
            end
        end
    end

    local review_button = ccui.Button:create("image/islandPopup/button.png","","")
    review_button:setScale9Enabled(true)
    review_button:setPosition(bottom_sprite:getContentSize().width * 0.7,bottom_sprite:getContentSize().height * 0.5)
    review_button:ignoreAnchorPointForPosition(false)
    review_button:setAnchorPoint(0.5,0.5)
    review_button:setTitleText("复习怪兽")
    review_button:setTitleFontSize(30)
    review_button:addTouchEventListener(review_button_click)
    
    return review_button
end

local function addSummaryButton(bottom_sprite,boss)
    local wordList = function (initWordList)
        local temp = {}
        local endList = {}
        for i = 1 , # initWordList do
            table.insert(temp,initWordList[i])
        end
        local length
        if #initWordList > 6 then
            length = 6
        else
            length = #initWordList
        end   
        for i = 1 , length do
            local randSeed = math.randomseed(os.time())
            local randNum  = math.random(1,#initWordList)
            local tempNum  = temp[randNum]
            temp[randNum] = temp[i]
            temp[i] = tempNum  
        end
        for i = 1 , length do
            table.insert(endList,temp[i])
        end
        return  endList
    end
    local summary_button_click = function(sender, eventType)
        local endList = wordList(boss.wrongWordList)
        if eventType == ccui.TouchEventType.ended then
        local SummaryBossLayer = require('view.summaryboss.SummaryBossLayer')
        local summaryBossLayer = SummaryBossLayer.create(endList,1,false)
        s_SCENE:replaceGameLayer(summaryBossLayer) 
        s_SCENE:removeAllPopups()
        end
    end

    local summary_button = ccui.Button:create("image/islandPopup/button.png","","")
    summary_button:setScale9Enabled(true)
    summary_button:setPosition(bottom_sprite:getContentSize().width * 0.3,bottom_sprite:getContentSize().height * 0.5)
    summary_button:ignoreAnchorPointForPosition(false)
    summary_button:setAnchorPoint(0.5,0.5)
    summary_button:setTitleText("总结怪兽")
    summary_button:setTitleFontSize(30)
    summary_button:addTouchEventListener(summary_button_click)
    
    return summary_button
end

function WordLibraryPopup:ctor(index)
    local boss = s_LocalDatabaseManager.getBossInfo(index + 1)
    
    self.backPopup = cc.Sprite:create("image/islandPopup/backforlibrary.png")
    self.backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 - 10)
    self:addChild(self.backPopup)

    local top_sprite = cc.Sprite:create("image/islandPopup/top.png")
    top_sprite:setPosition(self.backPopup:getContentSize().width * 0.5,self.backPopup:getContentSize().height * 0.95)
    top_sprite:ignoreAnchorPointForPosition(false)
    top_sprite:setAnchorPoint(0.5,0.5)
    self.backPopup:addChild(top_sprite)
    
    self.closeButton = addCloseButton(top_sprite,self.backPopup)
    top_sprite:addChild(self.closeButton)
    
    self.backButton = addBackButton(top_sprite,self,self.backPopup)
    top_sprite:addChild(self.backButton)
    
    self.unfamiliarButton = addUnfamiliarButton(top_sprite)
    top_sprite:addChild(self.unfamiliarButton)

    local borderSprite = cc.Sprite:create("image/islandPopup/border.png")
    borderSprite:setPosition(top_sprite:getContentSize().width * 0.5,top_sprite:getContentSize().height * 0.5)
    borderSprite:ignoreAnchorPointForPosition(false)
    borderSprite:setAnchorPoint(0.5,0.5)
    top_sprite:addChild(borderSprite)
    
    self.familiarButton = addfamiliarButton(top_sprite)
    top_sprite:addChild(self.familiarButton)
    
   local line_sprite = cc.Sprite:create("image/islandPopup/line.png")
   line_sprite:setPosition(top_sprite:getContentSize().width * 0.5 -1,0)
   line_sprite:ignoreAnchorPointForPosition(false)
   line_sprite:setAnchorPoint(0.5,0.5)
   top_sprite:addChild(line_sprite,-1)
    
    local bottom_sprite = cc.Sprite:create("image/islandPopup/bottom.png")
    bottom_sprite:setPosition(self.backPopup:getContentSize().width * 0.5,self.backPopup:getContentSize().height * 0.03)
    bottom_sprite:ignoreAnchorPointForPosition(false)
    bottom_sprite:setAnchorPoint(0.5,0.5)
    self.backPopup:addChild(bottom_sprite,2)
    
    self.reviewButton = addReviewButton(bottom_sprite,boss)
    bottom_sprite:addChild(self.reviewButton)
    
    self.summaryButton = addSummaryButton(bottom_sprite,boss)
    bottom_sprite:addChild(self.summaryButton)

    self.reviewButton:setVisible(false)
    self.summaryButton:setVisible(false)

    self.close = function ()
    	
    end
    
    local onTouchBegan = function(touch, event)
        return true  
    end
    

    if s_CURRENT_USER.familiarOrUnfamiliar == 0 then -- 0 for choose familiar ,1 for choose unfamiliar
        self.listview = Listview.create(boss.rightWordList)
        self.reviewButton:setVisible(false)
        self.summaryButton:setVisible(false)
        self.familiarButton:setTexture("image/islandPopup/familiarwordend.png")
        self.unfamiliarButton:setTexture("image/islandPopup/unfamiliarwordbegin.png")
    else
        self.listview = Listview.create(boss.wrongWordList)  
        self.familiarButton:setTexture("image/islandPopup/familiarwordbegin.png")
        self.unfamiliarButton:setTexture("image/islandPopup/unfamiliarwordend.png") 
        if tonumber(index) == 0 then
            if #boss.wrongWordList >= 3 then
                self.reviewButton:setVisible(true)
                self.summaryButton:setVisible(true)
            end
        elseif #boss.wrongWordList >= getMaxWrongNumEveryLevel() then
        --if true then
            self.reviewButton:setVisible(true)
            self.summaryButton:setVisible(true)
        else
            self.reviewButton:setVisible(false)
            self.summaryButton:setVisible(false)
        end
    end
    
    self.listview:setPosition(2,70)
    self.backPopup:addChild(self.listview)
    
    local onTouchEnded = function(touch, event)
        local location = top_sprite:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(self.familiarButton:getBoundingBox(), location)  then
            s_CURRENT_USER.familiarOrUnfamiliar = 0
            self.familiarButton:setTexture("image/islandPopup/familiarwordend.png")
            self.unfamiliarButton:setTexture("image/islandPopup/unfamiliarwordbegin.png")
            self.listview:removeFromParent()
            self.listview = Listview.create(boss.rightWordList) 
            self.listview:setPosition(2,70)
            self.backPopup:addChild(self.listview)
            self.reviewButton:setVisible(false)
            self.summaryButton:setVisible(false)
        elseif cc.rectContainsPoint(self.unfamiliarButton:getBoundingBox(), location) then
            s_CURRENT_USER.familiarOrUnfamiliar = 1
            self.familiarButton:setTexture("image/islandPopup/familiarwordbegin.png")
            self.unfamiliarButton:setTexture("image/islandPopup/unfamiliarwordend.png")
            self.listview:removeFromParent()
            self.listview = Listview.create(boss.wrongWordList) 
            self.listview:setPosition(2,70)
            self.backPopup:addChild(self.listview)
            if tonumber(index) == 0 then
                if #boss.wrongWordList >= 3 then
                    self.reviewButton:setVisible(true)
                    self.summaryButton:setVisible(true)
                end
            elseif #boss.wrongWordList >= getMaxWrongNumEveryLevel() then
                self.reviewButton:setVisible(true)
                self.summaryButton:setVisible(true)
            else
                self.reviewButton:setVisible(false)
                self.summaryButton:setVisible(false)
            end
        end
        local location1 = self:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(self.backPopup:getBoundingBox(),location1) then
            local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
            local remove = cc.CallFunc:create(function() 
                s_SCENE:removeAllPopups()
            end)
            self.backPopup:runAction(cc.Sequence:create(move,remove))
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

return WordLibraryPopup