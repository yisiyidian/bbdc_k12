-- 打点代码
-- 添加注释时间2015年06月02日18:48:46
-- 侯琪
-- **********************************************************************
-- 打了很多用不着的点！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
-- 看到写的不对的注释，自行修改！！！！！！！！！！！！！！！！！！！！！！！！！！
-- **********************************************************************

-- 打点的前缀
-- debug模式下为Test
-- 其他没有前缀
local function getAnalyticsPrefix()
    if BUILD_TARGET == BUILD_TARGET_DEBUG then
        return 'TEST_'
    else
        return ''
    end
end

-- 渠道信息点 xiaomi。etc
function AnalyticsChannel(channelId)
    if channelId ~= nil and string.len(channelId) > 0 then
        print('Analytics', getAnalyticsPrefix() .. 'Channel', channelId); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Channel', channelId)
    end
end

----------------------------------------------------------------------------------------
-- 原版本180的一级引导
function AnalyticsTutorial(step)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'TutorialStep_1st_day', tostring(step)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialStep_1st_day', tostring(step))
    end
    print('Analytics', getAnalyticsPrefix() .. 'TutorialStep', tostring(step)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialStep', tostring(step))
end
-- 原版本180的二级引导
function AnalyticsSmallTutorial(step)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'TutorialSmallStep_1st_day', tostring(step)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialSmallStep_1st_day', tostring(step))
    end
    print('Analytics', getAnalyticsPrefix() .. 'TutorialSmallStep', tostring(step)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialSmallStep', tostring(step))
end
-- 畅玩版本的引导
function AnalyticsSummaryStep(step)
    print('Analytics', getAnalyticsPrefix() .. 'TutorialSummaryStep', tostring(step)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TutorialSummaryStep', tostring(step))
end

----------------------------------------------------------------------------------------
-- 每日打卡引导
function AnalyticsDailyCheckIn(day)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'DailyCheckIn_1st_day', tostring(day)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DailyCheckIn_1st_day', tostring(day))
    end
    print('Analytics', getAnalyticsPrefix() .. 'DailyCheckIn', tostring(day)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DailyCheckIn', tostring(day))
end

----------------------------------------------------------------------------------------
-- 游客登录
function AnalyticsSignUp_Guest()
    print('Analytics', getAnalyticsPrefix() .. 'SignUp', 'Guest'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SignUp', 'Guest')
end
-- 通过账号密码登陆
function AnalyticsSignUp_Normal()
    print('Analytics', getAnalyticsPrefix() .. 'SignUp', 'Normal'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SignUp', 'Normal')
end
-- 通过QQ登陆
function AnalyticsSignUp_QQ()
    print('Analytics', getAnalyticsPrefix() .. 'SignUp', 'QQ'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SignUp', 'QQ')
end
-- 搜不到，不知道什么意思
function AnalyticsAccountBind()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'AccountBind_1st_day', 'YES'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AccountBind_1st_day', 'YES')
    end
    print('Analytics', getAnalyticsPrefix() .. 'AccountBind', 'YES'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AccountBind', 'YES')
end
-- 搜不到，不知道什么意思
function AnalyticsLogOut()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'LogOut_1st_day', 'YES'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LogOut_1st_day', 'YES')
    end
    print('Analytics', getAnalyticsPrefix() .. 'LogOut', 'YES'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LogOut', 'YES')
end
-- 切换账户
function AnalyticsAccountChange()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'AccountChange_1st_day', 'YES'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AccountChange_1st_day', 'YES')
    end
    print('Analytics', getAnalyticsPrefix() .. 'AccountChange', 'YES'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AccountChange', 'YES')
end

----------------------------------------------------------------------------------------
-- 搜不到，不知道什么意思
function AnalyticsWordsLibBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'WordsLib_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'WordsLib_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'WordsLib', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'WordsLib', 'TOUCH')
end

----------------------------------------------------------------------------------------
-- 点击好友功能
function AnalyticsFriendBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Friend_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Friend', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend', 'TOUCH')
end
-- 发送好友请求
function AnalyticsFriendRequest()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Friend_1st_day', 'Request'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend_1st_day', 'Request')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Friend', 'Request'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend', 'Request')
end
-- 接受好友请求
function AnalyticsFriendAccept()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Friend_1st_day', 'Accept'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend_1st_day', 'Accept')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Friend', 'Accept'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Friend', 'Accept')
end

----------------------------------------------------------------------------------------
-- 搜不到，不知道什么意思
function AnalyticsDataCenterBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'DataCenter_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DataCenter_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'DataCenter', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DataCenter', 'TOUCH')
end
-- 进入对应信息界面
function AnalyticsDataCenterPage(pageName)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'DataCenter_1st_day', pageName); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DataCenter_1st_day', pageName)
    end
    print('Analytics', getAnalyticsPrefix() .. 'DataCenter', pageName); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DataCenter', pageName)
end

----------------------------------------------------------------------------------------
-- 点击换书
function AnalyticsChangeBookBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'ChangeBookBtn_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ChangeBookBtn_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'ChangeBookBtn', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ChangeBookBtn', 'TOUCH')
end
-- 点击选书
function AnalyticsBook(bookname)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Book_1st_day', 'selected_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Book_1st_day', 'selected_' .. bookname)
    end
    print('Analytics', getAnalyticsPrefix() .. 'Book', 'selected_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Book', 'selected_' .. bookname)
end
-- 第一次选哪本书
function AnalyticsFirstBook(bookname)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', 'FirstBook_1st_day', 'selected_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'FirstBook_1st_day', 'selected_' .. bookname)
    end
    print('Analytics','FirstBook', 'selected_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'FirstBook', 'selected_' .. bookname)
end
-- 下载哪本书
function AnalyticsDownloadBook(bookname)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Book_1st_day', 'download_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Book_1st_day', 'download_' .. bookname)
    end
    print('Analytics', getAnalyticsPrefix() .. 'Book', 'download_' .. bookname); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Book', 'download_' .. bookname)
end

----------------------------------------------------------------------------------------
-- 进入选小关界面
function AnalyticsEnterLevelLayerBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'EnterLevelLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'EnterLevelLayer_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'EnterLevelLayer', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'EnterLevelLayer', 'TOUCH')
end
-- 没用到
function AnalyticsTasksBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Tasks_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Tasks_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Tasks', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Tasks', 'TOUCH')
end
-- 没用到
function AnalyticsTasksFinished(layerName)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'TasksFinished_1st_day', layerName); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TasksFinished_1st_day', layerName)
    end
    print('Analytics', getAnalyticsPrefix() .. 'TasksFinished', layerName); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'TasksFinished', layerName)
