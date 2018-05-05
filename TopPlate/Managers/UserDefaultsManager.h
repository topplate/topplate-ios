//
//  UserDefaultsManager.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/17/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const Default_SelectedEnvironment;
extern NSString * const Default_LoginType;
extern NSString * const Default_CurrentUser;
extern NSString * const Default_CurrentAccessToken;
extern NSString * const Default_SocialAccessTokenExpDate;
extern NSString * const Default_SocialAccessToken;

@interface UserDefaultsManager : NSUserDefaults

+ (void)saveCustomObject:(id)object forKey:(NSString *)key;
+ (id)loadCustomObjectForKey:(NSString *)key;

@end
