local MeetOpponentLayer = require('view.summaryboss.MeetOpponentLayer')

local SearchLayer = class("SearchLayer", function ()
    return cc.Layer:create()
end)

function SearchLayer.create(unit,type)
    local layer = SearchLayer.new(unit,type)
    return layer
end

function SearchLayer:ctor(unit,type)
	-- 白底
    self.unit = unit
    self.type = type
	local layer = cc.LayerColor:create(cc.c4b(255,255,255,255), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
	layer:setPosition(-s_DESIGN_OFFSET_WIDTH, 0)
    self.layer = layer
	self:addChild(self.layer)

	-- 蓝底
	local blue = cc.Sprite:create("image/islandPopup/blue.png")
	blue:ignoreAnchorPointForPosition(false)
	blue:setAnchorPoint(0.5,0)
	blue:setPosition(self.layer:getContentSize().width /2,0)
    self.blue = blue
	self.layer:addChild(self.blue)

	-- 搜索对手标签
	local searching = cc.Label:createWithSystemFont("搜索对手...",'',40)
    searching:setColor(cc.c4b(41,204,250,255))
    searching:setPosition(self.blue:getContentSize().width/2,900)
    self.searching = searching
    self.blue:addChild(self.searching)

    -- 取消配对按钮
   	local cancel_button = ccui.Button:create("image/islandPopup/cancelNormal.png","image/islandPopup/cancelPress.png","")
    cancel_button:setPosition(self.blue:getContentSize().width/2, 800)
    cancel_button:addTouchEventListener(handler(self,self.cancelClick))
    self.cancel_button = cancel_button
    self.blue:addChild(self.cancel_button)

    -- 姓名标签
    local name = cc.Label:createWithSystemFont("",'',50)
    name:setColor(cc.c4b(255,255,255,255))
    name:setPosition(self.blue:getContentSize().width/2,330)
    self.name = name
    self.blue:addChild(self.name)
    self.name:setString(MeetOpponentLayer:rename())

    -- 学校标签
    local school = cc.Label:createWithSystemFont("",'',27)
    school:setColor(cc.c4b(255,255,255,255))
    school:setPosition(self.blue:getContentSize().width/2,230)
    self.school = school
    self.blue:addChild(self.school)
    self.school:setString(MeetOpponentLayer:reschool())


    math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
    local getOpponent = math.random(1,10)
    if getOpponent > 9 then
        self:callWithDelay(6,self.endWithNoOpponent)
    else
        local time = math.random(10,60) / 10
        self:callWithDelay(time,self.endWithOpponent)
    end
    -- time = math.random()
end

function SearchLayer:callWithDelay(delay,func)
    local delayTime = cc.DelayTime:create(delay)
    local call = cc.CallFunc:create(func)
    self:runAction(cc.Sequence:create(delayTime,call))
end

function SearchLayer:cancelClick(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    self:stopAction()
    self:returnBack()
end

function SearchLayer:returnBack()
    if self.type == "normal" then
        local LevelProgressPopup = require("view.islandPopup.LevelProgressPopup")
        local levelProgressPopup = LevelProgressPopup.create(self.unit.unitID - 1)
        s_SCENE:popup(levelProgressPopup)        
        s_CorePlayManager.enterLevelLayer()
    elseif self.type == "word" then
        local WordCardView = require("view.wordcard.WordCardView")
        local wordCardView = WordCardView.create(self.unit.unitID - 1)
        s_SCENE:popup(wordCardView)
        s_CorePlayManager.enterLevelLayer()
    else
        s_CorePlayManager.enterLevelLayer()
    end
end

function SearchLayer:endWithNoOpponent()
    local SmallAlterWithOneButton = require("view.alter.SmallAlterWithOneButton")
    local smallAlter = SmallAlterWithOneButton.create("没有匹配到对手")
    smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    s_SCENE.popupLayer:addChild(smallAlter)
    smallAlter.affirm = function ()
        smallAlter:removeFromParent()
        self:returnBack()
    end
end

function SearchLayer:endWithOpponent()
    local MeetOpponentLayer = require('view.summaryboss.MeetOpponentLayer')
    local meetOpponentLayer = MeetOpponentLayer.create(self.unit)
    s_SCENE:replaceGameLayer(meetOpponentLayer) 
end

function SearchLayer:stopAction()
    self:stopAllActions()
end

return SearchLayer