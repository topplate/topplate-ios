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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.plateIngredients = [NSMutableArray new];
        self.plateUser = [[User alloc] init];
        self.plateReceipt = @"";
        self.plateName = @"";
    }
    return self;
}

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
             @"relatedPlates" : @"relatedPlates",
             @"plateEnvironment" : @"environment",
             @"plateCanLike" : @"canLike",
             @"plateIsLiked" : @"liked"
             };
}

+ (NSValueTransformer *)plateIngredientsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id str, BOOL *success, NSError *__autoreleasing *error) {
        
        if ([str isKindOfClass:[NSNumber class]]) {
            return @[];
        }
        
        if ([str isKindOfClass:[NSArray class]]) {
            return str;
        }
        
        return nil;
    }];
}

+ (NSValueTransformer*)relatedPlatesJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PlateModel class]];
}

+ (NSValueTransformer*)plateAuthorPlatesJSONTransformer{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[AuthorModel class]];
}

-(NSMutableDictionary *)uploadPlateDictionaryRepresentation {
    
    NSMutableDictionary *uploadDict = [NSMutableDictionary new];
    
    [uploadDict setObject:self.plateName forKey:@"name"];
    [uploadDict setObject:self.plateEnvironment forKey:@"environment"];
    
    if (isRestaurantEnv) {
        [uploadDict setObject:self.plateAuthorLocation forKey:@"address"];
        [uploadDict setObject:self.plateRestaurantName forKey:@"restaurantName"];
    } else {
        [uploadDict setObject:self.plateReceipt forKey:@"recipe"];
        [uploadDict setObject:self.plateIngredients forKey:@"ingredients"];
    }

//    [uploadDict setObject:@"stiffmeister.ua@gmail.com" forKey:@"email"];
    
    [uploadDict setObject:@"image/png" forKey:@"contentType"];
    
    return uploadDict;
}

-(NSMutableDictionary *)editPlateDictionaryRepresentation {
    
    NSMutableDictionary *uploadDict = [NSMutableDictionary new];
    
    [uploadDict setObject:self.plateId forKey:@"id"];
    
    NSDictionary *fieldsDict = [NSDictionary new];
    [fieldsDict setValue:self.plateReceipt forKey:@"recipe"];
    [fieldsDict setValue:self.plateIngredients forKey:@"ingredients"];

    return uploadDict;
}

@end
