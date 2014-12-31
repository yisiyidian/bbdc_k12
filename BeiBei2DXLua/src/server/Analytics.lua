
function AnalyticsChannel(channelId)
    if channelId ~= nil and string.len(channelId) > 0 then
        cx.CXAnalytics:logEventAndLabel('Channel', channelId)
    end
end

function AnalyticsTutorial(step)
    cx.CXAnalytics:logEventAndLabel('TutorialStep', tostring(step))
    -- s_SERVER.increment('TutorialStep_' .. tostring(step), s_CURRENT_USER.objectId, s_APP_VERSION)
end

function AnalyticsSmallTutorial(step)
    cx.CXAnalytics:logEventAndLabel('TutorialSmallStep', tostring(step))
    -- s_SERVER.increment('TutorialSmallStep_' .. tostring(step), s_CURRENT_USER.objectId, s_APP_VERSION)
end

function AnalyticsReviewBossTutorial(step)
    cx.CXAnalytics:logEventAndLabel('ReviewBossTutorialStep', tostring(step))
    -- s_SERVER.increment('ReviewBossTutorialStep_' .. tostring(step), s_CURRENT_USER.objectId, s_APP_VERSION)
end

function AnalyticsDailyCheckIn(day)
    cx.CXAnalytics:logEventAndLabel('DailyCheckIn', tostring(day))
    -- s_SERVER.increment('DailyCheckIn_' .. tostring(day), s_CURRENT_USER.objectId, s_APP_VERSION)
end

function AnalyticsSignUp_Guest()
    cx.CXAnalytics:logEventAndLabel('SignUp', 'Guest')
    -- s_SERVER.increment('SignUp_Guest')
end

function AnalyticsSignUp_Normal()
    cx.CXAnalytics:logEventAndLabel('SignUp', 'Normal')
    -- s_SERVER.increment('SignUp_Normal')
end

function AnalyticsSignUp_QQ()
    cx.CXAnalytics:logEventAndLabel('SignUp', 'QQ')
end

function AnalyticsAccountBind()
    cx.CXAnalytics:logEventAndLabel('AccountBind', 'YES')
    -- s_SERVER.increment('AccountBind', s_CURRENT_USER.objectId, s_APP_VERSION)
end

function AnalyticsLogOut()
    cx.CXAnalytics:logEventAndLabel('LogOut', 'YES')
    -- s_SERVER.increment('LogOut', s_CURRENT_USER.objectId, s_APP_VERSION)
end

function AnalyticsBook(bookname)
    cx.CXAnalytics:logEventAndLabel('Book', 'selected ' .. bookname)
end

function AnalyticsDownloadBook(bookname)
    cx.CXAnalytics:logEventAndLabel('Book', 'download ' .. bookname)
end

----------------------------------------------------------------------------------------
-- touch 

function AnalyticsLib()
    cx.CXAnalytics:logEventAndLabel('WordsLib', 'TOUCH')
    -- s_SERVER.increment('WordsLib', s_CURRENT_USER.objectId, s_APP_VERSION)
end

function AnalyticsFriend()
    cx.CXAnalytics:logEventAndLabel('Friend', 'TOUCH')
    -- s_SERVER.increment('Friend', s_CURRENT_USER.objectId, s_APP_VERSION)
end

function AnalyticsDataCenter()
    cx.CXAnalytics:logEventAndLabel('DataCenter', 'TOUCH')
    -- s_SERVER.increment('DataCenter', s_CURRENT_USER.objectId, s_APP_VERSION)
end

function AnalyticsChangeBookBtn()
    cx.CXAnalytics:logEventAndLabel('ChangeBook', 'TOUCH')
    -- s_SERVER.increment('ChangeBook', s_CURRENT_USER.objectId, s_APP_VERSION)
end

function AnalyticsEnterLevelLayer()
    cx.CXAnalytics:logEventAndLabel('EnterLevelLayer', 'TOUCH')
    -- s_SERVER.increment('EnterLevelLayer', s_CURRENT_USER.objectId, s_APP_VERSION)
end

function AnalyticsTouchTasks()
    cx.CXAnalytics:logEventAndLabel('Tasks', 'TOUCH')
end

function AnalyticsReplayerWrongWords()
    cx.CXAnalytics:logEventAndLabel('ReplayerWrongWords', 'TOUCH')
    -- s_SERVER.increment('ReplayerWrongWords', s_CURRENT_USER.objectId, s_APP_VERSION)
end

----------------------------------------------------------------------------------------

function AnalyticsReviewBoss()
    cx.CXAnalytics:logEventAndLabel('Review Boss', 'SHOW')
end

function AnalyticsSummaryBoss()
    cx.CXAnalytics:logEventAndLabel('Summary Boss', 'SHOW')
end

function Analytics_applicationDidEnterBackground(layerName)
    cx.CXAnalytics:logEventAndLabel('applicationDidEnterBackground', layerName)
    -- s_SERVER.increment('applicationDidEnterBackground_' .. layerName, s_CURRENT_USER.objectId, s_APP_VERSION)
end

function Analytics_reviewBoss()
    cx.CXAnalytics:logEventAndLabel('reviewBoss', 'show')
    local ut = os.date("!*t")
    currentDay = string.format('%d_%d_%d', ut.year, ut.month, ut.day)
    -- s_SERVER.incrementPerDay('reviewBossShow', currentDay, s_APP_VERSION)
end
