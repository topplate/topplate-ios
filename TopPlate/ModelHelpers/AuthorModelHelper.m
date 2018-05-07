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
    
#warning To Uncomment
    
    NSDictionary *params = @{@"id" : @"5ae9713bf8979e0004fbe9cd",
                             @"environment" : environment,
                             @"lim" : limit,
                             @"skip" : skip
                             };
    
    [MBProgressHUD showHUDAddedTo:[Helper rootViewController].view animated:YES];
    [[NetworkManager sharedManager] getPlatesForUser:params withCompletion:^(id response, NSError *error) {
        [MBProgressHUD hideHUDForView:[Helper rootViewController].view animated:YES];
        
        if (!error && response) {
            NSError *parsingError;
            
            NSMutableArray *plates = [[MTLJSONAdapter modelsOfClass:[PlateModel class] fromJSONArray:response error:&parsingError] mutableCopy];
            
            if (limit) {
                if (self.currentUserPlates) {
                    [self.currentUserPlates addObjectsFromArray:plates];
                } else {
                    self.currentUserPlates = [[NSArray arrayWithArray:plates] mutableCopy];
                }
            } else {
                self.currentUserPlates = plates;
            }
            
            completion(plates, nil);
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

-(void)getAuthorProfileInfoWithId:(NSString *)userId
                  completionBlock:(void(^)(User *currentUserProfile, NSString *errorString))completion {
    
    [MBProgressHUD showHUDAddedTo:[Helper rootViewController].view animated:YES];
    [[NetworkManager sharedManager] getUserProfileWithUserId:userId withCompletion:^(id response, NSError *error) {
        [MBProgressHUD hideHUDForView:[Helper rootViewController].view animated:YES];
        
        if (!error && response) {
            NSError *parsingError;
            self.currentUserInfo = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:response error:&parsingError];
            completion(self.currentUserInfo, nil);
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

@end
