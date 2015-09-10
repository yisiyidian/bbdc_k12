-- 词库渲染
local WordCardRender = class("WordCardRender", function()
	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(500,80))
	return layer
end)

function WordCardRender.create(text,index)
    local layer = WordCardRender.new(text,index)
    return layer
end
--index 1 单词
--index 2 释义
--index 3 音标
--index 4 英文例句 中文解释
function WordCardRender:ctor(text,index)
	self.text = text
	self.index = index 
    self.PlaySoundCall = function ()
    end
	self:init()
end
--初始化UI
function WordCardRender:init()
	local layerWidth = self:getContentSize().width
	local layerHeight = self:getContentSize().height
    -- 播放声音按钮

    local positionX = 0

    -- 显示text
    local text = cc.Label:createWithSystemFont(string.gsub(self.text,"|",""),"",20)
    text:setAlignment(cc.TEXT_ALIGNMENT_LEFT)
    text:setDimensions(400,0)
    text:setColor(cc.c4b(0,0,0,255))
    text:setPosition(80 ,60)
    text:setAnchorPoint(0,0.5)
    self.text = text
    self.text:setOpacity(0)
    self:addChild(self.text)

    -- 分割线
    -- local line = cc.Sprite:create("image/islandPopup/parting_line.png")
    -- line:setPosition(48, 0)
    -- line:ignoreAnchorPointForPosition(false)
    -- line:setAnchorPoint(0,0.5)
    -- self.line = line
    -- self:addChild(self.line)

end

function WordCardRender:PlayAnimation(sp,time)
    local fadeout = cc.FadeOut:create(time-0.7)
    local fadein = cc.FadeIn:create(0.7)
    local sequence = cc.Sequence:create(fadeout,fadein)
    sp:runAction(sequence)
end

function WordCardRender:PlaySound(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    self:PlaySoundCall()
end

function WordCardRender:setData()
	self:updataView()
    return self:getContentSize().height
end
 
function WordCardRender:updataView()
    if self.index == 1 then
        self.text:setSystemFontSize(40)
        self:PlayAnimation(self.text,0.2)
        self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function ()
            self:PlaySoundCall()
        end)))
    elseif self.index == 2 then
        self.text:setSystemFontSize(55)
        self:PlayAnimation(self.text,0.9)
    elseif self.index == 3 then
        self.text:setDimensions(0,0)
        self.text:setSystemFontSize(35)
        local playWordBtn = cc.Sprite:create("image/islandPopup/soundNormal.png")
        playWordBtn:setPosition(80 + self.text:getContentSize().width + 80,(self:getContentSize().height + 60 )/ 2)
        playWordBtn:setScale(1.5)
        playWordBtn:setOpacity(0)
        self.playWordBtn = playWordBtn
        self:addChild(self.playWordBtn)
        self:PlayAnimation(self.text,1.6)
        self:PlayAnimation(playWordBtn,1.6)
    elseif self.index == 4 then
        self.text:setSystemFontSize(27)
        self:setContentSize(cc.size(500,150))
        self:PlayAnimation(self.text,2.3)
    end

    if self.index == 4 then
        self:setContentSize(500,self.text:getContentSize().height + 60) 
    else
        self:setContentSize(500,100) 
    end
    self.text:setColor(cc.c4b(56,183,223,255))
    
    self.text:setPosition(80 ,self:getContentSize().height / 2)
end

function WordCardRender:setViewVisible()
    if self.index == 3 then
        self.playWordBtn:stopAllActions()
        self.playWordBtn:runAction(cc.FadeIn:create(0))
    end
    self.text:stopAllActions()
    self.text:runAction(cc.FadeIn:create(0))
end

return WordCardRender