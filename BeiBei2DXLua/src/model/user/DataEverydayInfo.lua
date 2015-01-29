local DataClassBase = require('model.user.DataClassBase')

---------------------------------------------------------------------------------------------------

local CLASSNAME = 'DataEverydayInfo'

WEEKDAYSTATE_NONE = 0
WEEKDAYSTATE_LOGEDIN = 1
WEEKDAYSTATE_CHECKEDIN = 2

---------------------------------------------------------------------------------------------------

local DataEverydayInfo = class(CLASSNAME, function()
    return DataClassBase.new()
end)

---------------------------------------------------------------------------------------------------

function DataEverydayInfo.create()
    local data = DataEverydayInfo.new()
    return data
end

---------------------------------------------------------------------------------------------------

function DataEverydayInfo:ctor()
    self.className = CLASSNAME
    
    self.Monday = WEEKDAYSTATE_NONE
    self.Tuesday = WEEKDAYSTATE_NONE
    self.Wednesday = WEEKDAYSTATE_NONE
    self.Thursday = WEEKDAYSTATE_NONE
    self.Friday = WEEKDAYSTATE_NONE
    self.Saturday = WEEKDAYSTATE_NONE
    self.Sunday = WEEKDAYSTATE_NONE
    
    self.week = 0
end

-- first day is Sunday
function getWeekDay(secondsFrom1970)
    local dd = os.date("*t", secondsFrom1970)
    return dd.wday
end

function getCurrentLogInWeek(offsetSeconds_1stPlay_now)
    local ret = offsetSeconds_1stPlay_now / (7 * 24 * 60 * 60.0)
    return math.ceil(ret)
end

local function setWeekDayState(DataEverydayInfo, secondsFrom1970, weekDayState)
    local wd = getWeekDay(secondsFrom1970)
    if wd == 1 then
        DataEverydayInfo.Sunday = weekDayState
    elseif wd == 2 then
        DataEverydayInfo.Monday = weekDayState
    elseif wd == 3 then
        DataEverydayInfo.Tuesday = weekDayState
    elseif wd == 4 then
        DataEverydayInfo.Wednesday = weekDayState
    elseif wd == 5 then
        DataEverydayInfo.Thursday = weekDayState
    elseif wd == 6 then
        DataEverydayInfo.Friday = weekDayState
    elseif wd == 7 then
        DataEverydayInfo.Saturday = weekDayState
    end
end

function DataEverydayInfo:setWeekDay(secondsFrom1970)
    setWeekDayState(self, secondsFrom1970, WEEKDAYSTATE_LOGEDIN)
end

function DataEverydayInfo:checkIn(secondsFrom1970)
    setWeekDayState(self, secondsFrom1970, WEEKDAYSTATE_CHECKEDIN)
end

function DataEverydayInfo:getDays()
    return {self.Monday,
    self.Tuesday,
    self.Wednesday,
    self.Thursday,
    self.Friday,
    self.Saturday,
    self.Sunday}
end

function DataEverydayInfo:updateFrom(otherDataEverydayInfo)
    if self.week ~= otherDataEverydayInfo.week 
        or (self.objectId ~= nil and string.len(self.objectId) > 0 and self.objectId ~= otherDataEverydayInfo.objectId) then 
        return false 
    end
    
    if (self.objectId == nil or string.len(self.objectId) <= 0) and otherDataEverydayInfo.objectId ~= nil then
        self.objectId = otherDataEverydayInfo.objectId
    end
    local keys = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'}
    for i, v in ipairs(keys) do
        if self[v] < otherDataEverydayInfo[v] then
            self[v] = otherDataEverydayInfo[v]
        end
    end
    
    return true
end

---------------------------------------------------------------------------------------------------

function DataEverydayInfo.getAllDatasFromLocalDB(handleRow)
    local localDatas = s_LocalDatabaseManager.getDatas(CLASSNAME, s_CURRENT_USER.objectId, s_CURRENT_USER.username, handleRow)
    return localDatas
end

function DataEverydayInfo.getNoObjectIdAndCurrentWeekDatasFromLocalDB()
    local noObjectIdDatas = {}
    local currentWeek = nil
    local week = getCurrentLogInWeek(os.time() - s_CURRENT_USER.localTime)
    s_LocalDatabaseManager.getDatas(CLASSNAME, s_CURRENT_USER.objectId, s_CURRENT_USER.username, function (row)
        if row.week == week then
            currentWeek = row
        elseif row.objectId == '' or row.objectId == nil then
            table.insert(noObjectIdDatas, row)
        end
    end)
    return {['noObjectIdDatas']=noObjectIdDatas, ['currentWeek']=currentWeek}
end

---------------------------------------------------------------------------------------------------

return DataEverydayInfo
