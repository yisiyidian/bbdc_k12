//
//  BBTestLua.cpp
//  CocosLuaGame
//
//  Created by Bemoo on 9/24/14.
//
//

#include "BBTestLua.h"

int BBTestLua::show(int arg)
{
    log("BBTestLua show %d", arg);
    return arg + 100;
}
