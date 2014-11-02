//
//  CXAvos.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#include "CXAvos.h"
#include "CCLuaEngine.h"
#include "platform/android/jni/JniHelper.h"

using namespace cocos2d;

CXAvos* CXAvos::m_pInstance = nullptr;

CXAvos* CXAvos::getInstance() {
    if (!m_pInstance) {
        m_pInstance = new CXAvos();
    }
    return m_pInstance;
}

CXAvos::CXAvos()
: mLuaHandlerId_dl(0) {
    
}

void CXAvos::downloadFile(const char* objectId, const char* savepath, CXLUAFUNC nHandler) {
    mLuaHandlerId_dl = nHandler;

    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, "com/beibei/wordmaster/AppActivity", "downloadFile", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_objectId = t.env->NewStringUTF(objectId);
        jstring stringArg_savepath = t.env->NewStringUTF(savepath);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_objectId, stringArg_savepath);

        t.env->DeleteLocalRef(stringArg_objectId);
        t.env->DeleteLocalRef(stringArg_savepath);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXAvos::invokeLuaCallbackFunction_dl(const char* objectId, const char* filename, const char* error, bool isSaved)
{
    if (mLuaHandlerId_dl > 0)
    {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectId);
        stack->pushString(filename);
        stack->pushString(error);
        stack->pushBoolean(isSaved);
        stack->executeFunctionByHandler(mLuaHandlerId_dl, 4);
        stack->clean();
    }
}

void CXAvos::signUp(const char* username, const char* password, CXLUAFUNC nHandler) {
    mLuaHandlerId_signUp = nHandler;
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, "com/beibei/wordmaster/AppActivity", "signUp", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_username = t.env->NewStringUTF(username);
        jstring stringArg_password = t.env->NewStringUTF(password);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_username, stringArg_password);

        t.env->DeleteLocalRef(stringArg_username);
        t.env->DeleteLocalRef(stringArg_password);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXAvos::invokeLuaCallbackFunction_su(const char* objectjson, const char* error) {
    if (mLuaHandlerId_signUp > 0) {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectjson);
        stack->pushString(error);
        stack->executeFunctionByHandler(mLuaHandlerId_signUp, 2);
        stack->clean();
    }
}

void CXAvos::logIn(const char* username, const char* password, CXLUAFUNC nHandler) {
    mLuaHandlerId_logIn = nHandler;
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, "com/beibei/wordmaster/AppActivity", "logIn", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_username = t.env->NewStringUTF(username);
        jstring stringArg_password = t.env->NewStringUTF(password);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_username, stringArg_password);

        t.env->DeleteLocalRef(stringArg_username);
        t.env->DeleteLocalRef(stringArg_password);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXAvos::invokeLuaCallbackFunction_li(const char* objectjson, const char* error) {
    if (mLuaHandlerId_logIn > 0) {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectjson);
        stack->pushString(error);
        stack->executeFunctionByHandler(mLuaHandlerId_logIn, 2);
        stack->clean();
    }
}

void CXAvos::logOut() {
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, "com/beibei/wordmaster/AppActivity", "logOut", "()V")) {
        t.env->CallStaticVoidMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
}
