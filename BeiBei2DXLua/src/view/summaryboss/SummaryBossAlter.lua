require("common.global")

local ENTRANCE_WORD_LIBRARY = false
local ENTRANCE_NORMAL = true

local SummaryBossAlter = class("SummaryBossAlter", function()
    return cc.Layer:create()
end)

function SummaryBossAlter.create(bossLayer,win,index,entrance)
    
    local layer = SummaryBossAlter.new()
    layer.wordCount = bossLayer.rightWord
    layer.win = win
    layer.index = index
    layer.levelIndex = levelIndex
    layer.wordList = bossLayer.wordList
    layer.bossLayer = bossLayer
    layer.entrance = entrance
    --disable pauseBtn
    if s_SCENE.popupLayer~=nil then
        s_SCENE.popupLayer:setPauseBtnEnabled(false)
        s_SCENE.popupLayer.isOtherAlter = true
    end    
    if layer.index > 3 then
        layer.index = 3
    end
    local back = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    back:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    layer:addChild(back)
    back:setName('background')
    if win then
        if entrance == ENTRANCE_NORMAL then
            s_CURRENT_USER:addBeans(3)
            saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
        end
        layer:win1(entrance)  
        cc.SimpleAudioEngine:getInstance():stopMusic()

        s_SCENE:callFuncWithDelay(0.3,function()
        -- win sound
            playMusic(s_sound_win,false)
        end)
    else    
        if not bossLayer.useItem and s_CURRENT_USER:getBeans() >= 10 then
        layer:lose(entrance)
        else
            layer:lose2(entrance)
        end
        
        cc.SimpleAudioEngine:getInstance():stopMusic()

        s_SCENE:callFuncWithDelay(0.3,function()
            -- win sound
            playSound(s_sound_fail)
        end)
    end
    
    return layer
end

function SummaryBossAlter:lose(entrance)
    if s_CURRENT_USER.tutorialStep == s_tutorial_complete then
        s_CURRENT_USER:setTutorialStep(s_tutorial_complete + 1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_complete_timeout)
    end

    --add board
    self.loseBoard = cc.Sprite:create("image/summarybossscene/background_zjboss_tanchu.png")
    self.loseBoard:setPosition(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.3)
    self.loseBoard:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5))))
    self:addChild(self.loseBoard)

    local been_number_back = cc.Sprite:create("image/shop/been_number_back.png")
    been_number_back:setPosition(self.loseBoard:getContentSize().width -100, self.loseBoard:getContentSize().height * 0.75 + 50)
    self.loseBoard:addChild(been_number_back)

    local been = cc.Sprite:create("image/shop/been.png")
    been:setPosition(0, been_number_back:getContentSize().height/2)
    been_number_back:addChild(been)

    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(been_number_back:getContentSize().width/2 , been_number_back:getContentSize().height/2)
    been_number_back:addChild(been_number)
    
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

    local continue = ccui.Button:create("image/summarybossscene/button_loose_zjboss.png","image/summarybossscene/button_loose_zjboss_pressed.png","")
    continue:setPosition(self.loseBoard:getContentSize().width / 2 + 10,self.loseBoard:getContentSize().height * 0.18 + 2)
    self.loseBoard:addChild(continue)

    local btn_title = cc.Label:createWithSystemFont("放弃挑战",'',36)
    btn_title:enableOutline(cc.c4b(255,255,255,255),1)
    btn_title:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    btn_title:setPosition(continue:getContentSize().width * 0.5,continue:getContentSize().height / 2)
    continue:addChild(btn_title)
 --   if not self.bossLayer.useItem then
        boss:setPosition(self.loseBoard:getContentSize().width / 4,self.loseBoard:getContentSize().height * 0.4)
        local buyTimeBtn = ccui.Button:create('image/summarybossscene/button_time_zjboss.png','image/summarybossscene/button_time_zjboss_pressed.png','')
        buyTimeBtn:setPosition(self.loseBoard:getContentSize().width / 2,self.loseBoard:getContentSize().height * 0.3 + 15)
        self.loseBoard:addChild(buyTimeBtn)

        local been_button = cc.Sprite:create("image/shop/been.png")
        been_button:setScale(0.8)
        been_button:setPosition(buyTimeBtn:getContentSize().width * 0.8, buyTimeBtn:getContentSize().height/2)
        buyTimeBtn:addChild(been_button)
    
        local rewardNumber = cc.Label:createWithSystemFont(10,"",24)
        rewardNumber:enableOutline(cc.c4b(255,255,255,255),1)
        rewardNumber:setPosition(buyTimeBtn:getContentSize().width * 0.9,buyTimeBtn:getContentSize().height * 0.5)
        buyTimeBtn:addChild(rewardNumber)

        local btn_title2 = cc.Label:createWithSystemFont("再来30秒",'',36)
        btn_title2:enableOutline(cc.c4b(255,255,255,255),1)
        btn_title2:setPosition(buyTimeBtn:getContentSize().width * 0.5 + 10,buyTimeBtn:getContentSize().height / 2 + 2)
        buyTimeBtn:addChild(btn_title2)



        local function buyTime(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                s_CURRENT_USER:addBeans(-10)
                saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
                local boss = self.bossLayer.bossNode
                local distance = s_DESIGN_WIDTH * 0.45 * 30 / self.bossLayer.totalTime
                self.loseBoard:runAction(cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5))))
                s_SCENE:callFuncWithDelay(0.3,function (  )
                    -- body
                    self:getChildByName('background'):runAction(cc.FadeOut:create(1.0))
                    boss:runAction(cc.Sequence:create(cc.MoveTo:create(1.0,cc.p(s_DESIGN_WIDTH * 0.15 + distance , s_DESIGN_HEIGHT * 0.75 + 20)),cc.CallFunc:create(function (  )
                        -- body
                        self:removeChildByName('background')
                        self:addTime()
                    end)))
                end)
                
                
            end
        end
        buyTimeBtn:addTouchEventListener(buyTime)
 --   end

    local function nextBoard(sender,eventType)
        if eventType == ccui.TouchEventType.ended then 
            self:lose2(entrance)
        end
    end
    continue:addTouchEventListener(nextBoard)
    
    
