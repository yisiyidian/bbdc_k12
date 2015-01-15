
local DataClassBase = require('model.user.DataClassBase')

local DataNewPlayState = class("DataNewPlayState", function()
    return DataClassBase.new()
end)

function DataNewPlayState.create()
    local data = DataNewPlayState.new()
    return data
end

function DataNewPlayState:ctor()
    self.className = 'DataNewPlayState'
    
    self.bookKey = ''
    self.lastUpdate = 0
    self.playModel = 0
    self.rightWordList = ''
    self.wrongWordList = ''
    self.wordCandidate = ''
end

return DataNewPlayState