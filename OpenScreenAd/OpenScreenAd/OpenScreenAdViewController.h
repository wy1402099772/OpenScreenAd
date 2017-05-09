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

typedef NSString* OpenScreenAdType; //@"purple", @"blue", @"orange", @"inkblue"
extern NSString *const OpenScreenAdTypePurple;
extern NSString *const OpenScreenAdTypeBlue;
extern NSString *const OpenScreenAdTypeOrange;
extern NSString *const OpenScreenAdTypeInkBlue;

@protocol OpenScreenAdViewControllerDelegate <NSObject>

//determine whether to auto dismiss when countdown reach ending or click skip，
- (BOOL)shouldOpenScreenAdVCDismissWhenCountDownOrSkip;

//called when countdown reach ending or click skip，
- (void)openScreenAdDidCountDownOrSkip:(UIViewController *)adViewController;

- (void)openScreenAdDidClickSkipAndWillDismiss:(UIViewController *)adViewController;
- (void)openScreenAdDidClickSkipAndDidDismiss:(UIViewController *)adViewController;

@end


@interface OpenScreenAdViewController : UIViewController


@property (nonatomic, assign) NSUInteger allowSkipSecond;
@property (nonatomic, assign) NSUInteger totalSecond;
@property (nonatomic, assign) NSUInteger delaySecond;
@property (nonatomic, assign) NSUInteger waitSecond;

@property (nonatomic, assign) BOOL       shouldShowDismissAnimation;
@property (nonatomic, assign) CGPoint    dismissEndPoint;
@property (nonatomic, strong) NSArray<UIColor *> *gradientColors;

@property (nonatomic, assign) BOOL       shouldAutoHideStatusBar;

@property (nonatomic, strong) OpenScreenAdType       openScreenAdType;

@property (nonatomic, assign, readonly) OpenScreenAdViewCurrentAdType currentState;

@property (nonatomic, weak  ) id<OpenScreenAdViewControllerDelegate> delegate;

- (void)setAppID:(NSString *)appId apiKey:(NSString *)apiKey;
- (void)configureWithUnitId:(NSString *)unitId;

- (void)configureMobAdWithApplicationID:(NSString *)mobAdAppId;
- (void)configureWithAdMobUnitId:(NSString *)mobAdUnitid;

- (void)startLoadAd;

- (BOOL)isCurrentVCPresenting;

- (void)reverseShow:(void (^)())block;

+ (OpenScreenAdViewController *)getLastAdVC;

@end