end

function SummaryBossAlter:addTime()

    if s_SCENE.popupLayer~=nil then
        s_SCENE.popupLayer:setPauseBtnEnabled(true)
        s_SCENE.popupLayer.isOtherAlter = false
    end 

    local bossLayer = self.bossLayer
    local boss = bossLayer.bossNode
    local distance = s_DESIGN_WIDTH * 0.45 * 30 / bossLayer.totalTime
    local index = self.index
    local entrance = self.entrance
    local wordList = self.wordList
    bossLayer.useItem = true

    --boss:setPosition(s_DESIGN_WIDTH * 0.15 + distance , s_DESIGN_HEIGHT * 0.75)
    bossLayer.globalLock = false
    bossLayer.girlAfraid = false
    bossLayer.girl:setAnimation(0,'girl-stand',true)
    bossLayer.isLose = false
    bossLayer.leftTime = 30
    bossLayer.totalTime = 30
    local wait = cc.DelayTime:create(30.0 - bossLayer.totalTime * 0.2)
    local afraid = cc.CallFunc:create(function() 
        if bossLayer.currentBlood > 0 then
            bossLayer.girlAfraid = true
            HINT_TIME = 4
            bossLayer.girl:setAnimation(0,'girl-afraid',true)
            -- deadline "Mechanical Clock Ring "
            playSound(s_sound_Mechanical_Clock_Ring)
        end
    end,{})
    local blinkIn = cc.FadeTo:create(0.5,50)
    local blinkOut = cc.FadeTo:create(0.5,0.0)
    local blink = cc.Sequence:create(blinkIn,blinkOut)
    local repeatBlink = cc.Repeat:create(blink,math.ceil(bossLayer.totalTime * 0.2))
    bossLayer.blink:runAction(cc.Sequence:create(wait,afraid,repeatBlink))
    local bossAction = {}
    for i = 1, 6 do
        local stop = cc.DelayTime:create(bossLayer.totalTime / 6 * 0.8)
        local stopAnimation = cc.CallFunc:create(function() 
            bossLayer.boss:setAnimation(0,'a2',true)
        end,{})
        local move = cc.MoveBy:create(bossLayer.totalTime / 6 * 0.2,cc.p(- distance / 6, 0))
        local moveAnimation = cc.CallFunc:create(function() 
            bossLayer.boss:setAnimation(0,'animation',false)
        end,{})
        bossAction[#bossAction + 1] = cc.Spawn:create(stop,stopAnimation)
        bossAction[#bossAction + 1] = cc.Spawn:create(move,moveAnimation)
    end
    bossAction[#bossAction + 1] = cc.CallFunc:create(function() 

        if bossLayer.currentBlood > 0 then
            bossLayer.isLose = true
            --print('chapter index'..self.index)
            bossLayer:lose(index,entrance,wordList)    
        end
    end,{})
    boss:runAction(cc.Sequence:create(bossAction))
    self:removeFromParent()
    --bossLayer.girl:
end

function SummaryBossAlter:lose2(entrance)
    if s_CURRENT_USER.tutorialStep == s_tutorial_complete then
        s_CURRENT_USER:setTutorialStep(s_tutorial_complete + 1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_complete_lose)
    end

    self.loseBoard2 = cc.Sprite:create(string.format("image/summarybossscene/summaryboss_board_%d.png",self.index))
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

    local label1 = cc.Label:createWithSystemFont(string.format("还需要找出%d个单词！\n做好准备再来",#self.wordList - self.wordCount),'',40)
    label1:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label1:setPosition(self.loseBoard2:getContentSize().width / 2,self.loseBoard2:getContentSize().height * 0.55)
    label1:setColor(cc.c4b(52,177,241,255))
    self.loseBoard2:addChild(label1)

    local head = cc.Sprite:create("image/summarybossscene/summaryboss_lose_head.png")
    head:setPosition(self.loseBoard2:getContentSize().width / 2,self.loseBoard2:getContentSize().height * 0.75)
    self.loseBoard2:addChild(head)

    local menu = cc.Menu:create()
    menu:setPosition(self.loseBoard2:getContentSize().width / 2,self.loseBoard2:getContentSize().height * 0.15)
    self.loseBoard2:addChild(menu)
    
    local continue = cc.MenuItemImage:create("image/summarybossscene/summaryboss_blue_button.png","")
    continue:setPosition(-130,0)
    menu:addChild(continue)

    local btn_title = cc.Label:createWithSystemFont("返回学习",'',40)
    btn_title:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    btn_title:setPosition(continue:getContentSize().width / 2,continue:getContentSize().height / 2)
    continue:addChild(btn_title)
    local again = cc.MenuItemImage:create("image/summarybossscene/summaryboss_blue_button.png","")
    again:setPosition(130,0)
    menu:addChild(again)

    local again_title = cc.Label:createWithSystemFont("再来一次",'',40)
    again_title:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    again_title:setPosition(again:getContentSize().width / 2,again:getContentSize().height / 2)
    again:addChild(again_title)
    
    local function backToLevelScene(sender)
        s_CorePlayManager.leaveSummaryModel(false)
        s_CorePlayManager.enterLevelLayer() 
        
        -- stop effect
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        -- button sound
        playSound(s_sound_buttonEffect)
    end
    continue:registerScriptTapHandler(backToLevelScene)
    
    local function challengeAgain(sender)
        
        --local summaryboss = require('view.summaryboss.SummaryBossLayer')
        if entrance == ENTRANCE_NORMAL then
            s_CorePlayManager.initSummaryModel()
        else
            local SummaryBossLayer = require('view.summaryboss.SummaryBossLayer')
            local summaryBossLayer = SummaryBossLayer.create(self.wordList,1,false)
            s_SCENE:replaceGameLayer(summaryBossLayer) 
        end
        
        -- stop effect
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        -- button sound
        playSound(s_sound_buttonEffect)

        AnalyticsSummaryBossResult('again')
    end
    again:registerScriptTapHandler(challengeAgain)
    
end

function SummaryBossAlter:win1(entrance)
    
    if s_CURRENT_USER.tutorialStep == s_tutorial_complete then
        s_CURRENT_USER:setTutorialStep(s_tutorial_complete + 1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_complete_win)
    end
    local hasCheckedIn = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey)
    if s_LocalDatabaseManager:getTodayRemainTaskNum() < 2 and not hasCheckedIn then
        checkInEverydayInfo()
        s_isCheckInAnimationDisplayed = false
    end
    
    if not hasCheckedIn and entrance == ENTRANCE_NORMAL then
        local missionCompleteCircle = require('view.MissionCompleteCircle').create()
        s_HUD_LAYER:addChild(missionCompleteCircle,1000,'missionCompleteCircle')
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function ()
            self:win2(entrance,hasCheckedIn)
            if entrance == ENTRANCE_NORMAL then
                s_CorePlayManager.leaveSummaryModel(true)
            end
        end,{})))
    else
        if entrance == ENTRANCE_NORMAL then
            s_CorePlayManager.leaveSummaryModel(true)
        end
        self:win2(entrance,hasCheckedIn)
    end
    
    
