--玩家的数据模型

local DataClassBase = require('model.user.DataClassBase')
local DataEverydayInfo = require('model.user.DataEverydayInfo')
local DataLevelInfo = require('model.user.DataLevelInfo')
local DataDailyStudyInfo = require('model.user.DataDailyStudyInfo')
local DataDailyUsing = require('model.user.DataDailyUsing')

local MissionConfig = require("model.mission.MissionConfig") --任务的配置

USER_TYPE_MANUAL = 0
USER_TYPE_GUEST  = 1
USER_TYPE_BIND   = 2
USER_TYPE_QQ     = 3
USER_TYPE_ALL    = 100

local DataUser = class("DataUser", function()
    return DataClassBase.new()
end)

function DataUser.create()
    local data = DataUser.new()
    return data
end

DataUser.BEANSKEY = 'bbbean'
local BEANS_PREFIX = 'xd928f'
local BEANS_SUBFIX = '$121M^'

function DataUser:ctor()
    self.className                         = '_User'
    
    self.localTime                         = 0
    self.serverTime                        = 0
    self.username                          = ''
    self.nickName                          = ''
    self.sex                               = 0 --性别 0女 1男
    -- self.email                             = nil --电子邮箱
    self.headImg                           = 0  --头像ID
    self.birth                             = ""
    self.job                               = ""  --职业
    self.school                            = ""  --学校
    self.examination                       = ""  --正准备的考试
    self.position                          = ""  --位置
    self.gradeNum                          = ""  --班级号
    self.gradeName                         = ""  --班级名

    self.relateContacts                     = 0  --关联通讯录
    self.bindAccount                        = "" --绑定帐号
    self.showLocation                       = 0  --位置可见

    self.password                          = ''
    self.mobilePhoneNumber                 = '' --电话号码
    self.sessionToken                      = ''
    self.usertype                          = USER_TYPE_GUEST
    self.channelId                         = ''
    self.statsMask                         = 0

    self.appVersion                        = s_APP_VERSION 
    self.tutorialStep                      = 0 
    self.tutorialSmallStep                 = 0 
    self.isSoundAm                         = 1 

    self.bookKey                           = ''
    self.wordsCount                        = 0 
    self.masterCount                       = 0 
    self.unitID                            = 0  --当前书本 开启到哪个关卡
    
    self.fansCount                         = 0 
    self.friendsCount                      = 0 
    self.fans                              = {}
    self.friends                           = {}
    self.followees                         = {} -- who I follow
    self.followers                         = {} -- who follow me
    self.seenFansCount                     = 0

    self.currentWordsIndex                 = 0 

    self.bulletinBoardTime                 = 0 
    self.bulletinBoardMask                 = 0
    self[DataUser.BEANSKEY]                = BEANS_PREFIX .. '0' .. BEANS_SUBFIX
    self.newStudyRightLayerMask            = 0

    self.needToUnlockNextChapter           = 0

    self.logInDatas                        = {}
    self.localAuthData                     = nil
    self.snsUserInfo                       = nil
    self.clientData                        = {0}
    self.levelInfo                         = DataLevelInfo.create()

    -- summary boss time
    self.timeAdjust                        = 0
    self.failTime                          = 0
    self.winCombo                          = 0    
    -- function lock
    self.lockFunction                      = 8

    self.isAlterOn                         = 1
    self.slideNum                          = 1
    self.familiarOrUnfamiliar              = 1 -- 0 for choose familiar ,1 for choose unfamiliar
    self.beanRewardForCollect              = 3 -- if begin a new mission ,bean = 3 ; if guess wrong word ,bean = 2 ,1 ,0
    self.beanRewardForIron                 = 3

    self.dataDailyUsing                    = DataDailyUsing.create()

    self.k12SmallStep                      = 0
    self.summaryStep                       = 0
    self.bossTutorialStep                  = 0
end

function DataUser:setSummaryStep(step)
    if self.summaryStep < step then
        self.summaryStep = step
        saveUserToServer({['summaryStep']=self.summaryStep})
        AnalyticsSummaryStep(step)
    end
end

function DataUser:setBossTutorialStep(step)
    if self.bossTutorialStep < step then
        self.bossTutorialStep = step
        saveUserToServer({['bossTutorialStep']=self.bossTutorialStep})
    end
end

function DataUser:getLockFunctionState(productId)
    local lockFunction = self.lockFunction
    for i = 1, productId - 1 do
        lockFunction = math.floor(lockFunction/2)
    end
    return lockFunction%2
end

function DataUser:unlockFunctionState(productId)
    AnalyticsBuy(productId)
    
    local lockFunction = self.lockFunction
    local addNum = 1
    for i = 1, productId - 1 do
        lockFunction = math.floor(lockFunction/2)
        addNum = addNum*2
    end
    if lockFunction%2 == 0 then
        self.lockFunction = self.lockFunction + addNum
    end
end

function DataUser:getBeans()
    local a = string.gsub(self[DataUser.BEANSKEY], BEANS_PREFIX,  "") 
    local b = string.gsub(a, BEANS_SUBFIX,  "") 
    return tonumber(b)
end

function DataUser:setBeans(num)
    self[DataUser.BEANSKEY] = string.format('%s%d%s', BEANS_PREFIX, num, BEANS_SUBFIX)
end

function DataUser:addBeans(count)
    self:setBeans( self:getBeans() + count )
end

function DataUser:subtractBeans(count)
    self:setBeans( self:getBeans() - count )
end

function DataUser:getNameForDisplay()
    if s_CURRENT_USER.usertype == USER_TYPE_QQ then 
        return self.nickName
    end
    if s_CURRENT_USER.usertype == USER_TYPE_GUEST then 
        return '游客' 
    end
    if self.nickName ~= "" then
        return self.nickName
    end
    return self.username
