local LevelProgressPopup = class ("LevelProgressPopup",function ()
    return cc.Layer:create()
end) 

local Button                = require("view.button.longButtonInStudy")
local ProgressBar           = require("view.islandPopup.ProgressBar")

function LevelProgressPopup.create(index)
    print("~~~"..index)
    local layer = LevelProgressPopup.new(index)
    local islandIndex = tonumber(index) + 1
    layer.unit = s_LocalDatabaseManager.getUnitInfo(islandIndex)
    print("~~~~~~~~~")
    layer.wrongWordList = {}
    for i = 1 ,#layer.unit.wrongWordList do
        table.insert(layer.wrongWordList,layer.unit.wrongWordList[i])
    end
    print_lua_table(layer.unit)
    layer.current_index = layer.unit.unitState
    layer.coolingDay = layer.unit.coolingDay
    layer:createPape()
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
    button_close:setPosition(backPopup:getContentSize().width - 60 , backPopup:getContentSize().height - 60 )
    button_close:addTouchEventListener(button_close_clicked)
    return button_close
end 

local function addBackButton(backPopup,islandIndex)
    local button_back_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            local WordLibrary = require("view.islandPopup.WordLibraryPopup")
            local wordLibrary = WordLibrary.create(islandIndex)
            s_SCENE.popupLayer:addChild(wordLibrary)  
            wordLibrary:setVisible(false)
            
            local action0 = cc.OrbitCamera:create(0.5,1, 0, 0, 90, 0, 0) 
            backPopup:runAction(action0) 
            
            local action1 = cc.DelayTime:create(0.5)
            local action2 = cc.CallFunc:create(function()
                wordLibrary:setVisible(true)
            end)
            local action3 = cc.OrbitCamera:create(0.5,1, 0, -90, 90, 0, 0) 
            local action4 = cc.Sequence:create(action1, action2, action3)
            wordLibrary:runAction(action4)  
        end
    end

    local button_back = ccui.Button:create("image/islandPopup/button_change_to_ciku.png","","")
    button_back:setScale9Enabled(true)
    button_back:setPosition(backPopup:getContentSize().width *0.1 , backPopup:getContentSize().height *0.95 )
    button_back:addTouchEventListener(button_back_clicked)
    return button_back
end

function LevelProgressPopup:ctor(index)
    local islandIndex = tonumber(index) + 1
    self.total_index = 7

    self.animation = function ()

    end
    
    self.backPopup = cc.Sprite:create("image/islandPopup/subtask_bg.png")
    self.backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 - 10)
    self:addChild(self.backPopup)

    self.closeButton = addCloseButton(self.backPopup)
    self.backPopup:addChild(self.closeButton,2)

    self.backBtn = addBackButton(self.backPopup,islandIndex)
    self.backPopup:addChild(self.backBtn,2)

    local popup_title = cc.Label:createWithSystemFont('夏威夷-'..islandIndex,'Verdana-Bold',38)
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

    local last_button = ccui.Button:create("image/islandPopup/subtask_previous_button.png","","")
    last_button:setPosition(self.backPopup:getContentSize().width * 0.1,self.backPopup:getContentSize().height * 0.5 + 80)
    last_button:setScale9Enabled(true)
    last_button:ignoreAnchorPointForPosition(false)
    last_button:setAnchorPoint(0.5,0.5)
    last_button:addTouchEventListener(last_button_clicked)
    self.backPopup:addChild(last_button,1)

    local next_button_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)
        elseif eventType == ccui.TouchEventType.ended then
            self.changeToPage(true) 
        end
    end

    local next_button = ccui.Button:create("image/islandPopup/subtask_next_button.png","","")
    next_button:setScale9Enabled(true)
    next_button:setPosition(self.backPopup:getContentSize().width * 0.9,self.backPopup:getContentSize().height * 0.5 + 80)
    next_button:ignoreAnchorPointForPosition(false)
    next_button:setAnchorPoint(0.5,0.5)
    next_button:addTouchEventListener(next_button_clicked)
    self.backPopup:addChild(next_button,1)
    
    local onTouchBegan = function(touch, event)
        return true  
    end

    local onTouchEnded = function(touch, event)
        local location = self:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(self.backPopup:getBoundingBox(),location) then
            local move = cc.MoveBy:create(0.3, cc.p(0, s_DESIGN_HEIGHT))
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

