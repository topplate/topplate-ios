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

-(void)getPlatesForEnvironment:(NSString *)environment
                     withLimit:(NSNumber *)limit
                      withSkip:(NSNumber *)skip
               completionBlock:(PlateCompletionBlock)completion {

    [[NetworkManager sharedManager] getPlates:@{@"environment" : environment ?: @"",
                                                @"lim" : limit ?: 0,
                                                @"skip" : skip ?: 0}
                                andCompletion:^(id response, NSError *error) {
        
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
    
    [[NetworkManager sharedManager] getPlateWithId:plateId andCompletion:^(id response, NSError *error) {
        if (error) {
            completion(nil, error.localizedDescription);
        } else {
            NSError *error;
            PlateModel *model = [MTLJSONAdapter modelOfClass:[PlateModel class] fromJSONDictionary:response error:&error];
            completion(model, nil);
        }
    }];
}

@end
