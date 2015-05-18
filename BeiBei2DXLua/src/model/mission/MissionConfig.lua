-- 任务数据 配置文件
-- Author: whe
-- Date: 2015-05-13 19:14:37
--
local MissionConfig = {}

--随机任务数据
--mission_id 	任务的 ID
--type 		任务类型 1普通任务  2特殊任务  3特殊任务中的解锁任务
--condition 任务条件，只有1个数据的,代表任务条件的次数
--					 数据是table的,代表每次任务条件的个数  需要保存一个当前完成任务链的游标
--bean      任务奖励 贝贝豆个数
MissionConfig.randomMission = {
	--普通任务
	{["mission_id"] = "1-1",["type"] = 1,["condition"]= {1},["bean"]=0}, --神秘任务
	{["mission_id"] = "1-2",["type"] = 1,["condition"]= {1},["bean"]=0}, --打卡
	{["mission_id"] = "1-3",["type"] = 1,["condition"]= {1},["bean"]=0}, --趁热打铁
	{["mission_id"] = "1-4",["type"] = 1,["condition"]= {1},["bean"]=0}, --分享
	{["mission_id"] = "1-5",["type"] = 1,["condition"]= {1},["bean"]=0}, --完成一次总结BOSS
	--特殊任务
	{["mission_id"] = "2-1",["type"] = 2,["condition"]= {1},["bean"]=0}, 			--完善信息
	{["mission_id"] = "2-2",["type"] = 2,["condition"]= {1,3,5,10,20},["bean"]=0},	--拥有X个好友
	{["mission_id"] = "2-3",["type"] = 2,["condition"]= {1},["bean"]=0}, 			--下载音频
	--特殊任务中的解锁任务
	{["mission_id"] = "3-1",["type"] = 3,["condition"]= {1},["bean"]=0}, --解锁数据1
	{["mission_id"] = "3-2",["type"] = 3,["condition"]= {1},["bean"]=0}, --解锁数据2
	{["mission_id"] = "3-3",["type"] = 3,["condition"]= {1},["bean"]=0}, --解锁数据4
	{["mission_id"] = "3-4",["type"] = 3,["condition"]= {1},["bean"]=0}, --解锁VIP
}

MissionConfig.MISSION_SHENMI 	= "1-1" --神秘任务
MissionConfig.MISSION_DAKA 		= "1-2"	--打卡
MissionConfig.MISSION_DATIE 	= "1-3" --趁热打铁
MissionConfig.MISSION_FENXIANG 	= "1-4" --分享
MissionConfig.MISSION_ZJBOSS 	= "1-5" --完成一次总结BOSS

MissionConfig.MISSION_INFO 		= "2-1" --完善信息
MissionConfig.MISSION_FRIEND 	= "2-2" --拥有X好友
MissionConfig.MISSION_AUDIO 	= "2-3" --下载音频

MissionConfig.MISSION_DATA1 	= "3-1" --解锁数据1	
MissionConfig.MISSION_DATA2 	= "3-2" --解锁数据2	
MissionConfig.MISSION_DATA3 	= "3-3" --解锁数据3	
MissionConfig.MISSION_VIP 		= "3-4" --解锁VIP 	

--累计登陆的任务类型
MissionConfig.MISSION_LOGIN  	= "MISSION_LOGIN"


--累计登陆任务数据
--key 	任务ID 次序
--value 需要累计登陆的天数
MissionConfig.loginMission = {
	[1] = 1,
	[2] = 2,
	[3] = 5,
	[4] = 10,
	[5] = 15,
	[6] = 20,
	[7] = 25,
	[8] = 30,
	[9] = 35,
	[10] = 40,
	[11] = 45,
	[12] = 50,
	[13] = 55,
	[14] = 60,
	[15] = 65,
	[16] = 70,
	[17] = 75,
	[18] = 80,
	[19] = 85,
	[20] = 90,
	[21] = 95,
	[22] = 100,
}

return MissionConfig