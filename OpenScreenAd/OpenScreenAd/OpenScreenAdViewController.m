//
//  OpenScreenAdViewController.m
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/13.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "OpenScreenAdViewController.h"
#import "OpenScreenAdParameters.h"
#import "OpenScreenAdSkipButton.h"
#import "OpenScreenAdManager.h"
#import "OpenScreenAdMVAdView.h"
#import "OpenScreenAdMVAdViewOne.h"
#import "Masonry.h"
#import "OpenScreenAdEmitterLayer.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "OpenScreenAdFlashView.h"
#import "OpenScreenAdDismissAnimationView.h"
#import "OpenScreenAdSkipButtonDelegate.h"
#import "OpenScreenAdSkipButtonProtocol.h"
#import "OpenScreenAdMVAdViewProtocol.h"
#import "OpenScreenAdMVAdViewTwo.h"
#import "OpenScreenAdMVAdViewThree.h"
#import "OpenScreenAdSkipButtonOne.h"
#import "OpenScreenAdSkipButtonTwo.h"
#import "OpenScreenAdSkipButtonThree.h"
#import "OpenScreenAdHelper.h"

NSString *const OpenScreenAdTypePurple = @"purple";
NSString *const OpenScreenAdTypeBlue = @"blue";
NSString *const OpenScreenAdTypeOrange = @"orange";
NSString *const OpenScreenAdTypeInkBlue = @"inkblue";

@interface OpenScreenAdViewController () <OpenScreenAdSkipButtonDelegate, OpenScreenAdManagerDelegate, GADNativeExpressAdViewDelegate, GADVideoControllerDelegate>

@property (nonatomic, strong) UIView<OpenScreenAdSkipButtonProtocol> *skipButton;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *emitView;
@property (nonatomic, strong) OpenScreenAdEmitterLayer *emitLayer;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) OpenScreenAdDismissAnimationView *dismissAnimationView;

@property (nonatomic, strong) OpenScreenAdManager *dataManager;

@property (nonatomic, strong) UIView<OpenScreenAdMVAdViewProtocol> *mvAdView;
@property (nonatomic, strong) GADNativeExpressAdView *mobAdView;

//@property (nonatomic, strong) OpenScreenAdFlashView *flashView;

@property (nonatomic, strong) NSString *mobADdUnitId;
@property (nonatomic, assign) BOOL isPresenting;

@end

@implementation OpenScreenAdViewController

- (instancetype)init {
    if(self = [super init]) {
        self.isPresenting = YES;
    }
    [[OpenScreenAdHelper sharedInstance] logOpenScreenAdVC:self];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.skipButton startCountdown];
        [self.indicator startAnimating];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    static dispatch_once_t onceToken;
    if(!self.shouldAutoHideStatusBar) {
        dispatch_once(&onceToken, ^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        });
    }
}

+ (OpenScreenAdViewController *)getLastAdVC {
    return [[OpenScreenAdHelper sharedInstance] getLastOpenScreenVC];
}


#pragma mark - Public
- (void)setAppID:(NSString *)appId apiKey:(NSString *)apiKey {
    [self.dataManager setAppID:appId apiKey:apiKey];
}

- (void)configureWithUnitId:(NSString *)unitId {
    [self.dataManager configureWithUnitId:unitId];
}

- (void)configureMobAdWithApplicationID:(NSString *)mobAdAppId {
    [GADMobileAds configureWithApplicationID:mobAdAppId];
}

- (void)configureWithAdMobUnitId:(NSString *)mobAdUnitid {
    _mobADdUnitId = mobAdUnitid;
}

- (void)startLoadAd {
    GADRequest *request = [GADRequest request];
    [self.mobAdView loadRequest:request];
    
    [self performSelector:@selector(prepareToLoadMobVista) withObject:nil afterDelay:self.waitSecond];
}

- (BOOL)isCurrentVCPresenting {
    return self.isPresenting;
}

- (void)reverseShow:(void (^)())block {
    [self exeReverseShowAnimation:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        if(block) {
            block();
        }
    }];
}


#pragma mark - Private
- (void)configureView {
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.bgImageView];
    
    [self.bgImageView addSubview:self.emitView];
    
    [self.bgImageView addSubview:self.indicator];
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(OSA_SCREENAPPLYHEIGHT(427));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(24));
        make.width.mas_equalTo(OSA_SCREENAPPLYHEIGHT(24));
    }];
    
    [self.bgImageView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.indicator.mas_bottom).offset(OSA_SCREENAPPLYHEIGHT(11));
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(OSA_SCREENAPPLYSPACE(23));
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(17));
    }];
    
    [self.bgImageView addSubview:self.mobAdView];
