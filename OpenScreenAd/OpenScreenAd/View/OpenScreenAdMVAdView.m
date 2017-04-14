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

@interface OpenScreenAdMVAdView ()

@property (nonatomic, strong) UIImageView   *bannerImageView;
@property (nonatomic, strong) UIImageView   *bannerView;
@property (nonatomic, strong) UIImageView   *avatarImageView;
@property (nonatomic, strong) UILabel       *displayAppNameLabel;
@property (nonatomic, strong) UILabel       *displayAppDesclabel;
@property (nonatomic, strong) UILabel       *adLabel;

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
        make.top.equalTo(self).offset(OSA_SCREENAPPLYHEIGHT(70));
        make.left.equalTo(self).offset(OSA_SCREENAPPLYHEIGHT(35));
        make.centerX.equalTo(self);
        make.height.equalTo(self.bannerView.mas_width).multipliedBy(0.51);
    }];
    
    [self addSubview:self.bannerImageView];
    [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(OSA_SCREENAPPLYHEIGHT(65));
        make.left.equalTo(self).offset(OSA_SCREENAPPLYHEIGHT(35));
        make.centerX.equalTo(self);
        make.height.equalTo(self.bannerImageView.mas_width).multipliedBy(0.51);
    }];
    
    [self addSubview:self.adLabel];
    [self.adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).offset(OSA_SCREENAPPLYHEIGHT(25));
        make.width.mas_equalTo(OSA_SCREENAPPLYHEIGHT(32));
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(16));
    }];
    
    [self addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(- OSA_SCREENAPPLYHEIGHT(215));
        make.centerX.equalTo(self);
        make.height.width.mas_equalTo(OSA_SCREENAPPLYHEIGHT(70));
    }];
    
    [self addSubview:self.displayAppNameLabel];
    [self.displayAppNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(OSA_SCREENAPPLYHEIGHT(22));
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(OSA_SCREENAPPLYSPACE(23));
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(21));
    }];
    
    [self addSubview:self.displayAppDesclabel];
    [self.displayAppDesclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.displayAppNameLabel.mas_bottom).offset(OSA_SCREENAPPLYHEIGHT(9));
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(OSA_SCREENAPPLYSPACE(23));
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(34));
    }];
}


#pragma mark - Getter
- (UIImageView *)bannerView {
    if(!_bannerView) {
        _bannerView = [[UIImageView alloc] init];
        _bannerView.layer.borderWidth = 4;
        _bannerView.layer.borderColor = [UIColor whiteColor].CGColor;
        _bannerView.layer.allowsEdgeAntialiasing = YES;
    }
    return _bannerView;
}

- (UIImageView *)bannerImageView {
    if(!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] init];
        //        [_bannerImageView sd_setImageWithURL:[NSURL URLWithString:self.campaign.imageUrl]];
        __weak typeof(self) weakSelf = self;
        [self.campaign loadImageUrlAsyncWithBlock:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _bannerImageView.image = image;
                weakSelf.bannerView.image = image;
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
        //        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.campaign.iconUrl] placeholderImage:[UIImage imageNamed:@"image_placeholder_user_small.png"]];
        [self.campaign loadIconUrlAsyncWithBlock:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _avatarImageView.image = image;
            });
        }];
        _avatarImageView.hidden = YES;
        _avatarImageView.layer.cornerRadius = OSA_SCREENAPPLYHEIGHT(70) / 2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarImageView.layer.borderWidth = 3;
    }
    return _avatarImageView;
}

- (UILabel *)displayAppNameLabel {
    if(!_displayAppNameLabel) {
        _displayAppNameLabel = [[UILabel alloc] init];
        _displayAppNameLabel.font = [UIFont systemFontOfSize:OSA_SCREENAPPLYHEIGHT(18)];
        _displayAppNameLabel.textColor = [UIColor whiteColor];
        _displayAppNameLabel.text = self.campaign.appName;
        _displayAppNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _displayAppNameLabel;
}

- (UILabel *)displayAppDesclabel {
    if(!_displayAppDesclabel) {
        _displayAppDesclabel = [[UILabel alloc] init];
        _displayAppDesclabel.font = [UIFont systemFontOfSize:OSA_SCREENAPPLYHEIGHT(14)];
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
        _adLabel.font = [UIFont systemFontOfSize:OSA_SCREENAPPLYHEIGHT(12)];
        _adLabel.textColor = [UIColor whiteColor];
        _adLabel.text = @"Sponsored";
        _adLabel.textAlignment = NSTextAlignmentCenter;
        _adLabel.alpha = 0.4;
    }
    return _adLabel;
}

@end
