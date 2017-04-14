//
//  OpenScreenAdManager.m
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/14.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "OpenScreenAdManager.h"
#import <MVSDK/MVSDK.h>
#import "OpenScreenMobVistaUnit.h"

@interface OpenScreenAdManager ()

@property (nonatomic, strong) OpenScreenMobVistaUnit *mvUnit;

@property (nonatomic ,strong) NSString *mvUnitId;

@end

@implementation OpenScreenAdManager

#pragma mark - Public
- (void)setAppID:(NSString *)appId apiKey:(NSString *)apiKey {
    [[MVSDK sharedInstance] setAppID:appId ApiKey:apiKey];
}

- (void)configureWithUnitId:(NSString *)unitId {
    _mvUnitId = unitId;
}

- (void)startLoadAd {
    [self.mvUnit preloadMVNativeAd];
}


#pragma mark - Getter
- (OpenScreenMobVistaUnit *)mvUnit {
    if(!_mvUnit) {
        _mvUnit = [[OpenScreenMobVistaUnit alloc] initWithUnitId:_mvUnitId preloadCount:2 storeCount:1];
    }
    return _mvUnit;
}

@end
