
function AnalyticsChannel(channelId)
    if channelId ~= nil and string.len(channelId) > 0 then
        cx.CXAnalytics:logEventAndLabel('Channel', channelId)
    end
end

----------------------------------------------------------------------------------------

function AnalyticsTutorial(step)
    cx.CXAnalytics:logEventAndLabel('TutorialStep', tostring(step))
end

function AnalyticsSmallTutorial(step)
    cx.CXAnalytics:logEventAndLabel('TutorialSmallStep', tostring(step))
end

function AnalyticsReviewBossTutorial(step)
    cx.CXAnalytics:logEventAndLabel('ReviewBossTutorialStep', tostring(step))
end

----------------------------------------------------------------------------------------

function AnalyticsDailyCheckIn(day)
    cx.CXAnalytics:logEventAndLabel('DailyCheckIn', tostring(day))
end

----------------------------------------------------------------------------------------

function AnalyticsSignUp_Guest()
    cx.CXAnalytics:logEventAndLabel('SignUp', 'Guest')
end

function AnalyticsSignUp_Normal()
    cx.CXAnalytics:logEventAndLabel('SignUp', 'Normal')
end

function AnalyticsSignUp_QQ()
    cx.CXAnalytics:logEventAndLabel('SignUp', 'QQ')
end

function AnalyticsAccountBind()
    cx.CXAnalytics:logEventAndLabel('AccountBind', 'YES')
end

function AnalyticsLogOut()
    cx.CXAnalytics:logEventAndLabel('LogOut', 'YES')
end

----------------------------------------------------------------------------------------

function AnalyticsWordsLibBtn()
    cx.CXAnalytics:logEventAndLabel('WordsLib', 'TOUCH')
end

----------------------------------------------------------------------------------------

function AnalyticsFriendBtn()
    cx.CXAnalytics:logEventAndLabel('Friend', 'TOUCH')
end

function AnalyticsFriendRequest()
    cx.CXAnalytics:logEventAndLabel('Friend', 'Request')
end

function AnalyticsFriendAccept()
    cx.CXAnalytics:logEventAndLabel('Friend', 'Accept')
end

----------------------------------------------------------------------------------------

function AnalyticsDataCenterBtn()
    cx.CXAnalytics:logEventAndLabel('DataCenter', 'TOUCH')
end

----------------------------------------------------------------------------------------

function AnalyticsChangeBookBtn()
    cx.CXAnalytics:logEventAndLabel('Book', 'TOUCH')
end

function AnalyticsBook(bookname)
    cx.CXAnalytics:logEventAndLabel('Book', 'selected ' .. bookname)
end

function AnalyticsDownloadBook(bookname)
    cx.CXAnalytics:logEventAndLabel('Book', 'download ' .. bookname)
end

----------------------------------------------------------------------------------------

function AnalyticsEnterLevelLayerBtn()
    cx.CXAnalytics:logEventAndLabel('Enter Level Layer', 'TOUCH')
end

function AnalyticsTasksBtn()
    cx.CXAnalytics:logEventAndLabel('Tasks', 'TOUCH')
end

----------------------------------------------------------------------------------------

-- 点击 重玩错词
function AnalyticsReplayWrongWordsBtn()
    cx.CXAnalytics:logEventAndLabel('Replay Wrong Words', 'TOUCH')
end

-- 点击 依然复习
function AnalyticsContinueReviewBtn()
    cx.CXAnalytics:logEventAndLabel('Continue Review', 'TOUCH')
end

-- 点击 下一步
function AnalyticsStudyNextBtn()
    cx.CXAnalytics:logEventAndLabel('Study Next', 'TOUCH')
end

-- 猜错
function AnalyticsStudyGuessWrong()
    cx.CXAnalytics:logEventAndLabel('answer word meaning', 'Guess Wrong')
end

-- 答对
function AnalyticsStudyAnswerRight()
    cx.CXAnalytics:logEventAndLabel('answer word meaning', 'Answer Right')
end

-- 不会
function AnalyticsStudyDontKnowAnswer()
    cx.CXAnalytics:logEventAndLabel('answer word meaning', 'Dont Know Answer')
end

-- 猜错
function AnalyticsStudyGuessWrong_strikeWhileHot()
    cx.CXAnalytics:logEventAndLabel('answer word meaning HOT', 'Guess Wrong')
end

-- 答对
function AnalyticsStudyAnswerRight_strikeWhileHot()
    cx.CXAnalytics:logEventAndLabel('answer word meaning HOT', 'Answer Right')
end

-- 不会
function AnalyticsStudyDontKnowAnswer_strikeWhileHot()
    cx.CXAnalytics:logEventAndLabel('answer word meaning HOT', 'Dont Know Answer')
end

-- 点击 跳过划单词步骤
function AnalyticsStudySkipSwipeWord()
    cx.CXAnalytics:logEventAndLabel('Skip Swipe Word', 'TOUCH')
end

-- 点击 生词回看
function AnalyticsStudyLookBackWord()
    cx.CXAnalytics:logEventAndLabel('Look Back Word', 'TOUCH')
end

----------------------------------------------------------------------------------------

function AnalyticsReviewBoss()
    cx.CXAnalytics:logEventAndLabel('Review Boss', 'SHOW')
end

function AnalyticsSummaryBoss()
    cx.CXAnalytics:logEventAndLabel('Summary Boss', 'SHOW')
end

function Analytics_applicationDidEnterBackground(layerName)
    cx.CXAnalytics:logEventAndLabel('App Enter Background', layerName)
end

