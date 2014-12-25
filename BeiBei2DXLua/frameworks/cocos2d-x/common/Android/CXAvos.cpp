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

#define JAVA_PKG "c/bb/dc/BBNDK"

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
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "downloadFile", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_objectId = t.env->NewStringUTF(objectId);
        jstring stringArg_savepath = t.env->NewStringUTF(savepath);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_objectId, stringArg_savepath);

        t.env->DeleteLocalRef(stringArg_objectId);
        t.env->DeleteLocalRef(stringArg_savepath);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXAvos::downloadConfigFiles(const char* objectIds, const char* path) {
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "downloadConfigFiles", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_objectIds = t.env->NewStringUTF(objectIds);
        jstring stringArg_path = t.env->NewStringUTF(path);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_objectIds, stringArg_path);

        t.env->DeleteLocalRef(stringArg_objectIds);
        t.env->DeleteLocalRef(stringArg_path);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXAvos::downloadWordSoundFiles(const char* prefix, const char* wordsList, const char* subfix, const char* path) {
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "downloadWordSoundFiles", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_prefix = t.env->NewStringUTF(prefix);
        jstring stringArg_wordsList = t.env->NewStringUTF(wordsList);
        jstring stringArg_subfix = t.env->NewStringUTF(subfix);
        jstring stringArg_path = t.env->NewStringUTF(path);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_prefix, stringArg_wordsList, stringArg_subfix, stringArg_path);

        t.env->DeleteLocalRef(stringArg_prefix);
        t.env->DeleteLocalRef(stringArg_wordsList);
        t.env->DeleteLocalRef(stringArg_subfix);
        t.env->DeleteLocalRef(stringArg_path);
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
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "signUp", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_username = t.env->NewStringUTF(username);
        jstring stringArg_password = t.env->NewStringUTF(password);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_username, stringArg_password);

        t.env->DeleteLocalRef(stringArg_username);
        t.env->DeleteLocalRef(stringArg_password);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXAvos::invokeLuaCallbackFunction_su(const char* objectjson, const char* error, int errorcode) {
    if (mLuaHandlerId_signUp > 0) {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectjson);
        stack->pushString(error);
        stack->pushInt(errorcode);
        stack->executeFunctionByHandler(mLuaHandlerId_signUp, 3);
        stack->clean();
    }
}

void CXAvos::logIn(const char* username, const char* password, CXLUAFUNC nHandler) {
    mLuaHandlerId_logIn = nHandler;
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "logIn", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_username = t.env->NewStringUTF(username);
        jstring stringArg_password = t.env->NewStringUTF(password);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_username, stringArg_password);

        t.env->DeleteLocalRef(stringArg_username);
        t.env->DeleteLocalRef(stringArg_password);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXAvos::invokeLuaCallbackFunction_li(const char* objectjson, const char* error, int errorcode) {
    if (mLuaHandlerId_logIn > 0) {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectjson);
        stack->pushString(error);
        stack->pushInt(errorcode);
        stack->executeFunctionByHandler(mLuaHandlerId_logIn, 3);
        stack->clean();
    }
}

void CXAvos::logInByQQAuthData(const char* openid, const char* access_token, const char* expires_in, CXLUAFUNC nHandler) {
    mLuaHandlerId_logInByQQ = nHandler;
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "logInByQQAuthData", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_openid = t.env->NewStringUTF(openid);
        jstring stringArg_access_token = t.env->NewStringUTF(access_token);
        jstring stringArg_expires_in = t.env->NewStringUTF(expires_in);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_openid, stringArg_access_token, stringArg_expires_in);

        t.env->DeleteLocalRef(stringArg_openid);
        t.env->DeleteLocalRef(stringArg_access_token);
        t.env->DeleteLocalRef(stringArg_expires_in);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXAvos::logInByQQ(CXLUAFUNC nHandler) {
    mLuaHandlerId_logInByQQ = nHandler;
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "logInByQQ", "()V")) {
        t.env->CallStaticVoidMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXAvos::invokeLuaCallbackFunction_logInByQQ(const char* objectjson, const char* qqjson, const char* authjson, const char* error, int errorcode) {
    if (mLuaHandlerId_logInByQQ > 0) {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectjson);
        stack->pushString(qqjson);
        stack->pushString(authjson);
        stack->pushString(error);
        stack->pushInt(errorcode);
        stack->executeFunctionByHandler(mLuaHandlerId_logInByQQ, 5);
        stack->clean();
    }
}

void CXAvos::logOut() {
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "logOut", "()V")) {
        t.env->CallStaticVoidMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
}
