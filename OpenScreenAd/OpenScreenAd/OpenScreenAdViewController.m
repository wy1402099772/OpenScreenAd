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

@interface OpenScreenAdViewController () <OpenScreenAdSkipButtonDelegate>

@property (nonatomic, strong) OpenScreenAdSkipButton *skipButton;
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation OpenScreenAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private
- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgImageView];
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


#pragma mark - Action


#pragma mark - OpenScreenAdSkipButtonDelegate
- (void)userDidSelectOpenScreenSkipButton:(NSUInteger)countdown {
    [self executeDismiss];
}


#pragma mark - Getter
- (OpenScreenAdSkipButton *)skipButton {
    if(!_skipButton) {
        _skipButton = [[OpenScreenAdSkipButton alloc] initWithFrame:CGRectMake(OSA_SCREEN_WIDTH - kOSASkipButtonSize - 15, 15, kOSASkipButtonSize, kOSASkipButtonSize)];
        _skipButton.delegate = self;
    }
    return _skipButton;
}

- (UIImageView *)bgImageView {
    if(!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_0713"]];
        [_bgImageView setFrame:self.view.frame];
    }
    return _bgImageView;
}

@end
