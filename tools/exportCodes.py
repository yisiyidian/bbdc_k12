#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import json
import os, os.path, errno
import sys
import shutil

LEAN_CLOUD_ID_TEST   = "gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn"
LEAN_CLOUD_KEY_TEST  = "x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3"

LEAN_CLOUD_ID        = "94uw2vbd553rx8fa6h5kt2y1w07p0x2ekwusf4w88epybnrp"
LEAN_CLOUD_KEY       = "lqsgx6mtmj65sjgrekfn7e5c28xc7koptbk9mqag2oraagdz"

UMENG_APP_KEY_XIAOMI = ["5498fc3afd98c56b4200075d", "xiao-mi"]

UMENG_INFO           = UMENG_APP_KEY_XIAOMI

def exportLua(isRelease, appVersionInfo, fullpathLua):
    appVersionInfoLua = '''

LEAN_CLOUD_ID_TEST   = "%s"
LEAN_CLOUD_KEY_TEST  = "%s"

LEAN_CLOUD_ID        = "%s"
LEAN_CLOUD_KEY       = "%s"

''' % (LEAN_CLOUD_ID_TEST, LEAN_CLOUD_KEY_TEST, LEAN_CLOUD_ID, LEAN_CLOUD_KEY)

    if isRelease == '0':
        appVersionInfoLua = appVersionInfoLua + '''
RELEASE_APP = false
LUA_ERROR = ''

function getAppVersionDebugInfo()
    local str = ''
    if s_CURRENT_USER.sessionToken ~= '' then str = s_CURRENT_USER.username .. '\\nnick:' .. s_CURRENT_USER.nickName end
    if AgentManager ~= nil then
        str = 'name:' .. str .. '\\nchannel:' .. AgentManager:getInstance():getChannelId() .. '\\nv:' .. s_APP_VERSION .. '\\n%s'
    else
        str = 'name:' .. str .. '\\nchannel:' .. 'unknown' .. '\\nv:' .. s_APP_VERSION .. '\\n%s'
    end
    str = str .. '\\n' .. LUA_ERROR
    return str
end
''' % (appVersionInfo, appVersionInfo)
    else:
        appVersionInfoLua = appVersionInfoLua + '''
RELEASE_APP = true
LUA_ERROR = ''

function getAppVersionDebugInfo() return '' end
'''

    appVersionInfoLuaFile = open(fullpathLua, 'w')
    appVersionInfoLuaFile.write(appVersionInfoLua)
    appVersionInfoLuaFile.close()

    pass

def exportObjc(isRelease, appVersionInfo, fullpath):
    appVersionInfoLua = '''

#define LEAN_CLOUD_ID_TEST   @"%s"
#define LEAN_CLOUD_KEY_TEST  @"%s"

#define LEAN_CLOUD_ID        @"%s"
#define LEAN_CLOUD_KEY       @"%s"

''' % (LEAN_CLOUD_ID_TEST, LEAN_CLOUD_KEY_TEST, LEAN_CLOUD_ID, LEAN_CLOUD_KEY)

    if isRelease == '0':
        appVersionInfoLua = '''
// DEBUG
%s
        
#define INIT_SERVER \\
    [AVOSCloud setApplicationId:LEAN_CLOUD_ID_TEST \\
                      clientKey:LEAN_CLOUD_KEY_TEST]; \\
    [AVCloud setProductionMode:NO];
''' % appVersionInfoLua
    else:
        appVersionInfoLua = '''
// RELEASE
%s

#define INIT_SERVER \\        
    [AVOSCloud setApplicationId:LEAN_CLOUD_ID \\
                      clientKey:LEAN_CLOUD_KEY]; \\
    [AVCloud setProductionMode:YES];
''' % appVersionInfoLua

    appVersionInfoLuaFile = open(fullpath, 'w')
    appVersionInfoLuaFile.write(appVersionInfoLua)
    appVersionInfoLuaFile.close()

    pass

def exportJava(isRelease, appVersionInfo, fullpath):
    appVersionInfoLua = '''

    private static String LEAN_CLOUD_ID_TEST   = "%s";
    private static String LEAN_CLOUD_KEY_TEST  = "%s";

    private static String LEAN_CLOUD_ID        = "%s";
    private static String LEAN_CLOUD_KEY       = "%s";

''' % (LEAN_CLOUD_ID_TEST, LEAN_CLOUD_KEY_TEST, LEAN_CLOUD_ID, LEAN_CLOUD_KEY)

    if isRelease == '0':
        appVersionInfoLua = '''
package c.bb.dc;
import com.avos.avoscloud.AVCloud;
import com.avos.avoscloud.AVOSCloud;
import com.umeng.analytics.AnalyticsConfig;
import android.app.Activity;

// DEBUG
public class AppVersionInfo {
    %s

    public static void initServer(Activity a) {
        AVOSCloud.initialize(a, LEAN_CLOUD_ID_TEST, LEAN_CLOUD_KEY_TEST);
        AVOSCloud.setDebugLogEnabled(true);
        AVCloud.setProductionMode(false);

        AnalyticsConfig.setAppkey(%s);
        AnalyticsConfig.setChannel(%s);
    }
}
''' % (appVersionInfoLua, UMENG_INFO[0], UMENG_INFO[1])
    else:
        appVersionInfoLua = appVersionInfoLua + '''
package c.bb.dc;
import com.avos.avoscloud.AVCloud;
import com.avos.avoscloud.AVOSCloud;
import com.umeng.analytics.AnalyticsConfig;
import android.app.Activity;

// RELEASE
public class AppVersionInfo {
    %s

    public static void initServer(Activity a) {
        AVOSCloud.initialize(a, LEAN_CLOUD_ID, LEAN_CLOUD_KEY);
        AVOSCloud.setDebugLogEnabled(false);
        AVCloud.setProductionMode(true);

        AnalyticsConfig.setAppkey(%s);
        AnalyticsConfig.setChannel(%s);
    }
}
''' % (appVersionInfoLua, UMENG_INFO[0], UMENG_INFO[1])

    appVersionInfoLuaFile = open(fullpath, 'w')
    appVersionInfoLuaFile.write(appVersionInfoLua)
    appVersionInfoLuaFile.close()

    pass

def export(isRelease, appVersionInfo, fullpathLua, fullpathObjc, fullpathJava):
    exportLua(isRelease, appVersionInfo, fullpathLua)
    exportObjc(isRelease, appVersionInfo, fullpathObjc)
    exportJava(isRelease, appVersionInfo, fullpathJava)
    pass
                
if __name__ == "__main__":
    export(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
