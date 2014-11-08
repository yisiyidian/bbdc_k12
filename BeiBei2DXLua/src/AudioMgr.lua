require("Cocos2d")
require("Cocos2dConstants")
local db = require('model.LocalDatabaseManager')

function playMusic(filename, isLoop)
    if db.isMusicOn() then
        local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename(filename) 
        cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, isLoop)
    end
end

function playSound(filename)
    if db.isSoundOn() then
        local effectPath = cc.FileUtils:getInstance():fullPathForFilename(filename)
        cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)
    end
end
