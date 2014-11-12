//
//  CXUtils.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/9/14.
//
//

#include "CXUtils.h"
#include "md5.h"
#include "external/xxtea/xxtea.h"

using namespace std;
using namespace cocos2d;

CXUtils* CXUtils::m_pInstance = nullptr;

CXUtils* CXUtils::getInstance() {
    if (!m_pInstance) {
        m_pInstance = new CXUtils();
        m_pInstance->autorelease();
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

const char * CXUtils::xxteaDecrypt(const char *data, uint32_t data_len, const char *key, uint32_t key_len, uint32_t *ret_length) {
    xxtea_long ret_length3 = 0;
    unsigned char* d = (unsigned char*)"xxtea is really good";
    unsigned char* e = (unsigned char*)"xxtea is good";
    unsigned char* r = xxtea_encrypt(d, 40, e, 13, &ret_length3);
    printf("%s", (const char*)r);
    
    xxtea_long ret_length4 = 0;
    unsigned char* r2 = xxtea_decrypt(r, ret_length3, (unsigned char*)e, 13, &ret_length4);
    printf("%s", (const char*)r2);
    
    string s("f5d7212a3cb3c386403ff7314e32489dad444dff");
    string k("xxtea is good");
    data_len = s.length();
    key_len = k.length();
    uint32_t ret_length2 = 0;
    return (const char *)xxtea_decrypt((unsigned char*)s.c_str(), data_len, (unsigned char*)k.c_str(), key_len, &ret_length2);
}
