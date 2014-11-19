require("Cocos2d")
require("Cocos2dConstants")
local db = require('model.LocalDatabaseManager')

function playMusic(filename, isLoop)
    if db.isMusicOn() then
        local localPath = cc.FileUtils:getInstance():fullPathForFilename(filename) 
        if cc.FileUtils:getInstance():isFileExist(localPath) then
            cc.SimpleAudioEngine:getInstance():playMusic(localPath, isLoop)
        end
    end
end

function playSound(filename)
    if db.isSoundOn() then
        local localPath = cc.FileUtils:getInstance():fullPathForFilename(filename)
        if cc.FileUtils:getInstance():isFileExist(localPath) then
            cc.SimpleAudioEngine:getInstance():playEffect(localPath)
        end
    end
end

function getWordSoundFileNamePrefix()
    local isAm = 'us' -- us en
    if s_CURRENT_USER ~= nil then 
        if s_CURRENT_USER.isSoundAm == 0 then
            isAm = 'en' 
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
