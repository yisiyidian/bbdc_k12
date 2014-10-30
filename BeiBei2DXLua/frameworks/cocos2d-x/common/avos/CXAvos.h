//
//  CXAvos.h
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#ifndef __BeiBei2DXLua__CXAvos__
#define __BeiBei2DXLua__CXAvos__

#include <stdio.h>
#include "cocos2d.h"

typedef int CXLUAFUNC;

class CXAvos : public cocos2d::Ref {
public:
    static CXAvos* getInstance();
    
    void downloadFile(const char* objectId, const char* savepath, CXLUAFUNC nHandler);
    
private:
    static CXAvos* m_pInstance;
    CXAvos();
    
    void invokeLuaCallbackFunction_dl(const char* objectId, const char* filename, const char* error, bool isSaved);
    
    int mLuaHandlerId_dl;
};

#endif /* defined(__BeiBei2DXLua__CXAvos__) */
