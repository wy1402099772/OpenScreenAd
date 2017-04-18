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

@end
