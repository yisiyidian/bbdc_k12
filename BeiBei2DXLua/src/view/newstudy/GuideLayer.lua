local BeibeiLayer = require("view.newstudy.BeibeiLayer")

local  GuideLayer = class("GuideLayer", function ()
    return cc.Layer:create()
end)

GUIDE_ENTER_COLLECT_WORD_LAYER  = 'COLLECT_WORD'
GUIDE_CLICK_I_KNOW_BUTTON       = 'CLICK_I_KNOW_BUTTON'

function GuideLayer.create(GUIDE_TYPE)
    local layer = GuideLayer.new(GUIDE_TYPE)
    return layer
end

function GuideLayer:createFromCollectWord()
    local back_exist = true
    local back = cc.Sprite:create("image/newstudy/background_yindao_big.png")
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55*3)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    self:addChild(back)

    local title = cc.Label:createWithSystemFont('新手任务','',28)
    title:setPosition(back:getContentSize().width/2,back:getContentSize().height*0.8)
    title:setColor(cc.c3b(35,181,229))
    back:addChild(title)

    local richtext1 = ccui.RichText:create()
     
    local richElement = {
    ccui.RichElementText:create(1,cc.c3b(0  , 0  , 0  ),255,"找到","Helvetica",26),
    ccui.RichElementText:create(2,cc.c3b(35 , 181, 229),255,"3","Helvetica",26),  
    ccui.RichElementText:create(3,cc.c3b(0  , 0  , 0  ),255,"个","Helvetica",26),  
    ccui.RichElementText:create(4,cc.c3b(35 , 181, 229),255,"不认识","Helvetica",26),  
    ccui.RichElementText:create(5,cc.c3b(0  , 0  , 0  ),255,"的生词","Helvetica",26)   }
    
    for i=1,#richElement do
        richtext1:pushBackElement(richElement[i]) 
    end

    richtext1:setContentSize(cc.size(300,50)) 
    richtext1:ignoreContentAdaptWithSize(false)
    richtext1:ignoreAnchorPointForPosition(false)
    richtext1:setAnchorPoint(cc.p(0.5,0.5))
    richtext1:setPosition(back:getContentSize().width/2 + 10,back:getContentSize().height*0.5)     
    back:addChild(richtext1)

    local beibei

    local action1 = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.40))
    local action2 = cc.EaseBackOut:create(action1)
    local action3 = cc.CallFunc:create(function()
            beibei = BeibeiLayer.create()
            self:addChild(beibei)
        end)
    back:runAction(cc.Sequence:create(action2,action3))

    local function closeAnimation() 
        if back_exist ~= true then
            return
        end
        local action1 = cc.CallFunc:create(function()
            if beibei ~= nil then
                beibei.remove()
            end           
        end)
        local action2 = cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT * 0.55*3))
        local action3 = cc.EaseBackIn:create(action2)
        local action4 = cc.CallFunc:create(function()
            s_SCENE:removeAllPopups()
        end)
        back:runAction(cc.Sequence:create(action1,action3,action4))
        back_exist = false
    end

    s_SCENE:callFuncWithDelay(2.5,function ()
        closeAnimation() 
    end)
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        closeAnimation() 
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)


    onAndroidKeyPressed(self, function ()
        closeAnimation()
    end, function ()

    end)
end

function GuideLayer:ctor(GUIDE_TYPE)
    if GUIDE_TYPE == GUIDE_ENTER_COLLECT_WORD_LAYER then
        self:createFromCollectWord()
    end

end

return GuideLayer