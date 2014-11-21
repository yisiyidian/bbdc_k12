require("Cocos2d")
require("Cocos2dConstants")
require("CCBReaderLoad")
require("common.global")

local LevelLayer = class("LevelLayer", function()
    return cc.Layer:create()
end)

local player
local levelLayerI
local levelLayerII
local connection1_2

function LevelLayer.create()
    local layer = LevelLayer.new()
    return layer
end

function LevelLayer:levelStateManager()
    -- test
    --s_SCENE.levelLayerState = s_review_boss_pass_state
    --s_CURRENT_USER:initLevels()
    -- TODO Check Review boss state
    local reviewBossId = s_DATABASE_MGR.getCurrentReviewBossID()
    if reviewBossId ~= -1 then
        -- check whether current level is passed
        local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)
        if levelData.stars > 0 then
            if s_SCENE.levelLayerState ~= s_review_boss_appear_state 
                and s_SCENE.levelLayerState ~= s_review_boss_pass_state then
                if s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state or s_SCENE.levelLayerState == s_unlock_normal_notPlotInfo_state then
                    levelLayerI:plotStarAnimation(s_CURRENT_USER.currentLevelKey, levelData.stars)
                end
                s_SCENE.levelLayerState = s_review_boss_appear_state
            end
        end
    end
    -- TODO switch state
    if s_SCENE.levelLayerState == s_normal_level_state then
        print(s_SCENE.levelLayerState)
       
    elseif s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state or s_SCENE.levelLayerState == s_unlock_normal_notPlotInfo_state then
        -- lock screen and plot animation
        s_TOUCH_EVENT_BLOCK_LAYER:lockTouch()
        s_SCENE:callFuncWithDelay(3.9, function()
            s_TOUCH_EVENT_BLOCK_LAYER:unlockTouch()
        end)
        -- plot star animation
        local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey)
        levelLayerI:plotStarAnimation(s_CURRENT_USER.currentLevelKey, levelData.stars)
        
        -- save and update level data
        s_CURRENT_USER:setUserLevelDataOfStars(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey,2)
        s_CURRENT_USER.currentLevelKey = 'level'..(string.sub(s_CURRENT_USER.currentLevelKey, 6) + 1)
        --s_CURRENT_USER.currentLevelKey = 'level1'
        s_CURRENT_USER:setUserLevelDataOfUnlocked(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey, 1)
        -- plot unlock next level animation
        levelLayerI:plotUnlockLevelAnimation(s_CURRENT_USER.currentLevelKey)
        -- plot player animation
        s_SCENE:callFuncWithDelay(1.3,function()
            local targetPosition = levelLayerI:getPlayerPositionForLevel(s_CURRENT_USER.currentLevelKey)
            local action = cc.MoveTo:create(0.8, targetPosition)
            player:runAction(action)      
        end)
        
        -- update level state and plot popup(call on level button clicked)
        if s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state then
            s_SCENE:callFuncWithDelay(3,function()
                levelLayerI:onLevelButtonClicked(s_CURRENT_USER.currentLevelKey)
            end)
        end
        s_SCENE.levelLayerState = s_normal_level_state
        
        -- TODO CHECK level index valid
        
        s_SCENE:callFuncWithDelay(3,function()
            local currentLevelButton = levelLayerI.ccbLevelLayerI['levelSet']:getChildByName(s_CURRENT_USER.currentLevelKey)
            local action = cc.MoveTo:create(1, cc.p(currentLevelButton:getPosition()))
            player:runAction(action)
        end
        )
     elseif s_SCENE.levelLayerState == s_review_boss_appear_state then
        levelLayerI:plotReviewBossAppearOnLevel('level'..(string.sub(s_CURRENT_USER.currentLevelKey,6) + 1))
     elseif s_SCENE.levelLayerState == s_review_boss_pass_state then
        --levelLayerI:plotReviewBossPassOnLevel('level'..(string.sub(s_CURRENT_USER.currentLevelKey,6) + 1))
        -- save and update level data
        s_CURRENT_USER:setUserLevelDataOfStars(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey,2)
        s_CURRENT_USER.currentLevelKey = 'level'..(string.sub(s_CURRENT_USER.currentLevelKey, 6) + 1)
        s_CURRENT_USER:setUserLevelDataOfUnlocked(s_CURRENT_USER.currentChapterKey,s_CURRENT_USER.currentLevelKey, 1)
        -- plot unlock level animation
        levelLayerI:plotUnlockLevelAnimation(s_CURRENT_USER.currentLevelKey)
        -- plot player animation
        s_SCENE:callFuncWithDelay(1.3,function()
            local targetPosition = levelLayerI:getPlayerPositionForLevel(s_CURRENT_USER.currentLevelKey)
            local action = cc.MoveTo:create(0.8, targetPosition)
            player:runAction(action)      
        end)

        -- update level state and plot popup(call on level button clicked)
        --if s_SCENE.levelLayerState == s_unlock_normal_plotInfo_state then
            s_SCENE:callFuncWithDelay(3,function()
                levelLayerI:onLevelButtonClicked(s_CURRENT_USER.currentLevelKey)
            end)
        --end
        s_SCENE.levelLayerState = s_normal_level_state
     end
     s_CURRENT_USER:updateDataToServer()
