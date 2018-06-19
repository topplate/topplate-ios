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
               completionBlock:(PlatesCompletionBlock)completion {

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
                                           
                                           if ([self.delegate respondsToSelector:@selector(platesUpdated)]) {
                                               [self.delegate platesUpdated];
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

-(void)editPlateWithModel:(PlateModel *)model
                 completion:(void(^)(BOOL result, NSString *errorString))completion {
    
    [[NetworkManager sharedManager] editPlateWithModel:model withCompletion:^(id response, NSError *error) {
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

-(void)getWinnersWithCompletion:(PlatesCompletionBlock)completion {
    
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

-(void)likePlate:(NSString *)plateId
      completion:(PlateCompletionBlock)completion {
    
    [[NetworkManager sharedManager] likePlateWithId:plateId withCompletion:^(id response, NSError *error) {
        if (error) {
            completion(nil, error.localizedDescription);
        } else {
            NSError *parseError;
            PlateModel *updatedPlate = [MTLJSONAdapter modelOfClass:[PlateModel class] fromJSONDictionary:response error:&parseError];
            
            NSArray *filteredArray = [self.plates filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"plateId == %@", updatedPlate.plateId]];
            
            if (filteredArray.count > 0) {
                
                NSInteger plateIndex = [self.plates indexOfObject:filteredArray.firstObject];
                [self.plates replaceObjectAtIndex:plateIndex withObject:updatedPlate];
                
                if ([self.delegate respondsToSelector:@selector(plateAtIndexIsUpdated:)]) {
                    [self.delegate plateAtIndexIsUpdated:plateIndex];
                }
            }
            
            completion(updatedPlate, nil);
        }
    }];
}

-(void)unlikePlate:(NSString *)plateId
      completion:(PlateCompletionBlock)completion {
    
    [[NetworkManager sharedManager] unlikePlateWithId:plateId withCompletion:^(id response, NSError *error) {
        if (error) {
            completion(nil, error.localizedDescription);
        } else {
            NSError *parseError;
            PlateModel *updatedPlate = [MTLJSONAdapter modelOfClass:[PlateModel class] fromJSONDictionary:response error:&parseError];
            
            NSArray *filteredArray = [self.plates filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"plateId == %@", updatedPlate.plateId]];
            
            if (filteredArray.count > 0) {
                NSInteger plateIndex = [self.plates indexOfObject:filteredArray.firstObject];
                [self.plates replaceObjectAtIndex:plateIndex withObject:updatedPlate];
                
                if ([self.delegate respondsToSelector:@selector(plateAtIndexIsUpdated:)]) {
                    [self.delegate plateAtIndexIsUpdated:plateIndex];
                }
            }
            
            completion(updatedPlate, nil);
        }
    }];
}

-(BOOL)isEditable:(PlateModel *)plate {
    
    if ([plate.plateAuthor.authorId isEqualToString:getCurrentUser.userId] && [plate.plateEnvironment isEqualToString:@"homemade"]) {
        return YES;
    }
    
    return NO;
}

@end
