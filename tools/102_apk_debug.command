baseDirForScriptSelf=$(cd "$(dirname "$0")"; pwd)
cd ${baseDirForScriptSelf}/../BeiBei2DXLua

cocos run \
    -p android \
    -j 4 \
    -ap 17

# /BeiBei2DXLua/runtime/android/BeiBei2DXLua-debug_houhai.apk