end

----------------------------------------------------------------------------------------

-- 没用到
function AnalyticsReplayWrongWordsBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'ReplayWrongWords_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReplayWrongWords_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'ReplayWrongWords', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReplayWrongWords', 'TOUCH')
end

-- 没用到
function AnalyticsContinueReviewBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'ContinueReview_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ContinueReview_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'ContinueReview', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ContinueReview', 'TOUCH')
end

-- 没用到
function AnalyticsStudyNextBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'StudyNext_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'StudyNext_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'StudyNext', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'StudyNext', 'TOUCH')
end

-- 没用到
function AnalyticsStudyGuessWrong()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaning_1st_day', 'GuessWrong'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning_1st_day', 'GuessWrong')
    end
    print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaning', 'GuessWrong'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning', 'GuessWrong')
end

-- 没用到
function AnalyticsStudyAnswerRight()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaning_1st_day', 'AnswerRight'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning_1st_day', 'AnswerRight')
    end
    print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaning', 'AnswerRight'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning', 'AnswerRight')
end

-- 没用到
function AnalyticsStudyDontKnowAnswer()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaning_1st_day', 'DontKnowAnswer'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning_1st_day', 'DontKnowAnswer')
    end
    print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaning', 'DontKnowAnswer'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaning', 'DontKnowAnswer')
end

-- 没用到
function AnalyticsStudyGuessWrong_strikeWhileHot()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaningHOT_1st_day', 'GuessWrong'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT_1st_day', 'GuessWrong')
    end
    print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'GuessWrong'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'GuessWrong')
end

-- 没用到
function AnalyticsStudyAnswerRight_strikeWhileHot()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaningHOT_1st_day', 'AnswerRight'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT_1st_day', 'AnswerRight')
    end
    print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'AnswerRight'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'AnswerRight')
end

-- 没用到
function AnalyticsStudyDontKnowAnswer_strikeWhileHot()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaningHOT_1st_day', 'DontKnowAnswer'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT_1st_day', 'DontKnowAnswer')
    end
    print('Analytics', getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'DontKnowAnswer'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'answerWordMeaningHOT', 'DontKnowAnswer')
end

-- 没用到
function AnalyticsStudySkipSwipeWord()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'SkipSwipeWord_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SkipSwipeWord_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'SkipSwipeWord', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SkipSwipeWord', 'TOUCH')
end

