local DataClassBase = require('model/user/DataClassBase')

local DataLogIn = class("DataLogIn", function()
    return DataClassBase.new()
end)

function DataLogIn.create()
    local data = DataLogIn.new()
    return data
end

function DataLogIn:ctor()
    self.className = 'DataLogIn'
    
    self.Monday = 0
    self.Tuesday = 0
    self.Wednesday = 0
    self.Thursday = 0
    self.Friday = 0
    self.Saturday = 0
    self.Sunday = 0
    self.week = 0
end

-- first day is Sunday
function getWeekDay(secondsFrom1970)
    local dd = os.date("*t", secondsFrom1970)
    return dd.wday
end

function getCurrentLogInWeek(offsetSeconds_1stPlay_now)
    local ret = offsetSeconds_1stPlay_now / 7 * 24 * 60 * 60.0
    return math.ceil(ret)
end

function DataLogIn:setWeekDay(secondsFrom1970)
    local wd = getWeekDay(secondsFrom1970)
    if wd == 1 then
        self.Sunday = 1
    elseif wd == 2 then
        self.Monday = 1
    elseif wd == 3 then
        self.Tuesday = 1
    elseif wd == 4 then
        self.Wednesday = 1
    elseif wd == 5 then
        self.Thursday = 1
    elseif wd == 6 then
        self.Friday = 1
    elseif wd == 7 then
        self.Saturday = 1
    end
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

return DataLogIn