function LevelProgressPopup:createPape()
    local pageViewSize = cc.size(545, 900)
    local backgroundSize = cc.size(545, 900)

    local pageView = ccui.PageView:create()
    pageView:setTouchEnabled(true)
    pageView:setContentSize(pageViewSize)

    local back_width = self.backPopup:getContentSize().width
    local back_height = self.backPopup:getContentSize().height

    pageView:setPosition(cc.p((back_width - backgroundSize.width) / 2 +
        (backgroundSize.width - pageView:getContentSize().width) / 2,
        (back_height - backgroundSize.height) / 2 +
        (backgroundSize.height - pageView:getContentSize().height) / 2 + 80 ))

    local progressBar = ProgressBar.create(6,self.current_index)
    progressBar:setPosition(self.backPopup:getContentSize().width * 0.5,self.backPopup:getContentSize().height * 0.25)
    self.backPopup:addChild(progressBar)

    for i=1, self.total_index do  
        local layout = ccui.Layout:create()
        layout:setContentSize(pageViewSize)

        if i == 1 then
            local StrikeLayer = self:createStrikeIron()
            layout:addChild(StrikeLayer)
        elseif i == 2 then
            local ReviewLayer = self:createReview()
            layout:addChild(ReviewLayer)
        elseif i == 3 then
            local SummaryLayer = self:createSummary()
            layout:addChild(SummaryLayer)
        elseif i <= self.current_index then
            local ReviewLayer = self:createReview(i)
            layout:addChild(ReviewLayer)
        else
            local MysteriousLayer = self:createMysterious()
            layout:addChild(MysteriousLayer) 
        end

        pageView:addPage(layout)
    end

    -- change to current index
    pageView:scrollToPage(self.current_index) 

    self.changeToPage = function (bool) 
        if bool == true then
            local target = pageView:getCurPageIndex()
            if target ~= 6 then
                pageView:scrollToPage(target + 1)
            end
        elseif bool == false then
            local target = pageView:getCurPageIndex()
            if target ~= 0 then
                pageView:scrollToPage(target - 1)
            end
        end
    end

    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
           progressBar.moveLightCircle(pageView:getCurPageIndex())
        end
    end 
    pageView:addEventListener(pageViewEvent)
    self.backPopup:addChild(pageView)
end

local function createTitle(Text,parent)
    local title = cc.Label:createWithSystemFont(Text,"",36)
    title:setColor(cc.c4b(50,60,64,255))
    title:setPosition(cc.p(parent:getContentSize().width * 0.5,parent:getContentSize().height * 0.75))
    parent:addChild(title)
end

local function createSubtitle(Text,parent)
    local subtitle = cc.Label:createWithSystemFont(Text,"",18)
    subtitle:setColor(cc.c4b(108,108,108,255))
    subtitle:setPosition(cc.p(parent:getContentSize().width * 0.5,parent:getContentSize().height * 0.7))
    parent:addChild(subtitle)
end

local function createReviewLabel(parent)
    local review_label = cc.Label:createWithSystemFont("复习生词","",25)
    review_label:setColor(cc.c4b(98,98,98,255))
    review_label:setPosition(cc.p(parent:getContentSize().width * 0.2,parent:getContentSize().height * 0.3))
    parent:addChild(review_label)
end

local function createReviewSprite(current,total,parent)
    local review_sprite = cc.Sprite:create("image/islandPopup/subtask_number_bg.png")
    review_sprite:setPosition(cc.p(parent:getContentSize().width * 0.4,parent:getContentSize().height * 0.3))
    parent:addChild(review_sprite)

    local review_num = cc.Label:createWithSystemFont(current.." / "..total,"",24)
    review_num:setColor(cc.c4b(255,255,255,255))
    review_num:setPosition(cc.p(review_sprite:getContentSize().width * 0.5,review_sprite:getContentSize().height * 0.5))
    review_sprite:addChild(review_num)
end

local function createRewardLabel(parent)
    local reward_label = cc.Label:createWithSystemFont("奖励","",25)
    reward_label:setColor(cc.c4b(98,98,98,255))
    reward_label:setPosition(cc.p(parent:getContentSize().width * 0.6,parent:getContentSize().height * 0.3))
    parent:addChild(reward_label)
end

