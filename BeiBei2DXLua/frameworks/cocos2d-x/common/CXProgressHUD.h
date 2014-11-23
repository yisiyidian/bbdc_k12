//
//  CXProgressHUD.h
//  BeiBei2DXLua
//
//  Created by Bemoo on 11/23/14.
//
//

#ifndef __BeiBei2DXLua__CXProgressHUD__
#define __BeiBei2DXLua__CXProgressHUD__

#include <stdio.h>

class CXProgressHUD {
public:
    static void setupWindow(void* uiWindow);
    
    static void show(const char* content);
    static void hide();
};

#endif /* defined(__BeiBei2DXLua__CXProgressHUD__) */
