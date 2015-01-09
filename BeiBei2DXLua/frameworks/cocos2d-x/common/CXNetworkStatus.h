//
//  CXNetworkStatus.h
//  BeiBei2DXLua
//
//  Created by Bemoo on 1/9/15.
//
//

#ifndef __BeiBei2DXLua__CXNetworkStatus__
#define __BeiBei2DXLua__CXNetworkStatus__

#include <stdio.h>

class CXNetworkStatus {
public:
    enum { 
        STATUS_NONE = -1,
        STATUS_WIFI = 1,
        STATUS_MOBILE = 2
    };

    static CXNetworkStatus* getInstance();
    int start();

    int getStatus();
    void setStatus(int s) { m_status = s; }
    
private:
    CXNetworkStatus();
    static CXNetworkStatus* m_pInstace;

    int m_status;
};

#endif /* defined(__BeiBei2DXLua__CXNetworkStatus__) */
