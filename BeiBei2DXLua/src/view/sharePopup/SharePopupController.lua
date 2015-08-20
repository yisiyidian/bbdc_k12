-- 设计文档
-- https://docs.google.com/document/d/1FEHzKtwvVpyNebCRsNrW98pvs52sbQ2Ks3LpNxI1BF0/edit#

local ShareConfig = require("model.share.ShareConfig")
-- 载入配置
local SharePopup = require("view.sharePopup.SharePopup")

local SharePopupController = class ("SharePopupController",function ()
	return cc.Layer:create()
end)

function SharePopupController:ctor(array)
	self.array = array
	if self.array == nil or self.array.unitID == 0 then
		return
	end
	-- 第一种分享类型
	self.wordList = self.array.wordList
	self.time = self.array.time
	-- 第二种分享类型
	self.loginData = self.array.loginData
	-- 第三种分享类型
	self.unitID = self.array.unitID

	self.popupType = 0
	self.days = 0
	self:init()
end

function SharePopupController:init()
	if not s_CURRENT_USER.sharePopupController then
		s_CURRENT_USER.sharePopupController = true
		saveUserToServer({['sharePopupController']=s_CURRENT_USER.sharePopupController})
		return
	end

	-- 第三种分享类型
	self.shareThirdRecord = s_CURRENT_USER.shareThirdRecord
	if not self.shareThirdRecord then
		self.popupType = SHARE_TYPE_FIRST_LEVEL
		self:createPopup()
		s_CURRENT_USER.shareThirdRecord = true
		saveUserToServer({['shareThirdRecord']=s_CURRENT_USER.shareThirdRecord})
		AnalyticsShareThirdPopup()
		return
	end

	-- 第二种分享类型
	self.shareSecondRecord = s_CURRENT_USER.shareSecondRecord
	if not is2TimeInSameDay(self.shareSecondRecord,os.time()) then
		s_CURRENT_USER.shareSecondRecord = os.time()
		saveUserToServer({['shareSecondRecord']=s_CURRENT_USER.shareSecondRecord})
		self.days = self:countDays()
		if self.days  > 1 then
			self.popupType = SHARE_TYPE_DATE
			self:createPopup()
			if self.days == 2 then
				AnalyticsShareSecondPopup()
			end
			return
		end
	end

	-- 第一种分享类型
	self.shareFirstPopupDateRecord = s_CURRENT_USER.shareFirstPopupDateRecord
	self.shareFirstPopupNumberEveryDay = s_CURRENT_USER.shareFirstPopupNumberEveryDay
	if not is2TimeInSameDay(self.shareFirstPopupDateRecord,os.time()) then
		s_CURRENT_USER.shareFirstPopupDateRecord = os.time()
		saveUserToServer({['shareFirstPopupDateRecord']=s_CURRENT_USER.shareFirstPopupDateRecord})
		s_CURRENT_USER.shareFirstPopupNumberEveryDay = 0 
		saveUserToServer({['shareFirstPopupNumberEveryDay']=s_CURRENT_USER.shareFirstPopupNumberEveryDay})
	end
	-- 不是同一天，更新时间戳，重置每天的记录


	self.score = self:getScore()
	if self.score == 0 or s_CURRENT_USER.shareFirstPopupNumberEveryDay >= 3 then
		return
	end
	self.popupType = SHARE_TYPE_TIME
	self:createPopup()
	s_CURRENT_USER.shareFirstPopupNumberEveryDay = s_CURRENT_USER.shareFirstPopupNumberEveryDay + 1
	saveUserToServer({['shareFirstPopupNumberEveryDay']=s_CURRENT_USER.shareFirstPopupNumberEveryDay})
	-- 是同一天，更新每天的记录
	self.shareFirstRecord = s_CURRENT_USER.shareFirstRecord
	if not self.shareFirstRecord then
		s_CURRENT_USER.shareFirstRecord = true
		saveUserToServer({['shareFirstRecord']=s_CURRENT_USER.shareFirstRecord})
		AnalyticsShareFirstPopup()
	end
