local ProtoBase = require('server.protocol.ProtocolBase')

-- callback(isExist, error)
function isUsernameExist(username, callback)
    local function cb (result, error)
        if error == nil then
            if callback then callback(result.datas.count > 0, nil) end
        else
            if callback then callback(nil, error) end
        end
    end
    local protocol = ProtoBase.create('searchusername', false, {['username']=username}, cb)
    protocol:request()
end

-- 1 data/book
-- 'DataCurrentIndex', 'DataNewPlayState', 'DataTodayReviewBossNum'
function syn( ... )
    -- body
end

-- 1 data
-- DataLevelInfo
-- DataStudyConfiguration

-- 1 data/day
-- DataDailyStudyInfo
-- DataLogIn

-- 1 data/book DataWrongWordBuffer
-- 20 words, book
-- DataBossWord