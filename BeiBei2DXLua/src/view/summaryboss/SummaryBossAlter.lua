
local MissionConfig  = require("model.mission.MissionConfig")
local SharePopupController = require("view.sharePopup.SharePopupController")
local Button                = require("view.button.longButtonInStudy")


local ENTRANCE_WORD_LIBRARY = false
local ENTRANCE_NORMAL = true

local SummaryBossAlter = class("SummaryBossAlter", function()
    return cc.Layer:create()
end)

function SummaryBossAlter.create(bossLayer,win,entrance)
    s_SCENE:removeAllPopups()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    local layer = SummaryBossAlter.new()
    layer.wordCount = bossLayer.maxCount
    layer.win = win
    -- 这个名字起的真好，我竟无言以对
    -- 这个wordlist是关卡结束时的最后一个词！！！！！
    layer.wordList = bossLayer.wordList
    -- 这个名字起的真好，我竟无言以对
    layer.bossLayer = bossLayer
    layer.islandIndex = bossLayer.unit.unitID - 1
    layer.constWord = bossLayer.constWord
    layer.stardandTime = 0

    for i=1,#layer.constWord do
        if layer.constWord[i][1] ~= nil then
            layer.stardandTime = layer.stardandTime + #layer.constWord[i][1] * 1.3
        end
    end

    layer.entrance = entrance
    layer.needToAddBean = win
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
        layer:lose(entrance,layer.islandIndex)
        -- boss失败的后的标志，非凡用
        s_game_fail_state = 1
        cc.SimpleAudioEngine:getInstance():stopMusic()
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

