#include "lua_bb_auto.hpp"
#include "BBTestLua.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_bb_BBTestLua_init(lua_State* tolua_S)
{
    int argc = 0;
    BBTestLua* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"BBTestLua",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (BBTestLua*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_bb_BBTestLua_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_bb_BBTestLua_init'.",&tolua_err);
#endif

    return 0;
}
int lua_bb_BBTestLua_show(lua_State* tolua_S)
{
    int argc = 0;
    BBTestLua* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"BBTestLua",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (BBTestLua*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_bb_BBTestLua_show'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0);
        if(!ok)
            return 0;
        int ret = cobj->show(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "show",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_bb_BBTestLua_show'.",&tolua_err);
#endif

    return 0;
}
int lua_bb_BBTestLua_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"BBTestLua",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
            return 0;
        BBTestLua* ret = BBTestLua::create();
        object_to_luaval<BBTestLua>(tolua_S, "BBTestLua",(BBTestLua*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_bb_BBTestLua_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_bb_BBTestLua_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (BBTestLua)");
    return 0;
}

int lua_register_bb_BBTestLua(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"BBTestLua");
    tolua_cclass(tolua_S,"BBTestLua","BBTestLua","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"BBTestLua");
        tolua_function(tolua_S,"init",lua_bb_BBTestLua_init);
        tolua_function(tolua_S,"show",lua_bb_BBTestLua_show);
        tolua_function(tolua_S,"create", lua_bb_BBTestLua_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(BBTestLua).name();
    g_luaType[typeName] = "BBTestLua";
    g_typeCast["BBTestLua"] = "BBTestLua";
    return 1;
}
TOLUA_API int register_all_bb(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"bbns",0);
	tolua_beginmodule(tolua_S,"bbns");

	lua_register_bb_BBTestLua(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

