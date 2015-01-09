//
//  CXNetworkStatus.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 1/9/15.
//
//

#include "CXNetworkStatus.h"

CXNetworkStatus* CXNetworkStatus::m_pInstace = nullptr;

CXNetworkStatus* CXNetworkStatus::getInstance() {
    if (m_pInstace == nullptr) {
        m_pInstace = new CXNetworkStatus();
    }
    return m_pInstace;
}

CXNetworkStatus::CXNetworkStatus() 
: m_status(STATUS_NONE) {
    
}