function SummaryBossAlter:lose(entrance,islandIndex)
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
    self.loseBoard = cc.Sprite:create("image/summarybossscene/lose/green_background_xuanxiaoguantqanchu.png")
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

    local boss = sp.SkeletonAnimation:create("spine/summaryboss/lose/failed_boss_doubiban.json","spine/summaryboss/lose/failed_boss_doubiban.atlas",1)
    boss:setAnimation(0,'animation',true)
    boss:setPosition(self.loseBoard:getContentSize().width / 2,self.loseBoard:getContentSize().height / 2 - 30)
    self.loseBoard:addChild(boss)

    local label = cc.Label:createWithSystemFont("失败！",'',40)
    label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label:setPosition(self.loseBoard:getContentSize().width / 2 + 15,self.loseBoard:getContentSize().height * 0.95)
    -- label:setColor(cc.c4b(52,177,241,255))
    self.loseBoard:addChild(label)

    local word = cc.Label:createWithSystemFont(self.bossLayer.wordList[1][4],'',40)
    word:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    word:setPosition(self.loseBoard:getContentSize().width / 2,self.loseBoard:getContentSize().height * 0.85 + 10)
    -- label:setColor(cc.c4b(52,177,241,255))
    self.loseBoard:addChild(word)

    local meaning = cc.Label:createWithSystemFont(s_LocalDatabaseManager.getWordInfoFromWordName(self.bossLayer.wordList[1][4]).wordMeaningSmall,'',40)
    meaning:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    meaning:setPosition(self.loseBoard:getContentSize().width / 2,self.loseBoard:getContentSize().height * 0.8 - 10)
    -- label:setColor(cc.c4b(52,177,241,255))
    self.loseBoard:addChild(meaning)

    local buyTimeBtn = Button.create("addTime","blue","10     立刻复活!")
    buyTimeBtn:setPosition(self.loseBoard:getContentSize().width / 2,self.loseBoard:getContentSize().height * 0.12)
    self.loseBoard:addChild(buyTimeBtn)

    local been_button = cc.Sprite:create("image/shop/been.png")
    been_button:setScale(0.8)
    been_button:setPosition(buyTimeBtn.button_front:getContentSize().width * 0.24, buyTimeBtn.button_front:getContentSize().height/2)
    buyTimeBtn.button_front:addChild(been_button)

    -- local rewardNumber = cc.Label:createWithSystemFont(10,"",24)
    -- rewardNumber:enableOutline(cc.c4b(255,255,255,255),1)
    -- rewardNumber:setPosition(buyTimeBtn.button_front:getContentSize().width * 0.2,buyTimeBtn.button_front:getContentSize().height * 0.5)
    -- buyTimeBtn.button_front:addChild(rewardNumber)


    local buytime = false
    local function button_buyTime_func()
        if not buytime then
            buytime = true
            playSound(s_sound_buttonEffect)
            if s_CURRENT_USER:getBeans() >= 10 then
                s_CURRENT_USER:addBeans(-10)
                saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
                local boss = self.bossLayer.boss
                local distance = s_DESIGN_WIDTH * 0.6
                self.loseBoard:runAction(cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5))))
                s_SCENE:callFuncWithDelay(0.3,function (  )
                    -- body
                    if self and not tolua.isnull(self) then
                        local bg = self:getChildByName('background')
                        if bg then
                           bg:runAction(cc.FadeOut:create(1.0)) 
                        end
                    end
                    -- self:getChildByName('background'):runAction(cc.FadeOut:create(1.0))
                    if boss and not tolua.isnull(boss) then
                        boss:runAction(cc.Sequence:create(cc.MoveTo:create(1.0,cc.p(distance , s_DESIGN_HEIGHT * 0.75 + 20)),cc.CallFunc:create(function (  )
                            -- body
                            self:removeChildByName('background')
                            self:addTime()
                        end)))
                    end
                end)
            else
                local shopErrorAlter = require("view.shop.ShopErrorAlter").create()
                s_SCENE:popup(shopErrorAlter)
            end
        end
    end

    buyTimeBtn.func = function ()
        button_buyTime_func()
    end

    onAndroidKeyPressed(self, function ()
        s_CorePlayManager.leaveSummaryModel(false)
        s_CorePlayManager.enterLevelLayer() 
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
    end, function ()

    end)

    local continue = Button.create("giveup","blue","返回学习")
    continue:setPosition(self.loseBoard:getContentSize().width / 2 - 130,self.loseBoard:getContentSize().height * 0.25)
    self.loseBoard:addChild(continue)

    continue.func = function ()
        s_CorePlayManager.leaveSummaryModel(false)
        s_CorePlayManager.enterLevelLayer() 
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        playSound(s_sound_buttonEffect)

        local WordCardView = require("view.wordcard.WordCardView")
        local wordCardView = WordCardView.create(islandIndex)
        s_SCENE:popup(wordCardView)
    end

    local again = Button.create("again","blue","再来一次")
    again:setPosition(self.loseBoard:getContentSize().width / 2 + 130,self.loseBoard:getContentSize().height * 0.25)
    self.loseBoard:addChild(again)

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

