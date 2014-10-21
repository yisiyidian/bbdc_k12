local DataClassBase = require('model/user/DataClassBase')

local DataUser = class("DataUser", function()
    return DataClassBase.new()
end)

function DataUser.create()
    local data = DataUser.new()
    return data
end

function DataUser:ctor()
    self.serverTime                        = ''
    self.username                          = ''
    self.nickname                          = ''
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
end

function DataUser:parseServerData(data)
    for key, value in pairs(self) do
        if nil ~= data[key] then
            self[key] = data[key]
        end
    end
end

return DataUser
