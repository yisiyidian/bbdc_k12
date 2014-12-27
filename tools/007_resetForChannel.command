echo ""
echo "1st -------------------------------"
echo "Enter < NUMBER > of app type"
echo "Debug:            \033[31m0\033[0m"
echo "Release:          \033[31m1\033[0m"
echo "Release for test: \033[31m2\033[0m"

read APPTYPE 

if [ $APPTYPE = "0" ] ; then
    echo "Debug" 
elif [ $APPTYPE = "1" ] ; then   
    echo "Release" 
elif [ $APPTYPE = "2" ] ; then 
    echo "Release for test" 
else 
    echo "Wrong App Type" 
    exit 0
fi

echo ""
echo "2nd -------------------------------"
echo "Enter < NUMBER > of channel"
echo "xiao mi:          \033[31m0\033[0m"
echo "other androids:   \033[31m1\033[0m"

read CHANNEL_NAME_ID

CHANNEL_NAME="xiaomi"
if [ $CHANNEL_NAME_ID = "0" ] ; then
    CHANNEL_NAME="xiaomi" 
elif [ $CHANNEL_NAME_ID = "1" ] ; then   
    CHANNEL_NAME="android" 
# elif [ $APPTYPE = "2" ] ; then 
    # echo "Release for test" 
else 
    echo "Wrong channel id" 
    exit 0
fi

BASE_DIR_FOR_SCRIPT_SELF=$(cd "$(dirname "$0")"; pwd)
cd ${BASE_DIR_FOR_SCRIPT_SELF}/

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
