


local PopupNormalLevel = class("PopupNormalLevel", function()
    return cc.Layer:create()
end)

function PopupNormalLevel.create(levelKey)
    local layer = PopupNormalLevel.new(levelKey)
    return layer
end

local width = s_RIGHT_X-s_LEFT_X

function PopupNormalLevel:plotStar(node, starCount)

    -- popup sound "Aluminum Can Open "
    playSound(s_sound_Aluminum_Can_Open)
    
    local star1, star2, star3
    if starCount == 0 then
        star1 = cc.Sprite:create('image/chapter_level/greyStar.png')
        star2 = cc.Sprite:create('image/chapter_level/greyStar.png')
        star3 = cc.Sprite:create('image/chapter_level/greyStar.png')
    elseif starCount == 1 then
        star1 = cc.Sprite:create('image/chapter_level/yellowStar.png')
        star2 = cc.Sprite:create('image/chapter_level/greyStar.png')
        star3 = cc.Sprite:create('image/chapter_level/greyStar.png')
    elseif starCount == 2 then
        star1 = cc.Sprite:create('image/chapter_level/yellowStar.png')
        star2 = cc.Sprite:create('image/chapter_level/yellowStar.png')
        star3 = cc.Sprite:create('image/chapter_level/greyStar.png')
    elseif starCount == 3 then
        star1 = cc.Sprite:create('image/chapter_level/yellowStar.png')
        star2 = cc.Sprite:create('image/chapter_level/yellowStar.png')
        star3 = cc.Sprite:create('image/chapter_level/yellowStar.png')
    end

    star1:setPosition(s_LEFT_X + width * 0.3, node:getContentSize().height*0.67) 
    star2:setPosition(s_LEFT_X + width * 0.5, node:getContentSize().height*0.71)
    star3:setPosition(s_LEFT_X + width * 0.7, node:getContentSize().height*0.67)
    node:addChild(star1)
    node:addChild(star2)
    node:addChild(star3)
end

function PopupNormalLevel:ctor(levelKey)
    self.ccbPopupNormalLevel = {}
    self.ccbPopupNormalLevel['onCloseButtonClicked'] = function()
        self:onCloseButtonClicked()
    end

    self.ccbPopupNormalLevel['onStudyButtonClicked'] = function()
        self:onStudyButtonClicked(levelKey)
    end
    self.ccbPopupNormalLevel['onTestButtonClicked'] = function()
        self:onTestButtonClicked(levelKey)
    end

    self.ccb = {}
    self.ccb['levelKey'] = 1
    self.ccb['popup_normal_level'] = self.ccbPopupNormalLevel
    local proxy = cc.CCBProxy:create()
    local node 
    if s_CURRENT_USER.currentSelectedChapterKey == 'chapter0' then
        node = CCBReaderLoad('res/ccb/popup_normal_level.ccbi', proxy, self.ccbPopupNormalLevel, self.ccb)
    elseif s_CURRENT_USER.currentSelectedChapterKey == 'chapter1' then
        node = CCBReaderLoad('res/ccb/popup_normal_level2.ccbi', proxy, self.ccbPopupNormalLevel, self.ccb)
    else
        node = CCBReaderLoad('res/ccb/popup_normal_level3.ccbi', proxy, self.ccbPopupNormalLevel, self.ccb)
    end
    node:setPosition(0,200)
