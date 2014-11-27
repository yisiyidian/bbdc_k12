require('Cocos2d')
require('Cocos2dConstants')
require('common.global')
require('CCBReaderLoad')

local Connection2_3 = class('Connection2_3', function()
    return cc.Layer:create()
end)

function Connection2_3.create()
    local layer = Connection2_3.new()
    return layer
end

function Connection2_3:ctor()
    self.ccbConnection2_3 = {}
    self.ccb = {}
    self.ccb['Connection2_3'] = self.ccbConnection2_3
    local proxy = cc.CCBProxy:create()
    local contentNode = CCBReaderLoad('ccb/connection2_3.ccbi',proxy,self.ccbConnection2_3,self.ccb)  
    self:setContentSize(cc.size(s_MAX_WIDTH,402))
    self:addChild(contentNode)
end

function Connection2_3:plotUnlockChapterAnimation()
    local leftCloud = self.ccbConnection2_3['left']
    local rightCloud = self.ccbConnection2_3['right']
    --local action1 = cc.MoveBy:create(0.5, cc.p(leftCloud:getContentSize().width,leftCloud:getPositionY()))
    local action2 = cc.MoveBy:create(0.5, cc.p(rightCloud:getContentSize().width, rightCloud:getPositionY()))
    --leftCloud:runAction(action1)
    rightCloud:runAction(action2)
end

return Connection2_3