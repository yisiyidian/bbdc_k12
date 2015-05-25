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
    self.objectId           = ""
    self.totalLoginDay 		= 0  --累计登陆天数
    self.lastLoginDate 		= 0  --上一次的登陆时间
    self.loginRewardIndex   = 0  --累积登陆的奖励,领取到哪次了 默认是0,领取了第一次奖励,值就是1

    self.curTaskId          = "" --当前随机任务的ID,此ID是任务列表里的ID
    self.taskGenDate 		= 0  --上一次生成任务列表的时间
    self.taskList 			= "" --[[
    任务列表   
    1-1_0_0_1_1|2-2_0_1_1_1|3-1_1_2_2_1       任务ID_任务状态_任务条件_任务总条件_任务游标
	任务状态: 0未完成  1 完成  2 已领取
    任务条件: 当前达到的条件数量
	任务条件总数: 完成任务条件的总数量,比如完成5次复习BOSS,才算事完成任务
	任务游标: 系列任务的话,会有任务游标,非系列任务,游标为1。系列任务第一个,游标也是1,以此递增。
    ]]
    self.taskSeriesList     = "" --[[  结构跟任务列表一样
    2-2_0_1_1_1|3-1_1_2_2_1   任务ID_任务状态_任务条件_任务总条件_任务游标
    任务状态:0未完成  1完成  2 已领取
    系列任务的游标,如果是系列任务,则要保存状态到这个列表里
    ]]

    self.taskCompleteList   = "" --[[
    3-1|3-2
    已经完成的特殊任务的ID  特殊任务只能做一次
    ]]
end

return DataMission