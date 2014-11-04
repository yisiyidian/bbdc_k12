require('Cocos2d')
require('Cocos2dConstants')
require('common.global')
require('CCBReaderLoad')

local LevelLayerI = class('LevelLayerI', function()
    return cc.Layer:create()
end)

function LevelLayerI.create()
    local layer = LevelLayerI.new()
    return layer
end

function isLevelUnlocked(chapterKey, levelKey) 
    for i = 1, #s_CURRENT_USER.levels do
        if s_CURRENT_USER.levels[i].chapterKey == chapterKey and s_CURRENT_USER.levels[i].levelKey == levelKey then
            if s_CURRENT_USER.levels[i].isLevelUnlocked then
                return true
            else
                return false
            end
        end
    end
end


function plotLevelStar(levelButton, heart)
    local star1, star2, star3
    if heart >= 3 then
        star1 = cc.Sprite:create('image/chapter_level/starFull.png')
        star2 = cc.Sprite:create('image/chapter_level/starFull.png')
        star3 = cc.Sprite:create('image/chapter_level/starFull.png')
    elseif heart == 2 then
        star1 = cc.Sprite:create('image/chapter_level/starFull.png')
        star2 = cc.Sprite:create('image/chapter_level/starFull.png')
        star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
    elseif heart == 1 then
        star1 = cc.Sprite:create('image/chapter_level/starFull.png')
        star2 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
    else
        star1 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        star2 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
    end
    star1:setPosition(30,30)
    star2:setPosition(80,10)
    star3:setPosition(130,30)
    levelButton:addChild(star1, 5)
    levelButton:addChild(star2, 5)
    levelButton:addChild(star3, 5)
end

function LevelLayerI:plotLevelDecoration()
    for i = 0, 11 do
        local levelButton = self.ccbLevelLayerI['levelSet']:getChildByName('level'..i)
        local levelConfig = s_DATA_MANAGER.getLevelConfig(s_BOOK_KEY_NCEE,'Chapter0','level'..i)
        
--        if i == 3 or i == 10 then  -- plot boat animation
--            local boat = sp.SkeletonAnimation:create('spine/first-level-moving-boat-bottom.json', 'spine/first-level-moving-boat-bottom.atlas',1)
--            boat:addAnimation(0, 'anmiation', true)
--            boat:setPosition(levelButton:getContentSize().width/2, -400)
--            levelButton:addChild(boat)
--        end
        
        if levelConfig['type'] == 1 then
            -- add summary boss
            local summaryboss = sp.SkeletonAnimation:create("spine/klschongshangdaoxia.json","spine/klschongshangdaoxia.atlas",1)
            summaryboss:setPosition(0,10)
            summaryboss:addAnimation(0, 'animation',true)
            summaryboss:setScale(0.7)
            levelButton:addChild(summaryboss, 3)
        elseif i % 8 == 0 then
            local deco = sp.SkeletonAnimation:create('spine/xuanxiaoguan1_san_1.json','spine/xuanxiaoguan1_san_1.atlas',1)
            deco:addAnimation(0,'animation',true)
            deco:setPosition(70,90)
            levelButton:addChild(deco, 3)
        elseif i % 8 == 1 then
            local deco = cc.Sprite:create('res/image/chapter_level/xuanxiaoguan1_yezi.png')
            deco:setPosition(120, 130)
            levelButton:addChild(deco, 3)
        elseif i % 8 == 2 then
            local deco = sp.SkeletonAnimation:create('spine/xuanxiaoguan1_san_2.json','spine/xuanxiaoguan1_san_2.atlas',1)
            deco:addAnimation(0,'animation',true)
            deco:setPosition(-10,40)
            levelButton:addChild(deco, 3)
        elseif i % 8 == 3 then
            local deco = cc.Sprite:create('res/image/chapter_level/xuanxiaoguan1_pangxie.png')
            deco:setPosition(70, 110)
            levelButton:addChild(deco, 3)
        elseif i % 8 == 4 then
            local deco = sp.SkeletonAnimation:create('spine/xuanxiaoguan1_shu_1.json','spine/xuanxiaoguan1_shu_1.atlas',1)
            deco:addAnimation(0,'animation',true)
            deco:setPosition(-10,40)
            levelButton:addChild(deco, 3)
        elseif i % 8 == 5 then
            local deco = cc.Sprite:create('res/image/chapter_level/xuanxiaoguan1_yinliao.png')
            deco:setPosition(120, 80)
            levelButton:addChild(deco, 3)
        elseif i % 8 == 6 then
            local deco = sp.SkeletonAnimation:create('spine/xuanxiaoguan1_shu_2.json','spine/xuanxiaoguan1_shu_2.atlas',1)
            deco:addAnimation(0,'animation',true)
            deco:setPosition(60,40)
            levelButton:addChild(deco, 3)
        elseif i % 8 == 7 then
            local deco = cc.Sprite:create('image/chapter_level/xuanxiaoguan1_youyongquan.png')
            deco:setPosition(120, 130)
            levelButton:addChild(deco, 3)
        end
    end
