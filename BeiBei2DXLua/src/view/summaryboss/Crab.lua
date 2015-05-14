require("cocos.init")
require("common.global")

local Crab = class("Crab",function ()
	return cc.Node:create()
end)

function Crab.create(word)
	local node = Crab.new(word)
	return node
end

function Crab:ctor(word)
	local proxy = cc.CCBProxy:create()
    self.ccb = {}
    self.ccbcrab = {} 
    self.ccb = {}
    self.ccb['CCB_crab'] = self.ccbcrab
    self.crab = CCBReaderLoad("ccb/crab1.ccbi", proxy, self.ccbcrab,self.ccb)
    self.crab:setPosition(s_DESIGN_WIDTH * 0.5, -s_DESIGN_HEIGHT * 0.1)
    self:addChild(self.crab)
    if s_CURRENT_USER.k12SmallStep < s_K12_summaryBoss then
        self.ccbcrab['meaningSmall']:setString(word)
        self.ccbcrab['meaningBig']:setString(word)
    else
        self.ccbcrab['meaningSmall']:setString(s_LocalDatabaseManager.getWordInfoFromWordName(word).wordMeaningSmall)
        self.ccbcrab['meaningBig']:setString(s_LocalDatabaseManager.getWordInfoFromWordName(word).wordMeaningSmall)
    end
    self:big()
    self:moveIn()
    s_SCENE:callFuncWithDelay(0.5,function (  )
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
        self:hint()
    end)
end

function Crab:hint()
	self.crab:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.15),cc.ScaleTo:create(0.5,1.0))))
end

function Crab:moveIn()
	local appear = cc.EaseBackOut:create(cc.MoveBy:create(0.5,cc.p(0,s_DESIGN_HEIGHT * 0.2)))
	self.crab:runAction(appear)
end

function Crab:moveOut()
	local disappear = cc.EaseBackIn:create(cc.MoveBy:create(0.5,cc.p(0,-s_DESIGN_HEIGHT * 0.2)))
	local remove = cc.CallFunc:create(function (  )
		self:removeFromParent()
	end)
	self.crab:runAction(cc.Sequence:create(disappear,remove))
end

function Crab:shake()
    --self.crab:stopAllActions()
	local shakeOnce = cc.Sequence:create(cc.RotateBy:create(0.05,9),cc.RotateBy:create(0.05,-18),cc.RotateBy:create(0.05,9))
    local shake = cc.Repeat:create(shakeOnce,2)
    local small = cc.CallFunc:create(function() 
        --self:small()   
    end,{})
    self.crab:runAction(cc.Sequence:create(shake,small))
end

function Crab:small()
    self.ccbcrab['boardBig']:setVisible(false)
    self.ccbcrab['boardSmall']:setVisible(true)
    self.ccbcrab['legBig']:setVisible(false)
    self.ccbcrab['legSmall']:setVisible(true)
end

function Crab:big()
    self.ccbcrab['boardBig']:setVisible(true)
    self.ccbcrab['boardSmall']:setVisible(false)
    self.ccbcrab['legBig']:setVisible(true)
    self.ccbcrab['legSmall']:setVisible(false)
end

return Crab