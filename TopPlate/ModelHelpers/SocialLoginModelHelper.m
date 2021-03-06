//
//  SocialLoginModelHelper.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "SocialLoginModelHelper.h"
#import "SocialLoginModel.h"
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface SocialLoginModelHelper () <GIDSignInDelegate>

@property (nonatomic, copy) SocialCompletionBlock completionForGoogle;

@property (nonatomic, strong) FBSDKLoginManager *facebookLoginManager;

@end


@implementation SocialLoginModelHelper

- (FBSDKLoginManager *)facebookLoginManager {
    
    if (!_facebookLoginManager)
        _facebookLoginManager = [[FBSDKLoginManager alloc] init];
    
    return _facebookLoginManager;
}

#pragma mark - Google sign in -

- (void)configureGooglePlusSignIn {
    
    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    
    signIn.shouldFetchBasicProfile = YES;
    signIn.clientID = googleClientId;
    signIn.delegate = self;
}

-(void)loginWithGoogle:(id<GIDSignInUIDelegate>)viewController
        withCompletion:(SocialCompletionBlock)completion {
    
    [self logout];
    
    [self requestGooglePlusAccessToken:viewController withCompletion:^(id result, NSString *error) {
        
        if (!error && result) {
            GIDGoogleUser *googleUser = result;
            [self loginWithGoogleUser:googleUser withCompletion:completion];
        }
    }];
}

- (void)requestGooglePlusAccessToken:(id<GIDSignInUIDelegate>)viewController
                      withCompletion:(SocialCompletionBlock)completion {
    
    self.completionForGoogle = completion;
    [self configureGooglePlusSignIn];
    [GIDSignIn sharedInstance].uiDelegate = viewController;
    [[GIDSignIn sharedInstance] signIn];
}

-(void)loginWithGoogleUser:(GIDGoogleUser *)googleUser withCompletion:(SocialCompletionBlock)completion {
    
    if (googleUser) {
        
        SocialLoginModel *localUser = [SocialLoginModel parseGoogleUser:googleUser];
        
        [MBProgressHUD showHUDAddedTo:[Helper rootViewController].view animated:YES];
        [[NetworkManager sharedManager] signInWithGoogle:localUser withCompletion:^(id response, NSError *error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
            
            if (!error && response) {
                
                NSError *parsingError = nil;
                
                User *currentUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:response error:&parsingError];
                
                [self finishSetupWithCurrentUser:currentUser
                                       loginType:LoginTypeGooglePlus
                                       authToken:googleUser.authentication.idToken
                                    tokenExpDate:googleUser.authentication.idTokenExpirationDate];
                if (completion) {
                    completion(currentUser, nil);
                }
            } else {
                if (completion) {
                    completion(nil, error.localizedDescription);
                }
            }
        }];
    } else {
        
    }
}

- (void)tryAutoLoginForGooglePlusWithCompletion:(SocialCompletionBlock)completion {
    NSLog(@"tryAutoLoginForGooglePlus");
    
    __weak typeof(self) weakSelf = self;
    
    self.completionForGoogle = ^(id result, NSString *error) {
        if (!error && [result isKindOfClass:[GIDGoogleUser class]]) {
            [weakSelf loginWithGoogleUser:result withCompletion:completion];
        } else {
            completion(nil, error);
        }
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configureGooglePlusSignIn];
        [[GIDSignIn sharedInstance] signInSilently];
    });
}

#pragma mark - Google auth callbacks

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    NSLog(@"Signed in user. Received error %@ and auth object %@",error, user.authentication);
    
    if(!error) {
        self.completionForGoogle(user, nil);
    } else {
        self.completionForGoogle(nil, error.localizedDescription);
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    NSLog(@"Disconnected user");
}


#pragma mark - Facebook sign -

-(void)loginWithFacebook:(UIViewController *)viewController
          withCompletion:(SocialCompletionBlock)completion {
    
    [self logout];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email"]
                 fromViewController:viewController
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                
                                if (error) {
                                    //error
                                } else if (result.isCancelled) {
                                    //result canceled
                                } else {
                                    //we've already got token, now geting user info
                                    
                                    SocialLoginModel *facebookUser = [SocialLoginModel new];
                                    facebookUser.tokenId = result.token.tokenString;
                                    facebookUser.tokenExpDate = result.token.expirationDate;
                                    
                                    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                                    [parameters setValue:@"id,name,email, picture" forKey:@"fields"];
                                    
                                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                                       parameters:parameters]
                                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                         if (!error) {
                                             facebookUser.email = [result valueForKey:@"email"];
                                             facebookUser.fullname = [result valueForKey:@"name"];
                                             facebookUser.imageUrl = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                                             [self loginWithFacebookUser:facebookUser withCompletion:completion];
                                         }
                                     }];
                                }
                            }];
}

-(void)loginWithFacebookUser:(SocialLoginModel *)facebookUser withCompletion:(SocialCompletionBlock)completion {
    
    if (facebookUser) {
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
        [[NetworkManager sharedManager] signInWithFacebook:facebookUser
                                            withCompletion:^(id response, NSError *error) {
                                                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
                                                
                                                if (!error && response) {
                                                    NSError *parsingError = nil;
                                                    User *currentUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:response error:&parsingError];
                                                    [self finishSetupWithCurrentUser:currentUser loginType:LoginTypeFacebook authToken:facebookUser.tokenId tokenExpDate:facebookUser.tokenExpDate];
                                                    if (completion) {
                                                        completion(currentUser, nil);
                                                    }
                                                } else {
                                                    if (completion) {
                                                        completion(nil, error.localizedDescription);
                                                    }
                                                }
                                            }];
    } else {
        
    }
}

