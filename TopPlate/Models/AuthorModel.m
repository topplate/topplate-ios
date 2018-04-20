//
//  AuthorModel.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/19/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "AuthorModel.h"

@implementation AuthorModel

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{@"authorId" : @"id",
             @"authorImageUrl" : @"image",
             @"authorName" : @"name"
             };
}

+ (NSValueTransformer *)authorImageUrlJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id str, BOOL *success, NSError *__autoreleasing *error) {
        
        if ([str containsString:@"http"] || [str containsString:@"https"]) {
            return [NSURL URLWithString:str];
        } else {
            return [str withBaseUrl];
        }
        
#warning ToDo Check
        
        return nil;
    }];
}

@end
