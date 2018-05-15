//
//  CharityModelHelper.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/15/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "CharityModelHelper.h"

@implementation CharityModelHelper

-(void)loadCharitiesWithCompletion:(CharityCompletionBlock)completion {
    
    [[NetworkManager sharedManager] loadCharityChoiseBannersWithCompletion:^(id response, NSError *error) {
        
        if (error) {
            completion(nil, error.localizedDescription);
        } else {
            NSError *parseError;
            NSArray *charities = [MTLJSONAdapter modelsOfClass:[Charity class] fromJSONArray:response error:&parseError];
            completion(charities, nil);
        }
    }];
}

@end
