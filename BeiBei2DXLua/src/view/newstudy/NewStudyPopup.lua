require("cocos.init")
require("common.global")


local NewStudyPopup = class ("NewStudyPopup",function ()
    return cc.Layer:create()
end)

function NewStudyPopup.create()
    local layer = NewStudyPopup.new()
    
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH


    local popup_window = cc.Sprite:create("image/newstudy/popup_new.png")
    popup_window:setPosition(s_LEFT_X + bigWidth / 2 ,s_DESIGN_HEIGHT / 2 * 3)
    popup_window:ignoreAnchorPointForPosition(false)
    popup_window:setAnchorPoint(0.5,0.5)
    layer:addChild(popup_window)
    
    local action1 = cc.MoveTo:create(0.1, cc.p(s_LEFT_X + bigWidth / 2 , s_DESIGN_HEIGHT / 2))
    local action2 = cc.EaseBackOut:create(action1)
    popup_window:runAction(action2)
    
    s_SCENE:callFuncWithDelay(1,function()
        local action1 = cc.MoveTo:create(1, cc.p(s_LEFT_X + bigWidth / 2 , s_DESIGN_HEIGHT / 2 * 3))
        local action2 = cc.EaseBackOut:create(action1)
        popup_window:runAction(action2)
        

        NewStudyLayer_State = NewStudyLayer_State_Mission
        local NewStudyLayer     = require("view.newstudy.NewStudyLayer")
        local newStudyLayer = NewStudyLayer.create(NewStudyLayer_State)
        s_SCENE:replaceGameLayer(newStudyLayer)

    end)
    
    local popup_text = cc.Label:createWithSystemFont("哦也，已经成功收集到"..s_CorePlayManager.maxWrongWordCount.."个生词了！","",26)
    popup_text:setPosition(popup_window:getContentSize().width / 2,popup_window:getContentSize().height *0.3)
    popup_text:setColor(cc.c4b(0,0,0,255))
    popup_text:ignoreAnchorPointForPosition(false)
    popup_text:setAnchorPoint(0.5,0.5)
    popup_window:addChild(popup_text)
      
    return layer
end

return NewStudyPopup