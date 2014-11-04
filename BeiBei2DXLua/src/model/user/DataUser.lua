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
    self.isSoundAm                         = true 
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
    self.currentChapterIndex               = 0 
    self.currentLevelIndex                 = 0 
    self.currentSelectedLevelIndex         = 0 
    self.stars                             = 0 
    self.bulletinBoardTime                 = 0 
    self.bulletinBoardMask                 = 0

    self.checkInWord                       = ''
    self.checkInWordUpdateDate             = nil
    self.hasCheckInButtonAppeared          = false

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
end

function DataUser:setUserLevelDataOfStars(chapterKey, levelKey, stars)
    for i = 1, #self.levels do
        if self.levels[i].chapterKey == chapterKey and self.levels[i].levelKey == levelKey then
            self.levels[i].hearts = stars
            s_SERVER.updateData(self.levels[i],
            function(api,result)
            end,
            function(api, code, message, description)
            end)        
        end
    end
end

function DataUser:setUserLevelDataOfUnlocked(chapterKey, levelKey, unlocked)
    for i = 1, #self.levels do
        if self.levels[i].chapterKey == chapterKey and self.levels[i].levelKey == levelKey then
            self.levels[i].isLevelUnlocked = unlocked
            s_SERVER.updateData(self.levels[i],
                function(api,result)
                end,
                function(api, code, message, description)
                end)        
        end
    end
end

return DataUser
