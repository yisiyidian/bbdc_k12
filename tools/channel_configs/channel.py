#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os, os.path, errno
import sys
import shutil

try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET

# ---------------------------------------------------------------------------------

BUILD_TYPE_DEBUG        = '0'
BUILD_TYPE_RELEASE      = '1'
BUILD_TYPE_RELEASE_TEST = '2'
BUILD_TYPE_DEVELOPMENT  = '3'

# ---------------------------------------------------------------------------------

class BuildTarget(object):
    def __init__(self, buildType, description, isProduction, loadAllWords):
        super(BuildTarget, self).__init__()
        self.buildType = buildType
        self.description = description
        self.isProduction = isProduction
        self.loadAllWords = loadAllWords

class Server(object):
    def __init__(self, AppName, AppID, AppKey):
        super(Server, self).__init__()
        self.AppName = AppName
        self.AppID = AppID
        self.AppKey = AppKey

    def description(self):
        return 'AppName:' + self.AppName + ', AppID:' + self.AppID + ', AppKey:' + self.AppKey

class QQ(object):
    def __init__(self, PkgName, Name, AppID, AppKey, isLogInAvailable, isShareAvailable):
        super(QQ, self).__init__()
        self.PkgName = PkgName
        self.Name = Name
        self.AppID = AppID
        self.AppKey = AppKey
        self.isLogInAvailable = isLogInAvailable
        self.isShareAvailable = isShareAvailable

    def description(self):
        return 'PkgName:' + self.PkgName + ', Name:' + self.Name + ', AppID:' + self.AppID + ', AppKey:' + self.AppKey + ', isLogInAvailable:' + self.isLogInAvailable + ', isShareAvailable:' + self.isShareAvailable

class WeiXin(object):
    def __init__(self, Name, AppID, AppSecret, Signature):
        super(WeiXin, self).__init__()
        self.Name = Name
        self.AppID = AppID
        self.AppSecret = AppSecret
        self.Signature = Signature

    def description(self):
        return 'Name:' + self.Name + ', AppID:' + self.AppID + ', AppSecret:' + self.AppSecret + ', Signature:' + self.Signature
        
class UMeng(object):
    def __init__(self, AppName, AppKey):
        super(UMeng, self).__init__()
        self.AppName = AppName
        self.AppKey = AppKey

    def description(self):
        return 'AppName:' + self.AppName + ', AppKey:' + self.AppKey
        
class Channel(object):
    def __init__(self, name, packageName, server, qq, wx, um):
        super(Channel, self).__init__()
        self.name = name
        self.packageName = packageName
        self.server = server
        self.qq = qq
        self.wx = wx
        self.um = um

    def description(self):
        return 'name:' + self.name + ', packageName:' + self.packageName + '\n    ' + self.server.description() + '\n    ' + self.qq.description() + '\n    ' + self.wx.description() + '\n    ' + self.um.description()

def readChannelConfigurations(channelXml, channelName):
    tree = ET.ElementTree(file=channelXml)
    root = tree.getroot()
    for channel in root:
        if channel.tag == 'channel' and channel.attrib['name'] == channelName:

            server = Server(channel.attrib['leanCloudAppName'].encode("utf-8"), channel.attrib['leanCloudAppID'], channel.attrib['leanCloudAppKey'])

            qq = QQ(channel.attrib['QQPkgName'] \
                , channel.attrib['QQName'].encode("utf-8") \
                , channel.attrib['QQAppID'] \
                , channel.attrib['QQAppKey'] \
                , channel.attrib['isQQLogInAvailable'] \
                , channel.attrib['isQQShareAvailable'])

            wx = WeiXin(channel.attrib['WXName'].encode("utf-8") \
                , channel.attrib['WXAppID'] \
                , channel.attrib['WXAppSecret'] \
                , channel.attrib['WXSignature'])

            um = UMeng(channel.attrib['umengAppName'].encode("utf-8"), channel.attrib['umengAppKey'])

            currentChannel = Channel(channelName, channel.attrib['packageName'], server, qq, wx, um)

            return currentChannel

    class NoSuchChannelException(Exception):
        def __init__(self, channelName):
            Exception.__init__(self)
            self.channelName = channelName

    try:
        raise NoSuchChannelException(channelName)
    except NoSuchChannelException, x:
        print 'NoSuchChannelException: Channel %s does not exsit!' % (x.channelName,)
        return None

