//
//  OpenScreenAdGoView.m
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/14.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "OpenScreenAdGoView.h"
#import "OpenScreenAdParameters.h"
#import "Masonry.h"

@interface OpenScreenAdGoView ()

@property (nonatomic, strong) UILabel *goLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) CAGradientLayer *flashLayer;

@end

@implementation OpenScreenAdGoView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self configureView];
    }
    return self;
}


#pragma mark - public
- (void)startFlashAnimation {
    if ([self.flashLayer superlayer] == nil) {
        [self.layer addSublayer:self.flashLayer];
    }
}

- (void)endFlashAnimation {
    [self.flashLayer removeFromSuperlayer];
    self.flashLayer = nil;
}


#pragma mark - Private
- (void)configureView {
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.5;
    [self addSubview:self.goLabel];
    [self addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goLabel);
        make.right.equalTo(self).offset(- OSA_SCREENAPPLYSPACE(20));
        make.width.mas_equalTo(OSA_SCREENAPPLYHEIGHT(16));
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(16));
    }];
}


#pragma mark - Getter
- (UILabel *)goLabel {
    if(!_goLabel) {
        _goLabel = [[UILabel alloc] initWithFrame:CGRectMake(OSA_SCREENAPPLYSPACE(20), OSA_SCREENAPPLYHEIGHT(17), OSA_SCREENAPPLYHEIGHT(125), OSA_SCREENAPPLYHEIGHT(25))];
        _goLabel.text = @"Play Now";
        _goLabel.textAlignment = NSTextAlignmentLeft;
        _goLabel.font = [UIFont systemFontOfSize:18];
        _goLabel.textColor = [UIColor whiteColor];
    }
    return _goLabel;
}

- (CAGradientLayer *)flashLayer {
    if (!_flashLayer) {
        CGFloat btnHeight = self.bounds.size.height;
        CGFloat btnWidth = self.bounds.size.width;
        NSArray *timeArray = @[@0,@.6,@1];
        
        _flashLayer = [CAGradientLayer layer];
        [_flashLayer setColors:@[(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.0f].CGColor, (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.3f].CGColor]];
        [_flashLayer setStartPoint:CGPointMake(0.f, 0.f)];
        [_flashLayer setEndPoint:CGPointMake(1.f, 0.f)];
        [_flashLayer setFrame:CGRectMake(0, 0, btnWidth*0.4f, btnHeight)];
        
        CAKeyframeAnimation *keyAnima_group1=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
        keyAnima_group1.values = @[@0,@1,@0];
        keyAnima_group1.keyTimes = timeArray;
        //位置移动动画
        CAKeyframeAnimation *keyAnima_group2=[CAKeyframeAnimation animationWithKeyPath:@"position"];
        keyAnima_group2.values= @[[NSValue valueWithCGPoint:CGPointMake(- btnWidth*0.4f, btnHeight/2.f)], [NSValue valueWithCGPoint:CGPointMake(btnWidth*0.6f, btnHeight/2.f)], [NSValue valueWithCGPoint:CGPointMake(btnWidth, btnHeight/2.f)]];
        keyAnima_group2.keyTimes = timeArray;
        //组合两个动画
        CAAnimationGroup * grounpAnimation = [CAAnimationGroup animation];
//        grounpAnimation.animations = @[keyAnima_group1, keyAnima_group2];
        grounpAnimation.animations = @[keyAnima_group2];
        grounpAnimation.duration = 2;
        //        grounpAnimation.fillMode=kCAFillModeForwards;
        grounpAnimation.removedOnCompletion = NO;
        //        grounpAnimation.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        grounpAnimation.repeatCount = MAXFLOAT;
        //再上一个动画执行完 在执行
        //        grounpAnimation.beginTime = CACurrentMediaTime();
        [_flashLayer addAnimation:grounpAnimation forKey:@"grounpAnimation"];
    }
    return _flashLayer;
}

- (UIImageView *)arrowImageView {
    if(!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
         UIImage *image = [UIImage imageWithContentsOfFile:[OSA_RESOUCE_BUNDLE pathForResource:@"image_flash_ad_arrow@3x" ofType:@"png"]];
        _arrowImageView.image = image;
    }
    return _arrowImageView;
}

@end
