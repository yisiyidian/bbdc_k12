require('Cocos2d')
require('Cocos2dConstants')
require('common.global')
require('CCBReaderLoad')

local LevelLayerII = class('LevelLayerII', function()
    return cc.Layer:create()
end)

function LevelLayerII.create()
    local layer = LevelLayerII.new()
    return layer
end

-- define touch event
local onTouchBegan = function(touch, event) 
    local touchPosition = touch:getLocation()
    --print(touchPosition.x..','..touchPosition.y)
end

function LevelLayerII:clickLockedLevelAnmation(levelKey)
    local clickedIndex = string.sub(levelKey, 6)
    local clickedButton = self.ccbLevelLayerII['levelSet']:getChildByName(levelKey)
    local lockSprite = clickedButton:getChildByName('lockSprite'..clickedIndex)
    local action1 = cc.MoveBy:create(0.1, cc.p(-5,0))
    local action2 = cc.MoveBy:create(0.1, cc.p(10,0))
    local action3 = cc.MoveBy:create(0.1, cc.p(-10, 0))
    local action4 = cc.Repeat:create(cc.Sequence:create(action2, action3),3)
    local action5 = cc.MoveBy:create(0.1, cc.p(5,0)) 
    local action = cc.Sequence:create(action1, action4, action5, nil)
    lockSprite:runAction(action)

    local action7 = cc.ScaleTo:create(0.15,1.15,0.85)
    local action8 = cc.ScaleTo:create(0.15,0.85,1.15)
    local action9 = cc.ScaleTo:create(0.1, 1, 1)
    clickedButton:runAction(cc.Sequence:create(action7, action8, action9, nil))
end

function LevelLayerII:ctor()
    --    self:initHead()
    self.ccbLevelLayerII = {}
    self.ccbLevelLayerII['onLevelButtonClicked'] = 
    function(levelTag)
        self:onLevelButtonClicked('level'..(levelTag-1))
    end
    self.ccb = {}
    self.ccb['chapter2'] = self.ccbLevelLayerII

    local proxy = cc.CCBProxy:create()
    local contentNode = CCBReaderLoad('ccb/chapter2.ccbi',proxy,self.ccbLevelLayerII,self.ccb)
    self.ccbLevelLayerII['contentNode'] = contentNode
    self.ccbLevelLayerII['levelSet'] = contentNode:getChildByTag(5)
    for i = 1, #self.ccbLevelLayerII['levelSet']:getChildren() do
        self.ccbLevelLayerII['levelSet']:getChildren()[i]:setName('level'..(self.ccbLevelLayerII['levelSet']:getChildren()[i]:getTag()-1))
    end
    contentNode:setContentSize(cc.size(854,4540))
    --print('chapter2--contentNode#####@@@@@@')
    --print_lua_table(contentNode:getContentSize())
    self:setContentSize(contentNode:getContentSize())
    self:addChild(contentNode)

    -- replot levelbutton ui based on the configuration file
    local levelConfig = s_DATA_MANAGER.getLevels(s_CURRENT_USER.bookKey)
    for i = 1, #levelConfig do
        if levelConfig[i]['chapter_key'] == 'chapter1' then
            -- change button image
            local levelButton = self.ccbLevelLayerII['levelSet']:getChildByName(levelConfig[i]['level_key'])
            if string.format('%s',levelConfig[i]['type']) == '1' then
                levelButton:setNormalImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan2_bosslevel_unlocked.png'))
                levelButton:setSelectedImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan2_bosslevel_unlocked.png'))
                if s_CURRENT_USER:getIsLevelUnlocked(levelConfig[i]['chapter_key'],levelConfig[i]['level_key']) then
                    self:plotLevelDecoration(levelConfig[i]['level_key'])
                else
                    local lockLayer = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan2_bosslevel_locked.png')
                    lockLayer:setPosition(levelButton:getContentSize().width/2, levelButton:getContentSize().height/2)
                    lockLayer:setName('lockLayer'..string.sub(levelButton:getName(),6))
                    levelButton:addChild(lockLayer)

                    local lockSprite = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_locked_zongjieboss.png')
                    lockSprite:setPosition(levelButton:getContentSize().width/2, levelButton:getContentSize().height/2+5)
                    lockSprite:setName('lockSprite'..string.sub(levelButton:getName(),6))
                    levelButton:addChild(lockSprite)
                end
            else                 
                if  s_CURRENT_USER:getIsLevelUnlocked(levelConfig[i]['chapter_key'],levelConfig[i]['level_key']) then  
                    self:plotLevelDecoration(levelConfig[i]['level_key'])
                else       
                    local lockLayer = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan2_level_locked.png')
                    lockLayer:setPosition(levelButton:getContentSize().width/2, levelButton:getContentSize().height/2)
                    levelButton:addChild(lockLayer)
                    lockLayer:setName('lockLayer'..string.sub(levelButton:getName(),6))

                    local lockSprite = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_level_locked_Lock.png')
                    lockSprite:setPosition(levelButton:getContentSize().width/2, levelButton:getContentSize().height/2+5)
                    lockSprite:setName('lockSprite'..string.sub(levelButton:getName(), 6))
                    levelButton:addChild(lockSprite)               
                end
            end
        end
    end

    -- register touch event
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function LevelLayerII:onLevelButtonClicked(levelKey)
    s_CURRENT_USER.currentSelectedLevelKey = levelKey
    s_CURRENT_USER.currentChapterKey = 'chapter1'
    --s_logd('LevelLayerI:onLevelButtonClicked: ' .. levelKey .. ', ' .. s_CURRENT_USER.bookKey .. ', ' .. s_CURRENT_USER.currentChapterKey..', selectedKey:'..s_CURRENT_USER.currentSelectedLevelKey)
    local levelButton = self.ccbLevelLayerII['levelSet']:getChildByName(levelKey)
    -- check level type
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,s_CURRENT_USER.currentChapterKey,levelKey)
    local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey, levelKey)
    if s_SCENE.levelLayerState == s_review_boss_appear_state and levelKey == 'level'..(string.sub(s_CURRENT_USER.currentLevelKey,6)+1)then -- review boss appear
        local popupReview = require('popup.PopupReviewBoss')
        local layer = popupReview.create()
        s_SCENE:popup(layer)
    elseif levelData == nil or levelData.isLevelUnlocked == 0 then
        self:clickLockedLevelAnmation(levelKey)
        --locked sound
        playSound(s_sound_clickLocked)
    elseif levelConfig['type'] == 0 then  -- normal level
        local popupNormal = require('popup.PopupNormalLevel')
        local layer = popupNormal.create(levelKey)
        s_SCENE:popup(layer)
    elseif levelConfig['type'] == 1 then -- summaryboss level
        -- check whether summary boss level can be played (starcount)
        if s_CURRENT_USER:getUserCurrentChapterObtainedStarCount() >= levelConfig['summary_boss_stars'] then
            local popupSummary = require('popup.PopupSummarySuccess')
            local layer = popupSummary.create(levelKey, s_CURRENT_USER:getUserCurrentChapterObtainedStarCount(),levelConfig['summary_boss_stars'])
            s_SCENE:popup(layer)
    else
        local popupSummary = require('popup.PopupSummaryFail')
        local layer = popupSummary.create(s_CURRENT_USER:getUserCurrentChapterObtainedStarCount(),levelConfig['summary_boss_stars'])
        s_SCENE:popup(layer)
    end
    end
end

return LevelLayerII