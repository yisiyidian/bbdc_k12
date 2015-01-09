//
//  CXNetworkStatus.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 1/9/15.
//
//

#include "CXNetworkStatus.h"
#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface CXNS : NSObject

+ (CXNS *)getInstance;
- (void)start;
- (void)updateInternetReachability;

@end

@interface CXNS ()

@property (nonatomic) Reachability *internetReachability;
//@property (nonatomic) Reachability *wifiReachability;

@end

@implementation CXNS

static CXNS *g_instance = nil;

+ (CXNS *)getInstance {
    @synchronized(self) {
        if (nil == g_instance) {
            g_instance = [[super allocWithZone:nil] init];
        }
    }
    
    return g_instance;
}

- (void)start {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
//    NSString *remoteHostName = @"www.baidu.com";
//    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
//    [self.hostReachability startNotifier];
//    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
//    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
//    [self.wifiReachability startNotifier];
//    [self updateInterfaceWithReachability:self.wifiReachability];
}

- (void) reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability {
//    if (reachability == self.internetReachability) {
//    }
//    if (reachability == self.wifiReachability) {
//    }
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
//    BOOL connectionRequired = [reachability connectionRequired];
     
    switch (netStatus) {
        case NotReachable: {
            // NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            CXNetworkStatus::getInstance()->setStatus(CXNetworkStatus::STATUS_NONE);
            break;
        }
            
        case ReachableViaWWAN: {
            // NSLocalizedString(@"Reachable WWAN", @"");
            CXNetworkStatus::getInstance()->setStatus(CXNetworkStatus::STATUS_MOBILE);
            break;
        }
        case ReachableViaWiFi: {
            // NSLocalizedString(@"Reachable WiFi", @"");
            CXNetworkStatus::getInstance()->setStatus(CXNetworkStatus::STATUS_WIFI);
            break;
        }
    }
}

- (void)updateInternetReachability {
    [self updateInterfaceWithReachability:self.internetReachability];
}

@end

int CXNetworkStatus::start() {
    [[CXNS getInstance] start];
    return m_status; 
}

int CXNetworkStatus::getStatus() { 
    [[CXNS getInstance] updateInternetReachability];
    return m_status; 
}
