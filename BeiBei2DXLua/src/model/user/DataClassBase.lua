local DataClassBase = class("DataClassBase", function()
    return {}
end)

function DataClassBase.create()
    local data = DataClassBase.new()
    return data
end

function DataClassBase:ctor()
    self.userId = ''
    self.createdAt = os.time()
    self.updatedAt = 0
end

return DataClassBase
