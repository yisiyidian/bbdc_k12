local DataClassBase = require('model/user/DataClassBase')

local DataBookProgress = class("DataBookProgress", function()
    return DataClassBase.new()
end)

function DataBookProgress.create()
    local data = DataBookProgress.new()
    return data
end

function DataBookProgress:ctor()
    self.className = 'DataBookProgress'
    self.CET4 = 'cet4|chapter0|level0'
    self.CET6 = 'cet6|chapter0|level0'
    self.GMAT = 'gmat|chapter0|level0'
    self.GRE = 'gre|chapter0|level0'
    self.GSE = 'gse|chapter0|level0'
    self.IELTS = 'ielts|chapter0|level0'
    self.MIDDLE = 'middle|chapter0|level0'
    self.NCEE = 'ncee|chapter0|level0'
    self.PRIMARY = 'primary|chapter0|level0'
    self.PRO4 = 'pro4|chapter0|level0'
    self.PRO8 = 'pro8|chapter0|level0'
    self.SAT = 'sat|chapter0|level0'
    self.TOEFL = 'toefl|chapter0|level0'
end

return DataBookProgress
