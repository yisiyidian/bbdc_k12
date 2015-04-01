local  BeibeiLayer = class("BeibeiLayer", function ()
    return cc.Layer:create()
end)

BEIBEI_ENTER_COLLECT_WORD_LAYER  = 'COLLECT_WORD'
BEIBEI_CLICK_I_KNOW_BUTTON       = 'CLICK_I_KNOW_BUTTON'

function BeibeiLayer.create(BEIBEI_TYPE)
    local layer = BeibeiLayer.new(BEIBEI_TYPE)
    return layer
end

function BeibeiLayer:createFromCollectWord()
    local beibei = cc.Sprite:create("image/newstudy/bb_big_yindao.png")
    beibei:setPosition(s_DESIGN_WIDTH / 2  - 100, s_DESIGN_HEIGHT * 0.55*(-0.5))
    beibei:ignoreAnchorPointForPosition(false)
    beibei:setAnchorPoint(0.5,0)
    self:addChild(beibei)

    local beibei_arm = cc.Sprite:create("image/newstudy/bb_arm_yindao.png")
    beibei_arm:setPosition(beibei:getContentSize().width/2 - 70,beibei:getContentSize().height/2 - 2)
    beibei_arm:ignoreAnchorPointForPosition(false)
    beibei_arm:setAnchorPoint(0,0)
    beibei:addChild(beibei_arm,-1)

    local action1 = cc.MoveBy:create(0.5,cc.p(5,4))
    local action2 = cc.MoveBy:create(0.5,cc.p(-5,-4))
    local action3 = cc.RepeatForever:create(cc.Sequence:create(action1,action2))
    beibei_arm:runAction(action3)
    
    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2 - 100, 0))
    local action2 = cc.EaseBackOut:create(action1)
    beibei:runAction(action2)    

    self.remove = function ()
        local action1 = cc.MoveTo:create(0.2,cc.p(s_DESIGN_WIDTH / 2  - 100, s_DESIGN_HEIGHT * 0.55*(-1)))
        local action2 = cc.EaseBackIn:create(action1)
        beibei:runAction(action2)  
    end
end

function BeibeiLayer:ctor(BEIBEI_TYPE)
    if BEIBEI_TYPE == BEIBEI_ENTER_COLLECT_WORD_LAYER then
       self:createFromCollectWord()
    end
end

return BeibeiLayer