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
    
    [self setBackgroundImageWithName:@"loginImage"];
}

-(void)setBackgroundImageWithName:(NSString *)imageName {
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [backgroundImageView setFrame:self.view.frame];
    [self.view insertSubview:backgroundImageView atIndex:0];
}

-(void)setNavigationTitleViewImage {
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopPlateLogo"]];
}

@end
