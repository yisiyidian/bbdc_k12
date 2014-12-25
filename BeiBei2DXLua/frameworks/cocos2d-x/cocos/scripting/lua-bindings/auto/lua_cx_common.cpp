#include "lua_cx_common.hpp"
#include "CXAvos.h"
#include "CXAnalytics.h"
#include "CXUtils.h"
#include "CXStore.h"
#include "CXProgressHUD.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_cx_common_CXAvos_invokeLuaCallbackFunction_dl(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_dl'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        bool arg3;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:invokeLuaCallbackFunction_dl"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:invokeLuaCallbackFunction_dl"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CXAvos:invokeLuaCallbackFunction_dl"); arg2 = arg2_tmp.c_str();

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "CXAvos:invokeLuaCallbackFunction_dl");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_dl'", nullptr);
            return 0;
        }
        cobj->invokeLuaCallbackFunction_dl(arg0, arg1, arg2, arg3);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:invokeLuaCallbackFunction_dl",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_dl'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_invokeLuaCallbackFunction_su(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_su'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        int arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:invokeLuaCallbackFunction_su"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:invokeLuaCallbackFunction_su"); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "CXAvos:invokeLuaCallbackFunction_su");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_su'", nullptr);
            return 0;
        }
        cobj->invokeLuaCallbackFunction_su(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:invokeLuaCallbackFunction_su",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_su'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_signUp(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_signUp'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        CXLUAFUNC arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:signUp"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:signUp"); arg1 = arg1_tmp.c_str();

        arg2 = (  toluafix_ref_function(tolua_S,4,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_signUp'", nullptr);
            return 0;
        }
        cobj->signUp(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:signUp",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_signUp'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_downloadFile(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_downloadFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        CXLUAFUNC arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:downloadFile"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:downloadFile"); arg1 = arg1_tmp.c_str();

        arg2 = (  toluafix_ref_function(tolua_S,4,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_downloadFile'", nullptr);
            return 0;
        }
        cobj->downloadFile(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:downloadFile",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_downloadFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_logInByQQ(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_logInByQQ'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        CXLUAFUNC arg0;

        arg0 = (  toluafix_ref_function(tolua_S,2,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_logInByQQ'", nullptr);
            return 0;
        }
        cobj->logInByQQ(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:logInByQQ",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_logInByQQ'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_downloadWordSoundFiles(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_downloadWordSoundFiles'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        const char* arg3;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:downloadWordSoundFiles"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:downloadWordSoundFiles"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CXAvos:downloadWordSoundFiles"); arg2 = arg2_tmp.c_str();

        std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "CXAvos:downloadWordSoundFiles"); arg3 = arg3_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_downloadWordSoundFiles'", nullptr);
            return 0;
        }
        cobj->downloadWordSoundFiles(arg0, arg1, arg2, arg3);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:downloadWordSoundFiles",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_downloadWordSoundFiles'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_downloadConfigFiles(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_downloadConfigFiles'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        const char* arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:downloadConfigFiles"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:downloadConfigFiles"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_downloadConfigFiles'", nullptr);
            return 0;
        }
        cobj->downloadConfigFiles(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:downloadConfigFiles",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_downloadConfigFiles'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_logOut(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_logOut'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_logOut'", nullptr);
            return 0;
        }
        cobj->logOut();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:logOut",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_logOut'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_logIn(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_logIn'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        CXLUAFUNC arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:logIn"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:logIn"); arg1 = arg1_tmp.c_str();

        arg2 = (  toluafix_ref_function(tolua_S,4,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_logIn'", nullptr);
            return 0;
        }
        cobj->logIn(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:logIn",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_logIn'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_invokeLuaCallbackFunction_li(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_li'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        int arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:invokeLuaCallbackFunction_li"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:invokeLuaCallbackFunction_li"); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "CXAvos:invokeLuaCallbackFunction_li");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_li'", nullptr);
            return 0;
        }
        cobj->invokeLuaCallbackFunction_li(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:invokeLuaCallbackFunction_li",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_li'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_invokeLuaCallbackFunction_logInByQQ(lua_State* tolua_S)
{
    int argc = 0;
    CXAvos* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXAvos*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_logInByQQ'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 5) 
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        const char* arg3;
        int arg4;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAvos:invokeLuaCallbackFunction_logInByQQ"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAvos:invokeLuaCallbackFunction_logInByQQ"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CXAvos:invokeLuaCallbackFunction_logInByQQ"); arg2 = arg2_tmp.c_str();

        std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "CXAvos:invokeLuaCallbackFunction_logInByQQ"); arg3 = arg3_tmp.c_str();

        ok &= luaval_to_int32(tolua_S, 6,(int *)&arg4, "CXAvos:invokeLuaCallbackFunction_logInByQQ");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_logInByQQ'", nullptr);
            return 0;
        }
        cobj->invokeLuaCallbackFunction_logInByQQ(arg0, arg1, arg2, arg3, arg4);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXAvos:invokeLuaCallbackFunction_logInByQQ",argc, 5);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_logInByQQ'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXAvos_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXAvos",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAvos_getInstance'", nullptr);
            return 0;
        }
        CXAvos* ret = CXAvos::getInstance();
        object_to_luaval<CXAvos>(tolua_S, "CXAvos",(CXAvos*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXAvos:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_cx_common_CXAvos_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CXAvos)");
    return 0;
}