-- 没用到
function AnalyticsStudyLookBackWord()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'LookBackWord_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LookBackWord_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'LookBackWord', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LookBackWord', 'TOUCH')
end
-- 没用到
function AnalyticsStudySlideCoconut_EnterLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'SlideCoconut_EnterLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_EnterLayer_1st_day', 'TOUCH')
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'SlideCoconut_EnterLayer', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_EnterLayer', 'TOUCH')
end
-- 没用到
function AnalyticsStudySlideCoconut_LeaveLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'SlideCoconut_LeaveLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_LeaveLayer_1st_day', 'TOUCH')
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'SlideCoconut_LeaveLayer', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SlideCoconut_LeaveLayer', 'TOUCH')
end
-- 没用到
function AnalyticsStudyCollectAllWord()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'CollectAllWord_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'CollectAllWord_1st_day', 'TOUCH')
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'CollectAllWord', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'CollectAllWord', 'TOUCH')
end
-- 没用到
function AnalyticsForgeIron_EnterLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'ForgeIron_EnterLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_EnterLayer_1st_day', 'TOUCH')
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'ForgeIron_EnterLayer', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_EnterLayer', 'TOUCH')
end
-- 没用到
function AnalyticsForgeIron_LeaveLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'ForgeIron_LeaveLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_LeaveLayer_1st_day', 'TOUCH')
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'ForgeIron_LeaveLayer', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ForgeIron_LeaveLayer', 'TOUCH')
end
-- 没用到
function AnalyticsFirstDayEnterSecondIsland()
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
    if bossList == nil then
        return
    end
    if #bossList == 2 and is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) and  #s_LocalDatabaseManager.getBossInfo(1).rightWordList == 0 and #s_LocalDatabaseManager.getBossInfo(1).wrongWordList == 0 then
        print('Analytics', getAnalyticsPrefix() .. 'FirstDayEnterSecondIsland', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'FirstDayEnterSecondIsland', 'TOUCH')
    end
    if #bossList == 2 then
    print('Analytics', getAnalyticsPrefix() .. 'EnterSecondIsland', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'EnterSecondIsland', 'TOUCH')
    end
end

----------------------------------------------------------------------------------------
-- 没用到
function AnalyticsReviewBoss()
    print('Analytics', getAnalyticsPrefix() .. 'ReviewBoss', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss', 'SHOW')
end
-- 没用到
function AnalyticsReviewBoss_EnterLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'ReviewBoss_EnterLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_EnterLayer_1st_day', 'TOUCH')
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'ReviewBoss_EnterLayer', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_EnterLayer', 'SHOW')
end
-- 没用到
function AnalyticsReviewBoss_LeaveLayer()
    if s_CURRENT_USER ~= nil and s_CURRENT_USER ~= '' then
        if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'ReviewBoss_LeaveLayer_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_LeaveLayer_1st_day', 'TOUCH')
        end
    end
    print('Analytics', getAnalyticsPrefix() .. 'ReviewBoss_LeaveLayer', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ReviewBoss_LeaveLayer', 'SHOW')
end
----------------------------------------------------------------------------------------
-- 没用到
function AnalyticsSummaryBoss()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss_1st_day', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss_1st_day', 'SHOW')
    end
    print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss', 'SHOW')
end
-- 没用到
function AnalyticsSummaryBossWordCount(cnt)
    print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss', 'wordsCount_' .. tostring(cnt)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss', 'wordsCount_' .. tostring(cnt))
end
-- 总结boss后续事件
function AnalyticsSummaryBossResult(result)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss_1st_day', result); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss_1st_day', result)
    end
    print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss', result); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss', result)
end
-- 通过第二个boss
function AnalyticsPassSecondSummaryBoss()
    local bossList = s_LocalDatabaseManager.getAllBossInfo()
        if #bossList >= 2 and is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
            print('Analytics', getAnalyticsPrefix() .. 'PassSecondSummaryBoss_1st_day', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'PassSecondSummaryBoss_1st_day', 'SHOW')
        end
    print('Analytics', getAnalyticsPrefix() .. 'PassSecondSummaryBoss', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'PassSecondSummaryBoss', 'SHOW')
end
-- 总结boss加时
function AnalyticsSummaryBossAddTime()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss_1st_day', 'AddTime')
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss_1st_day', 'AddTime')
    end
    print('Analytics', getAnalyticsPrefix() .. 'SummaryBoss', 'AddTime')
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'SummaryBoss', 'AddTime')
end

----------------------------------------------------------------------------------------
-- 没用到
function AnalyticsChestGeneratedCnt(cnt)
    print('Analytics', getAnalyticsPrefix() .. 'ChestGeneratedCnt', tostring(cnt)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ChestGeneratedCnt', tostring(cnt))
end
-- 没用到
function AnalyticsChestCollectedCnt(name)
    print('Analytics', getAnalyticsPrefix() .. 'ChestCollectedCnt', name); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'ChestCollectedCnt', name)
