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

#include "base64.h"
#include "zlib.h"

/** Compress a STL string using zlib with given compression level and return
 * the binary data. */
std::string compress_string(const std::string& str,
                            int compressionlevel = Z_BEST_COMPRESSION) {
    z_stream zs;                        // z_stream is zlib's control structure
    memset(&zs, 0, sizeof(zs));
    
    if (deflateInit(&zs, compressionlevel) != Z_OK)
        throw(std::runtime_error("deflateInit failed while compressing."));
    
    zs.next_in = (Bytef*)str.data();
    zs.avail_in = (uInt)str.size();           // set the z_stream's input
    
    int ret;
    char outbuffer[32768];
    std::string outstring;
    
    // retrieve the compressed bytes blockwise
    do {
        zs.next_out = reinterpret_cast<Bytef*>(outbuffer);
        zs.avail_out = sizeof(outbuffer);
        
        ret = deflate(&zs, Z_FINISH);
        
        if (outstring.size() < zs.total_out) {
            // append the block to the output string
            outstring.append(outbuffer,
                             zs.total_out - outstring.size());
        }
    } while (ret == Z_OK);
    
    deflateEnd(&zs);
    
    if (ret != Z_STREAM_END) {          // an error occurred that was not EOF
        std::ostringstream oss;
        oss << "Exception during zlib compression: (" << ret << ") " << zs.msg;
        throw(std::runtime_error(oss.str()));
    }
    
    return outstring;
}

/** Decompress an STL string using zlib and return the original data. */
std::string decompress_string(const std::string& str) {
    z_stream zs;                        // z_stream is zlib's control structure
    memset(&zs, 0, sizeof(zs));
    
    if (inflateInit(&zs) != Z_OK)
        throw(std::runtime_error("inflateInit failed while decompressing."));
    
    zs.next_in = (Bytef*)str.data();
    zs.avail_in = (uInt)str.size();
    
    int ret;
    char outbuffer[32768];
    std::string outstring;
    
    // get the decompressed bytes blockwise using repeated calls to inflate
    do {
        zs.next_out = reinterpret_cast<Bytef*>(outbuffer);
        zs.avail_out = sizeof(outbuffer);
        
        ret = inflate(&zs, 0);
        
        if (outstring.size() < zs.total_out) {
            outstring.append(outbuffer,
                             zs.total_out - outstring.size());
        }
        
    } while (ret == Z_OK);
    
    inflateEnd(&zs);
    
    if (ret != Z_STREAM_END) {          // an error occurred that was not EOF
        std::ostringstream oss;
        oss << "Exception during zlib decompression: (" << ret << ") "
        << zs.msg;
        throw(std::runtime_error(oss.str()));
    }
    
    return outstring;
}

std::string CXUtils::compressAndBase64EncodeString(const std::string& str) {
    std::string compress = compress_string(str);
    
    const unsigned char *in = reinterpret_cast<const unsigned char *>(compress.c_str());
    size_t inLength = compress.length();
    char *out = nullptr;
    int outLength = base64Encode(in, (unsigned int)inLength, &out);
    
    std::string outstring;
    outstring.append(out, outLength);
    
    if (out) free(out);
    
    return outstring;
}

std::string CXUtils::base64DecodeAndDecompressString(const std::string& str) {
    const unsigned char *in = reinterpret_cast<const unsigned char *>(str.c_str());
    size_t inLength = str.length();
    unsigned char *out = nullptr;
    int outLength = base64Decode(in, (unsigned int)inLength, &out);
    
    std::string decodedStr;
    decodedStr.append(reinterpret_cast<const char *>(out), outLength);
    
    if (out) free(out);
    
    std::string outstring = decompress_string(decodedStr);
    return outstring;
}

void CXUtils::_testCppApi_() {
    std::string raw = "{\"channels\":[{\"name\":\"小米\",\"packageName\":\"com.beibei.wordmaster.mi\",\"leanCloudAppName\":\"贝贝单词X\",\"leanCloudAppId\":\"94uw2vbd553rx8fa6h5kt2y1w07p0x2ekwusf4w88epybnrp\",\"leanCloudAppKey\":\"lqsgx6mtmj65sjgrekfn7e5c28xc7koptbk9mqag2oraagdz\",\"QQAppId\":\"\",\"QQAppKey\":\"\",\"isQQLogInAvailable\":\"false\",\"umengAppName\":\"贝贝单词-小米\",\"umengAppKey\":\"5498fc3afd98c56b4200075d\"},{\"name\":\"android\",\"packageName\":\"com.beibei.wordmaster\",\"leanCloudAppName\":\"贝贝单词X_0\",\"leanCloudAppId\":\"2ktgzl363xwj3y3l9axd5hx3i8t31k48tt6344ds0qdg38jq\",\"leanCloudAppKey\":\"gycctmmh4csumv8opxtodi55e6837r3w5sjtm7tpunqgovjc\",\"QQAppId\":\"1103783596\",\"QQAppKey\":\"n7vXdt6eDIggSsa6\",\"isQQLogInAvailable\":\"true\",\"umengAppName\":\"贝贝单词-android\",\"umengAppKey\":\"549a5eb9fd98c5b2ac00144e\"}]}";
    std::string now = compressAndBase64EncodeString(raw);
    printf("raw:%ld\nnow:%ld\n%s\n", raw.length(), now.length(), now.c_str());
    
    std::string compress = compress_string(raw);
    printf("compresses:%ld\n%s\n", compress.length(), compress.c_str());
    
    //
    
    std::string compressed = "eNqNkc9u1DAQxt8l57Jy4j9xeqvgsgIhrbhUQghNbMebTWwnsfOv1T5CxYkjzwAIXqmij0HQskUti6g0l5n59Gnm911HYgvWqtpH52+vIwtGRefR7ZcPP75+i86iBkQFWr0+jIUzq1yVS61G10kDPqhuZcpFWCuwz2vXy4um+a2++/5pqdubj3efby4fSdZyEWSkH5Mhl5TibuIFsC2tQjLHI0obNCWqGntfkJFz1cy57ZpHHi/VvJjUrdcTM8HsGPU73amqsKmiIuGTSCvXhLzKTAs6cR2AlleLyWZzvODYHKyWrvSbzSun1/ZigLKGvP71SAG1V8uyN8rq0/89uyd2FB0sKcl4ITAUMuOCspwkCKGUymh/dg8brOxcKZ9G+wmo36NTsJMq6KsaMzyNOzzjOoNJ0u2ESx5wXBEeAsOESI9aqTHftSdh61mIYMyWCN+bgbtmCk6WlCrGcdrhcUkgmDQ0vW21G3biAew4RjjlmGbsIXabDpcyMPVirfUbD+xfMYSu/18Kf1D+FQNQlWeHGPIEBEIxISrav9v/BGoSFTY=";
    std::string decompressed = base64DecodeAndDecompressString(compressed);
    printf("compressed:%ld\nnow:%ld\n%s\n", compressed.length(), decompressed.length(), decompressed.c_str());

}