int lua_register_cx_common_CXAvos(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CXAvos");
    tolua_cclass(tolua_S,"CXAvos","CXAvos","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"CXAvos");
        tolua_function(tolua_S,"invokeLuaCallbackFunction_dl",lua_cx_common_CXAvos_invokeLuaCallbackFunction_dl);
        tolua_function(tolua_S,"invokeLuaCallbackFunction_su",lua_cx_common_CXAvos_invokeLuaCallbackFunction_su);
        tolua_function(tolua_S,"signUp",lua_cx_common_CXAvos_signUp);
        tolua_function(tolua_S,"downloadFile",lua_cx_common_CXAvos_downloadFile);
        tolua_function(tolua_S,"logInByQQ",lua_cx_common_CXAvos_logInByQQ);
        tolua_function(tolua_S,"downloadWordSoundFiles",lua_cx_common_CXAvos_downloadWordSoundFiles);
        tolua_function(tolua_S,"downloadConfigFiles",lua_cx_common_CXAvos_downloadConfigFiles);
        tolua_function(tolua_S,"logOut",lua_cx_common_CXAvos_logOut);
        tolua_function(tolua_S,"logIn",lua_cx_common_CXAvos_logIn);
        tolua_function(tolua_S,"invokeLuaCallbackFunction_li",lua_cx_common_CXAvos_invokeLuaCallbackFunction_li);
        tolua_function(tolua_S,"invokeLuaCallbackFunction_logInByQQ",lua_cx_common_CXAvos_invokeLuaCallbackFunction_logInByQQ);
        tolua_function(tolua_S,"getInstance", lua_cx_common_CXAvos_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXAvos).name();
    g_luaType[typeName] = "CXAvos";
    g_typeCast["CXAvos"] = "CXAvos";
    return 1;
}

int lua_cx_common_CXAnalytics_beginLog(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXAnalytics",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAnalytics:beginLog"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAnalytics_beginLog'", nullptr);
            return 0;
        }
        CXAnalytics::beginLog(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXAnalytics:beginLog",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAnalytics_beginLog'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXAnalytics_endLog(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXAnalytics",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAnalytics:endLog"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAnalytics_endLog'", nullptr);
            return 0;
        }
        CXAnalytics::endLog(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXAnalytics:endLog",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAnalytics_endLog'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXAnalytics_logEventAndLabel(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXAnalytics",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        const char* arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXAnalytics:logEventAndLabel"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXAnalytics:logEventAndLabel"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXAnalytics_logEventAndLabel'", nullptr);
            return 0;
        }
        CXAnalytics::logEventAndLabel(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXAnalytics:logEventAndLabel",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAnalytics_logEventAndLabel'.",&tolua_err);
#endif
    return 0;
}
static int lua_cx_common_CXAnalytics_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CXAnalytics)");
    return 0;
}

