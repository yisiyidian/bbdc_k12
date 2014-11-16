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
    }
    return m_pInstance;
}

CXUtils::CXUtils() {
    m_xxteaKeyLen = 10;
    m_xxteaKey = (char*)malloc(m_xxteaKeyLen);
    memcpy(m_xxteaKey, "fuck2dxLua", m_xxteaKeyLen);
    
    m_xxteaSignLen = 9;
    m_xxteaSign = (char*)malloc(m_xxteaSignLen);
    memcpy(m_xxteaSign, "fuckXXTEA", m_xxteaSignLen);
}

CXUtils::~CXUtils() {
    free(m_xxteaKey); m_xxteaKey = nullptr;
    free(m_xxteaSign); m_xxteaSign = nullptr;
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

const char* CXUtils::decryptXxteaFile(const char* filePath) {
    Data data = FileUtils::getInstance()->getDataFromFile(filePath);
    if (data.isNull() == false) {
        unsigned char* buf = data.getBytes();
        size_t size = data.getSize();
        
        uint32_t ret_length;
        const char * ret = (const char *)xxtea_decrypt(buf + m_xxteaSignLen, uint32_t(size - m_xxteaSignLen), (unsigned char*)m_xxteaKey, m_xxteaKeyLen, &ret_length);
        return ret;
    } else {
        return nullptr;
    }
}