end

function SummaryBossAlter:win2(entrance,hasCheckedIn)
    local backColor = cc.LayerColor:create(cc.c4b(180,241,254,255),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    self:addChild(backColor)

    -- local been_number_back = cc.Sprite:create("image/shop/been_number_back.png")
    -- been_number_back:setPosition(s_RIGHT_X - s_LEFT_X -100, s_DESIGN_HEIGHT-50)
    -- backColor:addChild(been_number_back)

    -- local been = cc.Sprite:create("image/shop/been.png")
    -- been:setPosition(0, been_number_back:getContentSize().height/2)
    -- been_number_back:addChild(been)

    -- local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    -- been_number:setColor(cc.c4b(0,0,0,255))
    -- been_number:setPosition(been_number_back:getContentSize().width/2 , been_number_back:getContentSize().height/2)
    -- been_number_back:addChild(been_number)

    local win_back = cc.Sprite:create('image/summarybossscene/win_back.png')
    win_back:setAnchorPoint(0.5,0)
    win_back:setPosition(s_DESIGN_WIDTH / 2,-140)
    self:addChild(win_back)
    if not self.entrance then
        win_back:setPosition(s_DESIGN_WIDTH / 2,0)
    end

    local function onButton(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            
            if entrance == ENTRANCE_WORD_LIBRARY then
                s_CorePlayManager.enterLevelLayer()
            else
                --s_CorePlayManager.leaveSummaryModel(true)
                -- if s_LocalDatabaseManager:getTodayRemainTaskNum() < 2 and not hasCheckedIn then
                --     s_SCENE:checkInAnimation()
                -- else
                    s_HUD_LAYER:removeChildByName('missionCompleteCircle')
                    s_CorePlayManager.enterLevelLayer()
                -- end
            end
        end
    end

    local button = ccui.Button:create("image/shop/long_button.png","image/shop/long_button_clicked.png","")
    button:setPosition(s_DESIGN_WIDTH/2,150)
    button:addTouchEventListener(onButton)
    self:addChild(button)

    local item_name = cc.Label:createWithSystemFont('完成','',30)
    item_name:enableOutline(cc.c4b(255,255,255,255),1)
    item_name:setPosition(button:getContentSize().width/2, button:getContentSize().height/2)
    button:addChild(item_name)

    -- if self.entrance == ENTRANCE_NORMAL then
        
    --     local been_button = cc.Sprite:create("image/shop/been.png")
    --     been_button:setPosition(button:getContentSize().width * 0.75, button:getContentSize().height/2)
    --     button:addChild(been_button)
    
    --     local rewardNumber = cc.Label:createWithSystemFont("+"..3,"",36)
    --     rewardNumber:setPosition(button:getContentSize().width * 0.88,button:getContentSize().height * 0.5)
    --     button:addChild(rewardNumber)
    -- end
    if s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey) or not self.entrance then
        --print('self:addWinLabel(win_back)')
        self:addWinLabel(win_back)
    else
        s_SCENE:callFuncWithDelay(2,function (  )
            self:addWinLabel(win_back)
        end)
    end


end

function SummaryBossAlter:addWinLabel(win_back)

    local been_number_back = cc.Sprite:create("image/shop/been_number_back.png")
    been_number_back:setPosition(s_RIGHT_X -100, s_DESIGN_HEIGHT-50)
    self:addChild(been_number_back)

    local been = cc.Sprite:create("image/shop/been.png")
    been:setPosition(0, been_number_back:getContentSize().height/2)
    been_number_back:addChild(been)

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

    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans() - 3,'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(been_number_back:getContentSize().width/2 + 20, been_number_back:getContentSize().height/2 )
    been_number_back:addChild(been_number)
    been_number:setVisible(false)

    if self.entrance then
        been_number:setVisible(true)
        for i = 1,3 do
            bean_back[i]:setVisible(true)
        end
    end

    local function update(delta)
        if word_count < self.bossLayer.maxCount then
            word_count = word_count + 1
            word_count_label:setString(string.format('%d',word_count))
        end
        if min_count < math.floor(self.bossLayer.useTime/60) then
            min_count = min_count + 1
            min_count_label:setString(string.format('%d',min_count))
        end
        if sec_count < math.floor(self.bossLayer.useTime%60) then
            sec_count = sec_count + 1
            sec_count_label:setString(string.format('%d',sec_count))
        end
        if word_count == self.bossLayer.maxCount and min_count == math.floor(self.bossLayer.useTime/60) and sec_count == math.floor(self.bossLayer.useTime%60) then
            if self.entrance then
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
                    local action2 = cc.EaseSineIn:create(cc.MoveTo:create(0.3,cc.p(been_number_back:getPosition())))
                    local action3 = cc.ScaleTo:create(0.3,0)
                    local action4 = cc.CallFunc:create(function (  )
                        been_number:setString(s_CURRENT_USER:getBeans() - 3 + i)
                    end,{})
                    bean_back[i]:runAction(cc.Sequence:create(action1,cc.Sequence:create(action2,action3),action4))
                end
            end
            self:unscheduleUpdate()

        end

    end
    self:scheduleUpdateWithPriorityLua(update, 0)

    local boss = sp.SkeletonAnimation:create("spine/summaryboss/beidadekls2.json","spine/summaryboss/beidadekls2.atlas",1)
    boss:setAnimation(0,'animation',false)
    boss:setPosition(0.5 * s_DESIGN_WIDTH- 200,230)
    self:addChild(boss)


end

return SummaryBossAlter