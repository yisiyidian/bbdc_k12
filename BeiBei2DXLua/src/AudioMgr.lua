require("Cocos2d")
require("Cocos2dConstants")
local db = require('model.LocalDatabaseManager')
currentBGM = ""

function playMusic(filename, isLoop)
    currentBGM = filename
    if db.isMusicOn() then
        local localPath = cc.FileUtils:getInstance():fullPathForFilename(filename) 
        cc.SimpleAudioEngine:getInstance():setMusicVolume(0.5) 
        if cc.FileUtils:getInstance():isFileExist(localPath) then
            cc.SimpleAudioEngine:getInstance():playMusic(localPath, isLoop)
        end
    end
end

function playSound(filename)
    if db.isSoundOn() then
        local localPath = cc.FileUtils:getInstance():fullPathForFilename(filename)
        cc.SimpleAudioEngine:getInstance():setEffectsVolume(1.0)
        if cc.FileUtils:getInstance():isFileExist(localPath) then
            cc.SimpleAudioEngine:getInstance():playEffect(localPath)
        end
    end
end

WORD_SOUND_US = 'us'
WORD_SOUND_EN = 'en'
function getWordSoundFileNamePrefix()
    local isAm = WORD_SOUND_US
    if s_CURRENT_USER ~= nil then 
        if s_CURRENT_USER.isSoundAm == 0 then
            isAm = WORD_SOUND_EN
        end 
    end
    return isAm
end

function getWordSoundFileName(word)
    local isAm = getWordSoundFileNamePrefix()
    local filename = isAm .. '_' .. word .. '.mp3'
    return filename
end

function getWordSoundFilePath(word)
    local filename = 'res/words/' .. getWordSoundFileName(word)
    local localPath = cc.FileUtils:getInstance():fullPathForFilename(filename)
    return localPath
end

function playWordSound(word)
    if db.isSoundOn() then
        local localPath = getWordSoundFilePath(word)
        if cc.FileUtils:getInstance():isFileExist(localPath) then
            cc.SimpleAudioEngine:getInstance():playEffect(localPath, false)
        end
    end
end
