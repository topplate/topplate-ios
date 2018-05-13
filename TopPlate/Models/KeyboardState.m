//
//  KeyboardState.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/13/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "KeyboardState.h"

@implementation KeyboardState

- (instancetype)initWithUserInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        self.keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.isVisible = YES;
        self.animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        self.keyboardDifference = 0.f;
    }
    return self;
}

@end
