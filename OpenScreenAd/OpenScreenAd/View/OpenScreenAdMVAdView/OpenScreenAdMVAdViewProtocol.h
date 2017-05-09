//
//  OpenScreenAdMVAdViewProtocol.h
//  Pods
//
//  Created by wyan assert on 2017/4/20.
//
//

#import <Foundation/Foundation.h>

@class MVCampaign;

@protocol OpenScreenAdMVAdViewProtocol <NSObject>

- (instancetype)initWithMVCampaign:(MVCampaign *)campaign;
- (void)setFrame:(CGRect)frame;
- (void)setGradientColors:(NSArray<UIColor *> *)gradientColors;

@end
