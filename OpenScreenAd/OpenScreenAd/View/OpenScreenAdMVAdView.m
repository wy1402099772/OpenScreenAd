//
//  OpenScreenAdMVAdView.m
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/14.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "OpenScreenAdMVAdView.h"
#import "OpenScreenAdParameters.h"
#import <MVSDK/MVSDK.h>
#import "Masonry.h"
#import "OpenScreenAdGoView.h"

@interface OpenScreenAdMVAdView ()

@property (nonatomic, strong) UIImageView   *bannerImageView;
@property (nonatomic, strong) UIImageView   *bannerView;
@property (nonatomic, strong) UIImageView   *avatarImageView;
@property (nonatomic, strong) UILabel       *displayAppNameLabel;
@property (nonatomic, strong) UILabel       *displayAppDesclabel;
@property (nonatomic, strong) UILabel       *adLabel;
@property (nonatomic, strong) OpenScreenAdGoView *goView;

@property (nonatomic, strong) MVCampaign    *campaign;

@end

@implementation OpenScreenAdMVAdView

- (instancetype)initWithMVCampaign:(MVCampaign *)campaign {
    if(self = [super init]) {
        _campaign = campaign;
        [self configureView];
    }
    return self;
}

#pragma mark - Private
- (void)configureView {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(OSA_SCREENAPPLYHEIGHT(155));
        make.centerX.equalTo(self);
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(190));
        make.width.mas_equalTo(OSA_SCREENAPPLYHEIGHT(300));
    }];
    
    [self addSubview:self.bannerImageView];
    [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bannerView);
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(166));
        make.width.mas_equalTo(OSA_SCREENAPPLYHEIGHT(296));
    }];
    
    [self addSubview:self.adLabel];
    [self.adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OSA_SCREENAPPLYSPACE(9));
        make.top.equalTo(self).offset(OSA_SCREENAPPLYHEIGHT(30));
        make.width.mas_equalTo(OSA_SCREENAPPLYHEIGHT(87));
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(17));
    }];
    
    [self addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom).offset(OSA_SCREENAPPLYHEIGHT(32));
        make.centerX.equalTo(self);
        make.height.width.mas_equalTo(OSA_SCREENAPPLYHEIGHT(50));
    }];
    
    [self addSubview:self.displayAppNameLabel];
    [self.displayAppNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(OSA_SCREENAPPLYHEIGHT(16));
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(OSA_SCREENAPPLYSPACE(23));
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(27));
    }];
    
    [self addSubview:self.displayAppDesclabel];
    [self.displayAppDesclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.displayAppNameLabel.mas_bottom).offset(OSA_SCREENAPPLYHEIGHT(9));
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(OSA_SCREENAPPLYSPACE(23));
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(34));
    }];
    
    [self addSubview:self.goView];
    [self.goView startFlashAnimation];
}


#pragma mark - Getter
- (UIImageView *)bannerView {
    if(!_bannerView) {
        _bannerView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageWithContentsOfFile:[OSA_RESOUCE_BUNDLE pathForResource:@"image_add_flower_border@3x" ofType:@"png"]];
        _bannerView.image = image;
    }
    return _bannerView;
}

- (UIImageView *)bannerImageView {
    if(!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] init];
        [self.campaign loadImageUrlAsyncWithBlock:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _bannerImageView.image = image;
            });
        }];
        _bannerImageView.layer.borderWidth = 4;
        _bannerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _bannerImageView.layer.allowsEdgeAntialiasing = YES;
    }
    return _bannerImageView;
}

- (UIImageView *)avatarImageView {
    if(!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        [self.campaign loadIconUrlAsyncWithBlock:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _avatarImageView.image = image;
            });
        }];
        _avatarImageView.layer.cornerRadius = OSA_SCREENAPPLYHEIGHT(12);
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)displayAppNameLabel {
    if(!_displayAppNameLabel) {
        _displayAppNameLabel = [[UILabel alloc] init];
        _displayAppNameLabel.font = [OpenScreenAdParameters getFontHeavy:OSA_SCREENAPPLYHEIGHT(22)];
        _displayAppNameLabel.textColor = [UIColor whiteColor];
        _displayAppNameLabel.text = self.campaign.appName;
        _displayAppNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _displayAppNameLabel;
}

- (UILabel *)displayAppDesclabel {
    if(!_displayAppDesclabel) {
        _displayAppDesclabel = [[UILabel alloc] init];
        _displayAppDesclabel.font = [OpenScreenAdParameters getFontRegular:OSA_SCREENAPPLYHEIGHT(14)];
        _displayAppDesclabel.textColor = [UIColor whiteColor];
        _displayAppDesclabel.text = self.campaign.appDesc;
        _displayAppDesclabel.numberOfLines = 2;
        _displayAppDesclabel.textAlignment = NSTextAlignmentCenter;
    }
    return _displayAppDesclabel;
}

- (UILabel *)adLabel {
    if(!_adLabel) {
        _adLabel = [[UILabel alloc] init];
        _adLabel.font = [OpenScreenAdParameters getFontRegular:OSA_SCREENAPPLYHEIGHT(12)];
        _adLabel.textColor = [UIColor whiteColor];
        _adLabel.text = @"Sponsored";
        _adLabel.alpha = 0.4;
    }
    return _adLabel;
}

- (OpenScreenAdGoView *)goView {
    if(!_goView) {
        _goView = [[OpenScreenAdGoView alloc] initWithFrame:CGRectMake(0, OSA_SCREEN_HEIGHT - OSA_SCREENAPPLYHEIGHT(60), OSA_SCREEN_WIDTH, OSA_SCREENAPPLYHEIGHT(60))];
    }
    return _goView;
}

@end
