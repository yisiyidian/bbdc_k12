echo "Enter < NUMBER > of app type (Debug: 0, Release: 1, Release for test: 2):"   #参数-n的作用是不换行，echo默认是换行
read APPTYPE 

if [ $APPTYPE = "0" ] ; then     #如果是linux的话打印linux字符串
    echo "Debug" 
elif [ $APPTYPE = "1" ] ; then   
    echo "Release" 
elif [ $APPTYPE = "2" ] ; then 
    echo "Release for test" 
else 
    echo "Wrong App Type" 
    exit 0
fi

BASE_DIR_FOR_SCRIPT_SELF=$(cd "$(dirname "$0")"; pwd)
cd ${BASE_DIR_FOR_SCRIPT_SELF}/

CHANNEL_NAME="xiaomi"
CHANNEL_CONFIGS=${BASE_DIR_FOR_SCRIPT_SELF}/../tools/channel_configs/configs.json
ANDROID_MANIFEST=${BASE_DIR_FOR_SCRIPT_SELF}/../tools/channel_configs/AndroidManifest.xml
ANDROID_MANIFEST_TARGET=${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/frameworks/runtime-src/proj.android/AndroidManifest.xml

LUA_CODE=${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/src/AppVersionInfo.lua 
OBJC_CODE=${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/frameworks/runtime-src/proj.ios_mac/ios/AppVersionInfo.h
JAVA_CODE=${BASE_DIR_FOR_SCRIPT_SELF}/../BeiBei2DXLua/frameworks/runtime-src/proj.android/src/c/bb/dc/AppVersionInfo.java

DATE=$(date +%Y_%m%d_%H%M)
echo $DATE

BRANCH=`git branch | awk '{if ($1=="*") print $2}'`

LOCALVER=`git rev-list HEAD | wc -l | awk '{print $1}'`

VER=r$LOCALVER
echo $VER

VER=$DATE"_"$BRANCH"_"$VER"_"$(git rev-list HEAD -n 1 | cut -c 1-7)
echo $VER

python exportCodes.py $APPTYPE $VER ${LUA_CODE} ${OBJC_CODE} ${JAVA_CODE} $CHANNEL_NAME $CHANNEL_CONFIGS $ANDROID_MANIFEST $ANDROID_MANIFEST_TARGET
