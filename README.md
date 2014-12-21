BeiBeiDanCiX
============

BeiBei2DXLua/frameworks/cocos2d-x/tools/bindings-generator/targets/lua/conversions.yaml
line: # lua to native
    CXLUAFUNC: "${out_value} = (  toluafix_ref_function(tolua_S,${arg_idx},0))"    

BeiBei2DXLua/frameworks/cocos2d-x/tools/tolua/genbindings.py
BeiBei2DXLua/frameworks/cocos2d-x/tools/tolua/cx_common_genbindings.py

----------------------------------------------------------------------------------------
开发环境

1. OSX下面的包管理工具 Homebrew
   - 安装命令:
     - ruby ­-e "$(curl ­fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

2. 好用的 shell zsh
   - 安装命令:
     - curl ­-L http://install.ohmyz.sh | sh

   - 打开 .zshrc
       - # Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x

       - ### cocos2d-x-3.2
       - export COCOS_CONSOLE_ROOT=XXX/cocos2d-x-3.2/tools/cocos2d-console/bin
       - export NDK_ROOT=/usr/local/Cellar/android-ndk/r9d

       - ### cocos2d-x-3.3
       - export COCOS_CONSOLE_ROOT=XXX/cocos2d-x-3.3/tools/cocos2d-console/bin
       - export NDK_ROOT=/usr/local/Cellar/android-ndk/r10c

       - export ANT_ROOT=/usr/local/bin
       - export ANDROID_SDK_ROOT=/usr/local/Cellar/android-sdk/23.0.2
       - export PATH=$ANT_ROOT:$ANDROID_SDK_ROOT:$NDK_ROOT:$COCOS_CONSOLE_ROOT:$PATH

3. android sdk
   - 安装命令:
      - brew install android­-sdk
      - android
   - 打开 android sdk 管理界面后选择对应的 sdk 进行安装

3. android­ ndk
   - 安装流程:
      - brew install android­-ndk
      - git checkout e8448bb /usr/local/Library/Formula/android­ndk.rb

4. ant
   - 安装命令:
      - brew install ant

5. build & run apk
    - cd BeiBei2DXLua
    - (debug) cocos run -p android -j 4 --ap 17
    - (release ERROR) cocos run -p android -j 4 --ap 17 --compile-script 1 --lua-encrypt --lua-encrypt-key "fuck2dxLua" --lua-encrypt-sign "fuckXXTEA" -m release
    - (release) cocos run -p android -j 4 --ap 17 --compile-script 1 -m release

6. eclipse ADT Plugin
    - http://developer.android.com/sdk/installing/installing-adt.html

----------------------------------------------------------------------------------------
目录结构

- BeiBei2DXLua
    |-- config.json : 运行时测试用配置
    |-- frameworks
        |-- cocos2d-x : 引擎源码
        |-- runtime-src : 各个平台的工程目录
    |-- res
        |-- cfg : 经过 tools 脚本处理过的配置
        |-- image : 图片
        |-- spine : raw/spine 动画导出后的资源
    |-- runtime : 各个平台的运行时，目前无法正确生成
    |-- src : lua 源代码

- lua_example : 参考例子

- raw
    |-- cfg : 原始配置文件
    |-- spine : 动画源文件

- tools
    |-- 0_exportCfg.command : 导出 raw/cfg/*.json 到 res/cfg/*
    |-- exportCfg_allwords.py : 处理 raw/cfg/allwords.json 为代码使用的格式 res/cfg/allwords

----------------------------------------------------------------------------------------
自定义C/C++代码绑定lua

1. 自定义C/C++代码目录: BeiBei2DXLua/frameworks/cocos2d-x/common
2. - iOS: common 目录中的代码拖入 BeiBei2DXLua/frameworks/runtime-src/proj.ios_mac 的 common group 内 
   - Android: common 目录中的代码按规则添加到 BeiBei2DXLua/frameworks/cocos2d-x/cocos/scripting/lua-bindings/Android.mk
3. 按代码lua绑定规则修改 BeiBei2DXLua/frameworks/cocos2d-x/tools/tolua/cx_common.ini
4. - cd BeiBei2DXLua/frameworks/cocos2d-x/tools/tolua; python cx_common_genbindings.py
   - 生成 BeiBei2DXLua/frameworks/cocos2d-x/cocos/scripting/lua-bindings/auto/lua_cx_common.hpp
   - 生成 BeiBei2DXLua/frameworks/cocos2d-x/cocos/scripting/lua-bindings/auto/lua_cx_common.cpp
   - iOS: 
       * 将 lua_cx_common.hpp 和 lua_cx_common.cpp 拖入 BeiBei2DXLua/frameworks/runtime-src/proj.ios_mac 的 cocos2d_luabindings.xcodeproj/auto group 内
       * 在 cocos2d_luabindings.xcodeproj -> luabinding iOS -> Build Settings -> Header Search Paths 添加 $(SRCROOT)/../../../../common/对应头文件目录
   - Android: 在 BeiBei2DXLua/frameworks/cocos2d-x/cocos/scripting/lua-bindings/CMakeLists.txt 添加 auto/lua_cx_common.cpp 到 LUABINDING_SRC
   - 在 AppDelegate.cpp 中 include lua_cx_common.hpp，并在 //register custom function 下注册绑定的库

----------------------------------------------------------------------------------------
Android 

http://beginios.com/blog/2014/08/19/fix-unknown-android-phone-device-for-mac/

----------------------------------------------------------------------------------------
路径必须使用相对路径 (以AVOS库为例)

1. iOS: BeiBei2DXLua/frameworks/runtime-src/proj.ios_mac -> BeiBei2DXLua iOS -> Build Settings -> Framework Search Paths 
2. Android: BeiBei2DXLua/frameworks/runtime-src/proj.android/.classpath -> <classpathentry kind="lib" path=xxx/>

----------------------------------------------------------------------------------------
lua

lua 简明教程: http://coolshell.cn/articles/10739.html

全局常量:  s_{name} 参考 common/resource.lua. 如果是 class，加上 s_class{XXX}
全局变量:  v_{name}
普通方法: 参考 example/example.lua 和 AudioMgr.lua
普通类: 参考 example/DataExample.lua
继承自 cocos2d-x 的类: 参考 AppScene.lua
模块: 参考 common/debugger.lua
类似C++单例模式: 参考 server/Server.lua

代码中打印日志请使用全局函数 s_logd

----------------------------------------------------------------------------------------
发布或者开发 DEBUG 或者 RELEASE 版本之前需要准备的代码

DEBUG 需要运行  tools/002_exportCodes_debug.comman 生成对应的 lua/objective-c/java 代码
RELEASE 需要运行  tools/003_exportCodes_release.command 生成对应的 lua/objective-c/java 代码

BeiBei2DXLua/src/AppVersionInfo.lua
BeiBei2DXLua/frameworks/runtime-src/proj.ios_mac/ios/AppVersionInfo.h
BeiBei2DXLua/frameworks/runtime-src/proj.android/src/c/bb/dc/AppVersionInfo.java

----------------------------------------------------------------------------------------
代码复审

每天有15分钟的代码复审的任务，关于代码复审：http://coolshell.cn/articles/1302.html

----------------------------------------------------------------------------------------

TODO:
layer 替换模块
每条数据加上 appVersion 字段和被存储的次数 recordCnt 来保证单机和联网的数据同步
资源代码加密
在线更新代码

