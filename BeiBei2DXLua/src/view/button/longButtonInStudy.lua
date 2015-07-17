-- require("cocos.init")
-- require("common.global")
-- 按钮类
-- 这种按钮有少量立体效果
-- 按下去，按钮上层和文字会下移
-- 松开后，复原
local  longButtonInStudy = class("longButtonInStudy", function ()
    return cc.Sprite:create()
end)

-- 参数 底层纹理位置，上层纹理位置，上下移动的距离，按钮上的文字
function longButtonInStudy.create(backTexture,frontTexture,moveLength,text)
    return longButtonInStudy.new(backTexture,frontTexture,moveLength,text)
end

function longButtonInStudy:ctor(backTexture,frontTexture,moveLength,text)
    self.backTexture = backTexture
    self.frontTexture = frontTexture
    self.moveLength = moveLength
    self.text = text
    self.color = cc.c4b(255,255,255,255)
    self:initUI()
end

function longButtonInStudy:initUI()
    local button_back = cc.Sprite:create()
    button_back:ignoreAnchorPointForPosition(false)
    button_back:setAnchorPoint(0.5,0.5)
    self.button_back = button_back
    self:addChild(self.button_back)

    self.func = function ()
    end

    local button_front = cc.Sprite:create()
    button_front:ignoreAnchorPointForPosition(false)
    button_front:setAnchorPoint(0.5,0.5)
    self.button_front = button_front
    self.button_back:addChild(self.button_front)

    local label = cc.Label:createWithSystemFont("","",30)
    label:ignoreAnchorPointForPosition(false)
    label:setAnchorPoint(0.5,0.5)
    label:setColor(cc.c4b(255,255,255,255))
    self.label = label
    self.button_front:addChild(self.label)

    self:resetUI()

    self:touchFunc()
end

function longButtonInStudy:resetUI()
    self.button_back:setTexture(self.backTexture)
    self.button_front:setTexture(self.frontTexture)
    self.label:setString(self.text)

    self.button_front:setPosition(self.button_back:getContentSize().width / 2,self.button_back:getContentSize().height / 2 + self.moveLength)
    self.label:setPosition(self.button_front:getContentSize().width / 2,self.button_front:getContentSize().height / 2)
    self.label:setColor(self.color)
end

function longButtonInStudy:touchFunc()
    local function onTouchBegan(touch, event)
        local location = self.button_back:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(self.button_front:getBoundingBox(),location) then
            playSound(s_sound_buttonEffect)  
            self.button_front:setPosition(self.button_back:getContentSize().width / 2,self.button_back:getContentSize().height / 2)
        end
        return true
    end

    local function onTouchEnded(touch, event)            
        self.button_front:setPosition(self.button_back:getContentSize().width / 2,self.button_back:getContentSize().height / 2 + self.moveLength)
        local location = self.button_back:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(self.button_front:getBoundingBox(),location) then 
           self.func()
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.button_back)
end

return longButtonInStudy