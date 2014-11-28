require('Cocos2d')
require('Cocos2dConstants')
require('common.global')
require('CCBReaderLoad')

local Connection1_2 = class('Connection1_2', function()
    return cc.Layer:create()
end)

function Connection1_2.create()
    local layer = Connection1_2.new()
    return layer
end

function Connection1_2:ctor()
    self.ccbConnection1_2 = {}
    self.ccb = {}
    self.ccb['connection2_3'] = self.ccbConnection1_2
    local proxy = cc.CCBProxy:create()
    local contentNode = CCBReaderLoad('ccb/connection2_3.ccbi',proxy,self.ccbConnection1_2,self.ccb)  
    self:setContentSize(cc.size(s_MAX_WIDTH,400))
    self:addChild(contentNode)
end

function Connection1_2:plotUnlockChapterAnimation()
    local leftCloud = self.ccbConnection1_2['left']
    local rightCloud = self.ccbConnection1_2['right']
    local action1 = cc.MoveBy:create(0.5, cc.p(-leftCloud:getContentSize().width,leftCloud:getPositionY()))
    local action2 = cc.MoveBy:create(0.5, cc.p(rightCloud:getContentSize().width, rightCloud:getPositionY()))
    leftCloud:runAction(action1)
    rightCloud:runAction(action2)
end

return Connection1_2