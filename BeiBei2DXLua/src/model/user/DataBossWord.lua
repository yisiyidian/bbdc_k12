local DataClassBase = require('model.user.DataClassBase')

-- record count == book count
-- 保存复习BOSS数据

local DataBossWord = class("DataBossWord", function()
    return DataClassBase.new()
end)

function DataBossWord.create()
    local data = DataBossWord.new()
    return data
end

function DataBossWord:ctor()
    self.className = 'DataBossWord'
    
    self.bookKey = ''
    self.lastUpdate = 0

    self.bossID = 0
    self.typeIndex = 0
    self.wordList = ''
    self.lastWordIndex = 0
    self.savedToServer = 0 -- wordList
end

function DataBossWord.getNoObjectIdDatasFromLocalDB()
    local noObjectIdDatas = {}
    s_LocalDatabaseManager.getDatas('DataBossWord', s_CURRENT_USER.objectId, s_CURRENT_USER.username, function (row)
        if row.bookKey ~= '' and row.bookKey ~= nil and row.bookKey == s_CURRENT_USER.bookKey and (row.objectId == '' or row.objectId == nil) then
            local data = DataBossWord.create()

            data.bookKey = row.bookKey
            data.lastUpdate = row.lastUpdate

            data.bossID = row.bossID
            data.typeIndex = row.typeIndex
            data.wordList = row.wordList
            data.lastWordIndex = row.lastWordIndex
            data.savedToServer = row.savedToServer

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
