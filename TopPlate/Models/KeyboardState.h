//
//  KeyboardState.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/13/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardState : NSObject

@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic) CGRect keyboardRect;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat keyboardDifference;

- (instancetype)initWithUserInfo:(NSDictionary *)info;

@end
