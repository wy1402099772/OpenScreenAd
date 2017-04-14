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

@interface OpenScreenAdViewController () <OpenScreenAdSkipButtonDelegate, OpenScreenAdManagerDelegate>

@property (nonatomic, strong) OpenScreenAdSkipButton *skipButton;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *emitView;
@property (nonatomic, strong) OpenScreenAdEmitterLayer *emitLayer;

@property (nonatomic, strong) OpenScreenAdManager *dataManager;

@property (nonatomic, strong) OpenScreenAdMVAdView *mvAdView;

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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.skipButton startCountdown];
}


#pragma mark - Public
- (void)setAppID:(NSString *)appId apiKey:(NSString *)apiKey {
    [self.dataManager setAppID:appId apiKey:apiKey];
}

- (void)configureWithUnitId:(NSString *)unitId {
    [self.dataManager configureWithUnitId:unitId];
}

#pragma mark - Private
- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.skipButton];
    [self.view addSubview:self.tipLabel];
    
    [self.view addSubview:self.emitView];
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

- (void)startLoadAd {
    [self.dataManager startLoadAd];
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
    [self.emitLayer addToSubView:self.view];
    
    if(self.mvAdView.superview == nil) {
        [self.view addSubview:self.mvAdView];
        [self.mvAdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.view bringSubviewToFront:self.skipButton];
    }
    
    [self.dataManager registerViewForInteraction:self.mvAdView withCampaign:[self.dataManager getMVCampaign]];
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
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, OSA_SCREEN_HEIGHT - 50, OSA_SCREEN_WIDTH, 30)];
        _tipLabel.text = @"Click Skip Button";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:20];
        _tipLabel.textColor = [UIColor redColor];
        _tipLabel.hidden = YES;
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
        _emitView = [[UIView alloc] initWithFrame:CGRectMake(0, OSA_SCREENAPPLYHEIGHT(125), OSA_SCREEN_WIDTH, OSA_SCREENAPPLYHEIGHT(225))];
    }
    return _emitView;
}

- (OpenScreenAdEmitterLayer *)emitLayer {
    if(!_emitLayer) {
        _emitLayer = [[OpenScreenAdEmitterLayer alloc] initWithLayerFrame:self.emitView.bounds andLayerCenterPoint:self.emitView.center andLayerSize:self.emitView.bounds.size andImage:[UIImage imageWithContentsOfFile:[OSA_RESOUCE_BUNDLE pathForResource:@"image_shine_cell@3x" ofType:@"png"]]];
     }
    return _emitLayer;
}

@end