# ---------------------------------------------------------------------------------

def createLuaCodes(gitVer, testServer, buildTarget, channelAndroid, channeliOS, savePath):
    buildInfo = '-- BUILD INFORMATION: %s (Android:%s, %s) (iOS:%s, %s)' % (buildTarget.description, channelAndroid.name, channelAndroid.packageName, channeliOS.name, channeliOS.packageName)
    # ---------------------------------------------------------------------------------    
    channelAndroidWX = 'false'
    if channelAndroid.wx.AppID != '':
        channelAndroidWX = 'true'
        
    snsAndroid = '''
        IS_SNS_QQ_LOGIN_AVAILABLE = %s
        IS_SNS_QQ_SHARE_AVAILABLE = %s
        -- QQ PACKAGE NAME : %s, APPNAME: %s
        SNS_QQ_APPID  = '%s'
        SNS_QQ_APPKEY = '%s'

        -- WEIXIN PACKAGE NAME : %s, APPNAME: %s
        IS_SNS_WEIXIN_SHARE_AVAILABLE = %s

        CHANNEL = "%s"
''' % (channelAndroid.qq.isLogInAvailable, channelAndroid.qq.isShareAvailable, \
    channelAndroid.qq.PkgName, channelAndroid.qq.Name, 
    channelAndroid.qq.AppID, channelAndroid.qq.AppKey, \
    channelAndroid.wx.Name, channelAndroid.packageName, channelAndroidWX, channelAndroid.packageName)

    serverAndroid = '''
        -- debug server: %s
        LEAN_CLOUD_NAME_TEST = "%s"
        LEAN_CLOUD_ID_TEST   = "%s"
        LEAN_CLOUD_KEY_TEST  = "%s"

        -- release server: %s
        LEAN_CLOUD_NAME      = "%s"
        LEAN_CLOUD_ID        = "%s"
        LEAN_CLOUD_KEY       = "%s"
''' % (testServer.AppName, testServer.AppName, testServer.AppID, testServer.AppKey, \
    channelAndroid.server.AppName, channelAndroid.server.AppName, channelAndroid.server.AppID, channelAndroid.server.AppKey)
    # ---------------------------------------------------------------------------------
    channeliOSWX = 'false'
    if channeliOS.wx.AppID != '':
        channeliOSWX = 'true'

    snsiOS = '''
        IS_SNS_QQ_LOGIN_AVAILABLE = %s
        IS_SNS_QQ_SHARE_AVAILABLE = %s
        -- QQ PACKAGE NAME : %s, APPNAME: %s
        SNS_QQ_APPID  = '%s'
        SNS_QQ_APPKEY = '%s'

        -- WEIXIN PACKAGE NAME : %s, APPNAME: %s
        IS_SNS_WEIXIN_SHARE_AVAILABLE = %s

        CHANNEL = "%s"
''' % (channeliOS.qq.isLogInAvailable, channeliOS.qq.isShareAvailable, \
    channeliOS.qq.PkgName, channeliOS.qq.Name, 
    channeliOS.qq.AppID, channeliOS.qq.AppKey, \
    channeliOS.wx.Name, channeliOS.packageName, channeliOSWX, channeliOS.packageName)

    serveriOS = '''
        -- debug server: %s
        LEAN_CLOUD_NAME_TEST = "%s"
        LEAN_CLOUD_ID_TEST   = "%s"
        LEAN_CLOUD_KEY_TEST  = "%s"

        -- release server: %s
        LEAN_CLOUD_NAME      = "%s"
        LEAN_CLOUD_ID        = "%s"
        LEAN_CLOUD_KEY       = "%s"
''' % (testServer.AppName, testServer.AppName, testServer.AppID, testServer.AppKey, \
    channeliOS.server.AppName, channeliOS.server.AppName, channeliOS.server.AppID, channeliOS.server.AppKey)
    # ---------------------------------------------------------------------------------

    luaSrcPath = savePath[0:savePath.rfind('/')] + '/'
    allwordsFullPath = luaSrcPath + '../../raw/codes/bbdxw.lua'
    wordPath = luaSrcPath + '../../raw/codes/words/'
    targetPath = luaSrcPath + '/model/words/'
    if os.path.exists(targetPath):
        shutil.rmtree(targetPath)
    os.makedirs(targetPath)

    IS_DEVELOPMENT_MODE = 'false'
    if buildTarget.loadAllWords:
        IS_DEVELOPMENT_MODE = 'true'
        shutil.copy(allwordsFullPath, targetPath)
    else:
        f = open(allwordsFullPath,'r')  

        for line in f.readlines():  
            if line.find('M.allwords["') >= 0:
                word = line[len('M.allwords["'):line.index('"]={"')]
                w = open(targetPath + word + '.lua', 'w')
                w.write('return {' + line[line.index('"]={"') + 5 + len(word) + 2:len(line)])
                w.close()

        f.close() 
        # for parent, dirnames, filenames in os.walk(wordPath):
        #     for filename in filenames:
        #         fullPath = os.path.join(parent, filename)
        #         shutil.copy(fullPath, targetPath)

    lua = '''%s

function initBuildTarget()

    IS_DEVELOPMENT_MODE = %s
    
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        %s
        %s
    else
        %s
        %s
    end

    --------------------------------------------------------------------------------

    BUILD_TARGET_DEBUG            = '%s'
    BUILD_TARGET_RELEASE          = '%s'
    BUILD_TARGET_RELEASE_TEST     = '%s'

    BUILD_TARGET = '%s' -- BUILD_TARGET_DEBUG, BUILD_TARGET_RELEASE, BUILD_TARGET_RELEASE_TEST

    --------------------------------------------------------------------------------

    LUA_ERROR = ''

end

function getAppVersionDebugInfo()
    if BUILD_TARGET_RELEASE == BUILD_TARGET then return end

    local str = ''
    -- if s_CURRENT_USER.sessionToken ~= '' then str = s_CURRENT_USER.username .. '\\nnick:' .. s_CURRENT_USER.nickName end
    str = '\\nname:' .. s_CURRENT_USER.username .. '\\nnick:' .. s_CURRENT_USER.nickName .. '\\nchannel:' .. CHANNEL .. ' v:' .. s_APP_VERSION .. '\\n%s'
    str = '[%s]' .. ' ' .. str .. '\\n' .. s_SERVER.appName .. '\\n' .. LUA_ERROR
    return str
end

''' % (buildInfo, IS_DEVELOPMENT_MODE,\
    snsAndroid, serverAndroid, snsiOS, serveriOS, \
    BUILD_TYPE_DEBUG, BUILD_TYPE_RELEASE, BUILD_TYPE_RELEASE_TEST, \
    buildTarget.buildType, gitVer, buildTarget.description)
    
    f = open(savePath, 'w')
    f.write(lua)
    f.close()

