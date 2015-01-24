local DataClassBase = require('model.user.DataClassBase')

local DataLogIn = class("DataLogIn", function()
    return DataClassBase.new()
end)

function DataLogIn.create()
    local data = DataLogIn.new()
    return data
end

WEEKDAYSTATE_NONE = 0
WEEKDAYSTATE_LOGEDIN = 1
WEEKDAYSTATE_CHECKEDIN = 2

function DataLogIn:ctor()
    self.className = 'DataLogIn'
    
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

local function setWeekDayState(dataLogIn, secondsFrom1970, weekDayState)
    local wd = getWeekDay(secondsFrom1970)
    if wd == 1 then
        dataLogIn.Sunday = weekDayState
    elseif wd == 2 then
        dataLogIn.Monday = weekDayState
    elseif wd == 3 then
        dataLogIn.Tuesday = weekDayState
    elseif wd == 4 then
        dataLogIn.Wednesday = weekDayState
    elseif wd == 5 then
        dataLogIn.Thursday = weekDayState
    elseif wd == 6 then
        dataLogIn.Friday = weekDayState
    elseif wd == 7 then
        dataLogIn.Saturday = weekDayState
    end
end

function DataLogIn:setWeekDay(secondsFrom1970)
    setWeekDayState(self, secondsFrom1970, WEEKDAYSTATE_LOGEDIN)
end

function DataLogIn:checkIn(secondsFrom1970)
    setWeekDayState(self, secondsFrom1970, WEEKDAYSTATE_CHECKEDIN)
end

function DataLogIn:getDays()
    return {self.Monday,
    self.Tuesday,
    self.Wednesday,
    self.Thursday,
    self.Friday,
    self.Saturday,
    self.Sunday}
end

function DataLogIn:updateFrom(otherDataLogIn)
    if otherDataLogIn.updatedAt < self.updatedAt then
        return false
    end
    local keys = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'}
    for i, v in ipairs(keys) do
        if otherDataLogIn[v] > 0 then
            self[v] = 1
        end
    end
    return true
end

return DataLogIn
