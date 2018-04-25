//
//  Helper.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/17/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(void)showEnvironmentsSelection {
    
    UIStoryboard *platesS = [UIStoryboard storyboardWithName:@"Plates" bundle:nil];
    ChooseEnvironmentViewController *chooseEnv = [platesS instantiateViewControllerWithIdentifier:@"ChooseEnvironmentViewController"];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    window.rootViewController = chooseEnv;
    [window makeKeyAndVisible];
}

+(void)showPlatesScreen {
    
    UIStoryboard *platesS = [UIStoryboard storyboardWithName:@"CustomTabBar" bundle:nil];
    UINavigationController *platesNav = (UINavigationController *)[platesS instantiateViewControllerWithIdentifier:@"customTabBarNavigationController"];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    window.rootViewController = platesNav;
    [window makeKeyAndVisible];
}

+(void)showWelcomeScreen {
    
    UIStoryboard *loginS = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UINavigationController *platesNav = (UINavigationController *)[loginS instantiateViewControllerWithIdentifier:@"loginNavigationController"];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    window.rootViewController = platesNav;
    [window makeKeyAndVisible];
}





@end
