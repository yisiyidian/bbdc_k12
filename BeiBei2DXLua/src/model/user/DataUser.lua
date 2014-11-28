local DataClassBase = require('model/user/DataClassBase')
local DataDailyCheckIn = require('model.user.DataDailyCheckIn')
local DataLogIn = require('model/user/DataLogIn')

local DataUser = class("DataUser", function()
    return DataClassBase.new()
end)

function DataUser.create()
    local data = DataUser.new()
    return data
end

function DataUser:ctor()
    self.className                         = '_User'
    
    self.localTime                         = 0
    self.serverTime                        = 0
    self.username                          = ''
    self.nickName                          = ''
    self.password                          = ''
    self.sessionToken                      = ''
    self.isGuest                           = 1

    self.appVersion                        = s_APP_VERSION 
    self.tutorialStep                      = 0 
    self.isSoundAm                         = 1 
    self.reviewBossTutorialStep            = 0 
    self.bookKey                           = ''
    self.energyLastCoolDownTime            = -1 
    self.energyCount                       = s_energyMaxCount
    self.wordsCount                        = 0 
    self.masterCount                       = 0 

    self.fansCount                         = 0 
    self.friendsCount                      = 0 
    self.fans                              = {}
    self.friends                           = {}
    self.followees                         = {} -- who I follow
    self.followers                         = {} -- who follow me

    self.currentWordsIndex                 = 0 
--    self.currentChapterIndex               = 0 
--    self.currentLevelIndex                 = 0 
--    self.currentSelectedLevelIndex         = 0 
    self.currentChapterKey                 = ''
    self.currentLevelKey                   = ''
    self.currentSelectedLevelKey           = ''
    self.stars                             = 0 
    self.bulletinBoardTime                 = 0 
    self.bulletinBoardMask                 = 0

    self.checkInWord                       = ''
    self.checkInWordUpdateDate             = 0
    self.hasCheckInButtonAppeared          = 0

    self.needToUnlockNextChapter           = 0

    self.dailyCheckInData                  = DataDailyCheckIn.create()
    self.levels                            = {}
    self.logInDatas                        = {}
end

function DataUser:parseServerData(data)
    for key, value in pairs(self) do
        if nil ~= data[key] then
            self[key] = data[key]
        end
    end
end

