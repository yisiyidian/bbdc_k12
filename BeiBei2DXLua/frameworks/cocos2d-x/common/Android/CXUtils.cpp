//
//  CXUtils.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/9/14.
//
//

#include "CXUtils.h"
#include "platform/android/jni/JniHelper.h"

#define JAVA_PKG "c/bb/dc/BBNDK"

using namespace cocos2d;

void CXUtils::shareImageToQQFriend(const std::string& path, const std::string& title, const std::string& desc) {
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "shareImageToQQFriend", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring java_path = t.env->NewStringUTF(path.c_str());
        jstring java_title = t.env->NewStringUTF(title.c_str());
        jstring java_desc = t.env->NewStringUTF(desc.c_str());

        t.env->CallStaticVoidMethod(t.classID, t.methodID, java_path, java_title, java_desc);

        t.env->DeleteLocalRef(java_path);
        t.env->DeleteLocalRef(java_title);
        t.env->DeleteLocalRef(java_desc);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXUtils::shareImageToWeiXin(const std::string& path, const std::string& title, const std::string& desc) {
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "shareImageToWeiXin", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring java_path = t.env->NewStringUTF(path.c_str());
        jstring java_title = t.env->NewStringUTF(title.c_str());
        jstring java_desc = t.env->NewStringUTF(desc.c_str());

        t.env->CallStaticVoidMethod(t.classID, t.methodID, java_path, java_title, java_desc);

        t.env->DeleteLocalRef(java_path);
        t.env->DeleteLocalRef(java_title);
        t.env->DeleteLocalRef(java_desc);
        t.env->DeleteLocalRef(t.classID);
    }
}

std::string CXUtils::getExternalStorageDirectory() {
    cocos2d::JniMethodInfo t;
    bool b = cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "getSDCardPath", "()Ljava/lang/String;");
    if (b) {
        jstring jSDCardPath = (jstring)(t.env->CallStaticObjectMethod(t.classID, t.methodID));
        const char *SDCardPath = jSDCardPath ? t.env->GetStringUTFChars(jSDCardPath, 0) : 0;
        if (jSDCardPath) {
            std::string ret(SDCardPath);
            t.env->ReleaseStringUTFChars(jSDCardPath, SDCardPath);
            return ret;
        } else {
            return cocos2d::FileUtils::getInstance()->getWritablePath();
        }
        t.env->DeleteLocalRef(t.classID);
    }
    return cocos2d::FileUtils::getInstance()->getWritablePath();
}
