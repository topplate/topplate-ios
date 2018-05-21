//
//  SocialLoginModelHelper.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleSignIn/GoogleSignIn.h>

typedef void(^SocialCompletionBlock)(id result, NSError *error);

@interface SocialLoginModelHelper : NSObject

-(void)loginWithGoogle:(id<GIDSignInUIDelegate>)viewController;

-(void)loginWithFacebook:(UIViewController *)viewController;

-(void)processLogin;

-(void)logout;


@end
