#include "AppDelegate.h"
#include "cocos2d.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>
#include <android/log.h>
#include "ConfigParser.h"
#include "PluginJniHelper.h"
#include "../../../cocos2d-x/common/avos/CXAvos.h"

using namespace anysdk::framework;

#define  LOG_TAG    "main"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)

using namespace cocos2d;

void cocos_android_app_init (JNIEnv* env, jobject thiz) {
    LOGD("cocos_android_app_init");
    AppDelegate *pAppDelegate = new AppDelegate();
    
    //set JavaVM for anysdk.
    JavaVM* vm;
    env->GetJavaVM(&vm);
    PluginJniHelper::setJavaVM(vm);
}

extern "C"
{
	bool Java_c_bb_dc_BBNDK_nativeIsLandScape(JNIEnv *env, jobject thisz)
	{
		return ConfigParser::getInstance()->isLanscape();
	}

	bool Java_c_bb_dc_BBNDK_nativeIsDebug(JNIEnv *env, jobject thisz)
	{
        #if (COCOS2D_DEBUG > 0)
        return true;
        #else
        return false;    
        #endif
	}

    void Java_c_bb_dc_BBNDK_invokeLuaCallbackFunctionDL(JNIEnv *env, jobject thisz,
                                                    jstring objectId, jstring filename, jstring error, jint isSaved)
    {
        const char *nativeString_objectId = objectId ? env->GetStringUTFChars(objectId, 0) : 0;
        const char *nativeString_filename = filename ? env->GetStringUTFChars(filename, 0) : 0;
        const char *nativeString_error = error ? env->GetStringUTFChars(error, 0) : 0;
    
        CXAvos::getInstance()->invokeLuaCallbackFunction_dl(nativeString_objectId, nativeString_filename, nativeString_error, isSaved);
    
        if (objectId) env->ReleaseStringUTFChars(objectId, nativeString_objectId);
        if (filename) env->ReleaseStringUTFChars(filename, nativeString_filename);
        if (error) env->ReleaseStringUTFChars(error, nativeString_error);
    }

    void Java_c_bb_dc_BBNDK_invokeLuaCallbackFunctionSU(JNIEnv *env, jobject thisz,
                                                    jstring objectjson, jstring error, jint errorcode)
    {
        const char *nativeString_objectjson = objectjson ? env->GetStringUTFChars(objectjson, 0) : 0;
        const char *nativeString_error = error ? env->GetStringUTFChars(error, 0) : 0;
    
        CXAvos::getInstance()->invokeLuaCallbackFunction_su(nativeString_objectjson, nativeString_error, errorcode);
    
        if (objectjson) env->ReleaseStringUTFChars(objectjson, nativeString_objectjson);
        if (error) env->ReleaseStringUTFChars(error, nativeString_error);
    }

    void Java_c_bb_dc_BBNDK_invokeLuaCallbackFunctionLI(JNIEnv *env, jobject thisz,
                                                    jstring objectjson, jstring error, jint errorcode)
    {
        const char *nativeString_objectjson = objectjson ? env->GetStringUTFChars(objectjson, 0) : 0;
        const char *nativeString_error = error ? env->GetStringUTFChars(error, 0) : 0;
    
        CXAvos::getInstance()->invokeLuaCallbackFunction_li(nativeString_objectjson, nativeString_error, errorcode);
    
        if (objectjson) env->ReleaseStringUTFChars(objectjson, nativeString_objectjson);
        if (error) env->ReleaseStringUTFChars(error, nativeString_error);
    }
}