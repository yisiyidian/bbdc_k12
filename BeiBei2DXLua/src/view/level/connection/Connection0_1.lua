require("cocos.init")
require('common.global')

local Connection0_1 = class('Connection0_1', function()
    return cc.Layer:create()
end)

function Connection0_1.create()
    local layer = Connection0_1.new()
    return layer
end

function Connection0_1:ctor()
    self.ccbConnection0_1 = {}
    self.ccb = {}
    self.ccb['connection1_2'] = self.ccbConnection0_1
    local proxy = cc.CCBProxy:create()
    local contentNode = CCBReaderLoad('ccb/connection1_2.ccbi',proxy,self.ccbConnection0_1,self.ccb)  
    self:setContentSize(cc.size(s_MAX_WIDTH,402))
    self:addChild(contentNode)
end

function Connection0_1:plotUnlockChapterAnimation()
    local leftCloud = self.ccbConnection0_1['connection_left_cloud']
    local rightCloud = self.ccbConnection0_1['connection_right_cloud']
    local action1 = cc.MoveBy:create(0.5, cc.p(-leftCloud:getContentSize().width,leftCloud:getPositionY()))
    local action2 = cc.MoveBy:create(0.5, cc.p(leftCloud:getContentSize().width, rightCloud:getPositionY()))
    leftCloud:runAction(action1)
    rightCloud:runAction(action2)
end

function Connection0_1:removeLockedCloud()
    local leftCloud = self.ccbConnection0_1['connection_left_cloud']
    local rightCloud = self.ccbConnection0_1['connection_right_cloud']
    leftCloud:setVisible(false)
    rightCloud:setVisible(false)
end

return Connection0_1