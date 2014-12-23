
BASE_DIR_FOR_SCRIPT_SELF=$(cd "$(dirname "$0")"; pwd)
cd ${BASE_DIR_FOR_SCRIPT_SELF}/

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

python exportCodes.py 2 $VER ${LUA_CODE} ${OBJC_CODE} ${JAVA_CODE}
