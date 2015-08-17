-- 设计文档
-- https://docs.google.com/document/d/1FEHzKtwvVpyNebCRsNrW98pvs52sbQ2Ks3LpNxI1BF0/edit#

local ShareConfig = require("model.share.ShareConfig")
-- 载入配置


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
	self.time = self.time
	-- 第二种分享类型
	self.loginData = self.array.loginData
	-- 第三种分享类型
	self.unitID = self.array.unitID

	self:init()
end

function SharePopupController:init()
	self.shareFirstRecord = s_CURRENT_USER.shareFirstRecord
	if not self.shareFirstRecord then
		self:createPopup(SHARE_TYPE_FIRST_LEVEL)
		s_CURRENT_USER.shareFirstRecord = true
		saveUserToServer({['shareFirstRecord']=s_CURRENT_USER.shareFirstRecord})
		--打点
		return
	end

	self.shareDateRecord = s_CURRENT_USER.shareDateRecord
	if not is2TimeInSameDay(self.shareDateRecord,os.time()) then
		-- if self.countDays then

		-- end
	end

end

function SharePopupController:createPopup()

end

function SharePopupController:countDays()
	local loginData = self.loginData
	local days = 0
end


return SharePopupController