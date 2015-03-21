local function getAnalyticsPrefix()
    if BUILD_TARGET == BUILD_TARGET_DEBUG then
        return '测试'
    else
        return ''
    end
end

function AnalyticsChannel(channelId)
    if channelId ~= nil and string.len(channelId) > 0 then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Channel', channelId)
    end
end

----------------------------------------------------------------------------------------

function AnalyticsTutorial(step)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialStepInFirstDay', tostring(step))
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialStep', tostring(step))
end

function AnalyticsSmallTutorial(step)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialSmallStepInFirstDay', tostring(step))
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialSmallStep', tostring(step))
end

--function AnalyticsReviewBossTutorial(step)
--    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBossTutorialStep', tostring(step))
--end

----------------------------------------------------------------------------------------

function AnalyticsDailyCheckIn(day)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DailyCheckInInFirstDay', tostring(day))
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DailyCheckIn', tostring(day))
end

----------------------------------------------------------------------------------------

function AnalyticsSignUp_Guest()
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SignUp', 'Guest')
end

function AnalyticsSignUp_Normal()
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SignUp', 'Normal')
end

function AnalyticsSignUp_QQ()
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SignUp', 'QQ')
end

function AnalyticsAccountBind()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AccountBindInFirstDay', 'YES')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AccountBind', 'YES')
end

function AnalyticsLogOut()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LogOutInFirstDay', 'YES')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LogOut', 'YES')
end

function AnalyticsAccountChange()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AccountChangeInFirstDay', 'YES')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AccountChange', 'YES')
end

----------------------------------------------------------------------------------------

function AnalyticsWordsLibBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'WordsLibInFirstDay', 'TOUCH')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'WordsLib', 'TOUCH')
end

----------------------------------------------------------------------------------------

function AnalyticsFriendBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'FriendInFirstDay', 'TOUCH')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend', 'TOUCH')
end

function AnalyticsFriendRequest()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'FriendInFirstDay', 'Request')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend', 'Request')
end

function AnalyticsFriendAccept()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'FriendInFirstDay', 'Accept')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend', 'Accept')
end

----------------------------------------------------------------------------------------

function AnalyticsDataCenterBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DataCenterInFirstDay', 'TOUCH')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DataCenter', 'TOUCH')
end

function AnalyticsDataCenterPage(pageName)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DataCenterInFirstDay', pageName)
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DataCenter', pageName)
end

----------------------------------------------------------------------------------------

function AnalyticsChangeBookBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ChangeBookBtnInFirstDay', 'TOUCH')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ChangeBookBtn', 'TOUCH')
end

function AnalyticsBook(bookname)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'BookInFirstDay', 'selected_' .. bookname)
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Book', 'selected_' .. bookname)
end

function AnalyticsFirstBook(bookname)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel('FirstBookInFirstDay', 'selected_' .. bookname)
    end
    cx.CXAnalytics:logEventAndLabel('FirstBook', 'selected_' .. bookname)
end

function AnalyticsDownloadBook(bookname)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'BookInFirstDay', 'download_' .. bookname)
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Book', 'download_' .. bookname)
end

----------------------------------------------------------------------------------------

function AnalyticsEnterLevelLayerBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'EnterLevelLayerInFirstDay', 'TOUCH')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'EnterLevelLayer', 'TOUCH')
end

function AnalyticsTasksBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TasksInFirstDay', 'TOUCH')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Tasks', 'TOUCH')
end

function AnalyticsTasksFinished(layerName)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TasksFinishedInFirstDay', layerName)
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TasksFinished', layerName)
end

----------------------------------------------------------------------------------------

-- 点击 重玩错词
function AnalyticsReplayWrongWordsBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReplayWrongWordsInFirstDay', 'TOUCH')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReplayWrongWords', 'TOUCH')
end

-- 点击 依然复习
function AnalyticsContinueReviewBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ContinueReviewInFirstDay', 'TOUCH')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ContinueReview', 'TOUCH')
end

-- 点击 下一步
function AnalyticsStudyNextBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'StudyNextInFirstDay', 'TOUCH')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'StudyNext', 'TOUCH')
end

-- 猜错
function AnalyticsStudyGuessWrong()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningInFirstDay', 'GuessWrong')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning', 'GuessWrong')
end

-- 答对
function AnalyticsStudyAnswerRight()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningInFirstDay', 'AnswerRight')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning', 'AnswerRight')
end

-- 不会
function AnalyticsStudyDontKnowAnswer()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningInFirstDay', 'DontKnowAnswer')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning', 'DontKnowAnswer')
end

-- 猜错
function AnalyticsStudyGuessWrong_strikeWhileHot()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOTInFirstDay', 'GuessWrong')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'GuessWrong')
end

-- 答对
function AnalyticsStudyAnswerRight_strikeWhileHot()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOTInFirstDay', 'AnswerRight')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'AnswerRight')
end

-- 不会
function AnalyticsStudyDontKnowAnswer_strikeWhileHot()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOTInFirstDay', 'DontKnowAnswer')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'DontKnowAnswer')
end

-- 点击 跳过划单词步骤
function AnalyticsStudySkipSwipeWord()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SkipSwipeWordInFirstDay', 'TOUCH')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SkipSwipeWord', 'TOUCH')
end

-- 点击 生词回看
function AnalyticsStudyLookBackWord()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LookBackWordInFirstDay', 'TOUCH')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LookBackWord', 'TOUCH')
end

function AnalyticsStudySlideCoconut_EnterLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_EnterLayer_firstday', 'TOUCH')
        end
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_EnterLayer', 'TOUCH')
end

