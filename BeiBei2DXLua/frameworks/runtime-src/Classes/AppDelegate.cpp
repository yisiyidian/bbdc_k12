#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "cocos2d.h"
#include "CodeIDESupport.h"
#include "Runtime.h"
#include "ConfigParser.h"
#include "lua_module_register.h"
#include "lua_cx_common.hpp"
#include "lua_cocos2dx_custom.hpp"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "anysdkbindings.h"
#include "anysdk_manual_bindings.h"
#endif

//#if (COCOS2D_DEBUG>0 && CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
//#define DEBUG_RUNTIME 1
//#endif

using namespace CocosDenshion;

USING_NS_CC;
using namespace std;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();

#if (COCOS2D_DEBUG > 0 && CC_CODE_IDE_DEBUG_SUPPORT > 0)
	// NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
	endRuntime();
#endif

	ConfigParser::purge();
}

//if you want a different context,just modify the value of glContextAttrs
//it will takes effect on all platforms
void AppDelegate::initGLContextAttrs()
{
    //set OpenGL context attributions,now can only set six attributions:
    //red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

    GLView::setGLContextAttrs(glContextAttrs);
}

bool AppDelegate::applicationDidFinishLaunching()
{
#if (COCOS2D_DEBUG > 0 && CC_CODE_IDE_DEBUG_SUPPORT > 0 && DEBUG_RUNTIME > 0)
    // NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
    initRuntime();
#endif
    
    // initialize director
    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();    
    if(!glview) {
        Size viewSize = ConfigParser::getInstance()->getInitViewSize();
        string title = ConfigParser::getInstance()->getInitViewName();
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 || CC_TARGET_PLATFORM == CC_PLATFORM_MAC) && (COCOS2D_DEBUG > 0 && CC_CODE_IDE_DEBUG_SUPPORT > 0)
        extern void createSimulator(const char* viewName, float width, float height, bool isLandscape = true, float frameZoomFactor = 1.0f);
        bool isLanscape = ConfigParser::getInstance()->isLanscape();
        createSimulator(title.c_str(),viewSize.width,viewSize.height, isLanscape);
#else
        glview = cocos2d::GLViewImpl::createWithRect(title.c_str(), Rect(0, 0, viewSize.width, viewSize.height));
        director->setOpenGLView(glview);
#endif
    }
   
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);

    // If you want to use Quick-Cocos2d-X, please uncomment below code
    // register_all_quick_manual(L);

    LuaStack* stack = engine->getLuaStack();
    stack->setXXTEAKeyAndSign("fuck2dxLua", strlen("fuck2dxLua"), "fuckXXTEA", strlen("fuckXXTEA"));
    
    //register custom function
    auto state = stack->getLuaState();
    lua_getglobal(state, "_G");
    register_all_cx_common(state);
    register_all_cocos2dx_custom(state);
    lua_pop(state, 1);
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    {
        LuaStack* stack = engine->getLuaStack();
        lua_getglobal(stack->getLuaState(), "_G");
        tolua_anysdk_open(stack->getLuaState());
        tolua_anysdk_manual_open(stack->getLuaState());
        lua_pop(stack->getLuaState(), 1);
    }
#endif
    
    std::string writablePath = FileUtils::getInstance()->getWritablePath();
    std::string pathSrc= writablePath + ("AssetsManager/ServerAssets/src");
    std::string pathRes= writablePath + ("AssetsManager/ServerAssets/res");
    FileUtils::getInstance()->addSearchPath(pathSrc,true);
    FileUtils::getInstance()->addSearchPath(pathRes,true);
    engine->addSearchPath(pathSrc.c_str());
    engine->addSearchPath(pathRes.c_str());
    CCLOG("the cpp path is %s",pathSrc.c_str());
    
    //设置可以调试
    setenv("LOG_CURL", "YES", 0);
    //TODO 移除不必要的搜索目录
    std::vector<std::string> soundRes;
    soundRes.push_back(writablePath + "BookSounds"+"/cet4/cet4");
    soundRes.push_back(writablePath + "BookSounds"+"/cet6/cet6");
    soundRes.push_back(writablePath + "BookSounds"+"/gmat/gmat");
    soundRes.push_back(writablePath + "BookSounds"+"/gre/gre");
    soundRes.push_back(writablePath + "BookSounds"+"/gse/gse");
    soundRes.push_back(writablePath + "BookSounds"+"/ielts/ielts");
    soundRes.push_back(writablePath + "BookSounds"+"/middle/middle");
    soundRes.push_back(writablePath + "BookSounds"+"/ncee/ncee");
    soundRes.push_back(writablePath + "BookSounds"+"/primary/primary");
    soundRes.push_back(writablePath + "BookSounds"+"/pro4/pro4");
    soundRes.push_back(writablePath + "BookSounds"+"/pro8/pro8");
    soundRes.push_back(writablePath + "BookSounds"+"/sat/sat");
    soundRes.push_back(writablePath + "BookSounds"+"/toefl/toefl");
    
    for (std::vector<std::string>::iterator it = soundRes.begin(); it!=soundRes.end(); ++it) {
        FileUtils::getInstance()->addSearchPath(*it,true);
        engine->addSearchPath(it->c_str());
    }
   
#if (COCOS2D_DEBUG > 0 && CC_CODE_IDE_DEBUG_SUPPORT > 0 && DEBUG_RUNTIME > 0)
    // NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
    startRuntime();
#else
    
    engine->executeScriptFile(ConfigParser::getInstance()->getEntryFile().c_str());
#endif

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    auto engine = LuaEngine::getInstance();
    
    engine->executeScriptFile("AppScene.lua");
    engine->executeGlobalFunction("applicationDidEnterBackgroundLua");
    
    engine->executeScriptFile("view/Pause.lua");
    engine->executeGlobalFunction("createPauseLayerWhenTestOrBoss");
    
    Director::getInstance()->stopAnimation();

    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
    
    auto engine = LuaEngine::getInstance();
    engine->executeScriptFile("AppScene.lua");
    engine->executeGlobalFunction("applicationWillEnterForeground");
}
