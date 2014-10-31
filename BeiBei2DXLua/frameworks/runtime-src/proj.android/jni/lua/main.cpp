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
	bool Java_com_beibei_wordmaster_AppActivity_nativeIsLandScape(JNIEnv *env, jobject thisz)
	{
		if (!ConfigParser::getInstance()->isInit())
		{
			ConfigParser::getInstance()->readConfig();
		}
		return ConfigParser::getInstance()->isLanscape();
	}

	bool Java_com_beibei_wordmaster_AppActivity_nativeIsDebug(JNIEnv *env, jobject thisz)
	{
		#ifdef NDEBUG 
    		return false;
    	#else
    		return true;	
		#endif
	}

	void Java_com_beibei_wordmaster_AppActivity_invokeLuaCallbackFunctionDL(JNIEnv *env, jobject thisz,
			jstring objectId, jstring filename, jstring error, jint isSaved)
	{
		const char *nativeString_objectId = env->GetStringUTFChars(objectId, 0);
		const char *nativeString_filename = env->GetStringUTFChars(filename, 0);
		const char *nativeString_error = env->GetStringUTFChars(error, 0);

		CXAvos::getInstance()->invokeLuaCallbackFunction_dl(nativeString_objectId, nativeString_filename, nativeString_error, isSaved);

		env->ReleaseStringUTFChars(objectId, nativeString_objectId);
		env->ReleaseStringUTFChars(filename, nativeString_filename);
		env->ReleaseStringUTFChars(error, nativeString_error);
	}
}

