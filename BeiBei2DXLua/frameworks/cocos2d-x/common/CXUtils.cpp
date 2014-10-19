//
//  CXUtils.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/9/14.
//
//

#include "CXUtils.h"
#include "md5.h"

using namespace std;
using namespace cocos2d;

CXUtils* CXUtils::m_pInstance = nullptr;

CXUtils* CXUtils::getInstance() {
    if (!m_pInstance) {
        m_pInstance = new CXUtils();
    }
    return m_pInstance;
}

CXUtils::CXUtils() {
    
}

int toMD5(char* dest, const char* src)
{
    md5_state_t state;
    md5_byte_t digest[16];
    md5_init(&state);
    md5_append(&state, (const md5_byte_t *)src, (int)strlen((char *)src));
    md5_finish(&state, digest);
    
    for (int di = 0; di < 16; ++di) {
        sprintf(dest + di * 2, "%02x", digest[di]);
    }
    return 0;
}

std::string& CXUtils::md5(const char* in, std::string& out)
{
    char md5str[33] = {0,};
    toMD5(md5str, in);
    out = md5str;

    return out;
}