# ---------------------------------------------------------------------------------

def createObjectiveCCodes(gitVer, testServer, buildTarget, channeliOS, savePath):
    buildInfo = 'BUILD INFORMATION: %s (iOS:%s, %s)' % (buildTarget.description, channeliOS.name, channeliOS.packageName)

    server = testServer
    if buildTarget.buildType != BUILD_TYPE_DEBUG:
        server = channeliOS.server
    isProduction = 'NO'
    if buildTarget.isProduction:
        isProduction = 'YES'

    channeliOSWX = 'NO'
    if channeliOS.wx.AppID != '':
        channeliOSWX = 'YES'

    objc = '''
// %s
// %s
// server: %s

#define INIT_APP \\
    [AVOSCloud setApplicationId:@"%s" \\
                      clientKey:@"%s"]; \\
    [AVCloud setProductionMode:%s];\\
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];\\
    \\
    if (%s) [WXApi registerApp:@"%s"];

''' % (buildInfo, gitVer, server.AppName, server.AppID, server.AppKey, isProduction, channeliOSWX, channeliOS.wx.AppID)

    f = open(savePath, 'w')
    f.write(objc)
    f.close()

# ---------------------------------------------------------------------------------

def createJavaCodes(gitVer, testServer, buildTarget, channelAndroid, savePath):
    buildInfo = 'BUILD INFORMATION: %s (Android:%s, %s)' % (buildTarget.description, channelAndroid.name, channelAndroid.packageName)

    server = testServer
    if buildTarget.buildType != BUILD_TYPE_DEBUG:
        server = channelAndroid.server
    isProduction = 'false'
    isDebugLogEnabled = 'true'
    if buildTarget.isProduction:
        isProduction = 'true'
        isDebugLogEnabled = 'false'

    isUMengAvailable = 'false'
    if len(channelAndroid.um.AppKey) > 0:
        isUMengAvailable = 'true'

    java = '''
// ----------
// %s
// %s
// ----------
package c.bb.dc;

import android.app.Activity;

import com.avos.avoscloud.AVCloud;
import com.avos.avoscloud.AVOSCloud;
import com.umeng.analytics.AnalyticsConfig;

public class AppVersionInfo {
    public static final String WEIXIN_APP_ID = "%s";

    public static void initServer(Activity a) {
        // server: %s
        AVOSCloud.initialize(a, "%s", "%s");
        AVOSCloud.setDebugLogEnabled(%s);
        AVCloud.setProductionMode(%s);

        if (%s) {
            AnalyticsConfig.setAppkey("%s");
            AnalyticsConfig.setChannel("%s");
        }
    }
}
''' % (buildInfo, gitVer, channelAndroid.wx.AppID, server.AppName, server.AppID, server.AppKey, isDebugLogEnabled, isProduction, isUMengAvailable, channelAndroid.um.AppKey, channelAndroid.packageName)
    
    f = open(savePath, 'w')
    f.write(java)
    f.close()

