//
//  ModelsManager.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "ModelsManager.h"
#import "PlateModelHelper.h"
#import "SocialLoginModelHelper.h"

@interface ModelsManager()

@property (strong, nonatomic) NSMutableDictionary *storage;

@end

@implementation ModelsManager

+ (instancetype)sharedManager {
    static ModelsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[ModelsManager alloc] initOnce];
    });
    return sharedMyManager;
}

- (instancetype)initOnce
{
    self = [super init];
    
    if (self) {
        self.storage = [NSMutableDictionary new];
    }
    
    return self;
}

- (id)getModel:(HelperType)type {
    
    id model = [self.storage objectForKey:@(type)];
    
    if (model)
        return model;
    
    switch (type) {
        case HelperTypeLogin:
//            model = [LoginModel new];
            break;
            
        case HelperTypeSocialLogin:
            model = [SocialLoginModelHelper new];
            break;
            
        case HelperTypePlates:
            model = [PlateModelHelper new];
            break;
            
        case HelperTypeAuthor: {
            model = [AuthorModelHelper new];
            break;
        }
        
        case HelperTypeCharity: {
            model = [CharityModelHelper new];
            break;
        }
                        
        default:
            break;
    }
    
    self.storage[@(type)] = model;
    
    return [self.storage objectForKey:@(type)];
}

- (void)cleanData {
    
    self.storage = [NSMutableDictionary new];
}

@end
