local DataClassBase = require('model.user.DataClassBase')

local DataUnit = class("DataUnit", function()
	return DataClassBase.new()
end)

function DataUnit.create()
	local data = DataUnit.new()
	return data
end

function DataUnit:ctor() 
	self.className = 'DataUnit'
	self.bookKey = ''
	self.lastUpdate = 0

	self.unitID = 0   -- unit id 
	self.unitState = 0 -- current unit state (1|2|3|4|5|6|7)
	self.wordList = ''
	self.currentWordIndex = 0  -- current word Index in current unit wordlist
	self.savedToServer = 0
end

function DataUnit.getNoObjectIdDatasFromLocalDB()
    local noObjectIdDatas = {}
    s_LocalDatabaseManager.getDatas('DataUnit', s_CURRENT_USER.objectId, s_CURRENT_USER.username, function (row)
        if row.bookKey ~= '' and row.bookKey ~= nil and row.bookKey == s_CURRENT_USER.bookKey and (row.objectId == '' or row.objectId == nil) then
            local data = DataUnit.create()

            data.bookKey = row.bookKey
            data.lastUpdate = row.lastUpdate

            data.unitID = row.unitID
            data.unitState = row.unitState
            data.wordList = row.wordList
            data.currentWordIndex = row.currentWordIndex
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

return DataUnit