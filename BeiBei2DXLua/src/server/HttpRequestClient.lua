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

return HttpRequestClient