int lua_register_cx_common_CXAnalytics(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CXAnalytics");
    tolua_cclass(tolua_S,"CXAnalytics","CXAnalytics","",nullptr);

    tolua_beginmodule(tolua_S,"CXAnalytics");
        tolua_function(tolua_S,"beginLog", lua_cx_common_CXAnalytics_beginLog);
        tolua_function(tolua_S,"endLog", lua_cx_common_CXAnalytics_endLog);
        tolua_function(tolua_S,"logEventAndLabel", lua_cx_common_CXAnalytics_logEventAndLabel);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXAnalytics).name();
    g_luaType[typeName] = "CXAnalytics";
    g_typeCast["CXAnalytics"] = "CXAnalytics";
    return 1;
}

int lua_cx_common_CXUtils_decryptXxteaFile(lua_State* tolua_S)
{
    int argc = 0;
    CXUtils* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXUtils*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXUtils_decryptXxteaFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXUtils:decryptXxteaFile"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_decryptXxteaFile'", nullptr);
            return 0;
        }
        const char* ret = cobj->decryptXxteaFile(arg0);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXUtils:decryptXxteaFile",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_decryptXxteaFile'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXUtils_showMail(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        const char* arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXUtils:showMail"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXUtils:showMail"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_showMail'", nullptr);
            return 0;
        }
        CXUtils::showMail(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXUtils:showMail",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_showMail'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXUtils_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_getInstance'", nullptr);
            return 0;
        }
        CXUtils* ret = CXUtils::getInstance();
        object_to_luaval<CXUtils>(tolua_S, "CXUtils",(CXUtils*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXUtils:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_getInstance'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXUtils_md5(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        std::string arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXUtils:md5"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CXUtils:md5");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXUtils_md5'", nullptr);
            return 0;
        }
        std::string& ret = CXUtils::md5(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXUtils:md5",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXUtils_md5'.",&tolua_err);
#endif
    return 0;
}
static int lua_cx_common_CXUtils_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CXUtils)");
    return 0;
}

int lua_register_cx_common_CXUtils(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CXUtils");
    tolua_cclass(tolua_S,"CXUtils","CXUtils","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"CXUtils");
        tolua_function(tolua_S,"decryptXxteaFile",lua_cx_common_CXUtils_decryptXxteaFile);
        tolua_function(tolua_S,"showMail", lua_cx_common_CXUtils_showMail);
        tolua_function(tolua_S,"getInstance", lua_cx_common_CXUtils_getInstance);
        tolua_function(tolua_S,"md5", lua_cx_common_CXUtils_md5);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXUtils).name();
    g_luaType[typeName] = "CXUtils";
    g_typeCast["CXUtils"] = "CXUtils";
    return 1;
}

int lua_cx_common_CXStore_invokeLuaCallbackFunction_requestProducts(lua_State* tolua_S)
{
    int argc = 0;
    CXStore* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXStore",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXStore*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXStore_invokeLuaCallbackFunction_requestProducts'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        const char* arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CXStore:invokeLuaCallbackFunction_requestProducts");

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXStore:invokeLuaCallbackFunction_requestProducts"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXStore_invokeLuaCallbackFunction_requestProducts'", nullptr);
            return 0;
        }
        cobj->invokeLuaCallbackFunction_requestProducts(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXStore:invokeLuaCallbackFunction_requestProducts",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXStore_invokeLuaCallbackFunction_requestProducts'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXStore_payForProduct(lua_State* tolua_S)
{
    int argc = 0;
    CXStore* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXStore",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXStore*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXStore_payForProduct'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        CXLUAFUNC arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXStore:payForProduct"); arg0 = arg0_tmp.c_str();

        arg1 = (  toluafix_ref_function(tolua_S,3,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXStore_payForProduct'", nullptr);
            return 0;
        }
        cobj->payForProduct(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXStore:payForProduct",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXStore_payForProduct'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXStore_requestProducts(lua_State* tolua_S)
{
    int argc = 0;
    CXStore* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXStore",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXStore*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXStore_requestProducts'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        CXLUAFUNC arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXStore:requestProducts"); arg0 = arg0_tmp.c_str();

        arg1 = (  toluafix_ref_function(tolua_S,3,0));
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXStore_requestProducts'", nullptr);
            return 0;
        }
        cobj->requestProducts(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXStore:requestProducts",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXStore_requestProducts'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXStore_invokeLuaCallbackFunction_payForProduct(lua_State* tolua_S)
{
    int argc = 0;
    CXStore* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CXStore",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CXStore*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cx_common_CXStore_invokeLuaCallbackFunction_payForProduct'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        int arg0;
        const char* arg1;
        const char* arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CXStore:invokeLuaCallbackFunction_payForProduct");

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CXStore:invokeLuaCallbackFunction_payForProduct"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CXStore:invokeLuaCallbackFunction_payForProduct"); arg2 = arg2_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXStore_invokeLuaCallbackFunction_payForProduct'", nullptr);
            return 0;
        }
        cobj->invokeLuaCallbackFunction_payForProduct(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CXStore:invokeLuaCallbackFunction_payForProduct",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXStore_invokeLuaCallbackFunction_payForProduct'.",&tolua_err);
#endif

    return 0;
}
int lua_cx_common_CXStore_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXStore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXStore_getInstance'", nullptr);
            return 0;
        }
        CXStore* ret = CXStore::getInstance();
        object_to_luaval<CXStore>(tolua_S, "CXStore",(CXStore*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXStore:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXStore_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_cx_common_CXStore_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CXStore)");
    return 0;
}

