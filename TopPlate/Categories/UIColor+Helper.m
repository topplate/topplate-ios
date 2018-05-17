//
//  UIColor+Helper.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/10/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(CGFloat)alphaValue
{
    unsigned int hexint = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alphaValue];
    
    return color;
}

+(UIColor *)googleButtonBackgroundColor {
    
    return [self colorWithHexString:@"#de4c2f" andAlpha:1.f];
}

+(UIColor *)facebookButtonBackgroundColor {
    
    return [self colorWithHexString:@"#264285" andAlpha:1.f];
}

+(UIColor *)emailButtonBackgroundColor {
    
    return [self colorWithHexString:@"#384346" andAlpha:1.f];
}

+(UIColor *)defaultDarkBackgroundColor {
    
    return [self colorWithHexString:@"#081413" andAlpha:1.f];
}

+(UIColor *)settingsLightGreenColor {
    
    return [self colorWithHexString:@"#4c6665" andAlpha:1.f];
}

+(UIColor *)settingsDarkGreenColor {
    
    return [self colorWithHexString:@"#385553" andAlpha:1.f];
}

@end
