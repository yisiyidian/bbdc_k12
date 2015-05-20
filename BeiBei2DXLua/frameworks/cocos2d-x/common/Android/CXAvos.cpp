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

void CXAvos::init() {
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

void CXAvos::logInByPhoneNumber(const char* phoneNumber,const char* password,CXLUAFUNC nHandler)  {
    mLuaHandlerId_logIn = nHandler;
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "logInByPhoneNumber", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_phoneNumber = t.env->NewStringUTF(phoneNumber);
        jstring stringArg_password = t.env->NewStringUTF(password);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_phoneNumber, stringArg_password);

        t.env->DeleteLocalRef(stringArg_phoneNumber);
        t.env->DeleteLocalRef(stringArg_password);
        t.env->DeleteLocalRef(t.classID);
    }
}

/**
*   请求短信验证码
*   phoneNumber 电话号码
*/
void CXAvos::requestSMSCode(const char* phoneNumber){
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "requestSMSCode", "(Ljava/lang/String;)V")) {
        jstring stringArg_phoneNumber = t.env->NewStringUTF(phoneNumber);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_phoneNumber);

        t.env->DeleteLocalRef(stringArg_phoneNumber);
        t.env->DeleteLocalRef(t.classID);
    }
}

/**
*   向服务器请求核对验证码
*   phoneNumber 手机号
*   smsCode     验证码
*   mHandler    回调句柄
*/
void CXAvos::verifySMSCode(const char* phoneNumber,const char* smsCode,CXLUAFUNC mHandler){
    mLuaHandlerId_vc = mHandler;
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "verifySMSCode", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_phoneNumber = t.env->NewStringUTF(phoneNumber);
        jstring stringArg_smsCode = t.env->NewStringUTF(smsCode);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_phoneNumber, stringArg_smsCode);

        t.env->DeleteLocalRef(stringArg_phoneNumber);
        t.env->DeleteLocalRef(stringArg_smsCode);
        t.env->DeleteLocalRef(t.classID);
    }
}
/**
 * 请求修改密码
 * @param username 用户名
 * @param oldPwd   旧密码
 * @param newPwd   新密码
 * @param nHandler 回调函数句柄
 */
void CXAvos::changePwd(const char* username,const char* oldPwd,const char* newPwd,CXLUAFUNC nHandler){
    mLuaHandlerId_cp = nHandler;
    cocos2d::JniMethodInfo t;
    if(cocos2d::JniHelper::getStaticMethodInfo(t,JAVA_PKG,"changePwd","((Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V)")){
        jstring stringArg_username = t.env->NewStringUTF(username);
        jstring stringArg_passwordOld = t.env->NewStringUTF(oldPwd);
        jstring stringArg_passwordNew = t.env->NewStringUTF(newPwd);

        t.env->CallStaticVoidMethod(t.classID,t.methodID,stringArg_username,stringArg_passwordOld,stringArg_passwordNew);

        t.env->DeleteLocalRef(stringArg_username);
        t.env->DeleteLocalRef(stringArg_passwordOld);
        t.env->DeleteLocalRef(stringArg_passwordNew);
        t.env->DeleteLocalRef(t.classID);
    }
}


void CXAvos::initTencentQQ(const char* appId, const char* appKey) {
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "initTencentQQ", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring jappId = t.env->NewStringUTF(appId);
        jstring jappKey = t.env->NewStringUTF(appKey);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, jappId, jappKey);

        t.env->DeleteLocalRef(jappId);
        t.env->DeleteLocalRef(jappKey);
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

void CXAvos::logOut() {
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "logOut", "()V")) {
        t.env->CallStaticVoidMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
}
