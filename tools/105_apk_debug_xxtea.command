baseDirForScriptSelf=$(cd "$(dirname "$0")"; pwd)
cd ${baseDirForScriptSelf}/../BeiBei2DXLua

cocos run \
    -p android \
    -j 4 \
    -ap 17 \
    --luacompile \
    --lua-encrypt true --lua-encrypt-key "fuck2dxLua" --lua-encrypt-sign "fuckXXTEA" \
    —disable-compile true