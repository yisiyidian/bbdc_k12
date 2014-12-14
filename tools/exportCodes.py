#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import json
import os, os.path, errno
import sys
import shutil

def exportLua(isRelease, appVersionInfo, fullpathLua):
    appVersionInfoLua = ''

    if isRelease == '0':
        appVersionInfoLua = appVersionInfoLua + '''
RELEASE_APP = false

function getAppVersionDebugInfo()
    local str = ''
    if s_CURRENT_USER.sessionToken ~= '' then str = s_CURRENT_USER.username end
    if AgentManager ~= nil then
        str = 'name:' .. str .. ', channel:' .. AgentManager:getInstance():getChannelId() .. '\\nv:' .. s_APP_VERSION .. '\\n%s'
    else
        str = 'name:' .. str .. ', channel:' .. 'unknown' .. '\\nv:' .. s_APP_VERSION .. '\\n%s'
    end
    return str
end
''' % (appVersionInfo, appVersionInfo)
    else:
        appVersionInfoLua = appVersionInfoLua + '''
RELEASE_APP = false

function getAppVersionDebugInfo() return '' end
'''

    appVersionInfoLuaFile = open(fullpathLua, 'w')
    appVersionInfoLuaFile.write(appVersionInfoLua)
    appVersionInfoLuaFile.close()

    pass

def exportObjc(isRelease, appVersionInfo, fullpath):
    appVersionInfoLua = ''

    if isRelease == '0':
        appVersionInfoLua = appVersionInfoLua + '''
#define INIT_SERVER \\
    [AVOSCloud setApplicationId:LEAN_CLOUD_ID_TEST \\
                      clientKey:LEAN_CLOUD_KEY_TEST]; \\
    [AVCloud setProductionMode:NO];
'''
    else:
        appVersionInfoLua = appVersionInfoLua + '''
#define INIT_SERVER \\        
    [AVOSCloud setApplicationId:LEAN_CLOUD_ID \\
                      clientKey:LEAN_CLOUD_KEY]; \\
    [AVCloud setProductionMode:YES];
'''

    appVersionInfoLuaFile = open(fullpath, 'w')
    appVersionInfoLuaFile.write(appVersionInfoLua)
    appVersionInfoLuaFile.close()

    pass

def exportJava(isRelease, appVersionInfo, fullpath):
    appVersionInfoLua = ''

    if isRelease == '0':
        appVersionInfoLua = appVersionInfoLua + '''
package c.bb.dc;
import com.avos.avoscloud.AVCloud;
import com.avos.avoscloud.AVOSCloud;
import android.app.Activity;
public class AppVersionInfo {
    public static void initServer(Activity a, String LEAN_CLOUD_ID_TEST, String LEAN_CLOUD_KEY_TEST, String LEAN_CLOUD_ID, String LEAN_CLOUD_KEY) {
        AVOSCloud.initialize(a, LEAN_CLOUD_ID_TEST, LEAN_CLOUD_KEY_TEST);
        AVOSCloud.setDebugLogEnabled(true);
        AVCloud.setProductionMode(false);
    }
}
'''
    else:
        appVersionInfoLua = appVersionInfoLua + '''
package c.bb.dc;
import com.avos.avoscloud.AVCloud;
import com.avos.avoscloud.AVOSCloud;
import android.app.Activity;
public class AppVersionInfo {
    public static void initServer(Activity a, String LEAN_CLOUD_ID_TEST, String LEAN_CLOUD_KEY_TEST, String LEAN_CLOUD_ID, String LEAN_CLOUD_KEY) {
        AVOSCloud.initialize(a, LEAN_CLOUD_ID, LEAN_CLOUD_KEY);
        AVOSCloud.setDebugLogEnabled(false);
        AVCloud.setProductionMode(true);
    }
}
'''

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