local function createRewardSprite(num,parent)
    local reward_sprite = cc.Sprite:create("image/islandPopup/subtask_beibeibean.png")
    reward_sprite:setPosition(cc.p(parent:getContentSize().width * 0.8,parent:getContentSize().height * 0.3))
    parent:addChild(reward_sprite)

    local reward_num = cc.Label:createWithSystemFont(num,"",24)
    reward_num:setColor(cc.c4b(255,255,255,255))
    reward_num:setPosition(cc.p(reward_sprite:getContentSize().width * 0.75,reward_sprite:getContentSize().height * 0.5))
    reward_sprite:addChild(reward_num)
end

local function createNormalPlay(parent)
    local button_func = function()
        playSound(s_sound_buttonEffect)           
        s_CorePlayManager.initTotalUnitPlay() 
        s_SCENE:removeAllPopups()    
    end

    local go_button = Button.create("long","blue","GO") 
    go_button:setPosition(parent:getContentSize().width * 0.5 - 2, parent:getContentSize().height * 0.05)
    go_button.func = function ()
        button_func()
    end

    parent:addChild(go_button)
end

local function createRepeatlPlay(playModel,parent)
    local button_func = function()
        playSound(s_sound_buttonEffect)           
        if playModel == "review" then

        elseif playModel == "summary" then

        end 
        s_SCENE:removeAllPopups()    
    end

    local go_button = Button.create("long","blue","重玩") 
    go_button:setPosition(parent:getContentSize().width * 0.5 - 2, parent:getContentSize().height * 0.05)
    go_button.func = function ()
        button_func()
    end

    parent:addChild(go_button)
end

function LevelProgressPopup:createStrikeIron()
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 900)

    local hammer_sprite = cc.Sprite:create("image/islandPopup/subtask_hammer.png")
    hammer_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
    back:addChild(hammer_sprite)
    
    createTitle("趁热打铁",back)
    createSubtitle("复习上课学过的单词",back)
    createReviewLabel(back)
    createReviewSprite(10,10,back)
    createRewardLabel(back)
    createRewardSprite(3,back)

    if self.current_index == 0 then
        createNormalPlay(back)
    end
    
    return back
end

function LevelProgressPopup:createReview(mysterious_index)
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 900)

    local review_sprite = cc.Sprite:create("image/islandPopup/subtask_review_boss.png")
    review_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
    back:addChild(review_sprite)

    createTitle("复习怪兽",back)
    createSubtitle("挑出和给出意思对应的章鱼",back)
    createReviewLabel(back)
    createReviewSprite(10,10,back)
    createRewardLabel(back)
    createRewardSprite(3,back)

    if mysterious_index ~= nil then
        if (self.current_index == (mysterious_index - 1) and self.coolingDay == 0) then
            createNormalPlay(back)
        elseif self.current_index >= mysterious_index then
            createRepeatlPlay("review",back)
        end
    else
        if self.current_index == 1 then
            createNormalPlay(back)
        elseif self.current_index > 1 then
            createRepeatlPlay("review",back)
        end
    end
    
    return back
end

function LevelProgressPopup:createSummary()
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 900)

    local summary_sprite = cc.Sprite:create("image/islandPopup/subtask_summary_boss.png")
    summary_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
    back:addChild(summary_sprite)

    createTitle("总结怪兽",back)
    createSubtitle("划出给出中文对应的单词来击败boss",back)
    createReviewLabel(back)
    createReviewSprite(10,10,back)
    createRewardLabel(back)
    createRewardSprite(3,back)
    
    if self.current_index == 2 then
        createNormalPlay(back)
    elseif self.current_index > 2 then
        createRepeatlPlay("summary",back)
    end
    
    return back
end

function LevelProgressPopup:createMysterious()
    local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 900)

    local mysterious_sprite = cc.Sprite:create("image/islandPopup/subtask_mysterious_task.png")
    mysterious_sprite:setPosition(back:getContentSize().width / 2,back:getContentSize().height / 2)
    back:addChild(mysterious_sprite)

    createTitle("神秘任务",back)
    createSubtitle("一个即将到来的神秘玩法",back)
    createReviewLabel(back)
    createReviewSprite("?","?",back)
    createRewardLabel(back)
    createRewardSprite("?",back)
    
    return back
end

return LevelProgressPopup