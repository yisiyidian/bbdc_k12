require("common.global")

local SummaryBossAlter = class("SummaryBossAlter", function()
    return cc.Layer:create()
end)

function SummaryBossAlter.create(win)
    local layer = SummaryBossAlter.new()
    layer.win = win
    local back = cc.LayerColor:create(cc.c4b(0,0,0,150), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
    back:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    layer:addChild(back)
    if win then
        layer:win1()
    else
        layer:lose()
    end
    
    return layer
end

function SummaryBossAlter:lose()
    --add board
    self.loseBoard = cc.Sprite:create("image/summarybossscene/summaryboss_board.png")
    self.loseBoard:setPosition(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.3)
    self.loseBoard:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5))))
    self:addChild(self.loseBoard)
    
    local boss = sp.SkeletonAnimation:create("spine/summaryboss/klschongshangdaoxia.json","spine/summaryboss/klschongshangdaoxia.atlas",1)
    boss:setAnimation(0,'animation',false)
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
    self.loseBoard2 = cc.Sprite:create("image/summarybossscene/summaryboss_board.png")
    self.loseBoard2:setPosition(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5)
    self.loseBoard:runAction(cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5))))
    self.loseBoard2:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5)))))
    self:addChild(self.loseBoard2)
    
    local boss = sp.SkeletonAnimation:create("spine/summaryboss/klschongshangdaoxia.json","spine/summaryboss/klschongshangdaoxia.atlas",1)
    boss:setAnimation(0,'animation',true)
    boss:setPosition(self.loseBoard:getContentSize().width / 4,self.loseBoard:getContentSize().height * 0.22)
    self.loseBoard2:addChild(boss)
    
    local label = cc.Label:createWithSystemFont("挑战失败！",'',40)
    label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label:setPosition(self.loseBoard2:getContentSize().width / 2,self.loseBoard2:getContentSize().height * 0.64)
    label:setColor(cc.c4b(251.0, 39.0, 10.0, 255))
    self.loseBoard2:addChild(label)

    local label1 = cc.Label:createWithSystemFont("还需要找出3个单词！\n做好准备再来",'',40)
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
        s_logd("back") 
        local level = require('view.LevelLayer')
        local layer = level.create()
        s_SCENE:replaceGameLayer(layer)
    end
    continue:registerScriptTapHandler(backToLevelScene)
    
    local function challengeAgain(sender)
        s_logd("again")
        local level = require('view.LevelLayer')
        local layer = level.create()
        s_SCENE:replaceGameLayer(layer) 
    end
    again:registerScriptTapHandler(challengeAgain)
    
end

function SummaryBossAlter:win1()
    local levelData = self:getUserLevelData(s_CURRENT_USER.currentChapterKey, s_CURRENT_USER.currentSelectLevelKey)
    local isPassed = levelData.isPassed
    if isPassed == 0 then
        s_CURRENT_USER:setUserLevelDataOfStars(s_CURRENT_USER.currentChapterKey, s_CURRENT_USER.currentSelectLevelKey,3)
    end
    self.winBoard = cc.Sprite:create("image/summarybossscene/summaryboss_board.png")
    self.winBoard:setPosition(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.3)
    self.winBoard:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5))))
    self:addChild(self.winBoard)
    
    local boss = sp.SkeletonAnimation:create("spine/summaryboss/klsbeidacandonghua.json","spine/summaryboss/klsbeidacandonghua.atlas",1)
    boss:setAnimation(0,'animation',true)
    boss:setPosition(self.winBoard:getContentSize().width / 4,self.winBoard:getContentSize().height * 0.22)
    self.winBoard:addChild(boss)
    
    local label = cc.Label:createWithSystemFont("挑战成功！",'',40)
    label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label:setPosition(self.winBoard:getContentSize().width / 2,self.winBoard:getContentSize().height * 0.64)
    label:setColor(cc.c4b(251.0, 39.0, 10.0, 255))
    self.winBoard:addChild(label)
    
    local label1 = cc.Label:createWithSystemFont("已经找到了4个单词\n击败了恐老师！",'',40)
    label1:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    label1:setPosition(self.winBoard:getContentSize().width / 2,self.winBoard:getContentSize().height * 0.55)
    label1:setColor(cc.c4b(52,177,241,255))
    self.winBoard:addChild(label1)
    
    local head = cc.Sprite:create("image/summarybossscene/summaryboss_win_head.png")
    head:setPosition(self.winBoard:getContentSize().width / 2,self.winBoard:getContentSize().height * 0.75)
    self.winBoard:addChild(head)
    
    local menu = cc.Menu:create()
    self.winBoard:addChild(menu)
    local continue = cc.MenuItemImage:create("image/summarybossscene/summaryboss_blue_button.png","")
    menu:setPosition(self.winBoard:getContentSize().width / 2,self.winBoard:getContentSize().height * 0.15)
    menu:addChild(continue)
    
    local btn_title = cc.Label:createWithSystemFont("继 续",'',40)
    btn_title:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    btn_title:setPosition(continue:getContentSize().width / 2,continue:getContentSize().height / 2)
    continue:addChild(btn_title)
    
    local function backToLevelScene(sender)
       s_logd("clicked") 
       local level = require('view.LevelLayer')
       local layer = level.create()
       if self.win and isPassed == 0 then
           s_SCENE.levelLayerState = s_unlock_normal_plotInfo_state
       end
       s_SCENE:replaceGameLayer(layer)
    end
    continue:registerScriptTapHandler(backToLevelScene)
    
end

return SummaryBossAlter