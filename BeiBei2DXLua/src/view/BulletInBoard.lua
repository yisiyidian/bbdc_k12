require("Cocos2d")
require("Cocos2dConstants")
require("common.global")
require("CCBReaderLoad")
local BulletInBoard = class("BulletInBoard", function()
    return cc.Layer:create()
end)

ccbBulletInBoard = ccbBulletInBoard or {}

function BulletInBoard.create()
    local layer = BulletInBoard.new()
    return layer
end

function BulletInBoard:ctor()
    self.ccb = {}
    ccbBulletInBoard['onClose'] = self.onClose
    self.ccb['bullet_in_board'] = ccbBulletInBoard
    ccbBulletInBoard['Layer'] = self
    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("res/ccb/bullet_in_board.ccbi", proxy, ccbBulletInBoard, self.ccb)
    self:addChild(node)
    ccbBulletInBoard['board']:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5))))
    --click effect
    local menu = cc.Menu:create()
    menu:setPosition(cc.p(ccbBulletInBoard['effect']:getPosition()))
    ccbBulletInBoard['board']:addChild(menu)
    local click = cc.MenuItemImage:create('','','')
    --click:setScale(0.5)
    click:setContentSize(cc.size(40,40))
    menu:addChild(click)
    
    local function onClick(sender)
        ccbBulletInBoard['effect']:setVisible(not ccbBulletInBoard['effect']:isVisible())
    end
    click:registerScriptTapHandler(onClick)
end

function BulletInBoard:onClose()
    local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5)))
    local remove = cc.CallFunc:create(function() 
        ccbBulletInBoard['Layer']:removeFromParent()
    end,{})
    ccbBulletInBoard['board']:runAction(cc.Sequence:create(move,remove))
end


return BulletInBoard