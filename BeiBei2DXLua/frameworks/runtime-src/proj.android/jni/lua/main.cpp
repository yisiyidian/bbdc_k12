#include "AppDelegate.h"
#include "cocos2d.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>
#include <android/log.h>
#include "ConfigParser.h"
#include "PluginJniHelper.h"
#include "../../../cocos2d-x/common/CXAvos.h"
#include "../../../cocos2d-x/common/CXAVCloud.h"

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

    /**
     * 短信验证回调
     * @param
     * @param   错误信息
     * @param   错误号 0 是没错误
     */
    void Java_c_bb_dc_BBNDK_invokeLuaCallbackFunctionVC(JNIEnv *env,jobject thisz,jstring error,jint errorcode)
    {   
        const char *nativeString_error = error ? env->GetStringUTFChars(error, 0) : 0;
        LOGD("error %s",nativeString_error);
        LOGD("errorCode %d",errorcode);
        CXAvos::getInstance()->invokeLuaCallBackFunction_vc(nativeString_error,errorcode);

        if(error) env->ReleaseStringUTFChars(error,nativeString_error);    
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

    /**
     * [用手机号码 + 短信验证码登陆]
     * @param env        [description]
     * @param thisz      [description]
     * @param objectjson [description]
     * @param error      [description]
     * @param errorcode  [description]
     */
    void Java_c_bb_dc_BBNDK_invokeLuaCallbackFunctionLS(JNIEnv *env, jobject thisz,jstring objectjson, jstring error, jint errorcode){
        const char *nativeString_objectjson = objectjson ? env->GetStringUTFChars(objectjson, 0) : 0;
		const char *nativeString_error = error ? env->GetStringUTFChars(error, 0) : 0;
		CXAvos::getInstance()->invokeLuaCallbackFunction_ls(nativeString_objectjson, nativeString_error, errorcode);
		if (objectjson) env->ReleaseStringUTFChars(objectjson, nativeString_objectjson);
		if (error) env->ReleaseStringUTFChars(error, nativeString_error);
    }

    /**
     * 修改密码回调
     * @param env        [description]
     * @param error      [错误信息]
     * @param errorcode  [错误号]
     */
    void Java_c_bb_dc_BBNDK_invokeLuaCallbackFunctionCP(JNIEnv *env, jstring error, jint errorcode)
    {
        const char *nativeString_error = error ? env->GetStringUTFChars(error, 0) : 0;
        CXAvos::getInstance()->invokeLuaCallbackFunction_cp(nativeString_error,errorcode);

        if(error) env->ReleaseStringUTFChars(error,nativeString_error);
    }    


    void Java_c_bb_dc_BBNDK_invokeLuaCallbackFunctionVP(JNIEnv *env, jstring error, jint errorcode)
    {
       const char *nativeString_error = error ? env->GetStringUTFChars(error, 0) : 0;
       CXAvos::getInstance()->invokeLuaCallbackFunction_vp(nativeString_error,errorcode);

       if(error) env->ReleaseStringUTFChars(error,nativeString_error);
    }


    void Java_c_bb_dc_BBNDK_invokeLuaCallbackFunctionLIQQ(JNIEnv *env, jobject thisz,
                                                    jstring objectjson, 
                                                    jstring qqjson,
                                                    jstring authjson,
                                                    jstring error, 
                                                    jint errorcode)
    {
        const char *nativeString_objectjson = objectjson ? env->GetStringUTFChars(objectjson, 0) : 0;
        const char *nativeString_qqjson = qqjson ? env->GetStringUTFChars(qqjson, 0) : 0;
        const char *nativeString_authjson = authjson ? env->GetStringUTFChars(authjson, 0) : 0;
        const char *nativeString_error = error ? env->GetStringUTFChars(error, 0) : 0;
    
        CXAvos::getInstance()->invokeLuaCallbackFunction_logInByQQ(
        		nativeString_objectjson,
        		nativeString_qqjson,
        		nativeString_authjson,
        		nativeString_error,
        		errorcode);
    
        if (objectjson) env->ReleaseStringUTFChars(objectjson, nativeString_objectjson);
        if (qqjson) env->ReleaseStringUTFChars(qqjson, nativeString_qqjson);
        if (authjson) env->ReleaseStringUTFChars(authjson, nativeString_authjson);
        if (error) env->ReleaseStringUTFChars(error, nativeString_error);
    }

    void Java_c_bb_dc_BBNDK_invokeLuaCallbackFunctionCallAVCloudFunction(JNIEnv *env, jobject thisz, jlong cppObjPtr,
            jstring objectjson, jstring errorjson) {
    	CXAVCloud* cloud = (CXAVCloud*)cppObjPtr;
    	const char *nativeString_objectjson = objectjson ? env->GetStringUTFChars(objectjson, 0) : 0;
    	const char *nativeString_errorjson = errorjson ? env->GetStringUTFChars(errorjson, 0) : 0;

    	cloud->invokeCallback(nativeString_objectjson, nativeString_errorjson);
    	cloud->release();

    	if (objectjson) env->ReleaseStringUTFChars(objectjson, nativeString_objectjson);
    	if (errorjson) env->ReleaseStringUTFChars(errorjson, nativeString_errorjson);
    }

    void Java_c_bb_dc_BBNDK_invokeLuaCallbackFunctionGetBulletinBoard(JNIEnv *env, jobject thisz, jlong cppObjPtr,
    		jint index, jstring content_top, jstring content, jstring errorjson) {
    	CXAVCloud* cloud = (CXAVCloud*)cppObjPtr;

    	const char *nativeString_content_top = content_top ? env->GetStringUTFChars(content_top, 0) : "";
    	const char *nativeString_content = content ? env->GetStringUTFChars(content, 0) : "";
		const char *nativeString_errorjson = errorjson ? env->GetStringUTFChars(errorjson, 0) : 0;

    	cloud->invokeCallback_getBulletinBoard(index, nativeString_content_top, nativeString_content, nativeString_errorjson);
		cloud->release();

		if (content_top) env->ReleaseStringUTFChars(content_top, nativeString_content_top);
		if (content) env->ReleaseStringUTFChars(content, nativeString_content);
		if (errorjson) env->ReleaseStringUTFChars(errorjson, nativeString_errorjson);
    }
}