--    local content = self.ccbPopupNormalLevel['_content']   -- get panel
--    -- set popup style 
--    if s_CURRENT_USER.currentSelectedChapterKey == 'chapter0' then
--        local topIcon = cc.Sprite:create('ccb/ccbResources/popup/tanchu_hawaii_head.png')
--        topIcon:setPosition(content:getContentSize().width/2,content:getContentSize().height)
--        content:addChild(topIcon)
--        local bottomIcon = cc.Sprite:create('ccb/ccbResources/popup/tanchu_hawaii_background.png')
--        bottomIcon:setPosition(content:getContentSize().width/2,content:getContentSize().height*0.1)
--        content:addChild(bottomIcon)
--    end
    
    --s_CURRENT_USER:setUserLevelDataOfIsPlayed(s_CURRENT_USER.currentChapterKey,levelKey,1)
    -- plot stars
    local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentSelectedChapterKey,levelKey)
    
    --print_lua_table(s_CURRENT_USER.levels)
    --print('chapteKey:'..s_CURRENT_USER.currentChapterKey..','..levelKey)
    self:plotStar(node, levelData.stars)
    
    -- plot word count
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,s_CURRENT_USER.currentSelectedChapterKey,levelKey)
    self.ccbPopupNormalLevel['_wordCount']:setString(levelConfig['word_num'])
    -- run action --
    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)
    
    -- add girl hello animation
    local girl_hello = sp.SkeletonAnimation:create('spine/bb_hello_public.json', 'spine/bb_hello_public.atlas',1)
    girl_hello:setPosition(s_LEFT_X + width * 0.4, node:getContentSize().height*0.28)
    girl_hello:addAnimation(0, 'animation', true)
    node:addChild(girl_hello, 5)
    
    -- change the test button
    if levelData.isPlayed == 1 then
        self.ccbPopupNormalLevel['_test']:setBackgroundSpriteForState(cc.Scale9Sprite:create('res/ccb/ccbResources/popup_normal_level/Level_blueButton.png'),cc.CONTROL_STATE_NORMAL)
        self.ccbPopupNormalLevel['_test']:setBackgroundSpriteForState(cc.Scale9Sprite:create('ccb/ccbResources/popup_normal_level/Level_blueButton.png'),cc.CONTROL_STATE_HIGH_LIGHTED)
        self.ccbPopupNormalLevel['_test']:setBackgroundSpriteForState(cc.Scale9Sprite:create('ccb/ccbResources/popup_normal_level/Level_blueButton.png'),cc.CONTROL_STATE_SELECTED)
    else 
        self.ccbPopupNormalLevel['_test']:setVisible(false)
    end
    self:addChild(node)
end

function PopupNormalLevel:onCloseButtonClicked()
    s_logd('on close button clicked')
    s_SCENE:removeAllPopups()
    
    -- button sound
    playSound(s_sound_buttonEffect)
end

function PopupNormalLevel:onStudyButtonClicked(levelKey)
    self:onCloseButtonClicked()   
    s_SCENE.gameLayerState = s_normal_game_state

    s_logd('on study button clicked')
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,s_CURRENT_USER.currentSelectedChapterKey,levelKey)
    s_CorePlayManager.wordList = split(levelConfig.word_content, "|")
--    s_CorePlayManager.newPlayerState = true 
    s_CorePlayManager.initStudyTestState()
    s_CorePlayManager.enterStudyLayer()
    
    -- download sounds of current level
    s_HttpRequestClient.downloadSoundsOfLevel(levelKey, 0, WORD_SOUND_US)
    s_HttpRequestClient.downloadSoundsOfLevel(levelKey, 0, WORD_SOUND_EN)
    -- download sounds of next 5th level
    s_HttpRequestClient.downloadSoundsOfLevel(levelKey, 5, WORD_SOUND_US)
    s_HttpRequestClient.downloadSoundsOfLevel(levelKey, 5, WORD_SOUND_EN)

end

function PopupNormalLevel:onTestButtonClicked(levelKey)
    self:onCloseButtonClicked()
    s_logd('on test button clicked')
    s_SCENE.gameLayerState = s_test_game_state
    
    -- button sound
    playSound(s_sound_buttonEffect)
    
    local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentSelectedChapterKey,levelKey)
    if levelData.isPassed == 1 or s_CURRENT_USER.energyCount >= s_normal_level_energy_cost then
        if levelData.isPassed ~= 1 then
--            s_CURRENT_USER:useEnergys(s_normal_level_energy_cost)

--            -- energy cost "cost"
--            s_SCENE:callFuncWithDelay(0.3,function()
--            playSound(s_sound_cost)
--            
--            end)

        end
        local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,s_CURRENT_USER.currentSelectedChapterKey,levelKey)
        s_CorePlayManager.wordList = split(levelConfig.word_content, "|")
        s_CorePlayManager.initStudyTestState()
        s_CorePlayManager.enterTestLayer()
--    else 
--        local energyInfoLayer = require('popup.PopupEnergyInfo')
--        local layer = energyInfoLayer.create()
--        s_SCENE:popup(layer)
    end
end

return PopupNormalLevel