function DataUser:parseServerLevelData(results)
    local DataLevel = require('model.user.DataLevel')
    --print('--------before server level--------')
    self.levels = {}
    for i, v in ipairs(results) do
        local data = DataLevel.create()
        parseServerDataToUserData(v, data)
        self.levels[i] = data
        --print_lua_table(data)
    end
    --print('-------server level size:'..#self.levels)
end

function DataUser:parseServerDailyCheckInData(results)
    for i, v in ipairs(results) do
        local data = DataDailyCheckIn.create()
        parseServerDataToUserData(v, data)
        self.dailyCheckInData = data
        print_lua_table(data)
        break
    end 
end

function DataUser:parseServerDataLogIn(results)
    local DataDailyCheckIn = require('model.user.DataLogIn')
   self.logInDatas = {}
   for i, v in ipairs(results) do
       local data = DataLogIn.create()
       parseServerDataToUserData(v, data)
       self.logInDatas[i] = data
       print_lua_table(data)
   end 
end

-- who I follow
function DataUser:parseServerFolloweesData(results)
    self.followees = {}
    for i, v in ipairs(results) do
        local data = DataUser.create()
        parseServerDataToUserData(v.followee, data)
        self.followees[i] = data
    end
end

-- who follow me
function DataUser:parseServerFollowersData(results)
    self.followers = {}
    for i, v in ipairs(results) do
        local data = DataUser.create()
        parseServerDataToUserData(v.follower, data)
        self.followers[i] = data
    end
end

function DataUser:parseServerFollowData(obj)
    if obj ~= nil then
        table.insert(self.followees, obj)
    end
end

function DataUser:getUserLevelData(chapterKey, levelKey)  
    --print('begin get user level data: size--'..#self.levels) 
    for i,v in ipairs(self.levels) do
        --s_logd('getUserLevelData: '..v.bookKey .. v.chapterKey .. ', ' .. v.levelKey..',star:'..v.stars..',unlocked:'..v.isLevelUnlocked..','..v.userId..','..v.objectId)
        if v.chapterKey == chapterKey and v.levelKey == levelKey and v.bookKey == s_CURRENT_USER.bookKey then
            return v
        end
    end
    --print('end get user level data')
    return nil
end

function DataUser:getBookChapterLevelData(bookKey, chapterKey, levelKey)
    for i,v in ipairs(self.levels) do
        if v.chapterKey == chapterKey and v.levelKey == levelKey and v.bookKey == bookKey then
            return v
        end
    end
    return nil
end

function DataUser:getUserCurrentChapterObtainedStarCount()
    local count = 0
    for i, v in ipairs(self.levels) do
        --print(v.chapterKey..','..v.levelKey..','..v.stars..','..v.isLevelUnlocked)
        if v.chapterKey == self.currentChapterKey and v.bookKey == self.bookKey then
            local levelConfig = s_DATA_MANAGER.getLevelConfig(self.bookKey,self.currentChapterKey,v.levelKey)
            if levelConfig['type'] == 0 then
                count = count + v.stars
            end
        end
    end
    --print('starCount:'..count)
    return count
end


function DataUser:initLevels()
    for i = 1, #self.levels do
        self.levels[i].chapterKey = 'chapter0'
        self.levels[i].stars = 0
        self.levels[i].levelKey = 'level'..(i-1)
        if self.levels[i].levelKey ~= 'level0' then
            self.levels[i].isLevelUnlocked = 0
        else
            self.levels[i].isLevelUnlocked = 1
        end
        s_UserBaseServer.saveDataObjectOfCurrentUser(self.levels[i],
            function(api,result)
            end,
            function(api, code, message, description)
            end) 
    end
    self.currentChapterKey = 'chapter0'
    self.currentLevelKey = 'level0'
    self.currentSelectedLevelKey = 'level0'
    self:updateDataToServer()
end

function DataUser:initChapterLevelAfterLogin()
    self.currentChapterKey = 'chapter0'
    self.currentLevelKey = 'level0'
    self.currentSelectedLevelKey = 'level0'
    s_SCENE.levelLayerState = s_normal_level_state
    local levelConfig = s_DATA_MANAGER.getLevels(s_CURRENT_USER.bookKey)
    for i, v in ipairs(levelConfig) do
        local levelData = self:getUserLevelData(v['chapter_key'],v['level_key'])
        if levelData ~= nil and levelData.isLevelUnlocked == 1 then
            self.currentChapterKey = v['chapter_key']
            self.currentLevelKey = v['level_key']
            self.currentSeletedLevelKey = v['levelKey']
        else 
            break
        end
--    end
--    self.currentLevelKey = 'level0'
--    self.currentSelectedLevelKey = 'level0'
--    self.currentChapterKey = 'chapter2'
    --s_CURRENT_USER:setUserLevelDataOfUnlocked(self.currentChapterKey,self.currentLevelKey,1)
    --s_SCENE.levelLayerState = s_unlock_next_chapter_state
end

function DataUser:setUserLevelDataOfStars(chapterKey, levelKey, stars)
    local levelData = self:getUserLevelData(chapterKey, levelKey)
    if levelData == nil then
        local DataLevel = require('model.user.DataLevel')
        levelData = DataLevel.create()
        levelData.bookKey = s_CURRENT_USER.bookKey
        levelData.chapterKey = chapterKey
        levelData.levelKey = levelKey
        levelData.stars = stars
        if levelData.stars > 0 then
            levelData.isPassed = 1
        end
        --print('------ before insert table-----')
        print_lua_table(levelData)
        table.insert(self.levels,levelData)
        --print('-------- after insert table -----')
        --print('levels_count:'..#self.levels)
    end
    if levelData.stars < stars then
        levelData.stars = stars
    end
    if levelData.stars > 0 then
        levelData.isPassed = 1
    end
    --print('---print stars: levelData.objectId is '..levelData.objectId)
    s_UserBaseServer.saveDataObjectOfCurrentUser(levelData,
    function(api,result)
        --print('call back stars')
        --print_lua_table(result)
        --print('levelData.objectId:'..levelData.objectId..','..levelData.levelKey)
    end,
    function(api, code, message, description)
    end)        
end

function DataUser:setUserLevelDataOfIsPlayed(chapterKey, levelKey, isPlayed)
    local levelData = self:getUserLevelData(chapterKey, levelKey)
    if levelData == nil then
        local DataLevel = require('model.user.DataLevel')
        levelData = DataLevel.create()
        levelData.bookKey = s_CURRENT_USER.bookKey
        levelData.chapterKey = chapterKey
        levelData.levelKey = levelKey
        levelData.isPlayed = isPlayed
        table.insert(self.levels,levelData)
    end
    levelData.isPlayed = isPlayed
    s_UserBaseServer.saveDataObjectOfCurrentUser(levelData,
        function(api,result)
        end,
        function(api, code, message, description)
        end) 
end

function DataUser:setUserLevelDataOfUnlocked(chapterKey, levelKey, unlocked, onSucceed, onFailed)
    local levelData = self:getUserLevelData(chapterKey, levelKey)
    if levelData == nil then
        local DataLevel = require('model.user.DataLevel')
        levelData = DataLevel.create()
        levelData.bookKey = s_CURRENT_USER.bookKey
        levelData.chapterKey = chapterKey
        levelData.levelKey = levelKey
        levelData.isLevelUnlocked = unlocked
        table.insert(self.levels,levelData)
    end

    levelData.isLevelUnlocked = unlocked
    s_UserBaseServer.saveDataObjectOfCurrentUser(levelData,
        function (api, result)
            --print('call back unlocked')
            local callLevelData = self:getUserLevelData(chapterKey, levelKey)
            callLevelData.objectId = levelData.objectId
            --print('levelData.objectId'..levelData.objectId..','..levelData.levelKey)
            s_DATABASE_MGR.saveDataClassObject(levelData)
            if onSucceed ~= nil then onSucceed(api, result) end
        end,
        function (api, code, message, description)
            if onFailed ~= nil then onFailed(api, code, message, description) end
        end)  
end

function DataUser:getIsLevelUnlocked(chapterKey, levelKey) 
    local levelData = self:getUserLevelData(chapterKey, levelKey)
    if levelData == nil then
        return false
    end
    
    if levelData.isLevelUnlocked ~= 0 then
        return true
    else
        return false
    end
end

-- energy api
function DataUser:resetEnergyLastCoolDownTime()
    if self.energyCount >= s_energyMaxCount then
        self.energyLastCoolDownTime = self.serverTime
    end
    if self.energyLastCoolDownTime > self.serverTime and self.serverTime > 0 then
        self.energyLastCoolDownTime = self.serverTime
    end
end

function DataUser:useEnergys(count)
    self:resetEnergyLastCoolDownTime()
    self.energyCount = self.energyCount - count
    self:updateDataToServer()
end

function DataUser:addEnergys(count)
    self:resetEnergyLastCoolDownTime()
    self.energyCount = self.energyCount + count
    self:updateDataToServer()
end

function DataUser:updateDataToServer()
    s_UserBaseServer.saveDataObjectOfCurrentUser(self,
        function(api,result)
        end,
        function(api, code, message, description)
        end) 
end


return DataUser
