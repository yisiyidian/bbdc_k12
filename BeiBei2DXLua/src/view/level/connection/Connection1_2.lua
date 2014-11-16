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
end

return Connection1_2