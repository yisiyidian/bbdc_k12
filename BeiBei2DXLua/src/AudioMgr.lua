require("Cocos2d")
require("Cocos2dConstants")

function playMusic(filename, isLoop)
    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename(filename) 
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, isLoop)
end

function playSound(filename)
    local effectPath = cc.FileUtils:getInstance():fullPathForFilename(filename)
    cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)
end