end

function DataUser:parseServerData(data)
    for key, value in pairs(self) do
        if nil ~= data[key] then
            self[key] = data[key]
        end
    end
end

function DataUser:parseServerDataLevelInfo(results)
    for i, v in ipairs(results) do
        parseServerDataToClientData(v, self.levelInfo)
        return self.levelInfo
    end 
end

function DataUser:setTutorialStep(step)
    self.tutorialStep = step
    saveUserToServer({['tutorialStep']=self.tutorialStep})
    AnalyticsTutorial(step)
end

function DataUser:setK12SmallStep(step)
    self.k12SmallStep = step
    saveUserToServer({['k12SmallStep']=self.k12SmallStep})
    AnalyticsK12SmallStep(step)
end

function DataUser:setTutorialSmallStep(step)
    self.tutorialSmallStep = step
    saveUserToServer({['tutorialSmallStep']=self.tutorialSmallStep})
    AnalyticsSmallTutorial(step)
end

-- who I follow
function DataUser:parseServerFolloweesData(results)
    self.followees = {}
    for i, v in ipairs(results) do
        local data = DataUser.create()
        parseServerDataToClientData(v.followee, data)
        self.followees[i] = data
    end
end

-- who follow me
function DataUser:parseServerFollowersData(results)
    self.followers = {}
    for i, v in ipairs(results) do
        local data = DataUser.create()
        parseServerDataToClientData(v.follower, data)
        self.followers[i] = data
    end
end

function DataUser:parseServerFollowData(obj)
    if obj ~= nil then
        table.insert(self.followees, obj)
    end
end

function DataUser:parseServerUnFollowData(obj)
    if obj ~= nil then
        for i = 1,#s_CURRENT_USER.followees do
            if s_CURRENT_USER.followees[i].username == obj.username then
                table.remove(s_CURRENT_USER.followees,i)
                break
            end
        end
    end
end

function DataUser:parseServerRemoveFanData(obj)
    if obj ~= nil then
        for i = 1,#s_CURRENT_USER.followees do
            if s_CURRENT_USER.followers[i].username == obj.username then
                table.remove(s_CURRENT_USER.followees,i)
                break
            end
        end
    end
end
--获取好友信息
function DataUser:getFriendsInfo()
    self.friends = {}
    self.fans = {}
    local friendsObjId = {}
    local friends = {}
    -- dump(s_CURRENT_USER.followers,"s_CURRENT_USER.followers")
    -- dump(s_CURRENT_USER.followees,"s_CURRENT_USER.followees")
    for key, followee in pairs(self.followees) do
        friendsObjId[followee.objectId] = 1
        friends[followee.objectId] = followee
    end

    for key, follower in pairs(self.followers) do
        print(friendsObjId[follower.objectId])
        if friendsObjId[follower.objectId] == 1 then
            friendsObjId[follower.objectId] = 2
            friends[follower.objectId] = follower
            self.friends[#self.friends + 1] = follower
        else
            table.insert(self.fans,1,follower)
            if #self.fans > s_friend_request_max_count then
                s_UserBaseServer.removeFan(self.fans[#self.fans],
                    function(api,result)
                        table.remove(self.fans,#self.fans)
                    end,
                    function(api, code, message, description)
                    end)
            end
        end
    end

    self.friendsCount = #self.friends
    self.fansCount = #self.fans
    
    saveUserToServer({['friendsCount']=self.friendsCount, ['fansCount']=self.fansCount})

    --处理添加好友的任务
    s_MissionManager:updateMission(MissionConfig.MISSION_FRIEND, self.friendsCount, false)
end

function DataUser:getBookChapterLevelData(bookKey, chapterKey, levelKey)
    for i,v in ipairs(self.levels) do
        if v.chapterKey == chapterKey and v.levelKey == levelKey and v.bookKey == bookKey then
            return v
        end
    end
    return nil
end

function DataUser:getUserLevelData(chapterKey, levelKey)  
    --print('begin get user level data: size--'..#self.levels) 
    for i,v in ipairs(self.levels) do
        if v.chapterKey == chapterKey and v.levelKey == levelKey and v.bookKey == s_CURRENT_USER.bookKey then
            return v
        end
    end
    --print('end get user level data')
    return nil
end

function DataUser:getUserBookObtainedStarCount()
    local count = 0
    for i, v in ipairs(self.levels) do
        if v.bookKey == self.bookKey then
            local levelConfig = s_DataManager.getLevelConfig(self.bookKey,v.chapterKey,v.levelKey)
            if levelConfig ~= nil and levelConfig['type'] == 0 then
                count = count + v.stars
            end
        end
    end
    return count
end

function DataUser:updateDataToServer()
    saveUserToServer(self)
end

-- get word in one book 
function DataUser:getUserBookWord()
    local wordTable = {}
    local wordTableOp = {}
    local chapterIndex = 0
    while chapterIndex < 4 do
        local levelIndex = 0
        local levelConfig = s_DataManager.getLevelConfig(s_CURRENT_USER.bookKey,'chapter'..chapterIndex,'level'..levelIndex)
        while levelConfig ~= nil do
            if levelConfig['type'] == 0 then
                table.insert(wordTable,split(levelConfig.word_content,'|'))
            end      
                levelIndex = levelIndex + 1
                levelConfig = s_DataManager.getLevelConfig(s_CURRENT_USER.bookKey,'chapter'..chapterIndex,'level'..levelIndex)
        end
        chapterIndex = chapterIndex + 1
    end
    table.foreachi(wordTable, function(i, v) table.foreachi(v, function(i, v)  table.insert(wordTableOp,v) end) end)
    table.foreachi(wordTableOp, function(i, v)  print(i ,v)  end)
    return wordTableOp
end

return DataUser
