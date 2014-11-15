require("Cocos2d")
require("Cocos2dConstants")
local db = require('model.LocalDatabaseManager')

function playMusic(filename, isLoop)
    if db.isMusicOn() then
        local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename(filename) 
        if bgMusicPath ~= nil then
            cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, isLoop)
        end
    end
end

function playSound(filename)
    if db.isSoundOn() then
        local effectPath = cc.FileUtils:getInstance():fullPathForFilename(filename)
        if effectPath ~= nil then
            cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)
        end
    end
end

function playWordSound(word)
    local isAm = 'us' -- us en
    if s_CURRENT_USER ~= nil then 
        if s_CURRENT_USER.isSoundAm == 0 then
            isAm = 'en' 
        end 
    end
    playSound('res/words/' .. isAm .. '_' .. word .. 'mp3')
end
