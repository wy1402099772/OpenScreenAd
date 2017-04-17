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

@interface OpenScreenAdManager () <OpenScreenMobVistaUnitDelegate>

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

- (MVCampaign *)getMVCampaign {
    static MVCampaign *campaign = nil;
    if(!campaign) {
        NSArray<MVCampaign *> *ads = [self.mvUnit getNativeAd:1];
        if(ads.count) {
            campaign = ads[0];
        } else {
            campaign = nil;
        }
    }
    return campaign;
}

- (void)registerViewForInteraction:(UIView *)view withCampaign:(MVCampaign *)campaign {
    [self.mvUnit registerViewForInteraction:view withCampaign:campaign];
}


#pragma mark - OpenScreenMobVistaUnitDelegate
- (void)openScreenMobvistaUnitDidGetAd {
    if(self.delegate && [self.delegate respondsToSelector:@selector(openScreenMVAdDidReach)]) {
        [self.delegate openScreenMVAdDidReach];
    }
}


#pragma mark - Getter
- (OpenScreenMobVistaUnit *)mvUnit {
    if(!_mvUnit) {
        _mvUnit = [[OpenScreenMobVistaUnit alloc] initWithUnitId:_mvUnitId preloadCount:2 storeCount:1];
        _mvUnit.delegate = self;
    }
    return _mvUnit;
}

@end