function SummaryBossAlter:win1(entrance)

    local table = {}
    table.unitID = self.bossLayer.unit.unitID
    table.wordList = self.bossLayer.unit.wrongWordList
    table.time = self.bossLayer.useTime
    table.loginData = s_CURRENT_USER.logInDatas
    SharePopupController:ctor(table)

    print("书籍",s_CURRENT_USER.bookKey)
    print("单元",self.bossLayer.unit.unitID)

    local missiondata = {}
    missiondata[1] = s_CURRENT_USER.bookKey       --书籍
    missiondata[2] = self.bossLayer.unit.unitID   --单元
    missiondata[3] = self.bossLayer.useTime       --用时

    --完成总结BOSS
    --打完总结boss

    if not self.bossLayer.newguid then
        --判断是否达到任务所要求时间
        if self.bossLayer.useTime <= self.bossLayer.totalBlood/2*2 then
            s_MissionManager:updateMission(MissionConfig.MISSION_TIME, missiondata, 1, false)
            print(self.bossLayer.useTime,"用时")
        end
        --判断是否使用了提示按钮
        if self.bossLayer.ishited == nil then
            s_MissionManager:updateMission(MissionConfig.MISSION_TIMES, missiondata, 1, false)
        end

        --直接触发通关当前关卡任务
        s_MissionManager:updateMission(MissionConfig.MISSION_NOTHING, missiondata, 1, false)
        print("触发当前关卡任务")
    end

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

    self:addWinLabel(win_back)

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
    title:setPosition(s_DESIGN_WIDTH / 2,1068)
    self:addChild(title)

    local right_label = cc.Label:createWithSystemFont('答对         单词','',32)
    right_label:setColor(cc.c3b(70,136,158))
    right_label:setPosition(s_DESIGN_WIDTH / 2,870)
    self:addChild(right_label)
    local word_count = 0
    local word_count_label = cc.Label:createWithSystemFont(string.format('%d',word_count),'',48)
    word_count_label:setPosition(right_label:getPositionX(),right_label:getPositionY() + 2)
    word_count_label:setColor(cc.c3b(251,227,65))
    word_count_label:enableOutline(cc.c4b(255,172,40,255),2)
    self:addChild(word_count_label)

    local time_label = cc.Label:createWithSystemFont('耗时       分钟         秒','',32)
    time_label:setColor(cc.c3b(70,136,158))
    time_label:setPosition(s_DESIGN_WIDTH / 2,804)
    self:addChild(time_label)   

    local defeat_label = cc.Label:createWithSystemFont('超过了              的用户','',32)
    defeat_label:setColor(cc.c3b(70,136,158))
    defeat_label:setPosition(s_DESIGN_WIDTH / 2,735)
    self:addChild(defeat_label)  

    local defeat_count = 0
    local defeat_count_label = cc.Label:createWithSystemFont(string.format('%d',defeat_count),'',48)
    defeat_count_label:setPosition(defeat_label:getPositionX(),defeat_label:getPositionY() + 2)
    defeat_count_label:setColor(cc.c3b(82,190,17))
    self:addChild(defeat_count_label)

    local time_count = 0
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
    bean_back[1]:setPosition(s_DESIGN_WIDTH / 2 - 100,s_DESIGN_HEIGHT * 0.83)
    bean_back[2]:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT * 0.83 + 30)
    bean_back[3]:setPosition(s_DESIGN_WIDTH / 2 + 100,s_DESIGN_HEIGHT * 0.83)

    if self.needToAddBean then
        been_number:setVisible(true)
        for i = 1,3 do
            bean_back[i]:setVisible(true)
        end
    end

    local showTime = self:getRatio(self.bossLayer.useTime,self.stardandTime)
    print("alter "..showTime)
    local time = 0
    local function update(delta)
        time = time + delta
        --print('delta='..delta)
        if word_count < self.bossLayer.maxCount then
            word_count = math.floor(self.bossLayer.maxCount * time /2)
            if word_count >= self.bossLayer.maxCount then
                word_count = self.bossLayer.maxCount
            end
            word_count_label:setString(string.format('%d',word_count))
        end

        if defeat_count < showTime then
            defeat_count = math.floor(showTime * time /2)
            if defeat_count >= showTime then
                defeat_count = showTime
            end
            defeat_count_label:setString(string.format('%d',defeat_count).."%")
        end

        if time_count < self.bossLayer.useTime then
            time_count = self.bossLayer.useTime / 2 * time
            if time_count >= self.bossLayer.useTime then
                time_count = self.bossLayer.useTime
            end
            min_count = math.floor(time_count / 60)
            sec_count = math.floor(time_count % 60)
            min_count_label:setString(string.format('%d',min_count))
            sec_count_label:setString(string.format('%d',sec_count))
        end

        if word_count == self.bossLayer.maxCount and defeat_count_label == showTime and min_count == math.floor(self.bossLayer.useTime/60) and sec_count >= math.floor(self.bossLayer.useTime%60) then
            if not self.needToAddBean then
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
end

function SummaryBossAlter:getRatio(userTime,goalTime)
    print (userTime)
    print (goalTime)
    if userTime < goalTime then
        return 100
    else
        return math.ceil(100 * math.exp(-1 * 0.01 * (userTime - goalTime)))
    end
end

return SummaryBossAlter