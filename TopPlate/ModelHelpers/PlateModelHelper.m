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

-(void)getPlatesForEnvironments:(NSString *)environment
                completionBlock:(PlateCompletionBlock)completion {
    
    [[NetworkManager sharedManager] getPlates:@{@"environment" : environment ?: @""} andCompletion:^(id response, NSError *error) {
        
        if (error) {
            completion(nil, error.localizedDescription);
        } else {
            if ([response isKindOfClass:[NSArray class]] && ![response isKindOfClass:[NSNull class]]) {
                
                NSError *error;
                NSMutableArray *plates = [[MTLJSONAdapter modelsOfClass:[PlateModel class] fromJSONArray:response error:&error] mutableCopy];
                
                self.plates = plates;
                
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
