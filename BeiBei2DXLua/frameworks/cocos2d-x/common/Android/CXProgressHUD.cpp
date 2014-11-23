//
//  CXProgressHUD.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 11/23/14.
//
//

#include "CXProgressHUD.h"
#include "platform/android/jni/JniHelper.h"

void CXProgressHUD::setupWindow(void* uiWindow) {

}

void CXProgressHUD::show(const char* content) {
    CXProgressHUD::hide();

    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, "c/bb/dc/BBNDK", "showCXProgressHUD", "(Ljava/lang/String;)V")) {
        jstring stringArg_content = t.env->NewStringUTF(content ? content : "Loading");

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_content);

        t.env->DeleteLocalRef(stringArg_content);
        t.env->DeleteLocalRef(t.classID);
    }
}

void CXProgressHUD::hide() {
    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, "c/bb/dc/BBNDK", "hideCXProgressHUD", "()V")) {

        t.env->CallStaticVoidMethod(t.classID, t.methodID);

        t.env->DeleteLocalRef(t.classID);
    }
}
