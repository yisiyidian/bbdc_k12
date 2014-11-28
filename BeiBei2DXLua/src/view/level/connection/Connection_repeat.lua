require('Cocos2d')
require('Cocos2dConstants')
require('common.global')
require('CCBReaderLoad')

local Connection_repeat = class('Connection_repeat', function()
    return cc.Layer:create()
end)

function Connection_repeat.create()
    local layer = Connection_repeat.new()
    return layer
end

function Connection_repeat:ctor()
    self.ccbConnection_repeat = {}
    self.ccb = {}
    self.ccb['connection_repeat'] = self.ccbConnection_repeat
    local proxy = cc.CCBProxy:create()
    local contentNode = CCBReaderLoad('ccb/connection_repeat.ccbi',proxy,self.ccbConnection_repeat,self.ccb)  
    self:setContentSize(cc.size(s_MAX_WIDTH,402))
    self:addChild(contentNode)
end

function Connection_repeat:plotUnlockChapterAnimation()
    local leftCloud = self.ccbConnection_repeat['connection_left_cloud']
    local rightCloud = self.ccbConnection_repeat['connection_right_cloud']
    local action1 = cc.MoveBy:create(0.5, cc.p(-leftCloud:getContentSize().width,leftCloud:getPositionY()))
    local action2 = cc.MoveBy:create(0.5, cc.p(leftCloud:getContentSize().width, rightCloud:getPositionY()))
    leftCloud:runAction(action1)
    rightCloud:runAction(action2)
end

return Connection_repeat