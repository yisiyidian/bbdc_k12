//
//  CXUtils.h
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/9/14.
//
//

#ifndef __BeiBei2DXLua__CXUtils__
#define __BeiBei2DXLua__CXUtils__

#include <stdio.h>
#include <string>
#include "cocos2d.h"

typedef int CXLUAFUNC;

class CXUtils : public cocos2d::Ref {
public:
    static CXUtils* getInstance();
    
    static void showMail(const char* mailTitle, const char* userName);
    static std::string& md5(const char* in, std::string& out);
    
    void requestProducts(const char* productIds, CXLUAFUNC nHandler);
    void invokeLuaCallbackFunction(int msgId, const char* text);
    
private:
    CXUtils();
    
    static CXUtils* m_pInstance;
    int mLuaHandlerId;
};

#endif /* defined(__BeiBei2DXLua__CXUtils__) */
