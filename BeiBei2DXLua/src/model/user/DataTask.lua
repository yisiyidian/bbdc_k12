local DataClassBase = require('model.user.DataClassBase')

-- record count == book count
-- 保存复习BOSS数据

local DataTask = class("DataTask", function()
    return DataClassBase.new()
end)

function DataTask.create()
    local data = DataTask.new()
    return data
end

function DataTask:ctor()
    self.className           = 'DataTask'

    self.bookKey             = ''
    self.lastUpdate          = 0
    
    self.todayTotalTaskNum   = 0
    self.todayRemainTaskNum  = 0
    self.todayTotalBossNum   = 0

end

return DataTask
