require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local ScrollViewTest = class("ScrollViewTest", function()
    return cc.Layer:create()
end)

function ScrollViewTest.create()
    local layer = ScrollViewTest.new()
    return layer
end

function ScrollViewTest:ctor()

    local back = cc.Sprite:create("image/summarybossscene/summaryboss_dierguan_back.png")    
    back:setPosition(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT / 2)
    self:addChild(back)

    local backEffect = sp.SkeletonAnimation:create('spine/summaryboss/second-level-summary-light.json','spine/summaryboss/second-level-summary-light.atlas',1)
    backEffect:setPosition(-30 - s_LEFT_X,0.675 * back:getContentSize().height)
    backEffect:setAnimation(0,'animation',true)
    self:addChild(backEffect)
    
end

return ScrollViewTest