local HttpRequestClient = {}

---------------------------------------------------------------------------------------------------------------------

-- callbackFunc: function (index, title, content)
function HttpRequestClient.getBulletinBoard(callbackFunc)
    local retIdx = -1
    local retTitle = ''
    local retContent = ''
    local onSucceed = function (api, result)
        for i, v in ipairs(result.results) do
            local idx = v["index"]
            local t = v["content_top"]
            local ct = v["content"]
            if idx > retIdx then
                retIdx = idx
                retTitle = t
                retContent = ct
            end
        end
        if callbackFunc ~= nil then callbackFunc(retIdx, retTitle, retContent) end
    end
    local onFailed = function (api, code, message, description)
        if callbackFunc ~= nil then callbackFunc(retIdx, retTitle, retContent) end
    end
    s_SERVER.search('classes/WMAV_BulletinBoard', onSucceed, onFailed)
end

---------------------------------------------------------------------------------------------------------------------

-- test: '5430b806e4b0c0d48049e293'
-- onDownloaded: function (objectId, filename, err, isSaved)
function HttpRequestClient.downloadFileFromAVOSWithObjectId(fileObjectId, onDownloaded)
    cx.CXAvos:getInstance():downloadFile(fileObjectId, cc.FileUtils:getInstance():getWritablePath(), 
        function (objectId, filename, err, isSaved)
            s_logd('objectId:' .. fileObjectId .. ', filename:' .. cc.FileUtils:getInstance():getWritablePath() .. filename .. ', error:' .. err .. ', isSaved:' .. tostring(isSaved))
            if onDownloaded ~= nil then onDownloaded(objectId, filename, err, isSaved) end
    end)
end

--[[
    s_HttpRequestClient.downloadWordSoundFile('great', function (objectId, filename, err, isSaved) 
        print(string.format('%s, %s, %s, %s', tostring(objectId), tostring(filename), tostring(err), tostring(isSaved)))
    end)
]]--
local function getWordObject(word, onSucceed, onFailed)
    s_SERVER.search('classes/_File?where={"name":"' .. getWordSoundFileName(word) .. '"}', onSucceed, onFailed)
end
function HttpRequestClient.downloadWordSoundFile(word, onDownloaded)
    local localPath = getWordSoundFilePath(word)
    s_logd('downloadWordSoundFile:' .. localPath)
    if localPath == nil or string.len(localPath) <= 0 or cc.FileUtils:getInstance():isFileExist(localPath) then
        if onDownloaded ~= nil then onDownloaded(nil, localPath, nil, true) end
    else
        getWordObject(word, 
            function (api, result)
                local len = #(result.results)
                if len <= 0 then 
                    if onDownloaded ~= nil then onDownloaded(nil, localPath, 'not found', false) end
                else
                    for i, v in ipairs(result.results) do
                        local objectId = v['objectId']
                        HttpRequestClient.downloadFileFromAVOSWithObjectId(objectId, 
                            function (objectId, filename, err, isSaved)
                                if onDownloaded ~= nil then onDownloaded(objectId, filename, err, isSaved) end                
                            end)
                        break
                    end
                end
            end,
            function (api, code, message, description)
                if onDownloaded ~= nil then onDownloaded(nil, localPath, message, false) end
            end)
    end
end

function HttpRequestClient.downloadSoundsOfNext5thLevel(levelKey)
    local nextLevelKey = string.sub(levelKey, 1, 5) .. tostring(string.sub(levelKey, 6) + 5)
    s_logd(string.format('downloadSoundsOfNext5thLevel: %s, %s, %s', s_CURRENT_USER.bookKey, s_CURRENT_USER.currentChapterKey, nextLevelKey))
    local nextLevelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey, s_CURRENT_USER.currentChapterKey, nextLevelKey)
    if nextLevelConfig == nil or string.len(nextLevelConfig.word_content) <= 0 then
        return
    end

    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        cx.CXAvos:getInstance():downloadWordSoundFiles(
            getWordSoundFileNamePrefix() .. '_', 
            nextLevelConfig.word_content, 
            '.mp3', 
            cc.FileUtils:getInstance():getWritablePath())
    else
        local wordList = split(nextLevelConfig.word_content, "|")
        local index = 1
        local total = #wordList
        if total > 0 then
            local downloadFunc
            downloadFunc = function ()
                s_HttpRequestClient.downloadWordSoundFile(wordList[index], function (objectId, filename, err, isSaved) 
                    s_logd(string.format('%s, %s, %s, %s', tostring(objectId), tostring(filename), tostring(err), tostring(isSaved)))
                    index = index + 1
                    if index <= total then downloadFunc() end 
                end)
            end

            downloadFunc(handleFunc)
        end
    end
end

return HttpRequestClient
