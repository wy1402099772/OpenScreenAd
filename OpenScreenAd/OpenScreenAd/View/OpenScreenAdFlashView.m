//
//  OpenScreenAdFlashView.m
//  GetX
//
//  Created by wyan assert on 2017/4/17.
//  Copyright © 2017年 JellyKit Inc. All rights reserved.
//

#import "OpenScreenAdFlashView.h"

@interface OpenScreenAdFlashView ()

@property (nonatomic, strong) CAGradientLayer *flashLayer;

@end

@implementation OpenScreenAdFlashView

- (void)startFlash {
    if ([self.flashLayer superlayer] == nil) {
        [self.layer addSublayer:self.flashLayer];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    if ([self pointInside:point withEvent:event]) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return nil;
    }
    return nil;
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

@end
