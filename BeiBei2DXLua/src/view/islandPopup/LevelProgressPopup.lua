
-- 选玩法的界面
-- 趁热打铁 复习怪兽 总结怪兽 神秘任务


-- 2015年09月07日18:43:03
-- 更新界面

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
    local background = cc.Sprite:create("image/islandPopup/islandPopup.png")
    background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 - 10)
    self.background = background
    self:addChild(self.background)

    --加入怪物
    local monsters = sp.SkeletonAnimation:create("image/boss_view/guaishou_special.json", "image/boss_view/guaishou_special.atlas")
    monsters:setPosition(self.background:getContentSize().width/2,self.background:getContentSize().height/2)
    self.background:addChild(monsters)
    monsters:addAnimation(0, 'animation', true)

    --加入title
    --local titleString = string.gsub('Unit '..s_BookUnitName[s_CURRENT_USER.bookKey][''..tonumber(self.index) + 1],"_","-")
    local titleString = string.gsub(s_BookUnitName[s_CURRENT_USER.bookKey][''..tonumber(self.index) + 1],"_","-")
    local title = cc.Label:createWithSystemFont(titleString,"",50)
    title:setPosition(self.background:getContentSize().width/2, self.background:getContentSize().height - 55)
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
    local pk_button = ccui.Button:create("image/islandPopup/pkBtnNormal.png","image/islandPopup/pkBtnPress.png","")
    pk_button:addTouchEventListener(handler(self,self.pkClick))
    pk_button:setPosition(63, self.background:getContentSize().height * 0.1)
    self.background:addChild(pk_button)

    local maxID = s_LocalDatabaseManager.getMaxUnitID()
    --if self.unit.coolingDay > 0 or self.unit.unitState >= 5 then
    print('Self.unit.unitID:'..self.unit.unitID..',maxID:'..maxID)
    if self.unit.unitState == 0 then
        pk_button:setOpacity(20)
    end



    local go_button = ccui.Button:create("image/islandPopup/goNormal.png","image/islandPopup/goPress.png","")
    go_button:addTouchEventListener(handler(self,self.goClick))
    go_button:setPosition(467, self.background:getContentSize().height * 0.1)

    local close_Click = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            sender:setTouchEnabled(false)
            s_SCENE:removeAllPopups()
            s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch() --放开点击
        end
    end
    --加入关闭按钮
    local close_button = ccui.Button:create("image/islandPopup/closeNormal.png","image/islandPopup/closePress.png","")
    close_button:setPosition(self.background:getContentSize().width - 40,self.background:getContentSize().height - 40)
    close_button:addTouchEventListener(close_Click)
    self.background:addChild(close_button)

    self.background:addChild(go_button)

    if s_CURRENT_USER.guideStep <= s_guide_step_enterLevel then  
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
    local wordCard_button = ccui.Button:create("image/islandPopup/wordNormal.png","image/islandPopup/wordPress.png","")
    wordCard_button:setPosition(255, self.background:getContentSize().height * 0.1)
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

-- 延时调用方法
function LevelProgressPopup:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self:runAction(sequence)   
end

function LevelProgressPopup:closeFunc()
    local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
    local remove = cc.CallFunc:create(function() 
        s_SCENE:removeAllPopups()
    end)
    self.background:runAction(cc.Sequence:create(move,remove))
end

-- 点击pk按钮
function LevelProgressPopup:pkClick(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    -- "您还没有通过该小岛，不能跟别的玩家pk"
    if self.unit.unitState == 0 then
        local SmallAlterWithOneButton = require("view.alter.SmallAlterWithOneButton")
        local smallAlter = SmallAlterWithOneButton.create("您还没有通过该小岛，不能跟别的玩家pk")
        smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
        s_SCENE.popupLayer:addChild(smallAlter)
        smallAlter.affirm = function ()
            smallAlter:removeFromParent()
        end
        return
    end

    if s_CURRENT_USER.pkTime ~= 0 then
        local WaitEndingLayer = require("view.summaryboss.WaitEndingLayer")
        local waitEndingLayer = WaitEndingLayer.create()
        s_SCENE:replaceGameLayer(waitEndingLayer)
    else
        local SearchLayer = require('view.summaryboss.SearchLayer')
        local searchLayer = SearchLayer.create(self.unit,"normal")
        s_SCENE:replaceGameLayer(searchLayer)
    end
 

    self:callFuncWithDelay(0.1,function()
        s_SCENE:removeAllPopups() 
    end) 
    -- pk
    -- local bossList = s_LocalDatabaseManager.getAllUnitInfo()
    -- local maxID = s_LocalDatabaseManager.getMaxUnitID()
    -- showProgressHUD('', true)
    -- local PK = require('view.summaryboss.PK')
    -- local pK = PK.create(self.unit)
    -- s_SCENE:replaceGameLayer(pK) 
    -- self:callFuncWithDelay(0.1,function()
    --     s_SCENE:removeAllPopups() 
    -- end) 
end

-- 点击go按钮
function LevelProgressPopup:goClick(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    playSound(s_sound_buttonEffect) 
    s_lastLevelOfEachBook[s_CURRENT_USER.bookKey] = self.index
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
    --if self.unit.coolingDay > 0 or self.unit.unitState >= 5 then
    print('Self.unit.unitID:'..self.unit.unitID..',maxID:'..maxID)
    if self.unit.unitID < maxID then
            -- 记录用户点击的关卡号
            -- print('user unit:'..self.unit.unitID)
        s_game_fail_level_index = self.unit.unitID - 1

        showProgressHUD('', true)
        --print('replay island')
        --self:callFuncWithDelay(0.5, function()
            local SummaryBossLayer = require('view.summaryboss.NewSummaryBossLayer')
            local summaryBossLayer = SummaryBossLayer.create(self.unit)
            s_CorePlayManager.currentUnitID = self.unit.unitID

            s_SCENE:replaceGameLayer(summaryBossLayer) 
            self:callFuncWithDelay(0.1,function()
                s_SCENE:removeAllPopups() 
            end) 
        --end)

        --return
    else
        showProgressHUD('', true)    
        --s_SCENE:removeAllPopups() 

        s_CorePlayManager.initTotalUnitPlay() -- 之前没有boss 
        self:callFuncWithDelay(0.1,function()
            s_SCENE:removeAllPopups() 
        end) 
    end 
end


return LevelProgressPopup