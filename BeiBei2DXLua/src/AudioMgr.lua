require("cocos.init")

local db = require('model.LocalDatabaseManager')
currentBGM = ""

function playMusic(filename, isLoop)
    currentBGM = filename
    if db.isMusicOn() then
        if cc.SimpleAudioEngine:getInstance():isMusicPlaying() then
        	cc.SimpleAudioEngine:getInstance():stopMusic()
        end
        local localPath = cc.FileUtils:getInstance():fullPathForFilename(filename) 
        cc.SimpleAudioEngine:getInstance():setMusicVolume(0.2) 
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

function playSoundByVolume(filename,volume,isLoop)
    if db.isSoundOn() then
        local localPath = cc.FileUtils:getInstance():fullPathForFilename(filename)
        cc.SimpleAudioEngine:getInstance():setEffectsVolume(volume)
        if cc.FileUtils:getInstance():isFileExist(localPath) then
            cc.SimpleAudioEngine:getInstance():playEffect(localPath,isLoop)
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
    local filename = getWordSoundFileName(word)
    
    local localPath = cc.FileUtils:getInstance():fullPathForFilename(filename)
    if cc.FileUtils:getInstance():isFileExist(localPath) then
        print("getWordSoundFilePath localPath Y :" .. localPath)
        return localPath
    else
        print("getWordSoundFilePath localPath N :" .. localPath)
    end

    local downloadPath = cc.FileUtils:getInstance():getWritablePath() .. filename
    print("getWordSoundFilePath downloadPath :" .. downloadPath)
    return downloadPath
end

function getWordSoundFileDownloadURLs(word)
    local us = WORD_SOUND_US .. '_' .. word .. '.mp3'
    local en = WORD_SOUND_EN .. '_' .. word .. '.mp3'

    local url = 'http://123.56.84.196/allsounds/'
    local us_url = url .. us
    local en_url = url .. en

    return {[1]=us_url, [2]=en_url, [3]=us, [4]=en}
end

PLAY_WORD_SOUND_YES     = 'PLAY_WORD_SOUND_YES'
PLAY_WORD_SOUND_NO      = 'PLAY_WORD_SOUND_NO'
PLAY_WORD_SOUND_UNKNOWN = 'PLAY_WORD_SOUND_UNKNOWN'
function playWordSound(word)
    if db.isSoundOn() then
        local filename = getWordSoundFileName(word)
                
        if cc.FileUtils:getInstance():isFileExist(filename) then
            print ('playWordSound Y : ' .. filename)
            cc.SimpleAudioEngine:getInstance():playEffect(filename, false)
            return PLAY_WORD_SOUND_YES
        else
            print ('playWordSound N : ' .. filename)
            return PLAY_WORD_SOUND_NO
        end
    end
    return PLAY_WORD_SOUND_UNKNOWN
end
