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
#import "Masonry.h"
#import "OpenScreenAdEmitterLayer.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface OpenScreenAdViewController () <OpenScreenAdSkipButtonDelegate, OpenScreenAdManagerDelegate, GADNativeExpressAdViewDelegate, GADVideoControllerDelegate>

@property (nonatomic, strong) OpenScreenAdSkipButton *skipButton;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *emitView;
@property (nonatomic, strong) OpenScreenAdEmitterLayer *emitLayer;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) OpenScreenAdManager *dataManager;

@property (nonatomic, strong) OpenScreenAdMVAdView *mvAdView;
@property (nonatomic, strong) GADNativeExpressAdView *mobAdView;

@property (nonatomic, strong) NSString *mobADdUnitId;

@end

@implementation OpenScreenAdViewController

- (instancetype)init {
    if(self = [super init]) {
        
    }
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
    });
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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


#pragma mark - Private
- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgImageView];
    
    [self.view addSubview:self.emitView];
    
    [self.view addSubview:self.indicator];
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(OSA_SCREENAPPLYHEIGHT(227));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(24));
        make.width.mas_equalTo(OSA_SCREENAPPLYHEIGHT(24));
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.indicator.mas_bottom).offset(OSA_SCREENAPPLYHEIGHT(11));
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(OSA_SCREENAPPLYSPACE(23));
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(17));
    }];
    
    [self.view addSubview:self.mobAdView];
    
    [self.view addSubview:self.skipButton];
    
}

- (void)executeDismiss {
    if(self.delegate && [self.delegate respondsToSelector:@selector(openScreenAdDidClickSkipAndWillDismiss)]) {
        [self.delegate openScreenAdDidClickSkipAndWillDismiss];
    }
    __weak typeof(self) weakSelf;
    [self dismissViewControllerAnimated:NO completion:^{
        if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(openScreenAdDidClickSkipAndDidDismiss)]) {
            [weakSelf.delegate openScreenAdDidClickSkipAndDidDismiss];
        }
    }];
}

- (void)addMVAdToView {
    _currentState = OpenScreenAdViewCurrentAdTypeMobVista;
    [self.view addSubview:self.mvAdView];
    [self.mvAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    
    [self.emitLayer addToSubView:self.view];
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
    if(self.currentState == OpenScreenAdViewCurrentAdTypeNone) {
        _currentState = OpenScreenAdViewCurrentAdTypeAdMob;
        self.mobAdView.hidden = NO;
        [self stopLoading];
    } else {

    }
}

- (void)nativeExpressAdView:(GADNativeExpressAdView *)nativeExpressAdView didFailToReceiveAdWithError:(GADRequestError *)error {
    [self.dataManager startLoadAd];
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


#pragma mark - Getter
- (OpenScreenAdSkipButton *)skipButton {
    if(!_skipButton) {
        _skipButton = [[OpenScreenAdSkipButton alloc] initWithFrame:CGRectMake(OSA_SCREEN_WIDTH - kOSASkipButtonSize - 25, 25, kOSASkipButtonSize, kOSASkipButtonSize)];
        _skipButton.delegate = self;
    }
    return _skipButton;
}

- (UIImageView *)bgImageView {
    if(!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageWithContentsOfFile:[OSA_RESOUCE_BUNDLE pathForResource:@"image_flash_ad_bg@3x" ofType:@"png"]];
        _bgImageView.image = image;
        [_bgImageView setFrame:self.view.frame];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"Loading...";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:12];
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

- (OpenScreenAdMVAdView *)mvAdView {
    if(!_mvAdView) {
        _mvAdView = [[OpenScreenAdMVAdView alloc] initWithMVCampaign:[self.dataManager getMVCampaign]];
    }
    return _mvAdView;
}

- (UIView *)emitView {
    if(!_emitView) {
        _emitView = [[UIView alloc] initWithFrame:CGRectMake(0, OSA_SCREENAPPLYHEIGHT(125), OSA_SCREEN_WIDTH, OSA_SCREEN_WIDTH)];
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
        _mobAdView = [[GADNativeExpressAdView alloc] initWithFrame:CGRectMake(0, 0, OSA_SCREEN_WIDTH, OSA_SCREEN_HEIGHT)];
        _mobAdView.adUnitID = _mobADdUnitId;
        _mobAdView.delegate = self;
        _mobAdView.rootViewController = self;
        _mobAdView.hidden = YES;
        
        GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
        videoOptions.startMuted = true;
        [_mobAdView setAdOptions:@[ videoOptions ]];
        
        _mobAdView.videoController.delegate = self;
    }
    return _mobAdView;
}

- (NSUInteger)waitSecond {
    if(!_waitSecond) {
        _waitSecond = kOSAWaitSecond;
    }
    return _waitSecond;
}

@end
