
local MissionConfig  = require("model.mission.MissionConfig")

local Button                = require("view.button.longButtonInStudy")

local ENTRANCE_WORD_LIBRARY = false
local ENTRANCE_NORMAL = true

local SummaryBossAlter = class("SummaryBossAlter", function()
    return cc.Layer:create()
end)

function SummaryBossAlter.create(bossLayer,win,entrance)

    local layer = SummaryBossAlter.new()
    layer.wordCount = bossLayer.maxCount
    layer.win = win
    layer.wordList = bossLayer.wordList
    layer.bossLayer = bossLayer

    layer.entrance = entrance
    layer.needToAddBean = not bossLayer.isReplay
    --disable pauseBtn
    if s_SCENE.popupLayer~=nil then
        s_SCENE.popupLayer:setPauseBtnEnabled(false)
        s_SCENE.popupLayer.isOtherAlter = true
    end    
    local back = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    back:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    layer:addChild(back)
    back:setName('background')

    if win then
        if entrance == ENTRANCE_NORMAL and layer.needToAddBean then
            AnalyticsPassSecondSummaryBoss()
            s_CURRENT_USER:addBeans(3)
            saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
        end
        layer:win1(entrance)  
        cc.SimpleAudioEngine:getInstance():stopMusic()

        s_SCENE:callFuncWithDelay(0.3,function()
            -- win sound
            playMusic(s_sound_win,true)
        end)
    else    
        if not bossLayer.useItem and s_CURRENT_USER:getBeans() >= 0 then
            layer:lose(entrance)
        else
            layer:lose2(entrance)
        end
        -- boss失败的后的标志，非凡用
        s_game_fail_state = 1
        cc.SimpleAudioEngine:getInstance():stopMusic()

        -- s_SCENE:callFuncWithDelay(0.3,function()
        --     -- win sound
        --     playSound(s_sound_fail)
        -- end)
    end

    return layer
end

function SummaryBossAlter:ctor(  )
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

function SummaryBossAlter:lose(entrance)
    -- if s_CURRENT_USER.tutorialStep == s_tutorial_summary_boss then
    --     s_CURRENT_USER:setTutorialStep(s_tutorial_summary_boss + 1)
    --     s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_complete_timeout)
    -- end
    if s_CURRENT_USER.k12SmallStep < s_K12_summaryBossFailure then
        s_CURRENT_USER:setK12SmallStep(s_K12_summaryBossFailure)
    end
    -- 打点

    if s_CURRENT_USER.k12SmallStep < s_K12_end then
        s_CURRENT_USER:setK12SmallStep(s_K12_end)
    end
    --打点
    --add board
    self.loseBoard = cc.Sprite:create("image/summarybossscene/background_zjboss_tanchu.png")
    self.loseBoard:setPosition(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.3)
    self.loseBoard:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5))))
    self:addChild(self.loseBoard)

    local beans = cc.Sprite:create("image/chapter/chapter0/background_been_white.png")
    beans:setPosition(s_DESIGN_WIDTH-s_LEFT_X-100, s_DESIGN_HEIGHT-70)
    self:addChild(beans)

    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(beans:getContentSize().width * 0.65 , beans:getContentSize().height/2)
    beans:addChild(been_number)

    local boss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
    boss:setAnimation(0,'animation',false)
    boss:addAnimation(0,'jianxiao',true)
    boss:setPosition(self.loseBoard:getContentSize().width / 4,self.loseBoard:getContentSize().height / 3)
    self.loseBoard:addChild(boss)

    local label = cc.Label:createWithSystemFont("时间已经用完了！",'',40)
    label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label:setPosition(self.loseBoard:getContentSize().width / 2,self.loseBoard:getContentSize().height * 0.75)
    label:setColor(cc.c4b(52,177,241,255))
    self.loseBoard:addChild(label)

    local giveup = Button.create("giveup","blue","放弃挑战")
    giveup:setPosition(self.loseBoard:getContentSize().width / 2 + 10,self.loseBoard:getContentSize().height * 0.18 + 2)
    self.loseBoard:addChild(giveup)

    local function button_giveup_func()
        playSound(s_sound_buttonEffect)
        self:lose2(entrance)
    end

    giveup.func = function ()
        button_giveup_func()
    end

    boss:setPosition(self.loseBoard:getContentSize().width / 4,self.loseBoard:getContentSize().height * 0.4)
    local buyTimeBtn = Button.create("addtime","blue","立刻复活")
    buyTimeBtn:setPosition(self.loseBoard:getContentSize().width / 2,self.loseBoard:getContentSize().height * 0.3 + 15)
    self.loseBoard:addChild(buyTimeBtn)

    local been_button = cc.Sprite:create("image/shop/been.png")
    been_button:setScale(0.8)
    been_button:setPosition(buyTimeBtn.button_front:getContentSize().width * 0.8, buyTimeBtn.button_front:getContentSize().height/2)
    buyTimeBtn.button_front:addChild(been_button)

    local rewardNumber = cc.Label:createWithSystemFont(10,"",24)
    rewardNumber:enableOutline(cc.c4b(255,255,255,255),1)
    rewardNumber:setPosition(buyTimeBtn.button_front:getContentSize().width * 0.9,buyTimeBtn.button_front:getContentSize().height * 0.5)
    buyTimeBtn.button_front:addChild(rewardNumber)



    local function button_buyTime_func()
        playSound(s_sound_buttonEffect)
        if s_CURRENT_USER:getBeans() >= 10 then
            s_CURRENT_USER:addBeans(-10)
            saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
            local boss = self.bossLayer.boss
            local distance = s_DESIGN_WIDTH * 0.6
            self.loseBoard:runAction(cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5))))
            s_SCENE:callFuncWithDelay(0.3,function (  )
                -- body
                self:getChildByName('background'):runAction(cc.FadeOut:create(1.0))
                boss:runAction(cc.Sequence:create(cc.MoveTo:create(1.0,cc.p(distance , s_DESIGN_HEIGHT * 0.75 + 20)),cc.CallFunc:create(function (  )
                    -- body
                    self:removeChildByName('background')
                    self:addTime()
                end)))
            end)
        else
            local shopErrorAlter = require("view.shop.ShopErrorAlter").create()
            s_SCENE:popup(shopErrorAlter)
        end
    end

    buyTimeBtn.func = function ()
        button_buyTime_func()
    end

    onAndroidKeyPressed(self, function ()
        self:lose2(entrance)
    end, function ()

    end)


