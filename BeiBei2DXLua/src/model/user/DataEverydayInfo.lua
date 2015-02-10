local DataClassBase = require('model.user.DataClassBase')

---------------------------------------------------------------------------------------------------

local CLASSNAME = 'DataEverydayInfo'

WEEKDAYSTATE_NONE = 0
WEEKDAYSTATE_LOGEDIN = 1

WEEKDAYSTATE_CHECKEDIN_MASK = nil

WEEKDAYSTATE_GETREWARD_KEY = 'getreward'

---------------------------------------------------------------------------------------------------

local DataEverydayInfo = class(CLASSNAME, function()
    return DataClassBase.new()
end)

---------------------------------------------------------------------------------------------------

function DataEverydayInfo.initCheckedInMask()
    if WEEKDAYSTATE_CHECKEDIN_MASK == nil then
        WEEKDAYSTATE_CHECKEDIN_MASK = {}
        for i, v in ipairs(g_BOOKKEYS) do
            WEEKDAYSTATE_CHECKEDIN_MASK[v] = math.pow(2, i) -- 1st bit is WEEKDAYSTATE_LOGEDIN
        end
        WEEKDAYSTATE_CHECKEDIN_MASK[WEEKDAYSTATE_GETREWARD_KEY] = math.pow(2,30)
        print('DataEverydayInfo.initCheckedInMask()')
        print_lua_table(WEEKDAYSTATE_CHECKEDIN_MASK)
    end
end

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

function getCurrentLogInWeek(currentTime,localTime)
    local ret = (currentTime - localTime) / (7 * 24 * 60 * 60.0)
    local t = math.ceil(ret) + getNumberOfWeekDay(localTime) - getNumberOfWeekDay(currentTime)
    t = t / 7 + 1
    if t - math.floor(t) > 0.5 then
        t = math.ceil(t)
    else
        t = math.floor(t)
    end
    return t
end

function getNumberOfWeekDay(time)
    local w = tonumber(os.date('%w',time),10)
    if w == 0 then 
        w = 7
    end
    return w
end

local function setWeekDayState(everydayInfo, secondsFrom1970, weekDayState)
    local wd = getWeekDay(secondsFrom1970)
    if wd == 1 then
        everydayInfo.Sunday = weekDayState
    elseif wd == 2 then
        everydayInfo.Monday = weekDayState
    elseif wd == 3 then
        everydayInfo.Tuesday = weekDayState
    elseif wd == 4 then
        everydayInfo.Wednesday = weekDayState
    elseif wd == 5 then
        everydayInfo.Thursday = weekDayState
    elseif wd == 6 then
        everydayInfo.Friday = weekDayState
    elseif wd == 7 then
        everydayInfo.Saturday = weekDayState
    end
end

local function getWeekDayState(everydayInfo, secondsFrom1970)
    local wd = getWeekDay(secondsFrom1970)
    if wd == 1 then
        return everydayInfo.Sunday
    elseif wd == 2 then
        return everydayInfo.Monday
    elseif wd == 3 then
        return everydayInfo.Tuesday
    elseif wd == 4 then
        return everydayInfo.Wednesday
    elseif wd == 5 then
        return everydayInfo.Thursday
    elseif wd == 6 then
        return everydayInfo.Friday
    elseif wd == 7 then
        return everydayInfo.Saturday
    end
end

function DataEverydayInfo:setWeekDay(secondsFrom1970)
    setWeekDayState(self, secondsFrom1970, WEEKDAYSTATE_LOGEDIN)
end

function DataEverydayInfo:checkIn(secondsFrom1970, bookKey)
    local weekDayState = getWeekDayState(self, secondsFrom1970)
    weekDayState =  math["or"](weekDayState, WEEKDAYSTATE_CHECKEDIN_MASK[bookKey])
    setWeekDayState(self, secondsFrom1970, weekDayState)
end

function DataEverydayInfo:isCheckIn(secondsFrom1970, bookKey)
    local weekDayState = getWeekDayState(self, secondsFrom1970)
    local ret = math["and"](weekDayState, WEEKDAYSTATE_CHECKEDIN_MASK[bookKey]) > 0
    return ret
end

function DataEverydayInfo:getReward(secondsFrom1970)
    self:checkIn(secondsFrom1970,WEEKDAYSTATE_GETREWARD_KEY)
end

function DataEverydayInfo:isGotReward(secondsFrom1970)
    return self:isCheckIn(secondsFrom1970,WEEKDAYSTATE_GETREWARD_KEY)
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
    local week = getCurrentLogInWeek(os.time() , s_CURRENT_USER.localTime)
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
