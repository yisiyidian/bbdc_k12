local DataClassBase = require('model.user.DataClassBase')

-- 保存今天需要完成的BOSS数量

local DataTodayReviewBossNum = class("DataTodayReviewBossNum", function()
    return DataClassBase.new()
end)

function DataTodayReviewBossNum.create()
    local data = DataTodayReviewBossNum.new()
    return data
end

function DataTodayReviewBossNum:ctor()
    self.className = 'DataTodayReviewBossNum'
    
    self.bookKey = ''
    self.bossNum = 0
    self.lastUpdate = 0
end

return DataTodayReviewBossNum