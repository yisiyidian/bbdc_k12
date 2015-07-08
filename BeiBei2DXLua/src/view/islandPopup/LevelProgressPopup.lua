
-- 选玩法的界面
-- 趁热打铁 复习怪兽 总结怪兽 神秘任务

local LevelProgressPopup = class ("LevelProgressPopup",function ()
    return cc.Layer:create()
end) 

local Button                = require("view.button.longButtonInStudy")

function LevelProgressPopup.create(index)
    local layer = LevelProgressPopup.new(index)
    return layer
end


function LevelProgressPopup:ctor(index)
    self.index = index
    if tonumber(index) == 0 then
        if s_CURRENT_USER.summaryStep < s_summary_enterFirstPopup then
            s_CURRENT_USER:setSummaryStep(s_summary_enterFirstPopup)
            AnalyticsSummaryStep(s_summary_enterFirstPopup)
        end
    elseif tonumber(index) == 1 then
        if s_CURRENT_USER.summaryStep < s_summary_enterSecondPopup then
            s_CURRENT_USER:setSummaryStep(s_summary_enterSecondPopup)
            AnalyticsSummaryStep(s_summary_enterSecondPopup)
        end
    end

    self.islandIndex = tonumber(index) + 1
    self.unit = s_LocalDatabaseManager.getUnitInfo(self.islandIndex)
    print("这个关卡的信息是")
    print_lua_table(self.unit)
    -- 界面初始化
    self:initUI()
    s_CURRENT_USER:setSummaryStep(s_summary_enterFirstPopup)
end

function LevelProgressPopup:initUI()
    -- 背景
    local background = cc.Sprite:create("image/islandPopup/subtask_bg.png")
    background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 - 10)
    self.background = background
    self:addChild(self.background)

    --加入上部 绿色背景
    local background_green = cc.Sprite:create("image/boss_view/background_green.png")
    background_green:setPosition(0,self.background:getContentSize().height)
    background_green:ignoreAnchorPointForPosition(false)
    background_green:setAnchorPoint(0,1)
    self.background:setContentSize(background_green:getContentSize().width,self.background:getContentSize().height)
    self.background:addChild(background_green)
    --加入怪物
    local monsters = sp.SkeletonAnimation:create("image/boss_view/guaishou_special.json", "image/boss_view/guaishou_special.atlas")
    monsters:setPosition(self.background:getContentSize().width/2,self.background:getContentSize().height/2)
    self.background:addChild(monsters)
    monsters:addAnimation(0, 'animation', true)

    --加入title
    local titleString = string.gsub('Unit '..s_BookUnitName[s_CURRENT_USER.bookKey][''..tonumber(self.index) + 1],"_","-")
    local title = cc.Label:createWithSystemFont(titleString,"",50)
    title:setPosition(self.background:getContentSize().width/2, self.background:getContentSize().height - 75)
    title:setColor(cc.c3b(255,255,255))
    self.background:addChild(title)

    self:createSummary(self.index)

    -- 添加引导
    if s_CURRENT_USER.guideStep == s_guide_step_enterLevel then
        s_CorePlayManager.enterGuideScene(6,self)
        s_CURRENT_USER:setGuideStep(s_guide_step_enterPopup) 
    -- 添加引导
    elseif s_CURRENT_USER.guideStep <= s_guide_step_enterCard and s_CURRENT_USER.guideStep > s_guide_step_enterLevel then
        s_CorePlayManager.enterGuideScene(8,self)
        s_CURRENT_USER:setGuideStep(s_guide_step_returnPopup) 
    end
end    

