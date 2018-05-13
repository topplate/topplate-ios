//
//  UIViewController+BackgroundImage.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "UIViewController+BackgroundImage.h"

@implementation UIViewController (BackgroundImage)

-(void)setLoginBackgroundImage {
    
    [self setBackgroundImageWithName:@"loginImage" withSafeArea:YES];
}

-(void)setBackgroundImage {
    
    [self setBackgroundImageWithName:@"loginImage" withSafeArea:NO];
}

-(void)setBackgroundImageWithName:(NSString *)imageName withSafeArea:(BOOL)safeArea {
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    CGRect viewFrame = self.view.frame;
    
    if (IS_IPHONE_X && !safeArea) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
//        CGFloat topPadding = window.safeAreaInsets.top;
        CGFloat bottomPadding = window.safeAreaInsets.bottom;

        viewFrame = CGRectMake(self.view.x, self.view.y, self.view.width, self.view.height - bottomPadding);
    }
    
    [backgroundImageView setFrame:viewFrame];
    [self.view insertSubview:backgroundImageView atIndex:0];
}

-(void)setNavigationTitleViewImage {
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopPlateLogo"]];
}

@end
