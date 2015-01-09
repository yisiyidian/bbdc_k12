//
//  CXNetworkStatus.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 1/9/15.
//
//

#include "CXNetworkStatus.h"
#include <jni.h>
#include <android/log.h>
#include "platform/android/jni/JniHelper.h"

#define JAVA_PKG "c/bb/dc/BBNDK"

#if (COCOS2D_DEBUG>0)
    #define ALOGD(INFO) __android_log_print(ANDROID_LOG_INFO, "CXNetworkStatus", INFO);
#else
    #define ALOGD(INFO)
#endif

static jint CONNECTEDTYPE_NONE = -1;

jint getConnectedType_jint(const char* javaFuncName) {
    cocos2d::JniMethodInfo t;
    jint ret = CONNECTEDTYPE_NONE;
    bool isHave_getConnectedType_NONE = cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, javaFuncName, "()I");
    if (isHave_getConnectedType_NONE) {
        ret = t.env->CallStaticIntMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
    return ret;
}

int CXNetworkStatus::start() {
    return getStatus();
}

int CXNetworkStatus::getStatus() { 
    jint current = getConnectedType_jint("getConnectedType");
    jint mobile  = getConnectedType_jint("getConnectedType_MOBILE");
    jint wifi    = getConnectedType_jint("getConnectedType_WIFI");
    jint none    = getConnectedType_jint("getConnectedType_NONE");
    if (current == mobile && mobile != none) {
        ALOGD("CXNetworkStatus::start mobile")
        CXNetworkStatus::getInstance()->setStatus(CXNetworkStatus::STATUS_MOBILE);
    } else if (current == wifi && wifi != none) {
        ALOGD("CXNetworkStatus::start wifi")   
        CXNetworkStatus::getInstance()->setStatus(CXNetworkStatus::STATUS_WIFI);
    } else {
        ALOGD("CXNetworkStatus::start none")  
        CXNetworkStatus::getInstance()->setStatus(CXNetworkStatus::STATUS_NONE); 
    }
    return m_status; 
}

const char* CXNetworkStatus::getDeviceUDID() {
    cocos2d::JniMethodInfo t;
    bool b = cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "getDeviceUDID", "()Ljava/lang/String;");
    if (b) {
        jstring judid = (jstring)(t.env->CallStaticObjectMethod(t.classID, t.methodID));
        const char *udid = judid ? t.env->GetStringUTFChars(judid, 0) : 0;
        if (judid) {
            std::string ret(udid);
            t.env->ReleaseStringUTFChars(judid, udid);
            ALOGD("CXNetworkStatus::getDeviceUDID done")  
            return ret.c_str();
        } else {
            ALOGD("CXNetworkStatus::getDeviceUDID none")  
            return "";
        }
        t.env->DeleteLocalRef(t.classID);
    }
    return "";
}

long CXNetworkStatus::getCurrentTimeMillis() {
    cocos2d::JniMethodInfo t;
    bool b = cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "getCurrentTimeMillis", "()J");
    if (b) {
        jlong ret = t.env->CallStaticLongMethod(t.classID, t.methodID);
        t.env->DeleteLocalRef(t.classID);
        return (long)ret;
    }
    return 0;
}