end

function SummaryBossAlter:addTime()

    AnalyticsSummaryBossAddTime()

    if s_SCENE.popupLayer~=nil then
        s_SCENE.popupLayer:setPauseBtnEnabled(true)
        s_SCENE.popupLayer.isOtherAlter = false
    end 

    local bossLayer = self.bossLayer

    bossLayer.useItem = true
    bossLayer.gameOver = false
    
    local boss = bossLayer.boss
    boss:goForward(bossLayer.totalTime)
    boss.bossBack()
    
    self:removeFromParent()
end

function SummaryBossAlter:lose2(entrance)
    if s_CURRENT_USER.tutorialStep == s_tutorial_summary_boss then
        s_CURRENT_USER:setTutorialStep(s_tutorial_summary_boss + 1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_complete_lose)
    end

    playMusic(s_sound_fail,true)

    self.loseBoard2 = cc.Sprite:create(string.format("image/summarybossscene/summaryboss_board_1.png"))
    self.loseBoard2:setPosition(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5)
    if self.loseBoard ~= nil then
        self.loseBoard:runAction(cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5))))
    end
    self.loseBoard2:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5)))))
    self:addChild(self.loseBoard2)

    local boss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
    boss:setAnimation(0,'animation',false)
    boss:addAnimation(0,'jianxiao',true)
    boss:setPosition(self.loseBoard2:getContentSize().width / 4,self.loseBoard2:getContentSize().height * 0.22)
    self.loseBoard2:addChild(boss)

    local label = cc.Label:createWithSystemFont("挑战失败！",'',40)
    label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label:setPosition(self.loseBoard2:getContentSize().width / 2,self.loseBoard2:getContentSize().height * 0.64)
    label:setColor(cc.c4b(251.0, 39.0, 10.0, 255))
    self.loseBoard2:addChild(label)

    local label1 = cc.Label:createWithSystemFont(string.format("还需要找出%d个单词！\n做好准备再来",#self.wordList),'',40)
    label1:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label1:setPosition(self.loseBoard2:getContentSize().width / 2,self.loseBoard2:getContentSize().height * 0.55)
    label1:setColor(cc.c4b(52,177,241,255))
    self.loseBoard2:addChild(label1)

    local head = cc.Sprite:create("image/summarybossscene/summaryboss_lose_head.png")
    head:setPosition(self.loseBoard2:getContentSize().width / 2,self.loseBoard2:getContentSize().height * 0.75)
    self.loseBoard2:addChild(head)

    local continue = Button.create("small","blue","返回学习")
    continue:setPosition(self.loseBoard2:getContentSize().width / 2 - 130,self.loseBoard2:getContentSize().height * 0.15)
    self.loseBoard2:addChild(continue)

    local function backToLevelScene()
        s_CorePlayManager.leaveSummaryModel(false)
        s_CorePlayManager.enterLevelLayer() 
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        playSound(s_sound_buttonEffect)
    end

    continue.func = function ()
        backToLevelScene()
    end

    local again = Button.create("small","blue","再来一次")
    again:setPosition(self.loseBoard2:getContentSize().width / 2 + 130,self.loseBoard2:getContentSize().height * 0.15)
    self.loseBoard2:addChild(again)

    local function challengeAgain()
        local SummaryBossLayer = require('view.summaryboss.NewSummaryBossLayer')
        local summaryBossLayer = SummaryBossLayer.create(self.bossLayer.oldUnit)
        s_SCENE:replaceGameLayer(summaryBossLayer) 

        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        playSound(s_sound_buttonEffect)
        AnalyticsSummaryBossResult('again')
    end

    again.func = function ()
        challengeAgain()
    end



    onAndroidKeyPressed(self, function ()
        s_CorePlayManager.leaveSummaryModel(false)
        s_CorePlayManager.enterLevelLayer() 
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
    end, function ()

    end)

end

function SummaryBossAlter:win1(entrance)
    --完成总结BOSS
    s_MissionManager:updateMission(MissionConfig.MISSION_ZJBOSS, 1, false)

    if s_CURRENT_USER.tutorialStep == s_tutorial_summary_boss then
        s_CURRENT_USER:setTutorialStep(s_tutorial_summary_boss + 1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_complete_win)
    end
    local hasCheckedIn = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey)
    if s_LocalDatabaseManager:getTodayRemainTaskNum() < 2 and not hasCheckedIn then
        checkInEverydayInfo()
        s_isCheckInAnimationDisplayed = false
    end

    -- if not hasCheckedIn and self.bossLayer.oldUnit == nil then
    --     local missionCompleteCircle = require('view.MissionCompleteCircle').create()
    --     s_HUD_LAYER:addChild(missionCompleteCircle,1000,'missionCompleteCircle')
    --     self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function ()
    --         self:win2(entrance,hasCheckedIn)
    --         if entrance == ENTRANCE_NORMAL and self.needToAddBean then
    --             s_CorePlayManager.leaveSummaryModel(true)
    --         end
    --     end,{})))
    -- else
    self:win2(entrance,hasCheckedIn)
    if entrance == ENTRANCE_NORMAL and self.needToAddBean then
        s_CorePlayManager.leaveSummaryModel(true)
    end
    -- end