end

-- define touch event
local onTouchBegan = function(touch, event) 
    local touchPosition = touch:getLocation()
    -- plot shark
    --print(touchPosition.x..touchPosition.y)
end

function LevelLayerI:ctor()
    self.ccbLevelLayerI = {}
    self.ccbLevelLayerI['onLevelButtonClicked'] = 
    function(levelTag)
        self:onLevelButtonClicked(levelTag-1)
    end
    self.ccb = {}
    self.ccb['chapter1'] = self.ccbLevelLayerI
    
    local proxy = cc.CCBProxy:create()
    local contentNode = CCBReaderLoad('ccb/chapter1.ccbi',proxy,self.ccbLevelLayerI,self.ccb)
    self.ccbLevelLayerI['contentNode'] = contentNode
    self.ccbLevelLayerI['levelSet'] = contentNode:getChildByTag(5)
    for i = 1, #self.ccbLevelLayerI['levelSet']:getChildren() do
        self.ccbLevelLayerI['levelSet']:getChildren()[i]:setName('level'..(self.ccbLevelLayerI['levelSet']:getChildren()[i]:getTag()-1))
    end
    self:setContentSize(contentNode:getContentSize())
    self:addChild(contentNode)
    self:plotLevelDecoration()
--    local back = sp.SkeletonAnimation:create("spine/3fxzls  xuanxiaoguan  diaoluo.json", "spine/3fxzls  xuanxiaoguan  diaoluo.atlas", 1)
--    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
--    self:addChild(back)      
--    back:addAnimation(0, 'animation', false)
    -- replot levelbutton ui based on the configuration file
    local levelConfig = s_DATA_MANAGER.level_ncee
    for i = 1, #levelConfig do
        if levelConfig[i]['chapter_key'] == 'Chapter0' then
            -- change button image
            local levelButton = self.ccbLevelLayerI['levelSet']:getChildByName(levelConfig[i]['level_key'])
            if string.format('%s',levelConfig[i]['type']) == '1' then
                if not isLevelUnlocked(levelConfig[i]['chapter_key'],levelConfig[i]['level_key']) then
                    levelButton:setNormalImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_unlocked.png'))
                    levelButton:setSelectedImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_unlocked.png'))
                else
                    levelButton:setNormalImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_locked.png'))
                    levelButton:setSelectedImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_locked.png'))
                end
            else 
                if isLevelUnlocked(levelConfig[i]['chapter_key'],levelConfig[i]['level_key']) then
                    levelButton:setNormalImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_level_locked.png')) 
                    levelButton:setSelectedImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_level_locked.png')) 
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

function LevelLayerI:onLevelButtonClicked(levelTag)
    local levelButton = self.ccbLevelLayerI['levelSet']:getChildByName('level'..levelTag)
    -- check level type
    local levelConfig = s_DATA_MANAGER.getLevelConfig('ncee','Chapter0','level'..levelTag)
    if s_SCENE.levelLayerState == s_review_boss_appear_state then -- review boss appear
        local popupReview = require('popup.PopupReviewBoss')
        local layer = popupReview.create()
        s_SCENE:popup(layer)
    elseif levelConfig['type'] == 0 then  -- normal level
        local popupNormal = require('popup.PopupNormalLevel')
        local layer = popupNormal.create(levelTag)
        s_SCENE:popup(layer)
    elseif levelConfig['type'] == 1 then -- summaryboss level
        -- check whether summary boss level can be played (starcount)
        if s_CURRENT_USER.stars >= levelConfig['summary_boss_stars'] then
            local popupSummary = require('popup.PopupSummarySuccess')
            local layer = popupSummary.create(s_CURRENT_USER.stars,levelConfig['summary_boss_stars'])
            s_SCENE:popup(layer)
        else
            local popupSummary = require('popup.PopupSummaryFail')
            local layer = popupSummary.create(s_CURRENT_USER.stars,levelConfig['summary_boss_stars'])
            s_SCENE:popup(layer)
        end
    end
end

return LevelLayerI