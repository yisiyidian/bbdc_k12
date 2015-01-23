//
//  CXAVCloud.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 1/23/15.
//
//

#include "CXAVCloud.h"
#include "CCLuaEngine.h"
#include "platform/android/jni/JniHelper.h"

#define JAVA_PKG "c/bb/dc/BBNDK"

using namespace cocos2d;

void CXAVCloud::callAVCloudFunction(const std::string& func, const std::string& parameters/*json*/, CXLUAFUNC callback) {
    m_callback = callback;
    
    retain();

    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, JAVA_PKG, "callAVCloudFunction", "(J;Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_func = t.env->NewStringUTF(func.c_str());
        jstring stringArg_parameters = t.env->NewStringUTF(parameters.c_str());

        t.env->CallStaticVoidMethod(t.classID, t.methodID, (long)this, stringArg_func, stringArg_parameters);

        t.env->DeleteLocalRef(stringArg_func);
        t.env->DeleteLocalRef(stringArg_parameters);
        t.env->DeleteLocalRef(t.classID);
    }
}