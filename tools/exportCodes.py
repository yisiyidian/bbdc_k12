#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import json
import os, os.path, errno
import sys
import shutil

DEBUG_FOR_TEST       = '0'
RELEASE_FOR_APPSTORE = '1'
RELEASE_FOR_TEST     = '2'

LEAN_CLOUD_TEST = ["gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn", "x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3"]

LEAN_CLOUD_XIAOMI = ["94uw2vbd553rx8fa6h5kt2y1w07p0x2ekwusf4w88epybnrp", "lqsgx6mtmj65sjgrekfn7e5c28xc7koptbk9mqag2oraagdz"]

UMENG_APP_XIAOMI = ["5498fc3afd98c56b4200075d", "xiao-mi"]
UMENG_APP_ANDROID = ['549a5eb9fd98c5b2ac00144e', 'android']

TENCENT_APP = ["1103783596", "n7vXdt6eDIggSsa6"]

# ---------------------------------------------------------

LEAN_CLOUD_RELEASE = LEAN_CLOUD_XIAOMI
UMENG_APP = UMENG_APP_ANDROID

# ---------------------------------------------------------

def getCodeTypeDes(codeType):
    if codeType == DEBUG_FOR_TEST:
        return 'debug'
    elif codeType == RELEASE_FOR_APPSTORE:
        return 'release'
    elif codeType == RELEASE_FOR_TEST:
        return 'release for test'

def getLeanCloudAppId(codeType):
    lean_cloud_id = LEAN_CLOUD_RELEASE[0]
    if codeType == DEBUG_FOR_TEST:
        lean_cloud_id = LEAN_CLOUD_TEST[0]
    return lean_cloud_id

def getLeanCloudAppKey(codeType):
    lean_cloud_key = LEAN_CLOUD_RELEASE[1]
    if codeType == DEBUG_FOR_TEST:
        lean_cloud_key = LEAN_CLOUD_TEST[1]        
    return lean_cloud_key

# ---------------------------------------------------------

def exportLua(codeType, appVersionInfo, fullpathLua):
    appVersionInfoLua = '''-- %s

LEAN_CLOUD_ID_TEST   = "%s"
LEAN_CLOUD_KEY_TEST  = "%s"

LEAN_CLOUD_ID        = "%s"
LEAN_CLOUD_KEY       = "%s"

DEBUG_FOR_TEST       = '0'
RELEASE_FOR_APPSTORE = '1'
RELEASE_FOR_TEST     = '2'

RELEASE_APP = %s
LUA_ERROR = ''

function getAppVersionDebugInfo()
    if RELEASE_FOR_APPSTORE == RELEASE_APP then return end

    local str = ''
    if s_CURRENT_USER.sessionToken ~= '' then str = s_CURRENT_USER.username .. '\\nnick:' .. s_CURRENT_USER.nickName end
    if AgentManager ~= nil then
        str = 'name:' .. str .. '\\nchannel:' .. AgentManager:getInstance():getChannelId() .. '\\nv:' .. s_APP_VERSION .. '\\n%s'
    else
        str = 'name:' .. str .. '\\nchannel:' .. 'unknown' .. '\\nv:' .. s_APP_VERSION .. '\\n%s'
    end
    str = '%s' .. '\\n' .. str .. '\\n' .. LUA_ERROR
    return str
end

''' % (getCodeTypeDes(codeType), LEAN_CLOUD_TEST[0], LEAN_CLOUD_TEST[1], LEAN_CLOUD_RELEASE[0], LEAN_CLOUD_RELEASE[1], codeType, appVersionInfo, appVersionInfo, getCodeTypeDes(codeType))

    appVersionInfoLuaFile = open(fullpathLua, 'w')
    appVersionInfoLuaFile.write(appVersionInfoLua)
    appVersionInfoLuaFile.close()

    pass

def exportObjc(codeType, appVersionInfo, fullpath):
    isProduction = 'NO'
    if codeType == RELEASE_FOR_APPSTORE:
        isProduction = 'YES'

    appVersionInfoLua = ''' // %s

#define TENCENT_APP_ID @"%s"

#define INIT_SERVER \\
    [AVOSCloud setApplicationId:@"%s" \\
                      clientKey:@"%s"]; \\
    [AVCloud setProductionMode:%s];

''' % (getCodeTypeDes(codeType), TENCENT_APP[0], getLeanCloudAppId(codeType), getLeanCloudAppKey(codeType), isProduction)

    appVersionInfoLuaFile = open(fullpath, 'w')
    appVersionInfoLuaFile.write(appVersionInfoLua)
    appVersionInfoLuaFile.close()

    pass

def exportJava(codeType, appVersionInfo, fullpath):
    macro_type = getCodeTypeDes(codeType)
    lean_cloud_id = getLeanCloudAppId(codeType)
    lean_cloud_key = getLeanCloudAppKey(codeType)
    umeng_app_key = UMENG_APP[0]
    umeng_app_channel = UMENG_APP[1]
    qq_app_id = TENCENT_APP[0]
    qq_app_key = TENCENT_APP[1]

    isDebugLogEnabled = 'true'
    isProduction = 'false'
    if codeType == RELEASE_FOR_APPSTORE:
        isDebugLogEnabled = 'false'
        isProduction = 'true'

    appVersionInfoLua = '''
// ----------
// %s
// ----------
package c.bb.dc;

import com.avos.avoscloud.AVCloud;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVOSCloud;
import com.avos.sns.*;

import com.umeng.analytics.AnalyticsConfig;

import android.app.Activity;

public class AppVersionInfo {

    public static void initServer(Activity a) {
        AVOSCloud.initialize(a, "%s", "%s");
        AVOSCloud.setDebugLogEnabled(%s);
        AVCloud.setProductionMode(%s);

        AnalyticsConfig.setAppkey("%s");
        AnalyticsConfig.setChannel("%s");

        try {
            SNS.setupPlatform(SNSType.AVOSCloudSNSQQ, "%s", "%s", null);
        } catch (AVException e) {
            e.printStackTrace();
        }
    }
}
''' % (macro_type, lean_cloud_id, lean_cloud_key, isDebugLogEnabled, isProduction, umeng_app_key, umeng_app_channel, qq_app_id, qq_app_key)

    appVersionInfoLuaFile = open(fullpath, 'w')
    appVersionInfoLuaFile.write(appVersionInfoLua)
    appVersionInfoLuaFile.close()

    pass

def export(codeType, appVersionInfo, fullpathLua, fullpathObjc, fullpathJava):
    exportLua(codeType, appVersionInfo, fullpathLua)
    exportObjc(codeType, appVersionInfo, fullpathObjc)
    exportJava(codeType, appVersionInfo, fullpathJava)
    pass
                
if __name__ == "__main__":
    export(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
