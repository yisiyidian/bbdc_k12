-- 任务Model  对应新的 任务系统 MissionManager
-- Author: whe
-- Date: 2015-05-12 14:02:23

local DataClassBase = require('model.user.DataClassBase')

local DataMission = class("DataMission", function()
    return DataClassBase.new()
end)


function DataMission.create()
    return DataMission.new()
end

function DataMission:ctor()
    self.className 			= 'DataMission'

    self.totalLoginDay 		= 0  --累计登陆天数
    self.lastLoginDate 		= 0  --上一次的登陆时间
    self.taskGenDate 		= 0  --上一次生成任务列表的时间
    self.taskList 			= "" --[[
    任务列表   
    1-1_0_1_1|2-2_0_1_1|3-1_1_2_1       任务ID_任务状态_任务条件_任务游标
	任务状态: 0未完成  1完成  2 已领取
	任务条件: 任务条件的数量,比如完成多少次复习BOSS							
	任务游标: 系列任务的话,会有任务游标,非系列任务,游标为1
    ]]
    self.taskSeriesList        = "" --[[
    1-1_1_0|2-1_1_0   任务ID_任务游标_任务状态
    任务状态:0未完成  1完成  2 已领取
    系列任务的游标,如果是系列任务,则要保存状态到这个列表里
    ]]
end

return DataMission