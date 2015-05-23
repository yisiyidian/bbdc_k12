#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import sys, os, subprocess

def inputAppType():
    cmd = '''
echo ""
echo " -------------------------------"
echo "input App Type"
echo "Enter < NUMBER > of app type"
echo " -------------------------------"
echo " "
echo "Debug:            \\033[31m0\\033[0m"
echo "Release:          \\033[31m1\\033[0m"
echo "Release for test: \\033[31m2\\033[0m"
echo "Development:      \\033[31m3\\033[0m"
echo " "
echo " -------------------------------"

read APPTYPE 

if [ $APPTYPE = "0" ] ; then
    echo "Debug" 
elif [ $APPTYPE = "1" ] ; then   
    echo "Release" 
elif [ $APPTYPE = "2" ] ; then 
    echo "Release for test" 
elif [ $APPTYPE = "3" ] ; then 
    echo "Development" 
else 
    echo "Wrong App Type" 
    exit 0
fi
'''
    return cmd

def inputChannelId():

# echo "xiao mi:          \\033[31m0\\033[0m"
# echo "open.QQ.com:      \\033[31m1\\033[0m"
# echo "360qihu:          \\033[31m2\\033[0m"
# echo "wan dou jia:      \\033[31m3\\033[0m"
# echo "baidu:            \\033[31m4\\033[0m"
# echo "others:           \\033[31m100\\033[0m"

# if [ $CHANNEL_NAME_ID = "0" ] ; then
#     CHANNEL_NAME="xiaomi" 
# elif [ $CHANNEL_NAME_ID = "1" ] ; then   
#     CHANNEL_NAME="openQQ" 
# elif [ $CHANNEL_NAME_ID = "2" ] ; then 
#     CHANNEL_NAME="360qihu" 
# elif [ $CHANNEL_NAME_ID = "3" ] ; then 
#     CHANNEL_NAME="wdj" 
# elif [ $CHANNEL_NAME_ID = "4" ] ; then 
#     CHANNEL_NAME="baidu" 
# elif [ $CHANNEL_NAME_ID = "100" ] ; then 
#     CHANNEL_NAME="others" 
# fi

    cmd = '''
echo ""
echo " -------------------------------"
echo "input Channel Id"
echo "Enter < NUMBER > of channel"
echo " -------------------------------"
echo " "
echo "AnySDK:           \\033[31m0\\033[0m"
echo "open.QQ.com:      \\033[31m1\\033[0m"
echo "360qihu:          \\033[31m2\\033[0m"
echo " "
echo " -------------------------------"

read CHANNEL_NAME_ID

CHANNEL_NAME="DEBUG"
if [ $CHANNEL_NAME_ID = "0" ] ; then
    CHANNEL_NAME="anysdk" 
elif [ $CHANNEL_NAME_ID = "1" ] ; then   
    CHANNEL_NAME="openQQ" 
elif [ $CHANNEL_NAME_ID = "2" ] ; then 
    CHANNEL_NAME="360qihu" 
fi
'''
    return cmd

