//
//  MobVistaUnit.m
//  InstaGrab
//
//  Created by wyan assert on 2016/12/1.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//

#import "OpenScreenMobVistaUnit.h"
#import <MVSDK/MVSDK.h>

@interface OpenScreenMobVistaUnit () <MVNativeAdManagerDelegate>

@property (nonatomic, strong)   MVNativeAdManager   *adManager;
@property (nonatomic, strong)   NSMutableArray      *adArray;
@property (nonatomic, assign)   NSInteger           preloadCount;
@property (nonatomic, assign)   NSInteger           storeCount;

@end

@implementation OpenScreenMobVistaUnit

@synthesize unitId= _unitId;

- (instancetype)initWithUnitId:(NSString *)unidId preloadCount:(NSInteger)preloadCount storeCount:(NSInteger)storeCount {
    if(self = [super init]) {
        _unitId = unidId;
        _preloadCount = preloadCount;
        _storeCount = storeCount;
        [[MVSDK sharedInstance] preloadNativeAdsWithUnitId:_unitId fbPlacementId:nil supportedTemplates:@[[MVTemplate templateWithType:MVAD_TEMPLATE_BIG_IMAGE adsNum:_preloadCount]] autoCacheImage:YES adCategory:MVAD_CATEGORY_ALL];
        [self getNativeAd:0];
    }
    return self;
}

- (NSArray <MVCampaign *> *)getNativeAd:(NSUInteger)number {
    
    if (_adArray == nil) {
        [self.adManager loadAds];
        return nil;
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    NSUInteger min  = MIN(self.adArray.count, number);
    for (int i = 0; i < min; i++) {
        
        [tempArray addObject:self.adArray[i]];
    }
    [self.adArray removeObjectsInArray:tempArray];
    if (self.adArray.count < _storeCount) {
        [self.adManager loadAds];
    }
    return tempArray;
}

- (void)registerViewForInteraction:(UIView *)view withCampaign:(MVCampaign *)campaign {
    
    [self.adManager registerViewForInteraction:view withCampaign:campaign];
}

- (void)preloadMVNativeAd {
    [[MVSDK sharedInstance] preloadNativeAdsWithUnitId:_unitId fbPlacementId:nil supportedTemplates:@[[MVTemplate templateWithType:MVAD_TEMPLATE_BIG_IMAGE adsNum:_preloadCount]] autoCacheImage:YES adCategory:MVAD_CATEGORY_ALL];
}


#pragma mark - MVNativeAdManagerDelegate
- (void)nativeAdsLoaded:(NSArray *)nativeAds {
    [[MVSDK sharedInstance] preloadNativeAdsWithUnitId:_unitId fbPlacementId:nil supportedTemplates:@[[MVTemplate templateWithType:MVAD_TEMPLATE_BIG_IMAGE adsNum:_preloadCount]] autoCacheImage:YES adCategory:MVAD_CATEGORY_ALL];
    
    if (nativeAds.count > 0) {
        
        [self.adArray addObjectsFromArray:nativeAds];
    }
}

- (void)nativeAdsFailedToLoadWithError:(nonnull NSError *)error {
    
}

- (void)nativeFramesLoaded:(nullable NSArray *)nativeFrames {
    
}

- (void)nativeFramesFailedToLoadWithError:(nonnull NSError *)error {
    
}

- (void)nativeAdClickUrlWillStartToJump:(nonnull NSURL *)clickUrl {
    
}


#pragma mark - Getters
- (MVNativeAdManager *)adManager {
    if (!_adManager) {
        _adManager = [[MVNativeAdManager alloc] initWithUnitID:_unitId fbPlacementId:nil supportedTemplates:@[[MVTemplate templateWithType:MVAD_TEMPLATE_BIG_IMAGE adsNum:_preloadCount]] autoCacheImage:YES adCategory:MVAD_CATEGORY_ALL presentingViewController:nil];
        _adManager.delegate = self;
    }
    return _adManager;
}

- (NSMutableArray *)adArray {
    if (!_adArray) {
        _adArray = [NSMutableArray array];
    }
    return _adArray;
}


@end
