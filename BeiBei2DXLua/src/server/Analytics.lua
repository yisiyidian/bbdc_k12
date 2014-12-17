
function AnalyticsChannel(channelId)
    if channelId ~= nil and string.len(channelId) > 0 then
        cx.CXAnalytics:logEventAndLabel('Channel', channelId)
    end
end

function AnalyticsTutorial(step)
    s_SERVER.increment('TutorialStep_' .. tostring(step), s_CURRENT_USER.objectId)
end

function AnalyticsSmallTutorial(step)
    s_SERVER.increment('TutorialSmallStep_' .. tostring(step), s_CURRENT_USER.objectId)
end

function AnalyticsReviewBossTutorial(step)
    s_SERVER.increment('ReviewBossTutorialStep_' .. tostring(step), s_CURRENT_USER.objectId)
end

function AnalyticsDailyCheckIn(day)
    s_SERVER.increment('DailyCheckIn_' .. tostring(day), s_CURRENT_USER.objectId)
end

function AnalyticsSignUp_Guest()
    s_SERVER.increment('SignUp_Guest')
end

function AnalyticsSignUp_Normal()
    s_SERVER.increment('SignUp_Normal')
end

function AnalyticsAccountBind()
    s_SERVER.increment('AccountBind', s_CURRENT_USER.objectId)
end

function AnalyticsLogOut()
    s_SERVER.increment('LogOut', s_CURRENT_USER.objectId)
end

function AnalyticsLib()
    s_SERVER.increment('WordsLib', s_CURRENT_USER.objectId)
end

function AnalyticsFriend()
    s_SERVER.increment('Friend', s_CURRENT_USER.objectId)
end

function AnalyticsDataCenter()
    s_SERVER.increment('DataCenter', s_CURRENT_USER.objectId)
end

function AnalyticsChangeBook()
    s_SERVER.increment('ChangeBook', s_CURRENT_USER.objectId)
end

function AnalyticsEnterLevelLayer()
    s_SERVER.increment('EnterLevelLayer', s_CURRENT_USER.objectId)
end

function AnalyticsReplayerWrongWords()
    s_SERVER.increment('ReplayerWrongWords', s_CURRENT_USER.objectId)
end

function Analytics_applicationDidEnterBackground(layerName)
    s_SERVER.increment('applicationDidEnterBackground_' .. layerName, s_CURRENT_USER.objectId)
end
