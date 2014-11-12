local DataClassBase = require('model/user/DataClassBase')

local DataUser = class("DataUser", function()
    return DataClassBase.new()
end)

function DataUser.create()
    local data = DataUser.new()
    return data
end

function DataUser:ctor()
    self.className                         = '_User'
    
    self.serverTime                        = 0
    self.username                          = ''
    self.nickName                          = ''
    self.password                          = ''
    self.sessionToken                      = ''

    self.appVersion                        = s_APP_VERSION 
    self.tutorialStep                      = 0 
    self.isSoundAm                         = 1 
    self.reviewBossTutorialStep            = 0 
    self.bookKey                           = ''
    self.energyLastCoolDownTime            = -1 
    self.energyCount                       = 7
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

    self.dailyCheckInData                  = {}
    self.levels                            = {}
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
    self.levels = {}
    for i, v in ipairs(results) do
        local data = DataLevel.create()
        parseServerDataToUserData(v, data)
        self.levels[i] = data
        print_lua_table(data)
    end
end

function DataUser:parseServerDailyCheckInData(results)
    local DataDailyCheckIn = require('model.user.DataDailyCheckIn')
   self.dailyCheckInData = {}
   for i, v in ipairs(results) do
       local data = DataDailyCheckIn.create()
       parseServerDataToUserData(v, data)
       self.dailyCheckInData[i] = data
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

function DataUser:getUserLevelData(chapterKey, levelKey)   
    for i = 1, #self.levels do
        if self.levels[i].chapterKey == chapterKey and self.levels[i].levelKey == levelKey then
            return self.levels[i]
        end
    end
    return nil
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
    self:updateDataToServer()
end

function DataUser:setUserLevelDataOfStars(chapterKey, levelKey, stars)
    local levelData = self:getUserLevelData(chapterKey, levelKey)
    --print('levelData-------------------'..levelData)
    if levelData == nil then
        local DataLevel = require('model.user.DataLevel')
        levelData = DataLevel.create()
        levelData.bookKey = s_CURRENT_USER.bookKey
        levelData.chapterKey = chapterKey
        levelData.levelKey = levelKey
        --levelData.hearts = stars
        levelData.stars = stars
        --print('--------')
        --s_CURRENT_USER.currentChapterKey = 'chapter0'
        
        --self:updateDataToServer()
        --print_lua_table(levelData)
        table.insert(self.levels,levelData)
    end
    
    
    levelData.stars = stars
    --levelData.hearts = stars
    s_UserBaseServer.saveDataObjectOfCurrentUser(levelData,
    function(api,result)
    end,
    function(api, code, message, description)
    end)        
end

function DataUser:setUserLevelDataOfUnlocked(chapterKey, levelKey, unlocked)
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
        function(api,result)
        end,
        function(api, code, message, description)
        end)  
end

function DataUser:isLevelUnlocked(chapterKey, levelKey) 
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
