require('Cocos2d')
require('Cocos2dConstants')
require('common.global')
require('CCBReaderLoad')

local LevelLayerI = class('LevelLayerI', function()
    return cc.Layer:create()
end)

function LevelLayerI.create()
    local layer = LevelLayerI.new()
    return layer
end

function LevelLayerI:ctor()
    self.ccbLevelLayerI = {}
    self.ccbLevelLayerI['onLevelButtonClicked'] = self.onLevelButtonClicked
    self.ccb = {}
    self.ccb['chapter1'] = self.ccbLevelLayerI
    
    local proxy = cc.CCBProxy:create()
    local contentNode = CCBReaderLoad('ccb/chapter1.ccbi',proxy,self.ccbLevelLayerI,self.ccb)
    self.ccbLevelLayerI['levelSet'] = contentNode:getChildByTag(5)
    for i = 1, #self.ccbLevelLayerI['levelSet']:getChildren() do
        self.ccbLevelLayerI['levelSet']:getChildren()[i]:setName('levelButton'..self.ccbLevelLayerI['levelSet']:getChildren()[i]:getTag())
    end
    self:addChild(contentNode)
end

function LevelLayerI:onLevelButtonClicked()
    s_logd('on LevelButtonClicked')
end

return LevelLayerI