//
//  LoginModelHelper.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "LoginModelHelper.h"
#import "LoginModel.h"


@implementation LoginModelHelper

-(void)singIn:(LoginModel *)login withCompletion:(LoginCompletionBlock)completion {
    
    [[NetworkManager sharedManager] signInWithEmail:login withCompletion:^(id response, NSError *error) {
        if (error) {
            completion(nil, error.localizedDescription);
        } else {
            
            NSError *parsingError = nil;
            
            User *currentUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:response error:&parsingError];
            
            [self finishSetupWithCurrentUser:currentUser];
            
            completion(YES, nil);
        }
    }];
}

-(void)singUp:(LoginModel *)login withCompletion:(LoginCompletionBlock)completion {
    
}

-(void)finishSetupWithCurrentUser:(User *)currentUser {
    
    NSLog(@"Current user - %@", currentUser);
    
    [UserDefaultsManager saveCustomObject:currentUser forKey:Default_CurrentUser];
    [[UserDefaultsManager standardUserDefaults] setObject:@(LoginTypeEmail) forKey:Default_LoginType];
    [[UserDefaultsManager standardUserDefaults] setObject:currentUser.token forKey:Default_SocialAccessToken];
}

@end
