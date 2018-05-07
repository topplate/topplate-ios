//
//  Helper.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/17/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "Helper.h"

@interface Helper ()

@end

@implementation Helper

+(void)showEnvironmentsSelection {
    
    UIStoryboard *platesS = [UIStoryboard storyboardWithName:@"Plates" bundle:nil];
    ChooseEnvironmentViewController *chooseEnv = [platesS instantiateViewControllerWithIdentifier:@"ChooseEnvironmentViewController"];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = chooseEnv;
    [window makeKeyAndVisible];
}

+(void)showPlatesScreen {
    
    UIStoryboard *platesS = [UIStoryboard storyboardWithName:@"CustomTabBar" bundle:nil];
    UINavigationController *platesNav = (UINavigationController *)[platesS instantiateViewControllerWithIdentifier:@"customTabBarNavigationController"];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = platesNav;
    [window makeKeyAndVisible];
}

+(void)showWelcomeScreen {
    
    UIStoryboard *loginS = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UINavigationController *platesNav = (UINavigationController *)[loginS instantiateViewControllerWithIdentifier:@"loginNavigationController"];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window.rootViewController presentViewController:platesNav animated:YES completion:nil];
//    window.rootViewController = platesNav;
    [window makeKeyAndVisible];
}

+(User *)currentUser {
    
    User *currentUser = [UserDefaultsManager loadCustomObjectForKey:Default_CurrentUser];
    return currentUser;
}

+(NSString *)currentEnviroment {
    
    NSString *enviroment = [[UserDefaultsManager standardUserDefaults] objectForKey:Default_SelectedEnvironment];
    return enviroment;
}

+ (BOOL)compareDate:(NSDate *)date1
    withAnotherDate:(NSDate *)date2 {
    
    BOOL returnBool = NO;
    
    if ([date1 compare:date2] == NSOrderedSame) {
        returnBool = NO;
        //same dates;
    }
    
    if ([date1 compare:date2] == NSOrderedDescending) {
        returnBool = NO;
        //date1 is later then date2
    }
    
    if ([date1 compare:date2] == NSOrderedAscending) {
        returnBool = YES;
        //date1 is earlier then date2
    }
    
    return returnBool;
}

+(NSDate *)currentDateInUTC {
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDate *utcDate = [dateFormatter dateFromString:dateString];
    
    return utcDate;
}

+(UIViewController *)rootViewController {
    
    UIViewController *delegateWindow = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    return delegateWindow;
}

+(void)showSuccessMessage:(NSString *)message forViewController:(UIViewController *)viewController {
    
    [self showMessage:message title:@"Success" forViewController:viewController];
}

+(void)showWarningMessage:(NSString *)message forViewController:(UIViewController *)viewController {

    [self showMessage:message title:@"Warning" forViewController:viewController];
}

+(void)showErrorMessage:(NSString *)message forViewController:(UIViewController *)viewController {
    
    [self showMessage:message title:@"Error" forViewController:viewController];
}
                                          
+(void)showMessage:(NSString *)message
             title:(NSString *)title
 forViewController:(UIViewController *)viewController {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:alertAction];
    
    if (viewController) {
        [viewController presentViewController:alertController animated:YES completion:nil];
    } else {
        [[self rootViewController] presentViewController:alertController animated:YES completion:nil];
    }
}

@end
