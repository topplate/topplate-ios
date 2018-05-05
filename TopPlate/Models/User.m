//
//  User.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/1/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)init {
    if (self = [super init]) {
        self.userId = @"";
        self.likedPlates = [NSMutableArray new];
        self.token = @"";
        self.userInfo = [AuthorModel new];
    }
    
    return self;
}

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{@"userId" : @"_id",
             @"likedPlates" : @"likedPlates",
             @"token" : @"token",
             @"userInfo" : @"user"
             };
}

+ (NSValueTransformer *)likedPlatesJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id str, BOOL *success, NSError *__autoreleasing *error) {
        
        if ([str isKindOfClass:[NSDictionary class]]) {//should be empty array, but having empty dictionary..
            return @[];
        }
        
        if ([str isKindOfClass:[NSArray class]]) {
            NSMutableArray *likedPlates = [str mutableCopy];
            return likedPlates;
        }
        
        return nil;
    }];
}

+ (NSValueTransformer*)userInfoJSONTransformer{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[AuthorModel class]];
}

@end
