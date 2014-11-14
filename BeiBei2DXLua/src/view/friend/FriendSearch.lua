require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local FriendSearch = class("FriendSearch", function()
    return cc.Layer:create()
end)

function FriendSearch.create()
    local layer = FriendSearch.new()
    --layer.friend = friend
    return layer 
end

function FriendSearch:ctor()
    local inputBack = cc.Sprite:create('image/friend/fri_inputback.png')
    inputBack:setPosition(0.5 * s_DESIGN_WIDTH,0.805 * s_DESIGN_HEIGHT)
    self:addChild(inputBack)
    
    local searchButton = ccui.Button:create('image/friend/fri_button_search.png','image/friend/fri_button_search.png','')
    searchButton:setPosition(0.9 * inputBack:getContentSize().width,0.5 * inputBack:getContentSize().height)
    inputBack:addChild(searchButton)
    
    local function textFieldEvent(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then
            local textField = sender
            local screenSize = cc.Director:getInstance():getWinSize()
            textField:runAction(cc.MoveTo:create(0.225,cc.p(screenSize.width / 2.0, screenSize.height / 2.0 + textField:getContentSize().height / 2.0)))
            local info = string.format("attach with IME max length %d",textField:getMaxLength())
            --self._displayValueLabel:setString(info)
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            local textField = sender
            local screenSize = cc.Director:getInstance():getWinSize()
            textField:runAction(cc.MoveTo:create(0.175, cc.p(screenSize.width / 2.0, screenSize.height / 2.0)))
            local info = string.format("detach with IME max length %d",textField:getMaxLength())
            --self._displayValueLabel:setString(info)
        elseif eventType == ccui.TextFiledEventType.insert_text then
            local textField = sender
            local info = string.format("insert words max length %d",textField:getMaxLength())
            --self._displayValueLabel:setString(info)
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            local textField = sender
            local info = string.format("delete word max length %d",textField:getMaxLength())
            --self._displayValueLabel:setString(info)
        end
    end

    local textField = ccui.TextField:create()
    textField:setMaxLengthEnabled(true)
    textField:setMaxLength(16)
    textField:setTouchEnabled(true)
    textField:setFontSize(30)
    textField:setPlaceHolder("input words here")
    textField:setPosition(cc.p(inputBack:getContentSize().width / 2.0, inputBack:getContentSize().height / 2.0))
    textField:addEventListener(textFieldEvent) 
    inputBack:addChild(textField) 
end

return FriendSearch