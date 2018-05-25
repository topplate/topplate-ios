//
//  PlateModelHelper.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlateModelHelper.h"
#import "NetworkManager.h"

@implementation PlateModelHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.currentPlate = [PlateModel new];
    }
    return self;
}

-(void)getPlatesForEnvironment:(NSString *)environment
                     withLimit:(NSNumber *)limit
                withLastPlateId:(NSString *)lastPlateId
               completionBlock:(PlateCompletionBlock)completion {

    NSDictionary *paramsDict = @{@"environment" : environment ?: @"",
                                 @"lim" : limit ?: 0,
                                 @"lastId" : lastPlateId ?: @""};
    
    [[NetworkManager sharedManager] getPlates:paramsDict
                               withCompletion:^(id response, NSError *error) {
                                   if (error) {
                                       completion(nil, error.localizedDescription);
                                   } else {
                                       if ([response isKindOfClass:[NSArray class]] && ![response isKindOfClass:[NSNull class]]) {
                                           
                                           NSError *error;
                                           NSMutableArray *plates = [[MTLJSONAdapter modelsOfClass:[PlateModel class] fromJSONArray:response error:&error] mutableCopy];
                                           
                                           if (limit) {
                                               
                                               if (self.plates) {
                                                   [self.plates addObjectsFromArray:plates];
                                               } else {
                                                   self.plates = [[NSArray arrayWithArray:plates] mutableCopy];
                                               }
                                           } else {
                                               self.plates = plates;   
                                           }
                                           
                                           if ([self.delegate respondsToSelector:@selector(modelIsUpdated)]) {
                                               [self.delegate modelIsUpdated];
                                           }
                                           
                                           completion(plates, nil);
                                       }
                                   }
                               }];
}

-(void)getPlateWithId:(NSString *)plateId
      completionBlock:(void(^)(PlateModel *plate, NSString *errorString))completion {
    
    [[NetworkManager sharedManager] getPlateWithId:plateId
                                    withCompletion:^(id response, NSError *error) {
                                        if (error) {
                                            completion(nil, error.localizedDescription);
                                        } else {
                                            NSError *error;
                                            PlateModel *model = [MTLJSONAdapter modelOfClass:[PlateModel class] fromJSONDictionary:response error:&error];
                                            completion(model, nil);
                                        }
                                    }];
}

-(void)uploadPlateWithModel:(PlateModel *)model
                 completion:(void(^)(BOOL result, NSString *errorString))completion {
    
    [[NetworkManager sharedManager] uploadPlateWithModel:model withCompletion:^(id response, NSError *error) {
        if (error) {
            completion(NO, error.localizedDescription);
        } else {
            completion(YES, nil);
        }
    }];
}

-(void)searchPlatesWithSearchString:(NSString *)searchString
                 completion:(void(^)(NSArray *searchResults, NSString *errorString))completion {
    
    [[NetworkManager sharedManager] searchPlates:searchString withCompletion:^(id response, NSError *error) {
        if (!error) {
            NSError *parseError;
            NSArray *searchPlates = [MTLJSONAdapter modelsOfClass:[PlateModel class] fromJSONArray:response error:&parseError];
            completion(searchPlates, nil);
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

-(void)getWinnersWithCompletion:(PlateCompletionBlock)completion {
    
    [[NetworkManager sharedManager] getWinnersWithCompletion:^(id response, NSError *error) {
        if (!error) {
            NSError *parseError;
            NSArray *winnerPlates = [MTLJSONAdapter modelsOfClass:[PlateModel class] fromJSONArray:response error:&parseError];
            completion(winnerPlates, nil);
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

-(BOOL)isMyPlate:(PlateModel *)plate {
    
    if ([plate.plateAuthor.authorId isEqualToString:getCurrentUser.userId]) {
        return YES;
    }
    
    return NO;
}

@end
