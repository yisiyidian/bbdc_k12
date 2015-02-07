require("common.global")

local SummaryBossAlter = class("SummaryBossAlter", function()
    return cc.Layer:create()
end)

function SummaryBossAlter.create(win,wordCount,blood,index,entrance,wordList)
    
    local layer = SummaryBossAlter.new()
    layer.wordCount = wordCount
    layer.blood = blood
    layer.win = win
    layer.index = index
    layer.levelIndex = levelIndex
    layer.wordList = wordList
    if layer.win then
        s_CURRENT_USER:addBeans(3)
        -- s_CURRENT_USER:removeSummaryBoss(levelIndex)
        -- s_CURRENT_USER:updateDataToServer()
        saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
    end
    
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
    if win then
        layer:win1(entrance)  
        cc.SimpleAudioEngine:getInstance():pauseMusic()

        s_SCENE:callFuncWithDelay(0.3,function()
        -- win sound
        playSound(s_sound_win)
        end)
    else
        layer:lose()
        
        cc.SimpleAudioEngine:getInstance():pauseMusic()

        s_SCENE:callFuncWithDelay(0.3,function()
            -- win sound
            playSound(s_sound_fail)
        end)
    end
    
    return layer
end

function SummaryBossAlter:lose()
    if s_CURRENT_USER.tutorialStep == s_tutorial_complete then
        s_CURRENT_USER:setTutorialStep(s_tutorial_complete + 1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_complete_timeout)
    end

    --add board
    self.loseBoard = cc.Sprite:create(string.format("image/summarybossscene/summaryboss_board_%d.png",self.index))
    self.loseBoard:setPosition(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.3)
    self.loseBoard:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5))))
    self:addChild(self.loseBoard)
    
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

    local menu = cc.Menu:create()
    self.loseBoard:addChild(menu)
    local continue = cc.MenuItemImage:create("image/summarybossscene/wsy_giveUpSummaryBoss.png","")
    menu:setPosition(self.loseBoard:getContentSize().width / 2,self.loseBoard:getContentSize().height * 0.22)
    menu:addChild(continue)

    local btn_title = cc.Label:createWithSystemFont("放弃挑战",'',40)
    btn_title:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    btn_title:setPosition(continue:getContentSize().width * 0.6,continue:getContentSize().height / 2)
    continue:addChild(btn_title)

    local function nextBoard(sender)
        
        self:lose2()

    end
    continue:registerScriptTapHandler(nextBoard)
    
    
end

function SummaryBossAlter:lose2()
    if s_CURRENT_USER.tutorialStep == s_tutorial_complete then
        s_CURRENT_USER:setTutorialStep(s_tutorial_complete + 1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_complete_lose)
    end

    self.loseBoard2 = cc.Sprite:create(string.format("image/summarybossscene/summaryboss_board_%d.png",self.index))
    self.loseBoard2:setPosition(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5)
    self.loseBoard:runAction(cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5))))
    self.loseBoard2:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5)))))
    self:addChild(self.loseBoard2)
    
    local boss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
    boss:setAnimation(0,'animation',false)
    boss:addAnimation(0,'jianxiao',true)
    boss:setPosition(self.loseBoard:getContentSize().width / 4,self.loseBoard:getContentSize().height * 0.22)
    self.loseBoard2:addChild(boss)
    
    local label = cc.Label:createWithSystemFont("挑战失败！",'',40)
    label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label:setPosition(self.loseBoard2:getContentSize().width / 2,self.loseBoard2:getContentSize().height * 0.64)
    label:setColor(cc.c4b(251.0, 39.0, 10.0, 255))
    self.loseBoard2:addChild(label)

    local label1 = cc.Label:createWithSystemFont(string.format("还需要找出%d个单词！\n做好准备再来",9 - self.wordCount),'',40)
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
        if entrance then
            s_CorePlayManager.initSummaryModel()
        else
            local SummaryBossLayer = require('view.summaryboss.SummaryBossLayer')
            local summaryBossLayer = SummaryBossLayer.create(self.wordlist,1,false)
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

    local hasCheckedIn = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(selectDate,s_CURRENT_USER.bookKey)
    if not hasCheckedIn then
        checkInEverydayInfo()
    end
    if not hasCheckedIn then
    local missionCompleteCircle = require('view.MissionCompleteCircle').create()
        s_HUD_LAYER:addChild(missionCompleteCircle,1000,'missionCompleteCircle')
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function ()
            self:win2(entrance,hasCheckedIn)
        end,{})))
    else
        self:win2(entrance,hasCheckedIn)
    end
    
    
end

function SummaryBossAlter:win2(entrance,hasCheckedIn)
    local backColor = cc.LayerColor:create(cc.c4b(127,239,255,255),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)
    self:addChild(backColor)

    local been_number_back = cc.Sprite:create("image/shop/been_number_back.png")
    been_number_back:setPosition(s_RIGHT_X - s_LEFT_X -100, s_DESIGN_HEIGHT-50)
    backColor:addChild(been_number_back)

    local been = cc.Sprite:create("image/shop/been.png")
    been:setPosition(0, been_number_back:getContentSize().height/2)
    been_number_back:addChild(been)

    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(been_number_back:getContentSize().width/2 , been_number_back:getContentSize().height/2)
    been_number_back:addChild(been_number)

    local win_back = cc.Sprite:create('image/summarybossscene/win_back.png')
    win_back:setAnchorPoint(0.5,0)
    win_back:setPosition(s_DESIGN_WIDTH / 2,0)
    self:addChild(win_back)

    local function onButton(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local ENTRANCE_WORD_LIBRARY = false
            local ENTRANCE_NORMAL = true
            if entrance == ENTRANCE_WORD_LIBRARY then
                s_CorePlayManager.enterLevelLayer()
            else
                s_CorePlayManager.leaveSummaryModel(true)
                if not hasCheckedIn then
                    s_SCENE:checkInAnimation()
                else
                    s_CorePlayManager.enterLevelLayer()
                end
            end
        end
    end

    local button = ccui.Button:create("image/shop/long_button.png","image/shop/long_button_clicked.png","")
    button:setPosition(win_back:getContentSize().width/2,150)
    button:addTouchEventListener(onButton)
    win_back:addChild(button)

    local item_name = cc.Label:createWithTTF('OK','font/CenturyGothic.ttf',30)
    --item_name:setColor(cc.c4b(255,255,255,255))
    item_name:setPosition(button:getContentSize().width/2, button:getContentSize().height/2)
    button:addChild(item_name)

    local been_button = cc.Sprite:create("image/shop/been.png")
    been_button:setPosition(button:getContentSize().width * 0.75, button:getContentSize().height/2)
    button:addChild(been_button)

    local rewardNumber = cc.Label:createWithSystemFont("+"..3,"",36)
    rewardNumber:setPosition(button:getContentSize().width * 0.88,button:getContentSize().height * 0.5)
    button:addChild(rewardNumber)

    local label = cc.Label:createWithSystemFont('打败总结Boss！','',44)
    label:setColor(cc.c3b(31,68,102))
    label:setPosition(0.5 * backColor:getContentSize().width,0.85 * s_DESIGN_HEIGHT)
    backColor:addChild(label)

    local pic = cc.Sprite:create('image/summarybossscene/summaryboss_beated.png')
    pic:setPosition(0.5 * win_back:getContentSize().width,0.5 * win_back:getContentSize().height)
    win_back:addChild(pic)
end

return SummaryBossAlter