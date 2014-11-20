require("Cocos2d")
require("Cocos2dConstants")
require("common.global")
require("CCBReaderLoad")
local BulletinBoard = class("BulletinBoard", function()
    return cc.Layer:create()
end)

ccbBulletinBoard = ccbBulletinBoard or {}

function BulletinBoard.create()
    local layer = BulletinBoard.new()
    return layer
end

function BulletinBoard:ctor()
    self.ccb = {}
    ccbBulletinBoard['onClose'] = self.onClose
    self.ccb['bullet_in_board'] = ccbBulletinBoard
    ccbBulletinBoard['Layer'] = self
    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("res/ccb/bullet_in_board.ccbi", proxy, ccbBulletinBoard, self.ccb)
    self:addChild(node)
    ccbBulletinBoard['board']:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 0.5))))
    --click effect
    local menu = cc.Menu:create()
    menu:setPosition(cc.p(ccbBulletinBoard['effect']:getPosition()))
    ccbBulletinBoard['board']:addChild(menu)
    local click = cc.MenuItemImage:create('','','')
    --click:setScale(0.5)
    click:setContentSize(cc.size(40,40))
    menu:addChild(click)
    
    local function onClick(sender)
        ccbBulletinBoard['effect']:setVisible(not ccbBulletinBoard['effect']:isVisible())
    end
    click:registerScriptTapHandler(onClick)
end

function BulletinBoard:onClose()
    local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH * 0.5,s_DESIGN_HEIGHT * 1.5)))
    local remove = cc.CallFunc:create(function() 
        ccbBulletinBoard['Layer']:removeFromParent()
    end,{})
    ccbBulletinBoard['board']:runAction(cc.Sequence:create(move,remove))
end


return BulletinBoard