# ---------------------------------------------------------------------------------

def setupAndroidProject(channelAndroid, manifestSrc, manifestDst, androidProjSrcPath, AppActivitySrc, AppActivityName, BBPushNotificationServiceSrc, BBPushNotificationServiceDst, MyProgressDialogSrc, MyProgressDialogDsc):
    # androidManifest ------------------------------------------------
    manifestRaw = open(manifestSrc).read()
    # <meta-data android:name="Channel ID" android:value="LeanCloud"/>
    manifestNew = manifestRaw.replace('com.beibei.wordmaster', channelAndroid.packageName)
    manifestNew = manifestNew.replace('LeanCloud', channelAndroid.name)
    if len(channelAndroid.qq.AppID) > 0:
        manifestNew = manifestNew.replace('1103783596', channelAndroid.qq.AppID)
    else:
        manifestNew = manifestNew.replace('<!-- tencent start -->', '<!-- tencent start ')
        manifestNew = manifestNew.replace('<!-- tencent end -->', ' tencent end -->')

    manifestFile = open(manifestDst, 'w')
    manifestFile.write(manifestNew)
    manifestFile.close()
    # androidManifest ------------------------------------------------

    # AppActivity.java ------------------------------------------------
    if os.path.exists(androidProjSrcPath + '/com/beibei/wordmaster'):
        shutil.rmtree(androidProjSrcPath + '/com/beibei/wordmaster')
    pkgPath = androidProjSrcPath + '/' + channelAndroid.packageName.replace('.', '/') + '/'
    os.makedirs(pkgPath)

    rawJavaStr = open(AppActivitySrc).read()
    newJavaStr = rawJavaStr.replace('com.beibei.wordmaster', channelAndroid.packageName)

    newAppActivityJava = open(pkgPath + AppActivityName, 'w')
    newAppActivityJava.write(newJavaStr)
    newAppActivityJava.close()
    # AppActivity.java ------------------------------------------------

    # BBPushNotificationService.java
    rawJavaStr = open(BBPushNotificationServiceSrc).read()
    newJavaStr = rawJavaStr.replace('com.beibei.wordmaster', channelAndroid.packageName)
    newAppActivityJava = open(BBPushNotificationServiceDst, 'w')
    newAppActivityJava.write(newJavaStr)
    newAppActivityJava.close()
    # BBPushNotificationService.java

    rawJavaStr = open(MyProgressDialogSrc).read()
    newJavaStr = rawJavaStr.replace('com.beibei.wordmaster', channelAndroid.packageName)
    newAppActivityJava = open(MyProgressDialogDsc, 'w')
    newAppActivityJava.write(newJavaStr)
    newAppActivityJava.close()

    pass

