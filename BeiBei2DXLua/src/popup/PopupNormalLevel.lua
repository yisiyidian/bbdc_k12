


local PopupNormalLevel = class("PopupNormalLevel", function()
    return cc.Layer:create()
end)

function PopupNormalLevel.create(levelKey)
    local layer = PopupNormalLevel.new(levelKey)
    return layer
end

function PopupNormalLevel:plotStar(node, starCount)
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
    
    star1:setPosition(node:getContentSize().width*0.3, node:getContentSize().height*0.67)
    star2:setPosition(node:getContentSize().width*0.5, node:getContentSize().height*0.71)
    star3:setPosition(node:getContentSize().width*0.7, node:getContentSize().height*0.67)
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
    local node = CCBReaderLoad('res/ccb/popup_normal_level.ccbi', proxy, self.ccbPopupNormalLevel, self.ccb)
    node:setPosition(0,200)
    --s_CURRENT_USER:setUserLevelDataOfIsPlayed(s_CURRENT_USER.currentChapterKey,levelKey,1)
    -- plot stars
    local levelData = s_CURRENT_USER:getUserLevelData(s_CURRENT_USER.currentChapterKey,levelKey)
    
    --print_lua_table(s_CURRENT_USER.levels)
    --print('chapteKey:'..s_CURRENT_USER.currentChapterKey..','..levelKey)
    self:plotStar(node, levelData.stars)
    
    -- plot word count
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,s_CURRENT_USER.currentChapterKey,levelKey)
    self.ccbPopupNormalLevel['_wordCount']:setString(levelConfig['word_num'])
    -- run action --
    local action1 = cc.MoveTo:create(0.3, cc.p(0,0))
    local action2 = cc.EaseBackOut:create(action1)
    node:runAction(action2)
    
    -- add girl hello animation
    local girl_hello = sp.SkeletonAnimation:create('spine/bb_hello_public.json', 'spine/bb_hello_public.atlas',1)
    girl_hello:setPosition(node:getContentSize().width/3, node:getContentSize().height*0.28)
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
end

function PopupNormalLevel:onStudyButtonClicked(levelKey)
    self:onCloseButtonClicked()
    s_logd('on study button clicked')
    if s_CURRENT_USER.energyCount >= s_normal_level_energy_cost then
        -- s_CURRENT_USER:useEnergys(s_normal_level_energy_cost)
        -- download sounds of next level
        local nextLevelKey = string.sub(levelKey, 1, 5) .. tostring(string.sub(levelKey, 6) + 5)
        s_logd(nextLevelKey)
        local nextLevelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey, s_CURRENT_USER.currentChapterKey, nextLevelKey)
        if nextLevelConfig ~= nil then
            local wordList = split(nextLevelConfig.word_content, "|")
            local index = 1
            local total = #wordList
            if total > 0 then
                local downloadFunc
                downloadFunc = function ()
                    s_HttpRequestClient.downloadWordSoundFile(wordList[index], function (objectId, filename, err, isSaved) 
                        s_logd(string.format('%s, %s, %s, %s', tostring(objectId), tostring(filename), tostring(err), tostring(isSaved)))
                        index = index + 1
                        if index <= total then downloadFunc() end 
                    end)
                end

                downloadFunc(handleFunc)
            end
        end

        local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,s_CURRENT_USER.currentChapterKey,levelKey)
        s_CorePlayManager.wordList = split(levelConfig.word_content, "|")
        s_CorePlayManager.initStudyTestState()
        s_CorePlayManager.enterStudyLayer()
    else 
        --s_CURRENT_USER:useEnergys(2)
        local energyInfoLayer = require('popup.PopupEnergyInfo')
        local layer = energyInfoLayer.create()
        s_SCENE:popup(layer)
    end

end

function PopupNormalLevel:onTestButtonClicked(levelKey)
    self:onCloseButtonClicked()
    s_logd('on test button clicked')
    
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,s_CURRENT_USER.currentChapterKey,levelKey)
    s_CorePlayManager.wordList = split(levelConfig.word_content, "|")
    s_CorePlayManager.initStudyTestState()
    s_CorePlayManager.enterTestLayer()
end

return PopupNormalLevel