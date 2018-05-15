//
//  UIColor+Helper.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/10/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)

+ (UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(CGFloat)alphaValue;

+(UIColor *)googleButtonBackgroundColor;
+(UIColor *)facebookButtonBackgroundColor;
+(UIColor *)emailButtonBackgroundColor;

+(UIColor *)defaultDarkBackgroundColor;

@end