-(void)tryAutoLoginWithFacebookWithCompletion:(SocialCompletionBlock)completion {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email, picture" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             SocialLoginModel *facebookUser = [SocialLoginModel parseFacebookUser:result];
             facebookUser.tokenId = [FBSDKAccessToken currentAccessToken].tokenString;
             facebookUser.tokenExpDate = [FBSDKAccessToken currentAccessToken].expirationDate;
             
             [self loginWithFacebookUser:facebookUser withCompletion:completion];
         } else {
             completion(nil, error.localizedDescription);
         }
     }];
}

-(void)getUserProfileDataWithCompletion:(SocialCompletionBlock)completion {
    
    [[NetworkManager sharedManager] getUserProfileWithUserId:getCurrentUser.userId withCompletion:^(id response, NSError *error) {
        if (error) {
            completion(nil, error.localizedDescription);
        } else {
            NSError *parsingError = nil;
            User *currentUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:response error:&parsingError];
            [self finishSetupWithCurrentUser:currentUser];
            
            completion(response, nil);
        }
    }];
}

#pragma mark - Sign in helpers -

-(void)processLoginWithCompletion:(SocialCompletionBlock)completion {
    
    NSNumber *loginType = [[UserDefaultsManager standardUserDefaults] objectForKey:Default_LoginType];
    User *currentUser = [UserDefaultsManager loadCustomObjectForKey:Default_CurrentUser];
    
    if (loginType && currentUser) { //somebody is logged in
        switch ([loginType integerValue]) {
            case LoginTypeEmail: {
                [self getUserProfileDataWithCompletion:completion];
            }
                break;
                
            case LoginTypeGooglePlus: {
                [self tryAutoLoginForGooglePlusWithCompletion:completion];
            }
                break;
                
            case LoginTypeFacebook: {
                
                if ([FBSDKAccessToken currentAccessToken]) {
                    [self tryAutoLoginWithFacebookWithCompletion:completion];
                } else {
                    completion(nil, @"");
                }
            }
                break;
                
            default:
                break;
        }
    } else {
        if (getCurrentEnvironment) {
            [Helper showPlatesScreen];
        } else {
            [Helper showEnvironmentsSelection];
        }
        completion(nil, nil);
    }
}

- (BOOL)checkToken {
    
    NSLog(@"updateTimerForRefreshGoogleToken");
    
    NSDate *exprirationDate = [[UserDefaultsManager standardUserDefaults] objectForKey:Default_SocialAccessTokenExpDate];
    
    if (exprirationDate) {
        
        return ![Helper compareDate:exprirationDate withAnotherDate:[Helper currentDateInUTC]];
    }
    
    return NO;
}

-(void)finishSetupWithCurrentUser:(User *)currentUser
                        loginType:(LoginType)loginType
                        authToken:(NSString *)token
                     tokenExpDate:(NSDate *)tokenDate {
    
    NSLog(@"Current user - %@", currentUser);
    NSLog(@"Login type - %lu", (unsigned long)loginType);
    NSLog(@"Token - %@", token);
    NSLog(@"Token date - %@", tokenDate);
    
    [UserDefaultsManager saveCustomObject:currentUser forKey:Default_CurrentUser];
    [[UserDefaultsManager standardUserDefaults] setObject:@(loginType) forKey:Default_LoginType];
    [[UserDefaultsManager standardUserDefaults] setObject:token forKey:Default_SocialAccessToken];
    [[UserDefaultsManager standardUserDefaults] setObject:tokenDate forKey:Default_SocialAccessTokenExpDate];
}

-(void)finishSetupWithCurrentUser:(User *)currentUser {
    
    NSLog(@"Current user - %@", currentUser);
    
    [UserDefaultsManager saveCustomObject:currentUser forKey:Default_CurrentUser];
    [[UserDefaultsManager standardUserDefaults] setObject:@(LoginTypeEmail) forKey:Default_LoginType];
    [[UserDefaultsManager standardUserDefaults] setObject:currentUser.token forKey:Default_SocialAccessToken];
}

-(void)logout {
    
    [[UserDefaultsManager standardUserDefaults] removeObjectForKey:Default_LoginType];
    [[UserDefaultsManager standardUserDefaults] removeObjectForKey:Default_CurrentUser];
    [[UserDefaultsManager standardUserDefaults] removeObjectForKey:Default_SelectedEnvironment];
    [[UserDefaultsManager standardUserDefaults] removeObjectForKey:Default_SocialAccessToken];
    [[UserDefaultsManager standardUserDefaults] removeObjectForKey:Default_SocialAccessTokenExpDate];
    [[UserDefaultsManager standardUserDefaults] removeObjectForKey:Default_CurrentAccessToken];
    
    [[GIDSignIn sharedInstance] signOut];
    [self.facebookLoginManager logOut];
    
    [modelsManager cleanData];
}

@end
