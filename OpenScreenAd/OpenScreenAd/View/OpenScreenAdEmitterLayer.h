//
//  OpenScreenAdEmitterLayer.h
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/14.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface OpenScreenAdEmitterLayer : CAEmitterLayer

- (instancetype)initWithLayerFrame:(CGRect)frame andLayerCenterPoint:(CGPoint)center andLayerSize:(CGSize)size andImage:(UIImage *)image;

- (void)addToSubView:(UIView *)subview;

- (void)removeLayer;

@end
