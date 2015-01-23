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
end

return DataBossWord
