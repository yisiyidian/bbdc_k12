#include "lua_cx_common.hpp"
#include "CXAvos.h"
#include "CXAnalytics.h"
#include "CXUtils.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



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
    tolua_cclass(tolua_S,"CXUtils","CXUtils","",nullptr);

    tolua_beginmodule(tolua_S,"CXUtils");
        tolua_function(tolua_S,"md5", lua_cx_common_CXUtils_md5);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CXUtils).name();
    g_luaType[typeName] = "CXUtils";
    g_typeCast["CXUtils"] = "CXUtils";
    return 1;
}
TOLUA_API int register_all_cx_common(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cx",0);
	tolua_beginmodule(tolua_S,"cx");

	lua_register_cx_common_CXAnalytics(tolua_S);
	lua_register_cx_common_CXUtils(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

