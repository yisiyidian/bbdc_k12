local LevelProgressPopup = class ("LevelProgressPopup",
    function ()
    return cc.Layer:create()
end) 

local Button                = require("view.button.longButtonInStudy")
local ProgressBar           = require("view.islandPopup.ProgressBar")

function LevelProgressPopup.create(index)
    local layer = LevelProgressPopup.new(index)
    layer.islandIndex = tonumber(index) + 1
    layer.unit = s_LocalDatabaseManager.getUnitInfo(layer.islandIndex)
    layer.wrongWordList = {}
    for i = 1 ,#layer.unit.wrongWordList do
        table.insert(layer.wrongWordList,layer.unit.wrongWordList[i])
    end
    print_lua_table(layer.unit)
    return layer
    
end


function LevelProgressPopup:ctor(index)
    print("index "..index)
    if tonumber(index) == 0 then
        s_CURRENT_USER:setSummaryStep(s_summary_enterFirstPopup) 
    elseif tonumber(index) == 1 then
        s_CURRENT_USER:setSummaryStep(s_summary_enterSecondPopup) 
    end
    --界面初始化
    --createPape()
    self:createSummary(index)

end

function LevelProgressPopup:createSummary(index)
    --local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 900)


    local background = cc.Sprite:create("image/islandPopup/subtask_bg.png")
    background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 - 10)
    self:addChild(background)
    self.background = background

    
    --加入上部 绿色背景
    local background_green = cc.Sprite:create("image/boss_view/background_green.png")
    background_green:setPosition(0,background:getContentSize().height)
    background_green:ignoreAnchorPointForPosition(false)
    background_green:setAnchorPoint(0,1)
    background:setContentSize(background_green:getContentSize().width,background:getContentSize().height)
    background:addChild(background_green)

    

    --加入怪物
    local monsters = sp.SkeletonAnimation:create("image/boss_view/guaishou_special.json", "image/boss_view/guaishou_special.atlas")
    monsters:setPosition(background:getContentSize().width/2,background:getContentSize().height/2)
    background:addChild(monsters)
    monsters:addAnimation(0, 'animation', true)

    --加入任务提示
    local text = cc.Label:createWithSystemFont("任务目标： 打败这货","",30)
    text:setPosition(background:getContentSize().width/2,background:getContentSize().height * 0.25)
    text:setColor(cc.c4b(50,50,50,255))
    background:addChild(text)

    --加入按钮
    local go_button = Button.create("long","blue","GO") 
    go_button:setPosition(background:getContentSize().width * 0.5 - 2, background:getContentSize().height * 0.13)

    local close_Click = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            s_SCENE:removeAllPopups()
        end
    end
    --加入关闭按钮
    local close_button = ccui.Button:create("image/button/button_close.png")
    close_button:setPosition(background:getContentSize().width - 20,background:getContentSize().height - 20)
    close_button:addTouchEventListener(close_Click)
    background:addChild(close_button)

    local wordCard_Click = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local WordCardView = require("view.wordcard.WordCardView")
            local wordCardView = WordCardView.create()
            s_SCENE:popup(wordCardView)
        end
    end
    --加入 词库按钮
    local wordCard_button = ccui.Button:create("image/islandPopup/button_change_to_ciku.png")
    wordCard_button:setPosition(40,background:getContentSize().height - 40)
    wordCard_button:addTouchEventListener(wordCard_Click)
    background:addChild(wordCard_button)

    local function button_func(  )
        playSound(s_sound_buttonEffect) 

        local bossList = s_LocalDatabaseManager.getAllUnitInfo()
        local maxID = s_LocalDatabaseManager.getMaxUnitID()
        if self.unit.coolingDay > 0 or self.unit.unitState >= 5 then
            --print('replay island')
            local SummaryBossLayer = require('view.summaryboss.NewSummaryBossLayer')
            local summaryBossLayer = SummaryBossLayer.create(self.unit)
            s_SCENE:replaceGameLayer(summaryBossLayer) 
            s_SCENE:removeAllPopups()  
            return
        end

        local taskIndex = -2

        for bossID, bossInfo in pairs(bossList) do
            if bossInfo["coolingDay"] == 0 and bossInfo["unitState"] - 1 >= 0 and taskIndex == -2 and bossInfo["unitState"] - 5 < 0 then
                taskIndex = bossID
            end
        end    

        if taskIndex == -2 then         
            s_CorePlayManager.initTotalUnitPlay() -- 之前没有boss
            s_SCENE:removeAllPopups()  
        elseif taskIndex == self.islandIndex then
            s_CorePlayManager.initTotalUnitPlay() -- 按顺序打第一个boss
            s_SCENE:removeAllPopups()  
        else
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch() 
            local tutorial_text = cc.Sprite:create('image/tutorial/tutorial_text.png')
            tutorial_text:setPosition(s_DESIGN_WIDTH / 2, 300)
            self:addChild(tutorial_text,520)
            local text = cc.Label:createWithSystemFont('请先打败前面的boss','',28)
            text:setPosition(tutorial_text:getContentSize().width/2,tutorial_text:getContentSize().height/2)
            text:setColor(cc.c3b(0,0,0))
            tutorial_text:addChild(text)
            local action1 = cc.FadeOut:create(1.5)
            local action1_1 = cc.MoveBy:create(1.5, cc.p(0, 100))
            local action1_2 = cc.Spawn:create(action1,action1_1)
            tutorial_text:runAction(action1_2)
            local action2 = cc.FadeOut:create(1.5)
            local action3 = cc.CallFunc:create(function ()
                s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch() 
            end)
            text:runAction(cc.Sequence:create(action2,action3))
        end 
    end
    go_button.func = function ()
        button_func()
    end
    background:addChild(go_button)


    --加入title
    local title = cc.Label:createWithSystemFont('Unit '..s_BookUnitName[s_CURRENT_USER.bookKey][''..tonumber(index) + 1],"",50)
    title:setPosition(background:getContentSize().width/2, background:getContentSize().height - 75)
    title:setColor(cc.c3b(255,255,255))
    background:addChild(title)

--[[
    local title2 = cc.Label:createWithSystemFont("good good study day day up", "",25)
    title2:setPosition(background:getContentSize().width/2, background:getContentSize().height - 150)
    title2:setColor(cc.c3b(255,255,255))
    background:addChild(title2)
]]--

    --点击开始
    local onTouchBegan = function(touch, event)
        return true  
    end

    --点击结束
    local onTouchEnded = function(touch, event)
        --获取点击的位置
        local location = self:convertToNodeSpace(touch:getLocation())
        --判断是否点击在弹出的方框内
        if not cc.rectContainsPoint(self.background:getBoundingBox(),location) then
            --是  移走
            local move = cc.MoveBy:create(0.3, cc.p(0, s_DESIGN_HEIGHT))
            local remove = cc.CallFunc:create(function() 
                s_SCENE:removeAllPopups()
            end)
            --执行动作
            self.background:runAction(cc.Sequence:create(move,remove))
        end
    end

    --监听函数
    local listener = cc.EventListenerTouchOneByOne:create()
    --不向下传递触摸
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    --获取响应事件
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self) 



      onAndroidKeyPressed(self, function ()
        local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
        local remove = cc.CallFunc:create(function() 
            s_SCENE:removeAllPopups()
        end)
        self.background:runAction(cc.Sequence:create(move,remove))
    end, function ()

    end)
end




return LevelProgressPopup