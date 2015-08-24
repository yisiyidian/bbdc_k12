-- 词库渲染
local WordCardRender = class("WordCardRender", function()
	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(560,120))
	return layer
end)

function WordCardRender.create(word,meaning)
    local layer = WordCardRender.new(word,meaning)
    return layer
end

function WordCardRender:ctor(word,meaning)
	self.word = word
	self.meaning = meaning 
	self:init()
end
--初始化UI
function WordCardRender:init()
	local layerWidth = self:getContentSize().width
	local layerHeight = self:getContentSize().height
    -- 播放声音按钮
    local playSoundButton = ccui.Button:create("image/islandPopup/unit_words_loudspeaker_click.png","image/islandPopup/unit_words_loudspeaker_click.png","")
    playSoundButton:setPosition(48, layerHeight*0.5)
    playSoundButton:addTouchEventListener(handler(self,self.PlaySound))
    self.playSoundButton = playSoundButton
    self:addChild(self.playSoundButton)

    self:setTouchEnabled(true)
    self:addTouchEventListener(handler(self,self.PlaySound))

    local poxitionX = playSoundButton:getContentSize().width
    local poxitionY = playSoundButton:getContentSize().height

    local first = cc.Sprite:create("image/islandPopup/unit_words_loudspeaker_first.png")
    first:setPosition(poxitionX + 3,poxitionY * 0.5)
    self.first = first
    self.playSoundButton:addChild(self.first)

    local second = cc.Sprite:create("image/islandPopup/unit_words_loudspeaker_second.png")
    second:setPosition(poxitionX + 6.5,poxitionY * 0.5)
    self.second = second
    self.playSoundButton:addChild(self.second)

    local third = cc.Sprite:create("image/islandPopup/unit_words_loudspeaker_third.png")
    third:setPosition(poxitionX + 10,poxitionY * 0.5)
    self.third = third
    self.playSoundButton:addChild(self.third)

    local positionX = 0
    positionX = playSoundButton:getPositionX() + playSoundButton:getContentSize().width + 32

    -- 单词显示
    local wordLabel = cc.Label:createWithSystemFont("","",25)
    wordLabel:setPosition(positionX,layerHeight*0.5)
    wordLabel:setColor(cc.c4b(38,64,80,255))
    wordLabel:enableOutline(cc.c4b(38,64,80,255),1)
    wordLabel:ignoreAnchorPointForPosition(false)
    wordLabel:setAnchorPoint(0,0.5)
   	self.wordLabel = wordLabel
    self:addChild(self.wordLabel)

    positionX = positionX + wordLabel:getContentSize().width + 70

    -- 释义显示
    local wordMeaningLabel = cc.Label:createWithSystemFont("","",25)
    wordMeaningLabel:setPosition(cc.p(positionX,layerHeight * 0.5))
    wordMeaningLabel:setColor(cc.c4b(120,159,0,255))
    wordMeaningLabel:enableOutline(cc.c4b(120,159,0,255),1)
    wordMeaningLabel:ignoreAnchorPointForPosition(false)
    wordMeaningLabel:setAnchorPoint(0,0.5)
    self.wordMeaningLabel = wordMeaningLabel
    self:addChild(self.wordMeaningLabel)

    -- 分割线
    local line = cc.Sprite:create("image/islandPopup/parting_line.png")
    line:setPosition(48, 0)
    line:ignoreAnchorPointForPosition(false)
    line:setAnchorPoint(0,0.5)
    self.line = line
    self:addChild(self.line)

end

function WordCardRender:PlaySoundAnimation(time)
    local fadeOut = cc.FadeOut:create(0)
    local fadeIn = cc.FadeIn:create(time)
    local sequence = cc.Sequence:create(fadeOut,fadeIn)
    return sequence
end

function WordCardRender:PlaySound(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    -- 动画
    s_SCENE.touchEventBlockLayer.lockTouch()
    self.first:runAction(self:PlaySoundAnimation(0.2))
    self.second:runAction(self:PlaySoundAnimation(0.4)) 
    self.third:runAction(self:PlaySoundAnimation(0.6))
    playWordSound(self.word)
    print("playsound")  
    local delay = cc.DelayTime:create(0.6)
    local func = cc.CallFunc:create(function (  )
        s_SCENE.touchEventBlockLayer.unlockTouch()
    end)  
    self.third:runAction(cc.Sequence:create(delay,func))
end

function WordCardRender:setData()
	self:updataView()
end
 
function WordCardRender:updataView()
    local positionX = 0
    -- 计算横坐标
    positionX = self.playSoundButton:getPositionX() + self.playSoundButton:getContentSize().width + 40
    self.wordLabel:setPositionX(positionX)
    local word = string.gsub(self.word,"|"," ")
	self.wordLabel:setString(word)
    positionX = positionX + self.wordLabel:getContentSize().width + 38
    self.wordMeaningLabel:setPositionX(positionX)
	self.wordMeaningLabel:setString(self.meaning)
end

return WordCardRender