# ---------------------------------------------------------------------------------
# BUILD_TYPE_DEBUG        = '0'
# BUILD_TYPE_RELEASE      = '1'
# BUILD_TYPE_RELEASE_TEST = '2'

BUILD_TARGET_DEBUG        = BuildTarget(BUILD_TYPE_DEBUG,        'BUILD_TARGET_DEBUG',        False, False)
BUILD_TARGET_RELEASE      = BuildTarget(BUILD_TYPE_RELEASE,      'BUILD_TARGET_RELEASE',      True,  False)
BUILD_TARGET_RELEASE_TEST = BuildTarget(BUILD_TYPE_RELEASE_TEST, 'BUILD_TARGET_RELEASE_TEST', False, False)
BUILD_TARGET_DEVELOPMENT  = BuildTarget(BUILD_TYPE_DEBUG,        'BUILD_TARGET_DEVELOPMENT',  False, True)
TEST_SERVER = Server('贝贝单词X测试', 'gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn', 'x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3')

# createLuaCodes('gitVer', TEST_SERVER, BUILD_TARGET_DEBUG, channelAndroid, channeliOS, '/Users/bmo/Dev/YiSiYiDian/BeiBeiDanCiX/BeiBei2DXLua/src/AppVersionInfo.lua')
# createObjectiveCCodes('gitVer', TEST_SERVER, BUILD_TARGET_DEBUG, channeliOS, 'savePath')
# createJavaCodes('gitVer', TEST_SERVER, BUILD_TARGET_DEBUG, channelAndroid, 'savePath')

if __name__ == "__main__":
    _appType = sys.argv[1]
    _ver = sys.argv[2]

    _channelXml = sys.argv[3]
    _channelName = sys.argv[4]

    _lua = sys.argv[5]
    _objc = sys.argv[6]
    _java = sys.argv[7]

    _manifestSrc = sys.argv[8]
    _manifestDst = sys.argv[9]
    _androidProjSrcPath = sys.argv[10]
    _AppActivitySrc = sys.argv[11]
    _AppActivityName = sys.argv[12]
    _BBPushNotificationServiceSrc = sys.argv[13]
    _BBPushNotificationServiceDsc = sys.argv[14]
    _MyProgressDialogSrc = sys.argv[15]
    _MyProgressDialogDsc = sys.argv[16]

    # ---------------------------------------------------------------------------------

    buildTarget = BUILD_TARGET_DEBUG
    if _appType == BUILD_TYPE_RELEASE:
        buildTarget = BUILD_TARGET_RELEASE
    elif _appType == BUILD_TYPE_RELEASE_TEST:
        buildTarget = BUILD_TARGET_RELEASE_TEST
    elif _appType == BUILD_TYPE_DEVELOPMENT:
        buildTarget = BUILD_TARGET_DEVELOPMENT

    channeliOS = readChannelConfigurations(_channelXml, 'iOS')
    channelAndroid = readChannelConfigurations(_channelXml, _channelName)

    createLuaCodes(_ver, TEST_SERVER, buildTarget, channelAndroid, channeliOS, _lua)
    createObjectiveCCodes(_ver, TEST_SERVER, buildTarget, channeliOS, _objc)
    createJavaCodes(_ver, TEST_SERVER, buildTarget, channelAndroid, _java)

    setupAndroidProject(channelAndroid, _manifestSrc, _manifestDst, _androidProjSrcPath, _AppActivitySrc, _AppActivityName, _BBPushNotificationServiceSrc, _BBPushNotificationServiceDsc, _MyProgressDialogSrc, _MyProgressDialogDsc)
