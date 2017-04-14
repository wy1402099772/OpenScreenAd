//
//  OpenScreenAdManager.h
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/14.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MVCampaign;

@protocol OpenScreenAdManagerDelegate <NSObject>

- (void)openScreenMVAdDidReach;

@end

@interface OpenScreenAdManager : NSObject

- (void)setAppID:(NSString *)appId apiKey:(NSString *)apiKey;
- (void)configureWithUnitId:(NSString *)unitId;

- (void)startLoadAd;

- (MVCampaign *)getMVCampaign;


@property (nonatomic, weak) id<OpenScreenAdManagerDelegate> delegate;

@end
