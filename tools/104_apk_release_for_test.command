baseDirForScriptSelf=$(cd "$(dirname "$0")"; pwd)
cd ${baseDirForScriptSelf}/../BeiBei2DXLua

cocos compile \
    -p android \
    -j 4 \
    -ap 17 \
    -m release