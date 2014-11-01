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
    
    self.serverTime                        = ''
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

function DataUser:getUserLevelData(chapterKey, levelKey)
    for i = 1, #self.levels do
        if self.levels[i].chapterKey == chapterKey and self.levels[i].levelKey == levelKey then
            return self.levels[i]
        end
    end
end

return DataUser