end

function SummaryBossAlter:win2(entrance,hasCheckedIn)
    if s_CURRENT_USER.k12SmallStep < s_K12_summaryBossSuccess then
        s_CURRENT_USER:setK12SmallStep(s_K12_summaryBossSuccess)
    end
    -- 打点
    if s_CURRENT_USER.k12SmallStep < s_K12_end then
        s_CURRENT_USER:setK12SmallStep(s_K12_end)
    end
    -- 打点
    local backColor = cc.LayerColor:create(cc.c4b(180,241,254,255),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    self:addChild(backColor)

    local win_back = sp.SkeletonAnimation:create('spine/summaryboss/jieshao_6.json','spine/summaryboss/jieshao_6.atlas',1)
    --win_back:setAnchorPoint(0.5,0)
    win_back:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    win_back:setAnimation(0,'animation',false)
    self:addChild(win_back)
    if not self.entrance then
        win_back:setPosition(s_DESIGN_WIDTH / 2,0)
    end

    local function button_func()
        playSound(s_sound_buttonEffect)
        if not s_isCheckInAnimationDisplayed then
            if s_HUD_LAYER:getChildByName('missionCompleteCircle') ~= nil then
                s_HUD_LAYER:getChildByName('missionCompleteCircle'):setName('missionComplete')
            end
        end
        s_HUD_LAYER:removeChildByName('missionCompleteCircle')
        if entrance == ENTRANCE_WORD_LIBRARY then
            s_CorePlayManager.enterLevelLayer()
        else
            if s_HUD_LAYER:getChildByName('missionComplete') ~= nil then
                s_HUD_LAYER:getChildByName('missionComplete'):setVisible(false)
            end
            s_CorePlayManager.enterLevelLayer()
        end  
    end

    local button = Button.create("long","blue","完成")
    button:setPosition(s_DESIGN_WIDTH / 2 ,80)
    self:addChild(button)
    button.func = function ()
        button_func()
    end

    -- if self.entrance == ENTRANCE_NORMAL then

    --     local been_button = cc.Sprite:create("image/shop/been.png")
    --     been_button:setPosition(button:getContentSize().width * 0.75, button:getContentSize().height/2)
    --     button:addChild(been_button)

    --     local rewardNumber = cc.Label:createWithSystemFont("+"..3,"",36)
    --     rewardNumber:setPosition(button:getContentSize().width * 0.88,button:getContentSize().height * 0.5)
    --     button:addChild(rewardNumber)
    -- end
    if hasCheckedIn or self.bossLayer.oldUnit ~= nil then
        --print('self:addWinLabel(win_back)')
        self:addWinLabel(win_back)
    else
        s_SCENE:callFuncWithDelay(0,function (  )
            self:addWinLabel(win_back)
        end)
    end

    onAndroidKeyPressed(self, function ()
        s_HUD_LAYER:removeChildByName('missionCompleteCircle')
        if s_HUD_LAYER:getChildByName('missionComplete') ~= nil then
            s_HUD_LAYER:getChildByName('missionComplete'):setVisible(false)
        end
        s_CorePlayManager.enterLevelLayer()
    end, function ()

    end)


end

function SummaryBossAlter:addWinLabel(win_back)
    if self.bossLayer.useTime < 0 then
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    end

    -- local shareBtn = ccui.Button:create('image/share/share_click.png')
    -- shareBtn:setScale9Enabled(true)
    -- shareBtn:setPosition(s_DESIGN_WIDTH * 0.8,80)
    -- self:addChild(shareBtn)
    -- local function onShare(sender,eventType)
    --     if eventType == ccui.TouchEventType.ended then
    --         local wordList = self.bossLayer.unit.wrongWordList[1]
    --         for i = 2,#self.bossLayer.unit.wrongWordList do
    --             wordList = wordList..'|'..self.bossLayer.unit.wrongWordList[i]
    --         end
    --         cx.CXUtils:getInstance():shareURLToWeiXin('http://yisiyidian.com/doubi/html5/index.html?time='..self.bossLayer.totalTime..'&wordlist='..wordList, '', '贝贝单词－根本停不下来')
    --     end
    -- end
    -- shareBtn:addTouchEventListener(onShare)

    local beans = cc.Sprite:create("image/chapter/chapter0/background_been_white.png")
    beans:setPosition(s_RIGHT_X -100, s_DESIGN_HEIGHT-70)
    self:addChild(beans)

    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans()-3,'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(beans:getContentSize().width * 0.65 , beans:getContentSize().height/2)
    beans:addChild(been_number)
    been_number:setVisible(false)

    local title = cc.Sprite:create('image/summarybossscene/title_shengli_study.png')
    title:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.92)
    self:addChild(title)

    local right_label = cc.Label:createWithSystemFont('答对         单词','',32)
    right_label:setColor(cc.c3b(70,136,158))
    right_label:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.92 - 100)
    self:addChild(right_label)
    local word_count = 0
    local word_count_label = cc.Label:createWithSystemFont(string.format('%d',word_count),'',48)
    word_count_label:setPosition(right_label:getPositionX(),right_label:getPositionY() + 2)
    word_count_label:setColor(cc.c3b(251,227,65))
    word_count_label:enableOutline(cc.c4b(255,172,40,255),2)
    self:addChild(word_count_label)

    local time_label = cc.Label:createWithSystemFont('耗时       分钟         秒','',32)
    time_label:setColor(cc.c3b(70,136,158))
    time_label:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.92 - 170)
    self:addChild(time_label)   

    local min_count = 0
    local sec_count = 0
    local min_count_label = cc.Label:createWithSystemFont(string.format('%d',min_count),'',48)
    min_count_label:setPosition(time_label:getPositionX() - 52,time_label:getPositionY() + 2)
    min_count_label:setColor(cc.c3b(255,0,0))
    --min_count:enableOutline(cc.c4b(255,0,0,255),1)
    self:addChild(min_count_label)

    local sec_count_label = cc.Label:createWithSystemFont(string.format('%d',sec_count),'',48)
    sec_count_label:setPosition(time_label:getPositionX() + 72,time_label:getPositionY() + 2)
    sec_count_label:setColor(cc.c3b(255,0,0))
    --sec_count:enableOutline(cc.c4b(255,0,0,255),1)
    self:addChild(sec_count_label)
    local bean_back = {}
    for i = 1,3 do
        bean_back[i] = cc.Sprite:create('image/summarybossscene/been_background_complete_studys.png')
        self:addChild(bean_back[i],1)
        bean_back[i]:setVisible(false)
    end
    bean_back[1]:setPosition(s_DESIGN_WIDTH / 2 - 100,s_DESIGN_HEIGHT * 0.67)
    bean_back[2]:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.67 + 30)
    bean_back[3]:setPosition(s_DESIGN_WIDTH / 2 + 100,s_DESIGN_HEIGHT * 0.67)

    if self.needToAddBean then
        been_number:setVisible(true)
        for i = 1,3 do
            bean_back[i]:setVisible(true)
        end
    end
    local function update(delta)
        --print('delta='..delta)
        if word_count < self.bossLayer.maxCount then
            word_count = word_count + 1
            word_count_label:setString(string.format('%d',word_count))
        end
        if min_count < math.floor(self.bossLayer.useTime/60) then
            min_count = min_count + 1
            min_count_label:setString(string.format('%d',min_count))
        end
        if sec_count < math.floor(self.bossLayer.useTime%60) then
            -- if 60 - sec_count > 1 then
            --     sec_count = sec_count + 2
            -- else
            sec_count = sec_count + 1 
            -- end
            sec_count_label:setString(string.format('%d',sec_count))
        end
        if word_count == self.bossLayer.maxCount and min_count == math.floor(self.bossLayer.useTime/60) and sec_count >= math.floor(self.bossLayer.useTime%60) then
            if self.needToAddBean then
                for i = 1,3 do
                    local bean = cc.Sprite:create('image/summarybossscene/been_complete_studys.png')
                    bean:setPosition(bean_back[i]:getContentSize().width / 2,bean_back[i]:getContentSize().height / 2 + 10)
                    bean_back[i]:addChild(bean)
                    bean:setOpacity(0)
                    bean:setScale(3)
                    local action1 = cc.DelayTime:create(0.3 * i)
                    local action2 = cc.EaseSineIn:create(cc.ScaleTo:create(0.3,1))
                    local action3 = cc.FadeIn:create(0.3)
                    bean:runAction(cc.Sequence:create(action1,cc.Spawn:create(action2,action3)))
                end
                local shine = cc.Sprite:create('image/summarybossscene/shine_complete_studys.png')
                shine:setOpacity(0)
                shine:setPosition(bean_back[2]:getPositionX(),bean_back[2]:getPositionY())
                self:addChild(shine)
                local fadeInOut = cc.Sequence:create(cc.FadeTo:create(1,255 * 0.7),cc.FadeOut:create(1))
                shine:runAction(cc.Spawn:create(fadeInOut,cc.RotateBy:create(2,360)))
                for i = 1,3 do
                    local action1 = cc.DelayTime:create(2 + 0.3 * i)
                    local action2 = cc.EaseSineIn:create(cc.MoveTo:create(0.3,cc.p(beans:getPosition())))
                    local action3 = cc.ScaleTo:create(0.3,0)
                    local action4 = cc.CallFunc:create(function (  )
                        been_number:setString(s_CURRENT_USER:getBeans() - 3 + i)
                        if i == 3 then
                            if self.bossLayer.useTime < 0 then
                                local wordList = self.bossLayer.unit.wrongWordList[1]
                                 for i = 2,#self.bossLayer.unit.wrongWordList do
                                     wordList = wordList..'|'..self.bossLayer.unit.wrongWordList[i]
                                 end
                                local shareBoard = require('view.summaryboss.ShareBoard').create(self.bossLayer.useTime,wordList)
                                s_SCENE.popupLayer:addChild(shareBoard)
                            end
                        end
                    end,{})
                    local bean = cc.Sprite:create('image/summarybossscene/been_complete_studys.png')
                    bean:setPosition(bean_back[i]:getPositionX(),bean_back[i]:getPositionY() + 10)
                    self:addChild(bean,2)
                    bean:setVisible(false)
                    bean:runAction(cc.Sequence:create(cc.DelayTime:create(1.2),cc.Show:create()))
                    bean:runAction(cc.Sequence:create(action1,cc.Sequence:create(action2,action3),action4))
                    
                    
                end
            else
               if self.bossLayer.useTime < 0 then
                    local wordList = self.bossLayer.unit.wrongWordList[1]
                     for i = 2,#self.bossLayer.unit.wrongWordList do
                         wordList = wordList..'|'..self.bossLayer.unit.wrongWordList[i]
                     end
                    local shareBoard = require('view.summaryboss.ShareBoard').create(self.bossLayer.useTime,wordList)
                    s_SCENE.popupLayer:addChild(shareBoard)
                end 
            end
            
            self:unscheduleUpdate()

        end


    end
    self:scheduleUpdateWithPriorityLua(update, 0)


end

return SummaryBossAlter