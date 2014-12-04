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

    local back = cc.LayerColor:create(cc.c4b(208,212,215,255),s_RIGHT_X - s_LEFT_X,162 * 6)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    back:setPosition(0.5 * s_DESIGN_WIDTH,162 * 3)
    self:addChild(back)

    local listView = ccui.ListView:create()
    -- set list view ex direction
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setBackGroundImageScale9Enabled(true)
    listView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,162 * 6))
    listView:setPosition(s_LEFT_X,0)
    listView:setName('listView')
    self:addChild(listView)
    
    for i = 1,10 do
        local nameStr = "image/friend/friendRankButton.png"
        local custom_button = cc.LayerColor:create(cc.c4b(255,255,255,255),s_RIGHT_X - s_LEFT_X,280)
        custom_button:ignoreAnchorPointForPosition(false)
        custom_button:setAnchorPoint(0,0)
        custom_button:setName("Title Button")
        
        local agree = ccui.Button:create("image/friend/fri_button_blue.png","image/friend/fri_button_blue.png","image/friend/fri_button_blue.png")
        agree:setPosition(0.3 * custom_button:getContentSize().width,0.2 * custom_button:getContentSize().height)
        custom_button:addChild(agree)
        
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,custom_button:getContentSize().height))
        custom_button:setPosition(cc.p((s_RIGHT_X - s_LEFT_X) * 0, custom_item:getContentSize().height * 0))
        custom_item:addChild(custom_button)
        
        local fri_word = cc.Label:createWithSystemFont('已学单词总数','',24)
        fri_word:setColor(cc.c3b(0,0,0))
        fri_word:ignoreAnchorPointForPosition(false)
        fri_word:setAnchorPoint(0,1)
        fri_word:setPosition(0.42 * custom_button:getContentSize().width,0.48 * custom_button:getContentSize().height)
        custom_button:addChild(fri_word)

        listView:addChild(custom_item)

        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                listView:removeItem(listView:getCurSelectedIndex())
            end
        end
        agree:addTouchEventListener(touchEvent) 

    end
    
end

return ScrollViewTest