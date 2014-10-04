
local DataUser = class("DataUser", function()
    return {}
end)

function DataUser.create()
    local data = DataUser.new()

    data.objectId                          = ''
    data.serverTime                        = ''
    data.username                          = ''
    data.password                          = ''
    data.session                           = ''
    
    data.appVersion                        = s_APP_VERSION 
    data.tutorialStep                      = 0 
    data.isSoundAm                         = true 
    data.reviewBossTutorialStep            = 0 
    data.bookKey                           = ''
    data.energyLastCoolDownTime            = -1 
    data.energyCount                       = 7 -- MODEL_MANAGER.energyMaxCount 
    data.wordsCount                        = 0 
    data.masterCount                       = 0 

    data.fansCount                         = 0 
    data.friendsCount                      = 0 
    data.fans                              = {}
    data.friends                           = {}
    
    data.currentWordsIndex                 = 0 
    data.currentChapterIndex               = 0 
    data.currentLevelIndex                 = 0 
    data.currentSelectedLevelIndex         = 0 
    data.stars                             = 0 
    data.bulletinBoardTime                 = 0 
    data.bulletinBoardMask                 = 0

    data.checkInWord                       = ''
    data.checkInWordUpdateDate             = nil
    data.hasCheckInButtonAppeared          = false

//unlock next chapter
@property (nonatomic) int needToUnlockNextChapter;


    return data
end

return DataUser
