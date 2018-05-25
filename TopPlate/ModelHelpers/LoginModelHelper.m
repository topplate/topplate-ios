//
//  LoginModelHelper.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "LoginModelHelper.h"
#import "LoginModel.h"

typedef void(^LoginCompletionBlock)(id result, NSError *error);

@implementation LoginModelHelper

-(void)singIn:(LoginModel *)login withCompletion:(LoginCompletionBlock)completion {
    
    [[NetworkManager sharedManager] signInWithEmail:login withCompletion:^(id response, NSError *error) {
        
    }];
}

-(void)singUp:(LoginModel *)login withCompletion:(LoginCompletionBlock)completion {
    
}

@end