function AnalyticsStudySlideCoconut_LeaveLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_LeaveLayer_firstday', 'TOUCH')
        end
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_LeaveLayer', 'TOUCH')
end

function AnalyticsStudyCollectAllWord()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'CollectAllWord_firstday', 'TOUCH')
        end
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'CollectAllWord', 'TOUCH')
end

function AnalyticsForgeIron_EnterLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_EnterLayer_firstday', 'TOUCH')
        end
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_EnterLayer', 'TOUCH')
end

function AnalyticsForgeIron_LeaveLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_LeaveLayer_firstday', 'TOUCH')
        end
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_LeaveLayer', 'TOUCH')
end
function AnalyticsFirstDayEnterSecondIsland()
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    if bossList == nil then
        return
    end
    if #bossList == 2 and is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) and  #s_LocalDatabaseManager.getBossInfo(1).rightWordList == 0 and #s_LocalDatabaseManager.getBossInfo(1).wrongWordList == 0 then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'FirstDayEnterSecondIsland', 'TOUCH')
    end
    if #bossList == 2 then
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'EnterSecondIsland', 'TOUCH')
    end
end

----------------------------------------------------------------------------------------

function AnalyticsReviewBoss()
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss', 'SHOW')
end

function AnalyticsReviewBoss_EnterLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_EnterLayer_firstday', 'TOUCH')
        end
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_EnterLayer', 'SHOW')
end

function AnalyticsReviewBoss_LeaveLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_LeaveLayer_firstday', 'TOUCH')
        end
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_LeaveLayer', 'SHOW')
end
----------------------------------------------------------------------------------------

function AnalyticsSummaryBoss()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBossInFirstDay', 'SHOW')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss', 'SHOW')
end

function AnalyticsSummaryBossWordCount(cnt)
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss', 'wordsCount_' .. tostring(cnt))
end

function AnalyticsSummaryBossResult(result)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBossInFirstDay', result)
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss', result)
end

function AnalyticsPassSecondSummaryBoss()
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
        if #bossList >= 2 and is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'PassSecondSummaryBossInFirstDay', 'SHOW')
        end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'PassSecondSummaryBoss', 'SHOW')
end

----------------------------------------------------------------------------------------

function AnalyticsChestGeneratedCnt(cnt)
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ChestGeneratedCnt', tostring(cnt))
end

function AnalyticsChestCollectedCnt(name)
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ChestCollectedCnt', name)
end

function Analytics_applicationDidEnterBackground(layerName)
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AppEnterBackground', layerName)
end

function Analytics_replaceGameLayer(layerName)
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'replaceGameLayer', layerName)
end

----------------------------------------------------------------------------------------

function AnalyticsButtonToShare()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ShareInFirstDay', 'TOUCH')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share', 'TOUCH')
end

function AnalyticsShare(name)
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share', name)
end

function AnalyticsEnterShare()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ShareInFirstDay', 'ENTER')
    end
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share', 'ENTER')
end

----------------------------------------------------------------------------------------

function AnalyticsDownloadSoundBtn()
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DownloadSound', 'TOUCH')
end

function AnalyticsBuy(itemId)
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'BuyProduct', tostring(itemId))
end

function AnalyticsShopBtn()
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Shop', 'TOUCH')
end

----------------------------------------------------------------------------------------

function AnalyticsImproveInfo()
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AnalyticsImproveInfo', 'SHOW')
end



----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- first
ANALYTICS_FIRST_BOOK = 0
ANALYTICS_FIRST_LEVEL = 1

ANALYTICS_FIRST_STUDY = 2
ANALYTICS_FIRST_SKIP_REVIEW = 3
ANALYTICS_FIRST_DONT_KNOW = 4
ANALYTICS_FIRST_SWIPE_WORD = 5

ANALYTICS_FIRST_GOT_ENOUGH_UNKNOWN_WORDS = 6

ANALYTICS_FIRST_STUDY_STRIKEWHILEHOT = 7
ANALYTICS_FIRST_SKIP_REVIEW_STRIKEWHILEHOT = 8
ANALYTICS_FIRST_DONT_KNOW_STRIKEWHILEHOT = 9
ANALYTICS_FIRST_SWIPE_WORD_STRIKEWHILEHOT = 10
ANALYTICS_FIRST_FINISH = 11

ANALYTICS_FIRST_REVIEW_BOSS = 12
ANALYTICS_FIRST_REVIEW_BOSS_RESULT = 13

local ANALYTICS_FIRST_EVENTS = {
    'firstBook', 'firstLevelScene', 
    'firstStudy', 'firstSkipReview', 'firstDontKnow', 'firstSwipeWord', 
    'firstGotEnoughUnknownWords', 
    'firstStudyStrikeWhileHot', 'firstSkipReviewStrikeWhileHot', 'firstDontKnowStrikeWhileHot', 'firstSwipeWordStrikeWhileHot', 'firstFinish',
    'firstReviewBoss', 'firstReviewBossResult'
}

function AnalyticsFirst(eventindex, eventDes)
    if math["and"](s_CURRENT_USER.statsMask, (2 ^ eventindex)) == 0 then
        local event = ANALYTICS_FIRST_EVENTS[eventindex + 1]
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. event, eventDes)

        if s_SERVER.isNetworkConnectedNow() and string.len(s_CURRENT_USER.objectId) > 0 then
            s_CURRENT_USER.statsMask = s_CURRENT_USER.statsMask + (2 ^ eventindex)
            local obj = {['className']=s_CURRENT_USER.className, ['objectId']=s_CURRENT_USER.objectId, ['statsMask']=s_CURRENT_USER.statsMask}
            s_SERVER.updateData(obj, nil, nil)
        end
    end
end

----------------------------------------------------------------------------------------