end
-- 退出app前留在那个页面
function Analytics_applicationDidEnterBackground(layerName)
    print('Analytics', getAnalyticsPrefix() .. 'AppEnterBackground', layerName); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AppEnterBackground', layerName)
end
-- 替换游戏层
function Analytics_replaceGameLayer(layerName)
    print('Analytics', getAnalyticsPrefix() .. 'replaceGameLayer', layerName); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'replaceGameLayer', layerName)
end

----------------------------------------------------------------------------------------
-- 分享按钮
function AnalyticsButtonToShare()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Share_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Share', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share', 'TOUCH')
end
-- 分享事件
function AnalyticsShare(name)
    print('Analytics', getAnalyticsPrefix() .. 'Share', name); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share', name)
end
-- 进入分享界面
function AnalyticsEnterShare()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Share_1st_day', 'ENTER'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share_1st_day', 'ENTER')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Share', 'ENTER'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Share', 'ENTER')
end

----------------------------------------------------------------------------------------
-- 下载音频按钮点击
function AnalyticsDownloadSoundBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'DownloadSound_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DownloadSound_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'DownloadSound', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DownloadSound', 'TOUCH')
end
-- 购买了哪样商品
function AnalyticsBuy(itemId)
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'BuyProduct_1st_day', tostring(itemId)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'BuyProduct_1st_day', tostring(itemId))
    end
    print('Analytics', getAnalyticsPrefix() .. 'BuyProduct', tostring(itemId)); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'BuyProduct', tostring(itemId))
end
-- 进入商店界面
function AnalyticsShopBtn()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'Shop_1st_day', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Shop_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'Shop', 'TOUCH'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'Shop', 'TOUCH')
end

----------------------------------------------------------------------------------------
-- 没用到
function AnalyticsImproveInfo()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'AnalyticsImproveInfo_1st_day', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AnalyticsImproveInfo_1st_day', 'SHOW')
    end
    print('Analytics', getAnalyticsPrefix() .. 'AnalyticsImproveInfo', 'SHOW'); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'AnalyticsImproveInfo', 'SHOW')
end
-- 进入每日领奖界面
function AnalyticsLoginReward()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'LoginReward_1st_day', 'TOUCH');
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LoginReward_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'LoginReward', 'TOUCH');
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'LoginReward', 'TOUCH')
end
-- 成功下载音频
function AnalyticsDownloadSuccessful()
    if is2TimeInSameDay(os.time(),s_CURRENT_USER.localTime) then
        print('Analytics', getAnalyticsPrefix() .. 'DownloadSuccessful_1st_day', 'TOUCH');
        cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DownloadSuccessful_1st_day', 'TOUCH')
    end
    print('Analytics', getAnalyticsPrefix() .. 'DownloadSuccessful', 'TOUCH');
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'DownloadSuccessful', 'TOUCH')
end
----------------------------------------------------------------------------------------
-- k12打点流程
-- 进入输入用户名界面   0
-- 进入输入密码界面    1
-- 进入输入老师名字界面  2
-- 进入选择年级界面    3
-- 进入选书界面  4
-- 进入主界面   5
-- 进入选小关   6
-- 进入趁热打铁  7
-- 进入趁热打铁胜利界面  8
-- 进入复习boss    9
-- 进入复习boss胜利界面    10
-- 进入总结boss    11
-- 进入总结boss胜利界面    12
-- 进入总结boss失败界面    13
function AnalyticsK12SmallStep(index)
    cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. 'K12TutorialSmallStep', tostring(index))
end


-- k12打点流程结束
----------------------------------------------------------------------------------------
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
-- V180版本的新手流程打点打点
function AnalyticsFirst(eventindex, eventDes)
    if math["and"](s_CURRENT_USER.statsMask, (2 ^ eventindex)) == 0 then
        local event = ANALYTICS_FIRST_EVENTS[eventindex + 1]
        print('Analytics', getAnalyticsPrefix() .. event, eventDes); cx.CXAnalytics:logEventAndLabel(getAnalyticsPrefix() .. event, eventDes)

        if s_SERVER.isNetworkConnectedNow() and string.len(s_CURRENT_USER.objectId) > 0 then
            s_CURRENT_USER.statsMask = s_CURRENT_USER.statsMask + (2 ^ eventindex)
            local obj = {['className']=s_CURRENT_USER.className, ['objectId']=s_CURRENT_USER.objectId, ['statsMask']=s_CURRENT_USER.statsMask}
            s_SERVER.updateData(obj, nil, nil)
        end
    end
end

----------------------------------------------------------------------------------------

