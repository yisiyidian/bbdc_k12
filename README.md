BeiBeiDanCiX
============

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
