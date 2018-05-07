//
//  Helper.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/17/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#define getCurrentUser [Helper currentUser]
#define getCurrentEnvironment [Helper currentEnviroment]
#define isRestaurantEnv [getCurrentEnvironment isEqualToString:@"restaurant"]
#define isHomeMadeEnv [getCurrentEnvironment isEqualToString:@"homemade"]

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface Helper : NSObject

//navigation helpers

+(void)showEnvironmentsSelection;

+(void)showPlatesScreen;

+(void)showWelcomeScreen;

+(UIViewController *)rootViewController;


//defines

+(User *)currentUser;

+(NSString *)currentEnviroment;

//NSDate

+ (BOOL)compareDate:(NSDate *)date1
    withAnotherDate:(NSDate *)date2;

+(NSDate *)currentDateInUTC;

//alert messages

+(void)showSuccessMessage:(NSString *)message forViewController:(UIViewController *)viewController;

+(void)showWarningMessage:(NSString *)message forViewController:(UIViewController *)viewController;

+(void)showErrorMessage:(NSString *)message forViewController:(UIViewController *)viewController;


@end
