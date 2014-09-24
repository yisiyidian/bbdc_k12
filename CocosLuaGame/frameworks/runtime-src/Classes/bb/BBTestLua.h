//
//  BBTestLua.h
//  CocosLuaGame
//
//  Created by Bemoo on 9/24/14.
//
//

#ifndef __CocosLuaGame__BBTestLua__
#define __CocosLuaGame__BBTestLua__

#include "cocos2d.h"

USING_NS_CC;

class BBTestLua : public Ref
{
public:
    bool init() { return true; }
    CREATE_FUNC(BBTestLua);
    int show(int);
};

#endif /* defined(__CocosLuaGame__BBTestLua__) */
