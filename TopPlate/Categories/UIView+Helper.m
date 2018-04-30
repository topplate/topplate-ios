//
//  UIView+Helper.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

-(void)roundCorners {
    
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = true;
}

-(void)roundFrame {
    [self roundCorners];
    
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [UIColor colorWithWhite:1.f alpha:.3f].CGColor;
}

- (CGFloat)height
{
    return self.bounds.size.height;
}

- (CGFloat)width
{
    return self.bounds.size.width;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setX:(CGFloat)positionX
{
    CGRect frame = self.frame;
    frame.origin.x = positionX;
    self.frame = frame;
}

- (void)setY:(CGFloat)positionY
{
    CGRect frame = self.frame;
    frame.origin.y = positionY;
    self.frame = frame;
}

@end
