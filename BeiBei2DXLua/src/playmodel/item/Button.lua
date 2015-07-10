-- 按钮类
-- 这种按钮有少量立体效果
-- 按下去，按钮上层和文字会下移,阴影上移
-- 松开后，复原

-- 按钮按下去不触发事件
-- 松开手，按钮状态还原

local  Button = class("Button", function ()
    return cc.Sprite:create()
end)

-- 参数 底层纹理位置，上层纹理位置,下层阴影位置，上下移动的距离，按钮上的文字
function Button.create(backTexture,frontTexture,shadowTexture,moveLength,text)
    return Button.new(backTexture,frontTexture,shadowTexture,moveLength,text)
end

function Button:ctor(backTexture,frontTexture,shadowTexture,moveLength,text)
    self.backTexture = backTexture
    self.frontTexture = frontTexture
    self.shadowTexture = shadowTexture
    self.moveLength = moveLength
    self.text = text

    self:initUI()
end

function Button:initUI()
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

    local button_shadow = cc.Sprite:create()
    button_shadow:ignoreAnchorPointForPosition(false)
    button_shadow:setAnchorPoint(0.5,0.5)
    self.button_shadow = button_shadow
    self.button_front:addChild(self.button_shadow,-1)

    local label = cc.Label:createWithSystemFont("","",30)
    label:ignoreAnchorPointForPosition(false)
    label:setAnchorPoint(0.5,0.5)
    label:setColor(cc.c4b(255,255,255,255))
    self.label = label
    self.button_front:addChild(self.label)

    self:resetUI()
end

function Button:resetUI()
    self.button_back:setTexture(self.backTexture)
    self.button_front:setTexture(self.frontTexture)
    self.button_shadow:setTexture(self.shadowTexture)
    self.label:setString(self.text)

    self.button_front:setPosition(self.button_back:getContentSize().width / 2,self.button_back:getContentSize().height / 2 + self.moveLength)
    self.label:setPosition(self.button_front:getContentSize().width / 2,self.button_front:getContentSize().height / 2)

    self.button_shadow:setPosition(self.button_back:getContentSize().width / 2,self.button_back:getContentSize().height / 2 - 2 * self.moveLength)

    self:touchFunc()
end

-- 给按钮右侧加精灵，文字
function Button:addSprite(texture,text)
    if texture == nil then
        return
    end

    local Sprite = cc.Sprite:create(texture)
    Sprite:setPosition(self.button_front:getContentSize().width * 0.75,self.button_front:getContentSize().height * 0.5)
    self.button_front:addChild(Sprite)

    if text ~= nil then
        local label = cc.Label:createWithSystemFont(text,"",30)
        label:ignoreAnchorPointForPosition(false)
        label:setAnchorPoint(0.5,0.5)
        label:setColor(cc.c4b(255,255,255,255))
        label:setPosition(Sprite:getContentSize().width * 0.5,Sprite:getContentSize().height * 0.5)
        Sprite:addChild(label)
    end

end

-- 按钮的触摸事件
function Button:touchFunc()
    local function onTouchBegan(touch, event)
        local location = self.button_back:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(self.button_front:getBoundingBox(),location) then
            playSound(s_sound_buttonEffect)  
            self.button_front:setPosition(self.button_back:getContentSize().width / 2,self.button_back:getContentSize().height / 2)
            self.button_shadow:setPosition(self.button_back:getContentSize().width / 2,self.button_back:getContentSize().height / 2)
        end
        return true
    end

    local function onTouchEnded(touch, event)            
        self.button_front:setPosition(self.button_back:getContentSize().width / 2,self.button_back:getContentSize().height / 2 + self.moveLength)
        self.button_shadow:setPosition(self.button_back:getContentSize().width / 2,self.button_back:getContentSize().height / 2 - 2 * self.moveLength)
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

return Button