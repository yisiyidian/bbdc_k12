
function AnalyticsChannel(channelId)
    if channelId ~= nil and string.len(channelId) > 0 then
        cx.CXAnalytics:logEventAndLabel('Channel', channelId)
    end
end

function AnalyticsTutorial(step)
    cx.CXAnalytics:logEventAndLabel('TutorialStep', tostring(step))
end

function AnalyticsReviewBossTutorial(step)
    cx.CXAnalytics:logEventAndLabel('ReviewBossTutorialStep', tostring(step))
end

function AnalyticsDailyCheckIn(day)
    cx.CXAnalytics:logEventAndLabel('DailyCheckIn', tostring(day))
end

function AnalyticsLogOut(userObjectId)
    cx.CXAnalytics:logEventAndLabel('LogOut', tostring(userObjectId))
end
