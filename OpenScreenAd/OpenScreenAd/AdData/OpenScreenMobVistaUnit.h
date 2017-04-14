//
//  MobVistaUnit.h
//  InstaGrab
//
//  Created by wyan assert on 2016/12/1.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MVCampaign;

@interface OpenScreenMobVistaUnit : NSObject

- (instancetype)initWithUnitId:(NSString *)unidId preloadCount:(NSInteger)preloadCount storeCount:(NSInteger)storeCount;

- (NSArray <MVCampaign *> *)getNativeAd:(NSUInteger)number;

- (void)registerViewForInteraction:(UIView *)view withCampaign:(MVCampaign *)campaign;

- (void)preloadMVNativeAd;

@property (nonatomic, strong, readonly) NSString *unitId;

@end