end

function LevelLayer:ctor()
    
    local levelStypeI = require('view.level.LevelLayerI')
    local levelStypeII = require('view.level.LevelLayerII')
    local connectionLayer1_2 = require('view.level.connection.Connection1_2')
    levelLayerI = levelStypeI.create()
    levelLayerII = levelStypeII.create()
    connection1_2 = connectionLayer1_2.create()
    --s_CURRENT_USER:initChapterLevelAfterLogin()
    -- plot player position
    local currentLevelButton = levelLayerI.ccbLevelLayerI['levelSet']:getChildByName(s_CURRENT_USER.currentLevelKey)
    local image = 'image/chapter_level/gril_head.png'
    player = cc.MenuItemImage:create(image,image,image)
    player:setEnabled(false)
    player:setPosition(currentLevelButton:getPosition())
    player:setScale(0.4)
    levelLayerI.ccbLevelLayerI['levelSet']:addChild(player, 5)
    
    -- level layer state manager
    self:levelStateManager()
--    local scrollViewNode = ccui.ScrollView:create()    
-- -- scroll view scroll
--    local function scrollViewDidScroll()
--        print 'scrollview did scroll'
--        print(scrollViewNode:getPosition())
--    end
--    
--    local function scrollViewDidZoom()
--        print 'scrollview did zoom'
--    end
--    
--    if nil ~= scrollViewNode then
--        local fullWidth = levelLayerI:getContentSize().width
--        scrollViewNode:setPosition((s_DESIGN_WIDTH - fullWidth) / 2, 0)
--        scrollViewNode:setContentSize(fullWidth, s_DESIGN_HEIGHT)
--        scrollViewNode:setInnerContainerSize(cc.size(fullWidth, levelLayerI:getContentSize().height))  
--        scrollViewNode:addChild(levelLayerI) 
--        scrollViewNode:setTouchEnabled(true)
--        scrollViewNode:scrollToPercentVertical(90,1, true)
--        self:addChild(scrollViewNode)
--    end
--
    local function listViewEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_START then
            print("select child index = ",sender:getCurSelectedIndex())
            local item1 = sender:getItem(0)
            
            if sender:getCurSelectedIndex() == 2 then
                connection1_2:plotUnlockChapterAnimation()
            end
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
    -- create list view
    local listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
        --listView:setBounceEnabled(true)
    local fullWidth = levelLayerI:getContentSize().width
    listView:setContentSize(fullWidth, s_DESIGN_HEIGHT)
    listView:setPosition(cc.p((s_DESIGN_WIDTH - fullWidth) / 2, 0))
    listView:addEventListener(listViewEvent)
    listView:addScrollViewEventListener(scrollViewEvent)
    self:addChild(listView)
    
    
    -- add list view item1
    local item1 = ccui.Layout:create()
    item1:setTouchEnabled(true)
    item1:setContentSize(levelLayerI:getContentSize())    
    levelLayerI:setPosition(cc.p(0, 0))
    item1:addChild(levelLayerI)
    item1:setPosition(cc.p(100, 1000))
    listView:pushBackCustomItem(item1)     

    -- add list view connection 
    local item1_2 = ccui.Layout:create()
    item1_2:setTouchEnabled(true)
    item1_2:setContentSize(connection1_2:getContentSize())
    connection1_2:setPosition(cc.p(0,0))
    item1_2:addChild(connection1_2)
    listView:pushBackCustomItem(item1_2)
    
    -- add list view item2
    local item2 = ccui.Layout:create()
    item2:setTouchEnabled(true)
    item2:setContentSize(levelLayerII:getContentSize())    
    levelLayerII:setPosition(cc.p(0, 0))
    item2:addChild(levelLayerII)
    --listView:insertCustomItem(item2,2)
    listView:pushBackCustomItem(item2)
    listView:setInnerContainerSize(cc.size(item1:getContentSize().width,item1:getContentSize().height+item2:getContentSize().height))
    print_lua_table(listView:getInnerContainerSize())
    --s_CURRENT_USER.currentLevelKey = 'level12'
    local currentVerticalPercent = string.sub(s_CURRENT_USER.currentSelectedLevelKey,6)/12.0 * 30+1
    listView:scrollToPercentVertical(currentVerticalPercent,0,false)
    
    --listView:scrollToPercentVertical(50,0,false)
