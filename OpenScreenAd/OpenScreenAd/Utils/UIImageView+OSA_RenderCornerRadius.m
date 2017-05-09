//
//  UIImageView+OSA_RenderCornerRadius.m
//  Pods
//
//  Created by wyan assert on 2017/4/21.
//
//

#import "UIImageView+OSA_RenderCornerRadius.h"

@implementation UIImageView (OSA_RenderCornerRadius)

- (void)OSA_renderImageWithRadius:(CGFloat)cornerRadius {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    CGContextAddPath(currnetContext, [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius].CGPath);
    CGContextClip(currnetContext);
    [self.layer renderInContext:currnetContext];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = image;
}

@end
