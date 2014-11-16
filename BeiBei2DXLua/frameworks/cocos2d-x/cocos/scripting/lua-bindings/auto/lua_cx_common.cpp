#include "lua_cx_common.hpp"
#include "CXAvos.h"
#include "CXAnalytics.h"
#include "CXUtils.h"
#include "CXStore.h"
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

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp); arg2 = arg2_tmp.c_str();

        ok &= luaval_to_boolean(tolua_S, 5,&arg3);
        if(!ok)
            return 0;
        cobj->invokeLuaCallbackFunction_dl(arg0, arg1, arg2, arg3);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "invokeLuaCallbackFunction_dl",argc, 4);
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

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2);
        if(!ok)
            return 0;
        cobj->invokeLuaCallbackFunction_su(arg0, arg1, arg2);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "invokeLuaCallbackFunction_su",argc, 3);
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

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp); arg1 = arg1_tmp.c_str();

        arg2 = (  toluafix_ref_function(tolua_S,4,0));
        if(!ok)
            return 0;
        cobj->signUp(arg0, arg1, arg2);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "signUp",argc, 3);
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

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp); arg1 = arg1_tmp.c_str();

        arg2 = (  toluafix_ref_function(tolua_S,4,0));
        if(!ok)
            return 0;
        cobj->downloadFile(arg0, arg1, arg2);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "downloadFile",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_downloadFile'.",&tolua_err);
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
            return 0;
        cobj->logOut();
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "logOut",argc, 0);
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

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp); arg1 = arg1_tmp.c_str();

        arg2 = (  toluafix_ref_function(tolua_S,4,0));
        if(!ok)
            return 0;
        cobj->logIn(arg0, arg1, arg2);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "logIn",argc, 3);
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

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2);
        if(!ok)
            return 0;
        cobj->invokeLuaCallbackFunction_li(arg0, arg1, arg2);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "invokeLuaCallbackFunction_li",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cx_common_CXAvos_invokeLuaCallbackFunction_li'.",&tolua_err);
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
            return 0;
        CXAvos* ret = CXAvos::getInstance();
        object_to_luaval<CXAvos>(tolua_S, "CXAvos",(CXAvos*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "getInstance",argc, 0);
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
        tolua_function(tolua_S,"logOut",lua_cx_common_CXAvos_logOut);
        tolua_function(tolua_S,"logIn",lua_cx_common_CXAvos_logIn);
        tolua_function(tolua_S,"invokeLuaCallbackFunction_li",lua_cx_common_CXAvos_invokeLuaCallbackFunction_li);
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
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();
        if(!ok)
            return 0;
        CXAnalytics::beginLog(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "beginLog",argc, 1);
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
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();
        if(!ok)
            return 0;
        CXAnalytics::endLog(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "endLog",argc, 1);
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
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp); arg1 = arg1_tmp.c_str();
        if(!ok)
            return 0;
        CXAnalytics::logEventAndLabel(arg0, arg1);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "logEventAndLabel",argc, 2);
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

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();
        if(!ok)
            return 0;
        const char* ret = cobj->decryptXxteaFile(arg0);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "decryptXxteaFile",argc, 1);
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
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp); arg1 = arg1_tmp.c_str();
        if(!ok)
            return 0;
        CXUtils::showMail(arg0, arg1);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "showMail",argc, 2);
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
            return 0;
        CXUtils* ret = CXUtils::getInstance();
        object_to_luaval<CXUtils>(tolua_S, "CXUtils",(CXUtils*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "getInstance",argc, 0);
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
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_std_string(tolua_S, 3,&arg1);
        if(!ok)
            return 0;
        std::string& ret = CXUtils::md5(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "md5",argc, 2);
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

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0);

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp); arg1 = arg1_tmp.c_str();
        if(!ok)
            return 0;
        cobj->invokeLuaCallbackFunction_requestProducts(arg0, arg1);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "invokeLuaCallbackFunction_requestProducts",argc, 2);
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

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();

        arg1 = (  toluafix_ref_function(tolua_S,3,0));
        if(!ok)
            return 0;
        cobj->payForProduct(arg0, arg1);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "payForProduct",argc, 2);
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

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp); arg0 = arg0_tmp.c_str();

        arg1 = (  toluafix_ref_function(tolua_S,3,0));
        if(!ok)
            return 0;
        cobj->requestProducts(arg0, arg1);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "requestProducts",argc, 2);
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

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0);

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp); arg2 = arg2_tmp.c_str();
        if(!ok)
            return 0;
        cobj->invokeLuaCallbackFunction_payForProduct(arg0, arg1, arg2);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "invokeLuaCallbackFunction_payForProduct",argc, 3);
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
            return 0;
        CXStore* ret = CXStore::getInstance();
        object_to_luaval<CXStore>(tolua_S, "CXStore",(CXStore*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "getInstance",argc, 0);
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
TOLUA_API int register_all_cx_common(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cx",0);
	tolua_beginmodule(tolua_S,"cx");

	lua_register_cx_common_CXAvos(tolua_S);
	lua_register_cx_common_CXAnalytics(tolua_S);
	lua_register_cx_common_CXUtils(tolua_S);
	lua_register_cx_common_CXStore(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