//    [self.mobAdView addSubview:self.flashView];
    
    [self.view addSubview:self.skipButton];
    CGRect skipRect = [OpenScreenAdParameters getSkipButtonFrame:self.openScreenAdType];
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(skipRect.origin.y);
        make.left.mas_equalTo(skipRect.origin.x);
        make.height.mas_equalTo(skipRect.size.height);
        make.width.mas_equalTo(skipRect.size.width);
    }];
    
}

- (void)executeDismiss {
    if(!self.shouldAutoHideStatusBar) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(openScreenAdDidCountDownOrSkip:)]) {
        [self.delegate openScreenAdDidCountDownOrSkip:self];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(shouldOpenScreenAdVCDismissWhenCountDownOrSkip)] && ![self.delegate shouldOpenScreenAdVCDismissWhenCountDownOrSkip]) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(openScreenAdDidClickSkipAndWillDismiss:)]) {
            [self.delegate openScreenAdDidClickSkipAndWillDismiss:self];
        }
        [self exeDismissAniation:^{
            self.isPresenting = NO;
            if(self.delegate && [self.delegate respondsToSelector:@selector(openScreenAdDidClickSkipAndDidDismiss:)]) {
                [self.delegate openScreenAdDidClickSkipAndDidDismiss:self];
            }
        }];
        return ;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(openScreenAdDidClickSkipAndWillDismiss:)]) {
        [self.delegate openScreenAdDidClickSkipAndWillDismiss:self];
    }
    [self exeDismissAniation:^{
        __weak typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:NO completion:^{
            self.isPresenting = NO;
            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(openScreenAdDidClickSkipAndDidDismiss:)]) {
                [weakSelf.delegate openScreenAdDidClickSkipAndDidDismiss:self];
            }
        }];
    }];
}

- (void)exeDismissAniation:(void (^)())dismissBlock {
    if(self.shouldShowDismissAnimation) {
        self.dismissAnimationView.image = [self getContentImage];
        self.dismissAnimationView.dismissEndPoint = self.dismissEndPoint;
        [self.view addSubview:self.dismissAnimationView];
        [self.dismissAnimationView startDismissAnimation:dismissBlock];
        self.bgImageView.hidden = YES;
    } else {
        if(dismissBlock) {
            dismissBlock();
        }
    }
}

- (void)exeReverseShowAnimation:(void (^)())reverseBlock {
    if(self.shouldShowDismissAnimation) {
        self.dismissAnimationView.dismissEndPoint = self.dismissEndPoint;
        [self.dismissAnimationView revertDismissAnimation:^{
            self.bgImageView.hidden = NO;
            [self.dismissAnimationView removeFromSuperview];
            
            if(reverseBlock) {
                reverseBlock();
            }
        }];
    } else {
        if(reverseBlock) {
            reverseBlock();
        }
    }
}

- (UIImage *)getContentImage
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    CGContextRef context =  UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = image.CGImage;
    CGFloat factor = image.size.width * image.scale / self.view.bounds.size.width;
    CGRect tmpRect = self.view.frame;
    tmpRect = CGRectMake(tmpRect.origin.x * factor, tmpRect.origin.y * factor, tmpRect.size.width * factor, tmpRect.size.height * factor);
    imageRef = CGImageCreateWithImageInRect(imageRef, tmpRect);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [image drawInRect:self.view.bounds];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)addMVAdToView {
    _currentState = OpenScreenAdViewCurrentAdTypeMobVista;
    [self.bgImageView addSubview:self.mvAdView];
    [self.view bringSubviewToFront:self.skipButton];
    [self.dataManager registerViewForInteraction:self.mvAdView withCampaign:[self.dataManager getMVCampaign]];
    
}

- (void)prepareToLoadMobVista {
    if(self.currentState == OpenScreenAdViewCurrentAdTypeNone) {
        [self.dataManager startLoadAd];
    }
}

- (void)stopLoading {
    [self.indicator stopAnimating];
    
    self.indicator.hidden = YES;
    self.tipLabel.hidden = YES;
    
    [self.emitLayer addToSubView:self.view];
}

