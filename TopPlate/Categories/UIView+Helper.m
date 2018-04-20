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

@end
