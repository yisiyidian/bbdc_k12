baseDirForScriptSelf=$(cd "$(dirname "$0")"; pwd)
cd ${baseDirForScriptSelf}/../BeiBei2DXLua

cocos compile \
    -p android \
    -j 4 \
    -ap 17 \
    -m release \
    --luacompile \
    --lua-encrypt --lua-encrypt-key "fuck2dxLua" --lua-encrypt-sign "fuckXXTEA"

# BeiBei2DXLua/publish/android/BeiBei2DXLua-release-signed.apk    