- (void)startFlashLayer {
//    [self.flashView startFlash];
}

#pragma mark - Action


#pragma mark - OpenScreenAdSkipButtonDelegate
- (void)userDidSelectOpenScreenSkipButton:(NSUInteger)countdown {
    [self executeDismiss];
}

- (void)openScreenSkipButtonDidCompleteCountdown {
    [self executeDismiss];
}

- (void)openScreenSkipButtonSkipEnaled {
//    self.tipLabel.hidden = NO;
}


#pragma mark - OpenScreenAdManagerDelegate
- (void)openScreenMVAdDidReach {
    
    if(self.currentState == OpenScreenAdViewCurrentAdTypeNone) {
        [self addMVAdToView];
        [self stopLoading];
    }
}


#pragma mark - GADNativeExpressAdViewDelegate
- (void)nativeExpressAdViewDidReceiveAd:(GADNativeExpressAdView *)nativeExpressAdView {
    if (nativeExpressAdView.videoController.hasVideoContent) {
        NSLog(@"Received ad an with a video asset.");
    } else {
        NSLog(@"Received ad an without a video asset.");
    }
    
    if(self.currentState == OpenScreenAdViewCurrentAdTypeNone) {
        _currentState = OpenScreenAdViewCurrentAdTypeAdMob;
        [self.skipButton forceToCountDown];
        [self.mobAdView setFrame:[OpenScreenAdParameters getAdFrame:self.openScreenAdType]];
        self.mobAdView.hidden = NO;
        [self startFlashLayer];
        [self stopLoading];
    } else {

    }
}

- (void)nativeExpressAdView:(GADNativeExpressAdView *)nativeExpressAdView didFailToReceiveAdWithError:(GADRequestError *)error {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(prepareToLoadMobVista) object:nil];
    [self.dataManager startLoadAd];
}


#pragma mark - GADVideoControllerDelegate
- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
    
}

- (void)videoControllerDidPlayVideo:(GADVideoController *)videoController {
    
}


#pragma mark - Setter
- (void)setAllowSkipSecond:(NSUInteger)allowSkipSecond {
    _allowSkipSecond = allowSkipSecond;
    self.skipButton.allowSkipSecond = allowSkipSecond;
}

- (void)setTotalSecond:(NSUInteger)totalSecond {
    _totalSecond = totalSecond;
    self.skipButton.totalSecond = totalSecond;
}

- (void)setDelaySecond:(NSUInteger)delaySecond {
    _delaySecond = delaySecond;
    self.skipButton.delaySecond = delaySecond;
}

- (void)setOpenScreenAdType:(OpenScreenAdType)openScreenAdType {
    _openScreenAdType = openScreenAdType;
}

- (void)setDismissEndPoint:(CGPoint)dismissEndPoint {
    _dismissEndPoint = dismissEndPoint;
    if(_dismissAnimationView) {
        self.dismissAnimationView.dismissEndPoint = dismissEndPoint;
    }
}

- (void)setGradientColors:(NSArray<UIColor *> *)gradientColors {
    _gradientColors = gradientColors;
}

#pragma mark - Getter
- (UIView<OpenScreenAdSkipButtonProtocol> *)skipButton {
    if(!_skipButton) {
        if ([self.openScreenAdType isEqualToString:OpenScreenAdTypePurple]) {
            _skipButton = [[OpenScreenAdSkipButton alloc] init];
        } else if ([self.openScreenAdType isEqualToString:OpenScreenAdTypeBlue]) {
            _skipButton = [[OpenScreenAdSkipButtonOne alloc] init];
        } else if ([self.openScreenAdType isEqualToString:OpenScreenAdTypeOrange]) {
            _skipButton = [[OpenScreenAdSkipButtonTwo alloc] init];
        } else if ([self.openScreenAdType isEqualToString:OpenScreenAdTypeInkBlue]) {
            _skipButton = [[OpenScreenAdSkipButtonThree alloc] init];
        } else {
            _skipButton = [[OpenScreenAdSkipButton alloc] init];
        }
        _skipButton.delegate = self;
        
    }
    return _skipButton;
}

