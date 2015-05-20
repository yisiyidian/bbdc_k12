require("cocos.init")
require("common.global")

--记录每本书的进度

local DataClassBase = require('model.user.DataClassBase')

local DataLevelInfo = class("DataLevelInfo", function()
    return DataClassBase.new()
end)

function DataLevelInfo.create()
    local data = DataLevelInfo.new()
    return data
end

DataLevelInfo.BOOKKEY = 'K'

function DataLevelInfo:ctor()
    self.className = 'DataLevelInfo'

    for i, v in ipairs(g_BOOKS) do
        self[DataLevelInfo.BOOKKEY .. v] = 0
    end
end

function DataLevelInfo:getCurrentWordIndex()
    local maxBoss = s_LocalDatabaseManager.getMaxBoss()
    if maxBoss ~= nil then return maxBoss.lastWordIndex + 1 end
    return 1
end

function DataLevelInfo:getWordIndex(bookKey)
    local maxBoss = s_LocalDatabaseManager.getMaxBossByBookKey(bookKey)
    if maxBoss ~= nil then return maxBoss.lastWordIndex + 1 end
    return 1
end

function DataLevelInfo:getBookCurrentLevelIndex()
    local progress = self:getLevelInfo(s_CURRENT_USER.bookKey)
    return progress
end

function DataLevelInfo:getLevelInfo(bookKey)
    print_lua_table(g_BOOKKEYS)
    print_lua_table(g_BOOKS)

    for i, v in ipairs(g_BOOKKEYS) do
        if v == bookKey then
            return self[DataLevelInfo.BOOKKEY .. g_BOOKS[i]]
        end
    end
    return 0
end

function DataLevelInfo:computeCurrentProgress()
     return s_LocalDatabaseManager.getMaxUnitID() - 1
end

function DataLevelInfo:getDataFromLocalDB()
    updateDataFromUser(self, s_CURRENT_USER)
    s_LocalDatabaseManager.getDatas(self.className, s_CURRENT_USER.objectId, s_CURRENT_USER.username, function (row)
        parseLocalDBDataToClientData(row, self)
        updateDataFromUser(self, s_CURRENT_USER)
    end)
end

function DataLevelInfo:updateDataToServer()
    local currentProgress = self:computeCurrentProgress() 
    local oldProgress = self:getLevelInfo(s_CURRENT_USER.bookKey) 
    saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
    -----------------------------
    bookKey = s_CURRENT_USER.bookKey
    for i, v in ipairs(g_BOOKKEYS) do
        if v == bookKey then
            self[DataLevelInfo.BOOKKEY .. g_BOOKS[i]] = currentProgress
        end
    end
    self:sysData()

end

function DataLevelInfo:sysData()
    sysLevelInfo(self, function (serverData, error)
        if serverData ~= nil then parseServerDataToClientData(serverData, self) end
        s_LocalDatabaseManager.saveDataClassObject(self, s_CURRENT_USER.userId, s_CURRENT_USER.username)
    end)
end

return DataLevelInfo
