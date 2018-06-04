//
//  AuthorModelHelper.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/6/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "AuthorModelHelper.h"

@implementation AuthorModelHelper

-(void)getPlatesForAuthor:(NSString *)userId
              environment:(NSString *)environment
                withLimit:(NSNumber *)limit
                 withSkip:(NSNumber *)skip
          completionBlock:(AuthorCompletionBlock)completion {
        
    NSDictionary *params = @{@"id" : userId,
                             @"environment" : environment,
                             @"lim" : limit,
                             @"skip" : skip
                             };
    
    [[NetworkManager sharedManager] getPlatesForUser:params withCompletion:^(id response, NSError *error) {
        
        if (!error && response) {
            NSError *parsingError;
            
            NSMutableArray *plates = [[MTLJSONAdapter modelsOfClass:[PlateModel class] fromJSONArray:response error:&parsingError] mutableCopy];
            
            if (limit) {
                if (self.userPlates) {
                    [self.userPlates addObjectsFromArray:plates];
                } else {
                    self.userPlates = [[NSArray arrayWithArray:plates] mutableCopy];
                }
            } else {
                self.userPlates = plates;
            }
            
            completion(plates, nil);
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

-(void)getAuthorProfileInfoWithId:(NSString *)userId
                  completionBlock:(void(^)(User *currentUserProfile, NSString *errorString))completion {
    
    [[NetworkManager sharedManager] getUserProfileWithUserId:userId withCompletion:^(id response, NSError *error) {
        
        if (!error && response) {
            NSError *parsingError;
            self.userInfo = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:response error:&parsingError];
            completion(self.userInfo, nil);
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

@end
