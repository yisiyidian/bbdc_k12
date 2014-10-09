BeiBeiDanCiX
============

1. OSX下面的包管理工具 Homebrew
安装命令:
    ruby ­e "$(curl ­fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

2. 好用的 shell zsh
安装命令:
    curl ­L http://install.ohmyz.sh | sh

打开 .zshrc
    # Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
    export COCOS_CONSOLE_ROOT=XXX/cocos2d-x-3.2/tools/cocos2d-console/bin
    export ANT_ROOT=/usr/local/bin
    export ANDROID_SDK_ROOT=/usr/local/Cellar/android-sdk/23.0.2
    export NDK_ROOT=/usr/local/Cellar/android-ndk/r9d
    export PATH=$ANT_ROOT:$ANDROID_SDK_ROOT:$NDK_ROOT:$COCOS_CONSOLE_ROOT:$PATH

3. android sdk
安装命令:
    brew install android­sdk
    android
打开 android sdk 管理界面后选择对应的 sdk 进行安装

3. android­ndk
安装流程:
    brew install android­ndk
    git checkout e8448bb /usr/local/Library/Formula/android­ndk.rb

4. ant
安装命令:
    brew install ant

5. build & run apk
    cd BeiBei2DXLua
    cocos run -p android -j 4 --ap 20

----------------------------------------------------------------------------------------

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

每天有15分钟的代码复审的任务，关于代码复审：http://coolshell.cn/articles/1302.html

----------------------------------------------------------------------------------------

TODO:
layer 替换模块
每条数据加上 appVersion 字段和被存储的次数 recordCnt 来保证单机和联网的数据同步
