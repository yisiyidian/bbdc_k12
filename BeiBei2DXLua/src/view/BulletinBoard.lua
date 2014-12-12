require("cocos.init")
require("common.global")

local BulletinBoard = class("BulletinBoard", function()
    return cc.Layer:create()
end)

ccbBulletinBoard = ccbBulletinBoard or {}

function BulletinBoard.create()
    local layer = BulletinBoard.new()
    return layer
end

local cw = 0
local ch = 0

function BulletinBoard:ctor()
    self.ccb = {}

    self.w = s_RIGHT_X - s_LEFT_X
    self.h = s_DESIGN_HEIGHT

    ccbBulletinBoard['onClose'] = self.onClose
    self.ccb['bullet_in_board'] = ccbBulletinBoard
    ccbBulletinBoard['Layer'] = self
    self:setContentSize(cc.size(self.w, self.h))

    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("res/ccb/bullet_in_board.ccbi", proxy, ccbBulletinBoard, self.ccb)
    cw = node:getContentSize().width
    ch = node:getContentSize().height
    node:setAnchorPoint(cc.p(0.5, 0.5))
    node:setPosition(cc.p(s_LEFT_X, 0))
    self:addChild(node)

    ccbBulletinBoard['board']:setPosition(cc.p(cw / 2, ch * 1.5))
    ccbBulletinBoard['board']:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3, cc.p(cw / 2, ch * 0.5))))

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
        if self.index >= 0 then
            local b = math["and"](s_CURRENT_USER.bulletinBoardMask, (2 ^ self.index)) ~= 0
            if ccbBulletinBoard['effect']:isVisible() and not b then
                s_CURRENT_USER.bulletinBoardMask = s_CURRENT_USER.bulletinBoardMask + (2 ^ self.index)
            elseif not ccbBulletinBoard['effect']:isVisible() and b then
                s_CURRENT_USER.bulletinBoardMask = s_CURRENT_USER.bulletinBoardMask - (2 ^ self.index)
            end
        
            if s_CURRENT_USER.bulletinBoardMask < 0 then
                s_CURRENT_USER.bulletinBoardMask = 0
            end
        end
    end
    click:registerScriptTapHandler(onClick)
end

function BulletinBoard:updateValue(index, title, content)
    self.index = index
    ccbBulletinBoard["labelTitle"]:setString(title)
    ccbBulletinBoard["labelContent"]:setString(content)
end

function BulletinBoard:onClose()
    s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER)
    local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(cw / 2, ch * 1.5)))
    local remove = cc.CallFunc:create(function() 
        s_SCENE:removeAllPopups()
    end,{})
    ccbBulletinBoard['board']:runAction(cc.Sequence:create(move,remove))
    
    -- button sound
    playSound(s_sound_buttonEffect)
end

return BulletinBoard