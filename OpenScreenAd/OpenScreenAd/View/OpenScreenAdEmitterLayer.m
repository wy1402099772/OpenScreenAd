//
//  OpenScreenAdEmitterLayer.m
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/14.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "OpenScreenAdEmitterLayer.h"

@implementation OpenScreenAdEmitterLayer

- (instancetype)initWithLayerFrame:(CGRect)frame andLayerCenterPoint:(CGPoint)center andLayerSize:(CGSize)size andImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.emitterPosition = center;
        self.emitterSize = size;
        self.emitterMode = kCAEmitterLayerSurface;
        self.emitterShape = kCAEmitterLayerRectangle;
        self.renderMode = kCAEmitterLayerOldestFirst;
        self.shadowOpacity = 0.0;
        self.shadowRadius = 0.0;
        self.shadowOffset = CGSizeMake(-4.9,10);
        self.shadowColor = [[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0] CGColor];
        
        CAEmitterCell *_myCell = [CAEmitterCell emitterCell];
        _myCell.name = @"_myCell";
        _myCell.birthRate = 20;
        _myCell.lifetime = 1.1;
        _myCell.lifetimeRange = 0.5;
        _myCell.color = [[UIColor colorWithRed:1.00 green:0.51 blue:0.62 alpha:0.00] CGColor];
        _myCell.redSpeed = 1.000;
        _myCell.greenSpeed = 0.289;
        _myCell.blueSpeed = -0.144;
        _myCell.alphaSpeed = 0.701;
        _myCell.redRange = 1.000;
        _myCell.greenRange = 0.510;
        _myCell.blueRange = 0.325;
        _myCell.alphaRange = 0.000;
        _myCell.contents = (id)[image CGImage];
        _myCell.emissionRange = 0.000*M_PI;
        _myCell.emissionLatitude = 0.000*M_PI;
        _myCell.emissionLongitude = 0.000*M_PI;
        _myCell.velocity = 0;
        _myCell.velocityRange = 33;
        _myCell.xAcceleration = -0;
        _myCell.yAcceleration = 29;
        _myCell.spin = 0.00*M_PI;
        _myCell.spinRange = 0.00*M_PI;
        _myCell.scale = 0.54/ [[UIScreen mainScreen] scale];
        _myCell.scaleSpeed = 0.21;
        _myCell.scaleRange = 0.13;
        self.emitterCells = [NSArray arrayWithObject:_myCell];
    }
    return self;
}

- (void)addToSubView:(UIView *)subview{
    if (self.superlayer == nil) {
        [subview.layer addSublayer:self];
    }
}

- (void)removeLayer{
    [self removeFromSuperlayer];
}

@end
