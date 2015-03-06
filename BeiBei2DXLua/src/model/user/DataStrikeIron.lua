local DataClassBase = require('model.user.DataClassBase')

local DataStrikeIron = class("DataStrikeIron", function()
    return DataStrikeIron.new()
end)

function DataStrikeIron.create()
    local data = DataClassBase.new()
    return data
end

function DataStrikeIron:ctor()   
    self.className = 'DataStrikeIron'

    self.bookKey = ''
    self.wordList = ''
end

function DataStrikeIron.getNoObjectIdDatasFromLocalDB()
    local noObjectIdDatas = {}
    s_LocalDatabaseManager.getDatas('DataStrikeIron', s_CURRENT_USER.objectId, s_CURRENT_USER.username, function (row)
        if row.bookKey ~= '' and row.bookKey ~= nil and row.bookKey == s_CURRENT_USER.bookKey and (row.objectId == '' or row.objectId == nil) then
            local data = DataStrikeIron.create()

            data.bookKey = row.bookKey
            data.wordList = row.wordList

            data.className = row.className
            data.objectId = row.objectId
            data.userId = row.userId
            data.username = row.username
            data.createdAt = row.createdAt
            data.updatedAt = row.updatedAt
            
            table.insert(noObjectIdDatas, data)
        end
    end)
    return noObjectIdDatas
end

return DataBossWord