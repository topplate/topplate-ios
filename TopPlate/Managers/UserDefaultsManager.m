//
//  UserDefaultsManager.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/17/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "UserDefaultsManager.h"

NSString * const Default_SelectedEnvironment = @"Default_SelectedEnvironment";

@implementation UserDefaultsManager

+ (void)saveCustomObject:(id)object forKey:(NSString *)key {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [[self standardUserDefaults] setObject:data forKey:key];
    [[self standardUserDefaults] synchronize];
}

+ (id)loadCustomObjectForKey:(NSString *)key {
    NSData *data = [[self standardUserDefaults] objectForKey:key];
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return object;
}

@end
