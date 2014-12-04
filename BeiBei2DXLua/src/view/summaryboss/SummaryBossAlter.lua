require("common.global")

local SummaryBossAlter = class("SummaryBossAlter", function()
    return cc.Layer:create()
end)
local vertical = 1
local horizontal = 2

function SummaryBossAlter.create(win,wordCount,blood,index)
    
    local layer = SummaryBossAlter.new()
    layer.wordCount = wordCount
    layer.blood = blood
    layer.win = win
    layer.index = index

    if layer.win then
        local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey, s_CURRENT_USER.currentSelectedLevelKey)
        local isPassed = levelData.isPassed
        if isPassed == 0 then
            s_CURRENT_USER:addEnergys(1)
            s_SCENE.levelLayerState = s_unlock_normal_plotInfo_state
            s_CURRENT_USER:setUserLevelDataOfStars(s_CURRENT_USER.currentChapterKey, s_CURRENT_USER.currentSelectedLevelKey,3)
        end
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
        layer:result(horizontal)    
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
        
        local move = cc.EaseBackIn:create(cc.MoveBy:create(0.3,cc.p(s_LEFT_X - s_RIGHT_X , 0)))
        local summary = cc.CallFunc:create(function ()
            self:result(vertical)
        end,{})
        self.loseBoard:runAction(cc.Sequence:create(move,summary))

    end
    continue:registerScriptTapHandler(nextBoard)

    local close = ccui.Button:create('image/button/button_close.png','image/button/button_close.png','')
    close:setPosition(self.loseBoard:getContentSize().width * 0.94,self.loseBoard:getContentSize().height * 0.82)
    self.loseBoard:addChild(close)

    local function onClose(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect)
            self.backToLevel()
        end
    end

    close:addTouchEventListener(onClose)
    
    
end


function SummaryBossAlter:result(direction)
    
    local board = cc.Sprite:create(string.format("image/summarybossscene/summaryboss_board_%d.png",self.index))
    if direction == horizontal then
        board:setPosition(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.3)
    else
        board:setPosition(s_DESIGN_WIDTH * 1.5,s_DESIGN_HEIGHT * 0.5)
    end
    board:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5))))
    self:addChild(board)
    local boss
    local label
    local label1
    local head
    if self.win then
        boss = sp.SkeletonAnimation:create("spine/summaryboss/klsbeidacandonghua.json","spine/summaryboss/klsbeidacandonghua.atlas",1)
        boss:setAnimation(0,'animation',true)       
        label = cc.Label:createWithSystemFont("挑战成功！",'',40)        
        label1 = cc.Label:createWithSystemFont(string.format("已经找到了%d个单词\n击败了恐老师！",self.wordCount),'',40)        
        head = cc.Sprite:create("image/summarybossscene/summaryboss_win_head.png")
    else
        boss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)     
        label = cc.Label:createWithSystemFont("挑战失败！",'',40)
        label1 = cc.Label:createWithSystemFont(string.format("还需要找出%d个单词！\n做好准备再来",math.ceil(self.blood / 5)),'',40)
        head = cc.Sprite:create("image/summarybossscene/summaryboss_lose_head.png")
        boss:setAnimation(0,'animation',false)
        boss:addAnimation(0,'jianxiao',true)
    end
    boss:setPosition(board:getContentSize().width / 4,board:getContentSize().height * 0.22)
    board:addChild(boss)
        
    label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label:setPosition(board:getContentSize().width / 2,board:getContentSize().height * 0.64)
    label:setColor(cc.c4b(251.0, 39.0, 10.0, 255))
    board:addChild(label)
        
    label1:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label1:setPosition(board:getContentSize().width / 2,board:getContentSize().height * 0.55)
    label1:setColor(cc.c4b(52,177,241,255))
    board:addChild(label1)
        
    head:setPosition(board:getContentSize().width / 2,board:getContentSize().height * 0.75)
    board:addChild(head)
    
    local continue = ccui.Button:create("image/summarybossscene/summaryboss_blue_button.png","")
    continue:setPosition(board:getContentSize().width / 2,board:getContentSize().height * 0.15)
    board:addChild(continue)
    
    local btn_title = cc.Label:createWithSystemFont("继 续",'',40)
    btn_title:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    btn_title:setPosition(continue:getContentSize().width / 2,continue:getContentSize().height / 2)
    continue:addChild(btn_title)
    local close = ccui.Button:create('image/button/button_close.png','image/button/button_close.png','')
    close:setPosition(board:getContentSize().width * 0.94,board:getContentSize().height * 0.82)
    board:addChild(close)

    local function onClose(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            playSound(s_sound_buttonEffect)
            self.backToLevel()
        end
    end

    close:addTouchEventListener(onClose)
    
    local function toSummaryMask(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local move = cc.EaseBackIn:create(cc.MoveBy:create(0.3,cc.p(s_LEFT_X - s_RIGHT_X , 0)))
            local summary = cc.CallFunc:create(function ()
                self:summaryMask()
            end,{})
            board:runAction(cc.Sequence:create(move,summary))
        end
    end
    continue:addTouchEventListener(toSummaryMask)
    
end

function SummaryBossAlter:summaryMask()
    local boardCount = math.ceil(13 / 10)
    local summaryBoard = {}
    for i = 1, boardCount do
        summaryBoard[i] = cc.Sprite:create(string.format("image/summarybossscene/summaryboss_board_%d.png",self.index))
        summaryBoard[i]:setPosition(s_DESIGN_WIDTH * 1.5,s_DESIGN_HEIGHT * 0.5)
        
        self:addChild(summaryBoard[i])
        
        local label = cc.Label:createWithSystemFont("考察到的单词",'',40)
        label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
        label:setPosition(summaryBoard[i]:getContentSize().width / 2,summaryBoard[i]:getContentSize().height * 0.75)
        label:setColor(cc.c4b(52,177,241,255))
        summaryBoard[i]:addChild(label)

        local continue = ccui.Button:create("image/summarybossscene/summaryboss_blue_button.png","")
        continue:setPosition(summaryBoard[i]:getContentSize().width / 2,summaryBoard[i]:getContentSize().height * 0.22)
        summaryBoard[i]:addChild(continue)

        local btn_title = cc.Label:createWithSystemFont("继续",'',40)
        btn_title:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
        btn_title:setPosition(continue:getContentSize().width * 0.6,continue:getContentSize().height / 2)
        continue:addChild(btn_title)

        local close = ccui.Button:create('image/button/button_close.png','image/button/button_close.png','')
        close:setPosition(summaryBoard[i]:getContentSize().width * 0.94,summaryBoard[i]:getContentSize().height * 0.82)
        summaryBoard[i]:addChild(close)

        local function onClose(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                playSound(s_sound_buttonEffect)
                self.backToLevel()
            end
        end

        close:addTouchEventListener(onClose)

        local function nextBoard(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                -- button sound
                playSound(s_sound_buttonEffect)
                if i < boardCount then
                    summaryBoard[i]:runAction(cc.EaseBackIn:create(cc.MoveBy:create(0.3,cc.p(s_LEFT_X - s_RIGHT_X , 0))))
                    summaryBoard[i + 1]:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5))))
                else
                    self.backToLevel()
                end
            end
        end
        continue:addTouchEventListener(nextBoard)
    end

    summaryBoard[1]:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5))))
    
end

function  SummaryBossAlter:backToLevel()
    local level = require('view.LevelLayer')
    local layer = level.create()
    s_SCENE:replaceGameLayer(layer)
    cc.SimpleAudioEngine:getInstance():stopAllEffects()
end

return SummaryBossAlter