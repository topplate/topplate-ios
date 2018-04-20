//
//  UserDefaultsManager.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/17/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const Default_SelectedEnvironment;

@interface UserDefaultsManager : NSUserDefaults

+ (void)saveCustomObject:(id)object forKey:(NSString *)key;
+ (id)loadCustomObjectForKey:(NSString *)key;

@end
