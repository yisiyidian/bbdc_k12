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

class CXUtils : public cocos2d::Ref {
public:
    ~CXUtils();
    
    static CXUtils* getInstance();
    
    static void showMail(const char* mailTitle, const char* userName);
    static std::string& md5(const char* in, std::string& out);
    
    const char* decryptXxteaFile(const char* filePath);
    
    std::string compressAndBase64EncodeString(const std::string& str);
    std::string base64DecodeAndDecompressString(const std::string& str);
    
    void shareImageToQQFriend(const std::string& path, const std::string& title, const std::string& desc);
    void shareImageToWeiXin(const std::string& path, const std::string& title, const std::string& desc);
    void shareURLToWeiXin(const std::string& url, const std::string& title, const std::string& desc);
    void addImageToGallery(const std::string& filePath);
    
    void download(const char* url, const char* savePath, const char* filename);
    
    void shutDownApp();
    
    void _testCppApi_();
    
//    std::string getExternalStorageDirectory();
    
    
    
private:
    CXUtils();
    
    static CXUtils* m_pInstance;
    
    char* m_xxteaKey;
    int m_xxteaKeyLen;
    char* m_xxteaSign;
    int m_xxteaSignLen;
};

#endif /* defined(__BeiBei2DXLua__CXUtils__) */
