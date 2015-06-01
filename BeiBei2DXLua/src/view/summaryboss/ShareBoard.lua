local Button                = require("view.button.longButtonInStudy")

local HintWord = class ("HintWord",function ()
    return cc.Layer:create()
end)

function HintWord.create(time,wordlist)
    local layer = HintWord.new(time,wordlist)
    return layer
end

function HintWord:ctor(time,wordlist)
    local curtain = cc.LayerColor:create(cc.c4b(0,0,0,150),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
    self:addChild(curtain)
    curtain:setPosition(s_LEFT_X,0)

    local back = cc.Sprite:create('image/summarybossscene/background_complete.png')
    back:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 * 3)
    local moveIn  =  cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT/2)))
    local unlock = cc.CallFunc:create(function (  )
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    end)
    back:runAction(cc.Sequence:create(moveIn,unlock))
    self:addChild(back)

    local close_Click = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            local action1 = cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local action3 = cc.CallFunc:create(function()
                self:removeFromParent()
            end)
            back:runAction(cc.Sequence:create(action2,action3))
        end
    end
    --加入关闭按钮
    local close_button = ccui.Button:create("image/button/button_close.png")
    close_button:setPosition(back:getContentSize().width - 50,back:getContentSize().height - 50)
    close_button:addTouchEventListener(close_Click)
    back:addChild(close_button)

    -----面板添加内容
    local label1 = cc.Label:createWithSystemFont('好厉害！','',40)
    label1:setColor(cc.c3b(28,58,71))
    label1:setPosition(back:getContentSize().width / 2,back:getContentSize().height * 0.8)
    back:addChild(label1)

    local label2 = cc.Label:createWithSystemFont('哇塞！你完成的速度','',30)
    label2:setColor(cc.c3b(28,58,71))
    label2:setPosition(back:getContentSize().width / 2,300)
    back:addChild(label2)
    label2:setAlignment(cc.TEXT_ALIGNMENT_RIGHT)

    local label3 = cc.Label:createWithSystemFont('超过了            的用户','',30)
    label3:setColor(cc.c3b(28,58,71))
    label3:setPosition(back:getContentSize().width / 2,240)
    back:addChild(label3)
    label3:setAlignment(cc.TEXT_ALIGNMENT_RIGHT)

    local label4 = cc.Label:createWithTTF('90%','font/impact.ttf',40)
    label4:setColor(cc.c3b(75,191,50))
    label4:setPosition(back:getContentSize().width / 2,240)
    back:addChild(label4)


    local shareBtn = Button.create("middle","blue","分享看看谁更棒！") 
    shareBtn:setPosition(back:getContentSize().width / 2,120)
    shareBtn.func = function ()
        cx.CXUtils:getInstance():shareURLToWeiXin('http://yisiyidian.com/doubi/html5/index.php?time='..string.format('%.2f',time)..'&wordlist='..wordlist, '我完成这些单词只用了'..string.format('%.2f',time)..'秒，你能做到吗？', '贝贝单词－根本停不下来')
        self:removeFromParent()
    end
    back:addChild(shareBtn)

    -- local function onShare(sender,eventType)
    --     if eventType == ccui.TouchEventType.ended then
    --         local wordList = self.bossLayer.unit.wrongWordList[1]
    --         for i = 2,#self.bossLayer.unit.wrongWordList do
    --             wordList = wordList..'|'..self.bossLayer.unit.wrongWordList[i]
    --         end
    --         cx.CXUtils:getInstance():shareURLToWeiXin('http://yisiyidian.com/doubi/html5/index.html?time='..self.bossLayer.totalTime..'&wordlist='..wordList, '', '贝贝单词－根本停不下来')
    --     end
    -- end
    -- shareBtn:addTouchEventListener(onShare)

    --------------
    
    local onTouchBegan = function(touch, event)
        return true
    end

    local onTouchEnded = function(touch, event)
        local location = self:convertToNodeSpace(touch:getLocation())
        if not cc.rectContainsPoint(back:getBoundingBox(),location) then
            local action1 = cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT/2*3))
            local action2 = cc.EaseBackIn:create(action1)
            local action3 = cc.CallFunc:create(function()
                self:removeFromParent()
            end)
            back:runAction(cc.Sequence:create(action2,action3))
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    
    
end

return HintWord