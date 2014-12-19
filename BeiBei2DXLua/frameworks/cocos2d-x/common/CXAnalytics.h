//
//  CXAnalytics.h
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#ifndef __BeiBei2DXLua__CXAnalytics__
#define __BeiBei2DXLua__CXAnalytics__

#include <stdio.h>

class CXAnalytics {
public:
    static void beginLog(const char* pageName);
    static void endLog(const char* pageName);
    static void logEventAndLabel(const char* event, const char* label);
};

#endif /* defined(__BeiBei2DXLua__CXAnalytics__) */