def resetCodesAndProjectsConfigsForChannel():
    cmd = '''
echo ""
echo " -------------------------------"
echo "reset Codes And Projects Configs For Channel"
echo ""

BASE_DIR_FOR_SCRIPT_SELF=%s
cd ${BASE_DIR_FOR_SCRIPT_SELF}/

CHANNEL_CONFIGS_PATH=${BASE_DIR_FOR_SCRIPT_SELF}/../tools/channel_configs/
CHANNEL_CONFIGS=${CHANNEL_CONFIGS_PATH}/channels.xml

JAVA_PROJ=${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/frameworks/runtime-src/proj.android
JAVA_SRC=${JAVA_PROJ}/src/

ANDROID_MANIFEST=${CHANNEL_CONFIGS_PATH}/AndroidManifest.xml
ANDROID_MANIFEST_TARGET=${JAVA_PROJ}/AndroidManifest.xml

APP_ACTIVITY_NAME=AppActivity.java
APP_ACTIVITY=${CHANNEL_CONFIGS_PATH}/AppActivity.java

BBPUSHNOTIFICATIONSERVICESRC=${CHANNEL_CONFIGS_PATH}/BBPushNotificationService.java
BBPUSHNOTIFICATIONSERVICEDSC=${JAVA_SRC}/c/bb/dc/notification/BBPushNotificationService.java
MyProgressDialogSRC=${CHANNEL_CONFIGS_PATH}/MyProgressDialog.java
MyProgressDialogDSC=${JAVA_SRC}/c/bb/dc/MyProgressDialog.java

LUA_CODE=${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/src/AppVersionInfo.lua 
OBJC_CODE=${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/frameworks/runtime-src/proj.ios_mac/ios/AppVersionInfo.h
JAVA_CODE=${JAVA_SRC}/c/bb/dc/AppVersionInfo.java

DATE=$(date +%%Y_%%m%%d_%%H%%M)
echo $DATE

BRANCH=`git branch | awk '{if ($1=="*") print $2}'`

LOCALVER=`git rev-list HEAD | wc -l | awk '{print $1}'`

VER=r$LOCALVER
echo $VER

VER=$DATE"_"$BRANCH"_"$VER"_"$(git rev-list HEAD -n 1 | cut -c 1-7)
echo $VER

cd ${CHANNEL_CONFIGS_PATH}/
python channel.py $APPTYPE $VER \
    $CHANNEL_CONFIGS $CHANNEL_NAME \
    $LUA_CODE $OBJC_CODE $JAVA_CODE \
    $ANDROID_MANIFEST $ANDROID_MANIFEST_TARGET \
    $JAVA_SRC $APP_ACTIVITY $APP_ACTIVITY_NAME \
    $BBPUSHNOTIFICATIONSERVICESRC $BBPUSHNOTIFICATIONSERVICEDSC \
    $MyProgressDialogSRC $MyProgressDialogDSC

cd $JAVA_PROJ
ant clean
android update project --name BeiBei2DXLua --target "android-17" --path $JAVA_PROJ
''' % os.getcwd()
    return cmd

# BeiBei2DXLua/runtime/android/BeiBei2DXLua-debug.apk
# BeiBei2DXLua/publish/android/BeiBei2DXLua-release-signed.apk
# BeiBei2DXLua/publish/android/BeiBei2DXLua-release-unsigned.apk
def packageApk():
    cmd = '''
cd ${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua

APK_PATH=${BASE_DIR_FOR_SCRIPT_SELF}/../tmp_apk
if [ ! -x ${APK_PATH} ]; then
    mkdir ${APK_PATH}
fi
APK_CHANNEL_PATH=${APK_PATH}/android_$CHANNEL_NAME
if [ ! -x ${APK_CHANNEL_PATH} ]; then
    mkdir ${APK_CHANNEL_PATH}
fi

if [ $APPTYPE = "0" ] ; then
    cocos compile -p android -j 4 -ap 17    
    cp ${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/runtime/android/BeiBei2DXLua-debug.apk ${APK_CHANNEL_PATH}/debug_$VER.apk
elif [ $APPTYPE = "1" ] ; then   
    cocos compile -p android -j 4 -ap 17 -m release --luacompile --lua-encrypt --lua-encrypt-key "fuck2dxLua" --lua-encrypt-sign "fuckXXTEA" —disable-compile true
    cp ${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/publish/android/BeiBei2DXLua-release-signed.apk ${APK_CHANNEL_PATH}/release-signed_$VER.apk
elif [ $APPTYPE = "2" ] ; then 
    cocos compile -p android -j 4 -ap 17 -m release
    cp ${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/publish/android/BeiBei2DXLua-release-unsigned.apk ${APK_CHANNEL_PATH}/release-unsigned_$VER.apk
else 
    exit 0
fi
'''
    return cmd
    pass

# BUILD_TARGET_DEBUG = '0'
# BUILD_TARGET_RELEASE = '1'
# BUILD_TARGET_RELEASE_TEST = '2'
# BUILD_TYPE_DEVELOPMENT  = '3'

if __name__ == "__main__":
    if sys.argv[1] == '0':
        cmd = 'APPTYPE="0"' + inputChannelId() + resetCodesAndProjectsConfigsForChannel()
    elif sys.argv[1] == '1':
        cmd = 'APPTYPE="1"' + inputChannelId() + resetCodesAndProjectsConfigsForChannel()
    elif sys.argv[1] == '2':
        cmd = 'APPTYPE="2"' + inputChannelId() + resetCodesAndProjectsConfigsForChannel()
    elif sys.argv[1] == '3':
        cmd = 'APPTYPE="3"' + inputChannelId() + resetCodesAndProjectsConfigsForChannel()
    else:
        cmd = inputAppType() + inputChannelId() + resetCodesAndProjectsConfigsForChannel() + packageApk()

    subprocess.call(cmd, shell=True)