int lua_register_cx_common_CXStore(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CXStore");
    tolua_cclass(tolua_S,"CXStore","CXStore","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"CXStore");
        tolua_function(tolua_S,"invokeLuaCallbackFunction_requestProducts",lua_cx_common_CXStore_invokeLuaCallbackFunction_requestProducts);
        tolua_function(tolua_S,"payForProduct",lua_cx_common_CXStore_payForProduct);
        tolua_function(tolua_S,"requestProducts",lua_cx_common_CXStore_requestProducts);
        tolua_function(tolua_S,"invokeLuaCallbackFunction_payForProduct",lua_cx_common_CXStore_invokeLuaCallbackFunction_payForProduct);
        tolua_function(tolua_S,"getInstance", lua_cx_common_CXStore_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXStore).name();
    g_luaType[typeName] = "CXStore";
    g_typeCast["CXStore"] = "CXStore";
    return 1;
}

int lua_cx_common_CXProgressHUD_hide(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXProgressHUD",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXProgressHUD_hide'", nullptr);
            return 0;
        }
        CXProgressHUD::hide();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXProgressHUD:hide",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXProgressHUD_hide'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXProgressHUD_setupWindow(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXProgressHUD",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        void* arg0;
        #pragma warning NO CONVERSION TO NATIVE FOR void*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXProgressHUD_setupWindow'", nullptr);
            return 0;
        }
        CXProgressHUD::setupWindow(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXProgressHUD:setupWindow",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXProgressHUD_setupWindow'.",&tolua_err);
#endif
    return 0;
}
int lua_cx_common_CXProgressHUD_show(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CXProgressHUD",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CXProgressHUD:show"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cx_common_CXProgressHUD_show'", nullptr);
            return 0;
        }
        CXProgressHUD::show(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CXProgressHUD:show",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXProgressHUD_show'.",&tolua_err);
#endif
    return 0;
}
static int lua_cx_common_CXProgressHUD_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CXProgressHUD)");
    return 0;
}

int lua_register_cx_common_CXProgressHUD(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CXProgressHUD");
    tolua_cclass(tolua_S,"CXProgressHUD","CXProgressHUD","",nullptr);

    tolua_beginmodule(tolua_S,"CXProgressHUD");
        tolua_function(tolua_S,"hide", lua_cx_common_CXProgressHUD_hide);
        tolua_function(tolua_S,"setupWindow", lua_cx_common_CXProgressHUD_setupWindow);
        tolua_function(tolua_S,"show", lua_cx_common_CXProgressHUD_show);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXProgressHUD).name();
    g_luaType[typeName] = "CXProgressHUD";
    g_typeCast["CXProgressHUD"] = "CXProgressHUD";
    return 1;
}
TOLUA_API int register_all_cx_common(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cx",0);
	tolua_beginmodule(tolua_S,"cx");

	lua_register_cx_common_CXUtils(tolua_S);
	lua_register_cx_common_CXAnalytics(tolua_S);
	lua_register_cx_common_CXProgressHUD(tolua_S);
	lua_register_cx_common_CXStore(tolua_S);
	lua_register_cx_common_CXAvos(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

