-- 词库渲染
local WordCardRender = class("WordCardRender", function()
	local layer = ccui.Layout:create()
	layer:setContentSize(cc.size(541,150))
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

    local wordLabel = cc.Label:createWithSystemFont("","",30)
    wordLabel:setPosition(layerWidth*0.1,layerHeight*0.5)
    wordLabel:setColor(cc.c4b(0,0,0,255))
    wordLabel:ignoreAnchorPointForPosition(false)
    wordLabel:setAnchorPoint(0,0.5)
   	self.wordLabel = wordLabel
    self:addChild(self.wordLabel)

    local wordMeaningLabel = cc.LabelTTF:create("","Helvetica",24, cc.size(layerWidth*0.32, 100), cc.TEXT_ALIGNMENT_LEFT)
    wordMeaningLabel:setPosition(cc.p(layerWidth * 0.5,layerHeight * 0.25))
    wordMeaningLabel:setColor(cc.c4b(0,0,0,255))
    wordMeaningLabel:ignoreAnchorPointForPosition(false)
    wordMeaningLabel:setAnchorPoint(0,0.5)
    self.wordMeaningLabel = wordMeaningLabel
    self:addChild(self.wordMeaningLabel)
end

function WordCardRender:setData()
	self:updataView()
end
 
function WordCardRender:updataView()
	self.wordLabel:setString(self.word)
	self.wordMeaningLabel:setString(self.meaning)
end

return WordCardRender