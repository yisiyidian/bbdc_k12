baseDirForScriptSelf=$(cd "$(dirname "$0")"; pwd)
cd ${baseDirForScriptSelf}/../BeiBei2DXLua

cocos run \
    -p ios \
    -j 4 \
    --sign-identity "com.BeiBeiDanCiX"

# xcrun   -sdk iphoneos PackageApplication \
#         -v ${baseDirForScriptSelf}/../BeiBei2DXLua/runtime/ios/BeiBei2DXLua.app \
#         -o ${baseDirForScriptSelf}/../BeiBei2DXLua/runtime/ios/BeiBei2DXLua.ipa