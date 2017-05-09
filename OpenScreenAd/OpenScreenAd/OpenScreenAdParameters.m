//
//  OpenScreenAdParameters.m
//  OpenScreenAd
//
//  Created by wyan assert on 2017/4/13.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "OpenScreenAdParameters.h"

@implementation OpenScreenAdParameters

+ (UIFont*)getFontRegular:(CGFloat)fontSize
{
    UIFont* fontRegular;
    if(OSA_IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
    {
        fontRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:fontSize];
    }
    else
    {
        fontRegular = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
    }
    
    if(fontRegular == nil)
    {
        fontRegular = [UIFont systemFontOfSize:fontSize];
    }
    return fontRegular;
}

+ (UIFont*)getFontHeavy:(CGFloat)fontSize
{
    UIFont* fontHeavy;
    if(OSA_IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
    {
        fontHeavy = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:fontSize];
    }
    else
    {
        fontHeavy = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    }
    
    if(fontHeavy == nil)
    {
        fontHeavy = [UIFont boldSystemFontOfSize:fontSize];
    }
    return fontHeavy;
}

+ (UIFont *)getFontLight:(CGFloat)fontSize
{
    UIFont* fontLight;
    fontLight = [UIFont fontWithName:@"AvenirNext-UltraLight" size:fontSize];
    
    if(fontLight == nil)
    {
        fontLight = [UIFont systemFontOfSize:fontSize];
    }
    return fontLight;
}

+ (NSString *)getLaunchImageName {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";    
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return launchImage;
}

+ (CGRect)getAdFrame:(OpenScreenAdType)adType {
    if ([adType isEqualToString:OpenScreenAdTypePurple]) {
        return [UIScreen mainScreen].bounds;
    } else if ([adType isEqualToString:OpenScreenAdTypeBlue]) {
        return CGRectMake(0, 0, OSA_SCREEN_WIDTH, OSA_SCREENAPPLYHEIGHT(541));
    } else if ([adType isEqualToString:OpenScreenAdTypeOrange]) {
        return CGRectMake(0, 0, OSA_SCREEN_WIDTH, OSA_SCREENAPPLYHEIGHT(597));
    } else if ([adType isEqualToString:OpenScreenAdTypeInkBlue]) {
        return CGRectMake(0, 0, OSA_SCREEN_WIDTH, OSA_SCREENAPPLYHEIGHT(559));
    } else {
        return [UIScreen mainScreen].bounds;
    }
}

+ (CGRect)getSkipButtonFrame:(OpenScreenAdType)adType {
    if ([adType isEqualToString:OpenScreenAdTypePurple]) {
        return CGRectMake(OSA_SCREEN_WIDTH - kOSASkipButtonSize - 25, 25, kOSASkipButtonSize, kOSASkipButtonSize);
    } else if ([adType isEqualToString:OpenScreenAdTypeBlue]) {
        return CGRectMake(OSA_SCREEN_WIDTH - 64 - 13, OSA_SCREEN_HEIGHT - 36 - 29, 64, 36);
    } else if ([adType isEqualToString:OpenScreenAdTypeOrange]) {
        return CGRectMake(OSA_SCREEN_WIDTH - 54 - 16, 30, 54, 24);
    } else if ([adType isEqualToString:OpenScreenAdTypeInkBlue]) {
        return CGRectMake(OSA_SCREEN_WIDTH - 54 - 16, 30, 54, 24);
    } else {
        return CGRectMake(OSA_SCREEN_WIDTH - kOSASkipButtonSize - 25, 25, kOSASkipButtonSize, kOSASkipButtonSize);
    }
}

@end
