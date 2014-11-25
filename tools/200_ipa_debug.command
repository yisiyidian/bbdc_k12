baseDirForScriptSelf=$(cd "$(dirname "$0")"; pwd)
cd ${baseDirForScriptSelf}/../BeiBei2DXLua

cocos run -p ios -j 4 --compile-script 1
xcrun   -sdk iphoneos PackageApplication \
        -v ${baseDirForScriptSelf}/../BeiBei2DXLua/runtime/ios/BeiBei2DXLua.app \
        -o ${baseDirForScriptSelf}/../BeiBei2DXLua/runtime/ios/BeiBei2DXLua.ipa