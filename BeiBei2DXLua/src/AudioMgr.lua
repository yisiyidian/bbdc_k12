-- 音频播放
-- 注释添加时间2015年06月02日18:08:52
-- 侯琪
require("cocos.init")

local db = require('model.LocalDatabaseManager')
currentBGM = ""

-- 播放声音，参数（文件，是否循环）
-- 声音一次只能播放一首
-- global.lua里面有常用的音频
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

-- 播放音效，参数（文件）
-- 音效可以播放多个
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
-- 根据s_CURRENT_USER.isSoundAm
-- 判断播放英式美式发音
-- 对应规则
-- s_CURRENT_USER.isSoundAm == 0 英式
-- s_CURRENT_USER.isSoundAm == 1 美式
function getWordSoundFileNamePrefix()
    local isAm = WORD_SOUND_US
    if s_CURRENT_USER ~= nil then 
        if s_CURRENT_USER.isSoundAm == 0 then
            isAm = WORD_SOUND_EN
        end 
    end
    return isAm
end
-- 获取单词文件名
-- us_apple.mp3
-- en_apple.mp3
function getWordSoundFileName(word)
    local isAm = getWordSoundFileNamePrefix()
    local filename = isAm .. '_' .. word .. '.mp3'
    return filename
end
-- 获得单词路径
-- 每本书自带若干音频，外加从音频包中获取的资源 
-- 位置是localPath或
-- 找到音频时，播放
-- 找不到音频时，从http://123.56.84.196/allsounds/获取音频下载地址
function getWordSoundFilePath(word)
    local filename = getWordSoundFileName(word)
    local localPath = cc.FileUtils:getInstance():fullPathForFilename(filename)
    local wordPath = cc.FileUtils:getInstance():getWritablePath().."BookSounds".."/"..s_CURRENT_USER.bookKey.."/"..s_CURRENT_USER.bookKey 
    if cc.FileUtils:getInstance():isFileExist(localPath) then
        print("getWordSoundFilePath localPath Y :" .. localPath)
        return localPath
    elseif cc.FileUtils:getInstance():isFileExist("BookSounds".."/"..s_CURRENT_USER.bookKey.."/"..s_CURRENT_USER.bookKey.."/"..filename) then
        print("getWordSoundFilePath localPath Y :" .. wordPath)
        return wordPath
    else
        print("getWordSoundFilePath localPath N :" .. localPath)
    end

    local downloadPath = cc.FileUtils:getInstance():getWritablePath() .. filename
    print("getWordSoundFilePath downloadPath :" .. downloadPath)
    return downloadPath
end
-- 获取音频下载地址
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
-- 播放单词声音
function playWordSound(word)
    if db.isSoundOn() then
        if isWord(word) then
            local wordPath = cc.FileUtils:getInstance():getWritablePath().."BookSounds".."/"..s_CURRENT_USER.bookKey.."/"..s_CURRENT_USER.bookKey
            local filename = getWordSoundFileName(word)
            if cc.FileUtils:getInstance():isFileExist(filename) then
                print ('playWordSound Y : ' .. filename)
                cc.SimpleAudioEngine:getInstance():playEffect(filename, false)
                return PLAY_WORD_SOUND_YES
            elseif cc.FileUtils:getInstance():isFileExist("BookSounds".."/"..s_CURRENT_USER.bookKey.."/"..s_CURRENT_USER.bookKey.."/"..filename) then
                print ('playWordSound Y : ' .. filename)
                cc.SimpleAudioEngine:getInstance():playEffect("BookSounds".."/"..s_CURRENT_USER.bookKey.."/"..s_CURRENT_USER.bookKey.."/"..filename, false)
                return PLAY_WORD_SOUND_YES
            else
                print ('playWordSound N : ' .. filename)
                return PLAY_WORD_SOUND_NO
            end
        else
            local wordPath = cc.FileUtils:getInstance():getWritablePath().."BookSounds".."/"..s_CURRENT_USER.bookKey.."/"..s_CURRENT_USER.bookKey
            word = string.gsub(word," ","_")
            local filename = getWordSoundFileName(word)
            if cc.FileUtils:getInstance():isFileExist(filename) then
                print ('playWordSound Y : ' .. filename)
                cc.SimpleAudioEngine:getInstance():playEffect(filename, false)
                return PLAY_WORD_SOUND_YES
            elseif cc.FileUtils:getInstance():isFileExist("BookSounds".."/"..s_CURRENT_USER.bookKey.."/"..s_CURRENT_USER.bookKey.."/"..filename) then
                print ('playWordSound Y : ' .. filename)
                cc.SimpleAudioEngine:getInstance():playEffect("BookSounds".."/"..s_CURRENT_USER.bookKey.."/"..s_CURRENT_USER.bookKey.."/"..filename, false)
                return PLAY_WORD_SOUND_YES
            else
                print ('playWordSound N : ' .. filename)
                return PLAY_WORD_SOUND_NO
            end
        end
    end
    return PLAY_WORD_SOUND_UNKNOWN
end
