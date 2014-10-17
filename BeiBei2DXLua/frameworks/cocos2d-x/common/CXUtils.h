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

class CXUtils {
public:
    static void showMail(const char* mailTitle, const char* userName);
    static std::string& md5(const char* in, std::string& out);
};

#endif /* defined(__BeiBei2DXLua__CXUtils__) */
