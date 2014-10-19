//
//  CXStore.h
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/19/14.
//
//

#ifndef __BeiBei2DXLua__CXStore__
#define __BeiBei2DXLua__CXStore__

#include <stdio.h>
#include "cocos2d.h"

typedef int CXLUAFUNC;

class CXStore : public cocos2d::Ref {
public:
    static CXStore* getInstance();
    
    void requestProducts(const char* productIds, CXLUAFUNC nHandler);
    void invokeLuaCallbackFunction_requestProducts(int msgId, const char* text);
    
private:
    CXStore();
    
    static CXStore* m_pInstance;
    int mLuaHandlerId_requestProducts;
};


#endif /* defined(__BeiBei2DXLua__CXStore__) */