end

function SharePopupController:createPopup()
	if BUILD_TARGET == BUILD_TARGET_DEBUG then
		print("debug 不分享")
		return 
	end

	self.sharePopupRecord = s_CURRENT_USER.sharePopupRecord
	if  is2TimeInSameDay(self.sharePopupRecord,os.time()) then
		print("今天分享过了 不分享")
		return 
	end

	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	local delay = cc.DelayTime:create(1)
	local func = cc.CallFunc:create(function ( ... )
		if self.popupType == SHARE_TYPE_TIME then
			local sharePopup = SharePopup.create(self.popupType,handler(self,self.analytics),self.time,self.score)
			s_SCENE:popup(sharePopup)
		end
		if self.popupType == SHARE_TYPE_DATE then
			local sharePopup = SharePopup.create(self.popupType,handler(self,self.analytics),self.days,s_LocalDatabaseManager.getTotalStudyWordsNumByBookKey(s_CURRENT_USER.bookKey))
			s_SCENE:popup(sharePopup)
		end	
		if self.popupType == SHARE_TYPE_FIRST_LEVEL then
			local sharePopup = SharePopup.create(self.popupType,handler(self,self.analytics))
			s_SCENE:popup(sharePopup)
		end
		s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
	end)
	self:runAction(cc.Sequence:create(delay,func))

end

function SharePopupController:analytics()
	if self.popupType == SHARE_TYPE_TIME then
		AnalyticsShareFirstPopupClick()
	end
	if self.popupType == SHARE_TYPE_DATE then
		AnalyticsShareSecondPopupClick()
	end	
	if self.popupType == SHARE_TYPE_FIRST_LEVEL then
		AnalyticsShareThirdPopupClick()
	end

	self.sharePopupRecord = s_CURRENT_USER.sharePopupRecord
	if not is2TimeInSameDay(self.sharePopupRecord,os.time()) then
		s_CURRENT_USER.sharePopupRecord = os.time()
		saveUserToServer({['sharePopupRecord']=s_CURRENT_USER.sharePopupRecord})
	end
end

function SharePopupController:countDays()
	local loginData = self.loginData
	local days = 0
	for i=1,#loginData do
		if loginData[i].Monday > 0 then
			days = days + 1
		end
		if loginData[i].Tuesday > 0 then
			days = days + 1
		end	
		if loginData[i].Wednesday > 0 then
			days = days + 1
		end	
		if loginData[i].Thursday > 0 then
			days = days + 1
		end	
		if loginData[i].Friday > 0 then
			days = days + 1
		end	
		if loginData[i].Saturday > 0 then
			days = days + 1
		end	
		if loginData[i].Sunday > 0 then
			days = days + 1
		end		
	end
	return days
end

function SharePopupController:getScore()
	local function getLength(word)
		local len = 0
	    local wordTable = {}
	    for k=1,#word do
	        table.insert(wordTable,string.sub(word,k,k))
	    end
	    for k=1,#word do
	        local num = string.byte(wordTable[k])
	        if num < 65 or (num > 90 and num < 97 ) or num > 122 then
	            len = k
	            return len
	        end
	    end	
	    return #word	
	end
	local wordNumber = #self.wordList
	local wordLength = 0
	for i=1,#self.wordList do
		wordLength = wordLength + getLength(self.wordList[i])
	end

	local score = 0
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))  
	if self.time <= wordNumber * 3  + wordLength then
		score = math.random(ShareConfig.score[1],ShareConfig.score[1]+10)
	elseif self.time <= wordNumber * 4  + wordLength then
		score = math.random(ShareConfig.score[2],ShareConfig.score[2]+10)
	elseif self.time <= wordNumber * 5  + wordLength then
		score = math.random(ShareConfig.score[3],ShareConfig.score[3]+10)
	elseif self.time <= wordNumber * 6  + wordLength then
		score = math.random(ShareConfig.score[4],ShareConfig.score[4]+10)
	end
	return score
end


return SharePopupController