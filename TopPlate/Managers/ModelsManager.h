//
//  ModelsManager.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

#define modelsManager [ModelsManager sharedManager]

typedef NS_ENUM(NSUInteger, HelperType) {
    HelperTypeLogin,
    HelperTypeSocialLogin,
    HelperTypePlates,
    HelperTypeAuthor
};

@interface ModelsManager : NSObject

+ (instancetype)sharedManager;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (id)getModel:(HelperType)type;

- (void)cleanData;

@end
