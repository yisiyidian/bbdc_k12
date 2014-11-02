local HttpRequestClient = {}

---------------------------------------------------------------------------------------------------------------------

-- CQL >>>

--[[
curl -X GET \
  -H "X-AVOSCloud-Application-Id: 9xbbmdasvu56yv1wkg05xgwewvys8a318x655ejuay6yw38l" \
  -H "X-AVOSCloud-Application-Key: 8985fsy50arzouq9l74txc25akvjluygt83qvlcvi46xsagg" \
  -G \
  --data-urlencode 'cql=select * from _User where username="yehanjie1"' \
  https://leancloud.cn/1.1/cloudQuery
]]--
function HttpRequestClient.searchUserByUserName(username, onSucceed, onFailed)
    local cql = "select * from _User where username='" .. username
    s_SERVER.CloudQueryLanguage(cql, onSucceed, onFailed)
end

-- CQL <<<

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