function LevelProgressPopup:createSummary(index)
    --加入按钮
    local go_button = Button.create("image/button/middleblueback.png","image/button/middlebluefront.png",9,"GO") 
    go_button:setPosition(self.background:getContentSize().width * 0.5 - 2, self.background:getContentSize().height * 0.13)

    local close_Click = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            sender:setTouchEnabled(false)
            s_SCENE:removeAllPopups()
            s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch() --放开点击
        end
    end
    --加入关闭按钮
    local close_button = ccui.Button:create("image/button/button_close.png")
    close_button:setPosition(self.background:getContentSize().width - 20,self.background:getContentSize().height - 20)
    close_button:addTouchEventListener(close_Click)
    self.background:addChild(close_button)

    local function button_func(  )
        playSound(s_sound_buttonEffect) 

        if s_CURRENT_USER.guideStep <= s_guide_step_enterCard then  
            local SmallAlterWithOneButton = require("view.alter.SmallAlterWithOneButton")
            local smallAlter = SmallAlterWithOneButton.create("请先跟着引导点击词库")
            smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
            s_SCENE.popupLayer:addChild(smallAlter)
            smallAlter.affirm = function ()
                smallAlter:removeFromParent()
            end
            return
        end

        if s_CURRENT_USER.summaryStep < s_summary_enterFirstLevel and tonumber(self.index) == 0 then
            s_CURRENT_USER:setSummaryStep(s_summary_enterFirstLevel)
            AnalyticsSummaryStep(s_summary_enterFirstLevel)
        elseif s_CURRENT_USER.summaryStep < s_summary_enterSecondLevel and tonumber(self.index) == 1 then
            s_CURRENT_USER:setSummaryStep(s_summary_enterSecondLevel)
            AnalyticsSummaryStep(s_summary_enterSecondLevel)
        end

        local bossList = s_LocalDatabaseManager.getAllUnitInfo()
        local maxID = s_LocalDatabaseManager.getMaxUnitID()
        if self.unit.coolingDay > 0 or self.unit.unitState >= 5 then
            -- 记录用户点击的关卡号
            -- print('user unit:'..self.unit.unitID)
            s_game_fail_level_index = self.unit.unitID - 1

            showProgressHUD('', true)
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
            --showProgressHUD('', true)    
            s_BattleManager:enterBattleView(self.unit) -- 之前没有boss
            s_SCENE:removeAllPopups()  
        else--if taskIndex == self.islandIndex then
            --showProgressHUD('', true) 
            s_BattleManager:enterBattleView(self.unit) -- 按顺序打第一个boss
            s_SCENE:removeAllPopups()  
        -- else
        --     s_TOUCH_EVENT_BLOCK_LAYER.lockTouch() --锁定触摸
        --     local tutorial_text = cc.Sprite:create('image/tutorial/tutorial_text.png')
        --     tutorial_text:setPosition(s_DESIGN_WIDTH / 2, 300)
        --     self:addChild(tutorial_text,520)
        --     local text = cc.Label:createWithSystemFont('请先打败前面的boss','',28)
        --     text:setPosition(tutorial_text:getContentSize().width/2,tutorial_text:getContentSize().height/2)
        --     text:setColor(cc.c3b(0,0,0))
        --     tutorial_text:addChild(text)
        --     local action1 = cc.FadeOut:create(1.5)
        --     local action1_1 = cc.MoveBy:create(1.5, cc.p(0, 100))
        --     local action1_2 = cc.Spawn:create(action1,action1_1)
        --     tutorial_text:runAction(action1_2)
        --     local action2 = cc.FadeOut:create(1.5)
        --     local action3 = cc.CallFunc:create(function ()
        --         s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
        --     end)
        --     text:runAction(cc.Sequence:create(action2,action3))
        end 
    end
    go_button.func = function ()
        button_func()
    end
    self.background:addChild(go_button)
    if s_CURRENT_USER.guideStep <= s_guide_step_enterLevel then  
        go_button.button_front:setOpacity(120)
        go_button.label:setOpacity(120)
        go_button:setOpacity(20)
    end


    if s_CURRENT_USER.guideStep <= s_guide_step_enterCard and s_CURRENT_USER.guideStep > s_guide_step_enterLevel then
        local guideFingerView = require("view.guide.GuideFingerView").create()
        guideFingerView:setPosition(go_button:getContentSize().width *0.8,0)
        go_button:addChild(guideFingerView,3)
    end

    local wordCard_Click = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local WordCardView = require("view.wordcard.WordCardView")
            local wordCardView = WordCardView.create(index)
            s_SCENE:popup(wordCardView)
        end
    end
    --加入 词库按钮
    local wordCard_button = ccui.Button:create("image/islandPopup/unit_words_button_click.png","image/islandPopup/unit_words_button.png","")
    wordCard_button:setPosition(self.background:getContentSize().width * 0.5 - 2, self.background:getContentSize().height * 0.25)
    wordCard_button:addTouchEventListener(wordCard_Click)
    self.background:addChild(wordCard_button)

    -- 加入引导手指
    if s_CURRENT_USER.guideStep == s_guide_step_enterLevel then
        local guideFingerView = require("view.guide.GuideFingerView").create()
        guideFingerView:setPosition(wordCard_button:getContentSize().width,0)
        wordCard_button:addChild(guideFingerView,3)
    end

    onAndroidKeyPressed(self,function() self:closeFunc() end, function ()end)
    touchBackgroundClosePopup(self,self.background,function() self:closeFunc() end)
end

function LevelProgressPopup:closeFunc()
    local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
    local remove = cc.CallFunc:create(function() 
        s_SCENE:removeAllPopups()
    end)
    self.background:runAction(cc.Sequence:create(move,remove))
end




return LevelProgressPopup