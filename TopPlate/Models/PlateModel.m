//
//  PlateModel.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlateModel.h"
#import "AuthorModel.h"
#import "NetworkManager.h"

@implementation PlateModel

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{@"plateId" : @"_id",
             @"plateName" : @"name",
             @"plateImages" : @"images",
             @"plateAuthor" : @"author",
             @"plateAuthorLocation" : @"address",
             @"plateLikes" : @"likes",
             @"plateIngredients" : @"ingredients",
             @"plateReceipt" : @"recipe",
             @"plateHasReceipt" : @"hasRecipe",
             @"relatedPlates" : @"relatedPlates"
             };
}

+ (NSValueTransformer *)plateIngredientsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id str, BOOL *success, NSError *__autoreleasing *error) {
        
        if ([str isKindOfClass:[NSNumber class]]) {
            return @[];
        }
        
#warning ToDo
    
        return nil;
    }];
}

+ (NSValueTransformer*)relatedPlatesJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PlateModel class]];
}

+ (NSValueTransformer*)plateAuthorPlatesJSONTransformer{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[AuthorModel class]];
}

@end