- (UIImageView *)bgImageView {
    if(!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        NSString *launchImageStr = [OpenScreenAdParameters getLaunchImageName];
        UIImage *image = [UIImage imageNamed:launchImageStr];
        if(!image) {
            image = [UIImage imageWithContentsOfFile:[OSA_RESOUCE_BUNDLE pathForResource:@"image_flash_ad_bg@3x" ofType:@"png"]];
        }
        _bgImageView.image = image;
        [_bgImageView setFrame:self.view.frame];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"Loading...";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [OpenScreenAdParameters getFontRegular:OSA_SCREENAPPLYHEIGHT(12)];
        _tipLabel.textColor = [UIColor whiteColor];
    }
    return _tipLabel;
}

- (OpenScreenAdManager *)dataManager {
    if(!_dataManager) {
        _dataManager = [[OpenScreenAdManager alloc] init];
        _dataManager.delegate = self;
    }
    return _dataManager;
}

- (UIView<OpenScreenAdMVAdViewProtocol> *)mvAdView {
    if(!_mvAdView) {
        if ([self.openScreenAdType isEqualToString:OpenScreenAdTypePurple]) {
            _mvAdView = [[OpenScreenAdMVAdView alloc] initWithMVCampaign:[self.dataManager getMVCampaign]];
        } else if ([self.openScreenAdType isEqualToString:OpenScreenAdTypeBlue]) {
            _mvAdView = [[OpenScreenAdMVAdViewOne alloc] initWithMVCampaign:[self.dataManager getMVCampaign]];
        } else if ([self.openScreenAdType isEqualToString:OpenScreenAdTypeOrange]) {
            _mvAdView = [[OpenScreenAdMVAdViewTwo alloc] initWithMVCampaign:[self.dataManager getMVCampaign]];
        } else if ([self.openScreenAdType isEqualToString:OpenScreenAdTypeInkBlue]) {
            _mvAdView = [[OpenScreenAdMVAdViewThree alloc] initWithMVCampaign:[self.dataManager getMVCampaign]];
        } else {
            _mvAdView = [[OpenScreenAdMVAdView alloc] initWithMVCampaign:[self.dataManager getMVCampaign]];
        }
        [_mvAdView setFrame:[OpenScreenAdParameters getAdFrame:self.openScreenAdType]];
        [_mvAdView setGradientColors:self.gradientColors];
    }
    return _mvAdView;
}

- (UIView *)emitView {
    if(!_emitView) {
        _emitView = [[UIView alloc] initWithFrame:CGRectMake(0, OSA_SCREENAPPLYHEIGHT(25), OSA_SCREEN_WIDTH, OSA_SCREEN_WIDTH)];
    }
    return _emitView;
}

- (OpenScreenAdEmitterLayer *)emitLayer {
    if(!_emitLayer) {
        _emitLayer = [[OpenScreenAdEmitterLayer alloc] initWithLayerFrame:self.emitView.bounds andLayerCenterPoint:self.emitView.center andLayerSize:self.emitView.bounds.size andImage:[UIImage imageWithContentsOfFile:[OSA_RESOUCE_BUNDLE pathForResource:@"image_shine_cell@3x" ofType:@"png"]]];
     }
    return _emitLayer;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] init];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    
    return _indicator;
}

- (GADNativeExpressAdView *)mobAdView {
    if (!_mobAdView) {
        _mobAdView = [[GADNativeExpressAdView alloc] initWithFrame:[OpenScreenAdParameters getAdFrame:self.openScreenAdType]];
        _mobAdView.adUnitID = _mobADdUnitId;
        _mobAdView.delegate = self;
        _mobAdView.rootViewController = self;
        _mobAdView.hidden = YES;
        
//        GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
//        videoOptions.startMuted = true;
//        [_mobAdView setAdOptions:@[ videoOptions ]];
//        _mobAdView.videoController.delegate = self;
    }
    return _mobAdView;
}

- (NSUInteger)waitSecond {
    if(!_waitSecond) {
        _waitSecond = kOSAWaitSecond;
    }
    return _waitSecond;
}

//- (OpenScreenAdFlashView *)flashView {
//    if(!_flashView) {
//        _flashView = [[OpenScreenAdFlashView alloc] initWithFrame:CGRectMake(0, OSA_SCREEN_HEIGHT - 50, OSA_SCREEN_WIDTH, 50)];
//    }
//    return _flashView;
//}

- (OpenScreenAdDismissAnimationView *)dismissAnimationView {
    if(!_dismissAnimationView) {
        _dismissAnimationView = [[OpenScreenAdDismissAnimationView alloc] initWithFrame:self.view.frame];
    }
    return _dismissAnimationView;
}



@end
