//
//  OpenScreenAdManager.h
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/14.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MVCampaign;

@protocol OpenScreenAdManagerDelegate <NSObject>

- (void)openScreenMVAdDidReach;

@end

@interface OpenScreenAdManager : NSObject

//MV
- (void)setAppID:(NSString *)appId apiKey:(NSString *)apiKey;
- (void)configureWithUnitId:(NSString *)unitId;

- (MVCampaign *)getMVCampaign;
- (void)registerViewForInteraction:(UIView *)view withCampaign:(MVCampaign *)campaign;


- (void)startLoadAd;




@property (nonatomic, weak) id<OpenScreenAdManagerDelegate> delegate;

@end
