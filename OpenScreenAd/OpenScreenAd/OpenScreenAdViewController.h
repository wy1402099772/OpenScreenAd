//
//  OpenScreenAdViewController.h
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/13.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, OpenScreenAdViewCurrentAdType) {
    OpenScreenAdViewCurrentAdTypeNone = 0,
    OpenScreenAdViewCurrentAdTypeAdMob,
    OpenScreenAdViewCurrentAdTypeMobVista
};

@protocol OpenScreenAdViewControllerDelegate <NSObject>

- (void)openScreenAdDidClickSkipAndWillDismiss;
- (void)openScreenAdDidClickSkipAndDidDismiss;

@end


@interface OpenScreenAdViewController : UIViewController


@property (nonatomic, assign) NSUInteger allowSkipSecond;
@property (nonatomic, assign) NSUInteger totalSecond;
@property (nonatomic, assign) NSUInteger delaySecond;
@property (nonatomic, assign) NSUInteger waitSecond;

@property (nonatomic, assign, readonly) OpenScreenAdViewCurrentAdType currentState;

@property (nonatomic, weak  ) id<OpenScreenAdViewControllerDelegate> delegate;

- (void)setAppID:(NSString *)appId apiKey:(NSString *)apiKey;
- (void)configureWithUnitId:(NSString *)unitId;

- (void)configureMobAdWithApplicationID:(NSString *)mobAdAppId;
- (void)configureWithAdMobUnitId:(NSString *)mobAdUnitid;

- (void)startLoadAd;

@end
