local  NewStudyPopup = class ("NewStudyPopup",function (  )
   return cc.layer:create()
end)

function NewStudyPopup.create(  )
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

	local layer = NewStudyPopup.new()

    local popup_window = cc.Sprite:create("image/newstudy/popup_white.png")
    popup_window:setPosition(bigWidth / 2,s_DESIGN_HEIGHT / 2)
    popup_window:ignoreAnchorPointForPosition(false)
    popup_window:setAnchorPoint(0.5,0.5)
    layer:addChild(popup_window)
    
    local popup_text = cc.Label:createWithSystemFont("哦也，已经成功收集到20个生词了！","",48)
    popup_text:setPosition(popup_window:getContentSize().width / 2,popup_window:getContentSize().height / 2)
    popup_text:setColor(cc.c4b(0,0,0,255))
    popup_text:ignoreAnchorPointForPosition(false)
    popup_text:setAnchorPoint(0.5,0.5)
    popup_window:addChild(popup_text)

	return layer
end

return NewStudyPopup