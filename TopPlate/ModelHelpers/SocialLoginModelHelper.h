//
//  SocialLoginModelHelper.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleSignIn/GoogleSignIn.h>

typedef void(^SocialCompletionBlock)(id result, NSString *errorString);

@interface SocialLoginModelHelper : NSObject

-(void)loginWithGoogle:(id<GIDSignInUIDelegate>)viewController
        withCompletion:(SocialCompletionBlock)completion;

-(void)loginWithFacebook:(UIViewController *)viewController
          withCompletion:(SocialCompletionBlock)completion;

-(void)processLogin;

-(void)logout;


@end
