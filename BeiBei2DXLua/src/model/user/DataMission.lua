-- 任务表 对应新的 任务系统
-- Author: whe
-- Date: 2015-05-12 14:02:23
--

local DataClassBase = require('model.user.DataClassBase')

local DataMission = class("DataMission", function()
    return DataClassBase.new()
end)


function DataMission.create()
    return DataMission.new()
end

function DataMission:ctor()
    self.className 			= 'DataMission'


    self.totalLoginDay 		= 1  --累计登陆天数
    self.lastLoginDate 		= 0  --上一次的登陆时间
    self.taskList 			= "" --任务列表   1_0_1|2_0_1|3_1_2       任务ID_任务状态_任务条件
end




return DataTask