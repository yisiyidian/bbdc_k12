#include "lua_cocos2dx_custom.hpp"
#include "my/CustomClass.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_cocos2dx_custom_CustomClass_addSkipBackupAttributeToItemAtPath(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::CustomClass* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"cc.CustomClass",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::CustomClass*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_CustomClass_addSkipBackupAttributeToItemAtPath'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "cc.CustomClass:addSkipBackupAttributeToItemAtPath");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_CustomClass_addSkipBackupAttributeToItemAtPath'", nullptr);
            return 0;
        }
        std::string ret = cobj->addSkipBackupAttributeToItemAtPath(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "cc.CustomClass:addSkipBackupAttributeToItemAtPath",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_CustomClass_addSkipBackupAttributeToItemAtPath'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_CustomClass_init(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::CustomClass* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"cc.CustomClass",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::CustomClass*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_custom_CustomClass_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_CustomClass_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "cc.CustomClass:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_CustomClass_init'.",&tolua_err);
#endif

    return 0;
}
int lua_cocos2dx_custom_CustomClass_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"cc.CustomClass",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_CustomClass_create'", nullptr);
            return 0;
        }
        cocos2d::CustomClass* ret = cocos2d::CustomClass::create();
        object_to_luaval<cocos2d::CustomClass>(tolua_S, "cc.CustomClass",(cocos2d::CustomClass*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "cc.CustomClass:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_CustomClass_create'.",&tolua_err);
#endif
    return 0;
}
int lua_cocos2dx_custom_CustomClass_constructor(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::CustomClass* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_custom_CustomClass_constructor'", nullptr);
            return 0;
        }
        cobj = new cocos2d::CustomClass();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"cc.CustomClass");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "cc.CustomClass:CustomClass",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_CustomClass_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cocos2dx_custom_CustomClass_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CustomClass)");
    return 0;
}

int lua_register_cocos2dx_custom_CustomClass(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"cc.CustomClass");
    tolua_cclass(tolua_S,"CustomClass","cc.CustomClass","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"CustomClass");
        tolua_function(tolua_S,"new",lua_cocos2dx_custom_CustomClass_constructor);
        tolua_function(tolua_S,"addSkipBackupAttributeToItemAtPath",lua_cocos2dx_custom_CustomClass_addSkipBackupAttributeToItemAtPath);
        tolua_function(tolua_S,"init",lua_cocos2dx_custom_CustomClass_init);
        tolua_function(tolua_S,"create", lua_cocos2dx_custom_CustomClass_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(cocos2d::CustomClass).name();
    g_luaType[typeName] = "cc.CustomClass";
    g_typeCast["CustomClass"] = "cc.CustomClass";
    return 1;
}
TOLUA_API int register_all_cocos2dx_custom(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_cocos2dx_custom_CustomClass(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

