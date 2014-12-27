require("cocos.init")
require('common.global')

local ChapterLayer = class('ChapterLayer', function() 
    return cc.Layer:create()
end)

local listView
local s_chapter_layer_width = 854
local oceanBlue = cc.c4b(61,191,244,255)
local bounceSectionSize = cc.size(854,512)

function ChapterLayer.create()
    local layer = ChapterLayer.new()
    return layer
end

function ChapterLayer:ctor()
    self.chapterDic = {}
    -- add list view
    local function listViewEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_END then
        end
    end

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            print("SCROLL_TO_BOTTOM")
        elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
            print("SCROLL_TO_TOP")
        elseif evenType == ccui.ScrollviewEventType.scrolling then
            --print('SCROLLING:'..sender:getPosition())
        end

    end 
    listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(true)
    listView:setBackGroundImageScale9Enabled(true)
    listView:addEventListener(listViewEvent)
    listView:addScrollViewEventListener(scrollViewEvent)
    listView:removeAllChildren()
    self:addChild(listView)
    
    local fullWidth = s_chapter_layer_width
    listView:setContentSize(fullWidth, s_DESIGN_HEIGHT)
    listView:setPosition(cc.p((s_DESIGN_WIDTH - fullWidth) / 2, 0))
    -- add bounce
    self:addTopBounce()
    self:addBottomBounce()
    -- add chapter node
    self:addChapterIntoListView('chapter0')
    self:addChapterIntoListView('chapter1')
end

function ChapterLayer:addPlayer()
    local bookProgress = s_CURRENT_USER.bookProgress:getBookProgress(s_CURRENT_USER.bookKey)
    self.player = cc.Sprite:create('image/chapter_level/gril_head.png')
    self.player:setPosition(currentChapterLayer:getPlayerPositionForLevel(s_CURRENT_USER.currentLevelKey))
    player:setScale(0.4)
    currentChapterLayer:addChild(player, 5)
end

function ChapterLayer:addChapterIntoListView(chapterKey)
--    print('chapterKey:'..chapterKey)
    if chapterKey == 'chapter0' then    
        local ChapterLayer0 = require('view.level.ChapterLayer0')
        self.chapterDic['chapter0'] = ChapterLayer0.create("start")
        self.chapterDic['chapter0']:setPosition(cc.p(0,0))
        self.chapterDic['chapter0']:loadLevelPosition("level0")
        self.chapterDic['chapter0']:plotDecoration()
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(self.chapterDic['chapter0']:getContentSize())  
        custom_item:setName('chapter0')  
        --self.chapterDic['chapter0']:setAnchorPoint(cc.p(0,0))
        listView:addChild(self.chapterDic['chapter0'])
   else    
        local RepeatChapterLayer = require('view.level.RepeatChapterLayer')
        self.chapterDic[chapterKey] = RepeatChapterLayer.create(chapterKey)
        self.chapterDic[chapterKey]:setPosition(cc.p(0,0))
        print('contentSize:'..self.chapterDic[chapterKey]:getContentSize().height)
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(self.chapterDic[chapterKey]:getContentSize())  
        custom_item:setName(chapterKey)  
        --self.chapterDic['chapter0']:setAnchorPoint(cc.p(0,0))
        listView:addChild(self.chapterDic[chapterKey]) 
        -- add connection 
--        local connectionLayer0_1 = require('view.level.connection.Connection0_1')
--        self.chapterDic['connection0_1'] = connectionLayer0_1.create()
--        if string.sub(s_CURRENT_USER.currentChapterKey,8) - string.sub(chapterKey, 8) >= 1 then
--            self.chapterDic['connection0_1']:plotUnlockChapterAnimation()
--        end
--        local item0_1 = ccui.Layout:create()
--        item0_1:setContentSize(self.chapterDic['connection0_1']:getContentSize())
--        self.chapterDic['connection0_1']:setPosition(cc.p(0,0))
--        item0_1:addChild(self.chapterDic['connection0_1'])
--        listView:addChild(item0_1)
    end
end

function ChapterLayer:addTopBounce()
    --if s_CURRENT_USER.currentChapterKey == 'chapter0' then
        --local blueLayerColor = cc.LayerColor:create(oceanBlue,bounceSectionSize.width,bounceSectionSize.height)
        local blueLayerColor = cc.LayerColor:create(oceanBlue,s_chapter_layer_width,s_DESIGN_HEIGHT)
        blueLayerColor:ignoreAnchorPointForPosition(false)
        blueLayerColor:setAnchorPoint(0,1)
        blueLayerColor:setPosition((s_DESIGN_WIDTH-bounceSectionSize.width)/2,s_DESIGN_HEIGHT)
        self:addChild(blueLayerColor,-1)
    --end
end

function ChapterLayer:addBottomBounce()
    self.chapterDic['leftCloud'] = cc.Sprite:create('image/chapter/leftCloud.png')
    self.chapterDic['rightCloud'] = cc.Sprite:create('image/chapter/rightCloud.png')
    self.chapterDic['leftCloud']:setAnchorPoint(0, 1)
    self.chapterDic['rightCloud']:setAnchorPoint(0, 1)
    self.chapterDic['leftCloud']:setPosition((s_DESIGN_WIDTH-bounceSectionSize.width)/2,100)
    self.chapterDic['rightCloud']:setPosition((s_DESIGN_WIDTH-bounceSectionSize.width)/2,100)
    listView:addChild(self.chapterDic['leftCloud'],100)
    listView:addChild(self.chapterDic['rightCloud'],100)
end

return ChapterLayer