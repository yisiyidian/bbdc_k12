local DataClassBase = require('model/user/DataClassBase')

local DataConfigs = class("DataConfigs", function()
    return DataClassBase.new()
end)

function DataConfigs.create()
    local data = DataConfigs.new()
    return data
end

function DataConfigs.getKeys()
    return {'text',
    'starRule',
    'review_boss',
    'lv_toefl',
    'lv_ncee',
    'lv_ielts',
    'lv_cet6',
    'lv_cet4',
    'items',
    'energy',
    'dailyCheckIn',
    'chapters',
    'books',
    'allwords'}
end

DataConfigsVer = '_ver'

function DataConfigs:ctor()
    self.className = 'DataConfigs'

    self.version = s_CONFIG_VERSION
    for i, v in ipairs(DataConfigs.getKeys()) do
        self[v] = ''
        self[v .. DataConfigsVer] = s_CONFIG_VERSION
    end
end

return DataConfigs