--    local item1_2 = ccui.Layout:create()
--    local connection1_2 = cc.Scale9Sprite:create('ccb/ccbResources/chapter_level/connection/connection_xuanxiaoguan1-2_background.png')
--    item1_2:setContentSize(connection1_2:getContentSize())
--    connection1_2:setPosition(cc.p(item1_2:getContentSize().width/2, item1_2:getContentSize().height/2))
--    local chapterImage = cc.Sprite:create('image/chapter_level/tittle_xuanxiaoguan2_losangles.png')
--    chapterImage:setPosition(connection1_2:getContentSize().width/2, connection1_2:getContentSize().height/2)
--    connection1_2:addChild(chapterImage)
--    item1_2:addChild(connection1_2)
--    listView:pushBackCustomItem(item1_2)
--    local item2 = ccui.Layout:create()
--    item2:setTouchEnabled(true)
--    item2:setContentSize(levelLayerII:getContentSize())    
--    levelLayerII:setPosition(cc.p(item2:getContentSize().width/2, item2:getContentSize().height/2))
--    item2:addChild(levelLayerII)
--    listView:pushBackCustomItem(item2)
--    --listView:insertCustomItem(item1, 0)


    -- right top node

    local IntroLayer = require("view.hud.RightTopNode")
    local introLayer = IntroLayer.create()
    self:addChild(introLayer)
    
    local click_home = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            local IntroLayer = require("view.home.HomeLayer")
            local introLayer = IntroLayer.create()  
            s_SCENE:replaceGameLayer(introLayer)
        end
    end
    
    
    -- return to homepage button
    local homeButton = ccui.Button:create("image/chapter_level/button_home_book.png","image/chapter_level/button_home_book.png","")
    homeButton:addTouchEventListener(click_home)
    homeButton:ignoreAnchorPointForPosition(false)
    homeButton:setAnchorPoint(0,1)
    homeButton:setPosition(s_LEFT_X + 50  , s_DESIGN_HEIGHT - 50 )
    homeButton:setLocalZOrder(1)
    self:addChild(homeButton)
    
    
--    -- pause call
--    
--    local click_pause = function(sender, eventType)
--        if eventType == ccui.TouchEventType.began then
--            local IntroLayer = require("view/Pause")
--            local introLayer = IntroLayer.create()  
--            s_SCENE:popup(introLayer)
--
--            local action1 = cc.MoveTo:create(0.3, cc.p(0,-600))          
--            introLayer:runAction(action1)
--        end
--    end
--    
--    -- pause node
--    
--    local pauseButton = ccui.Button:create("image/button/pauseButtonWhite.png", "image/button/pauseButtonWhite.png", "")
--    pauseButton:addTouchEventListener(click_pause)
--    pauseButton:ignoreAnchorPointForPosition(false)
--    pauseButton:setAnchorPoint(0,0.5)
--    pauseButton:setPosition(s_LEFT_X  , s_DESIGN_HEIGHT - 100 )
--    pauseButton:setLocalZOrder(1)
--    self:addChild(pauseButton)

    -- level select "s_sound_bgm1"
    playMusic(s_sound_bgm1,true)
    
    
    
end
return LevelLayer