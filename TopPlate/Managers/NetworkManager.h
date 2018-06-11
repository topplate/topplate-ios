//
//  NetworkManager.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "SocialLoginModel.h"

typedef void (^NetworkCompletionBlock)(id response, NSError *error);

@interface NetworkManager : NSObject

+ (NetworkManager *) sharedManager;

-(void)getEnvironmentsWithCompletion:(NetworkCompletionBlock)completion;

#pragma mark - SignIn -

-(void)signInWithGoogle:(SocialLoginModel *)userInfo
         withCompletion:(NetworkCompletionBlock)completion;

-(void)signInWithFacebook:(SocialLoginModel *)userInfo
           withCompletion:(NetworkCompletionBlock)completion;

-(void)signInWithEmail:(LoginModel *)login
        withCompletion:(NetworkCompletionBlock)completion;

-(void)signUpWithEmail:(LoginModel *)login
        withCompletion:(NetworkCompletionBlock)completion;

-(void)logoutWithCompletion:(NetworkCompletionBlock)completion;

#pragma mark - Plates -

- (void)getPlates:(NSDictionary*)params
   withCompletion:(NetworkCompletionBlock)completion;

- (void)getPlateWithId:(NSString *)plateId
        withCompletion:(NetworkCompletionBlock)completion;

-(void)likePlateWithId:(NSString *)plateId
        withCompletion:(NetworkCompletionBlock)completion;

-(void)unlikePlateWithId:(NSString *)plateId
          withCompletion:(NetworkCompletionBlock)completion;

- (void)uploadPlateWithModel:(PlateModel *)platemodel
              withCompletion:(NetworkCompletionBlock)completion;

- (void)searchPlates:(NSString *)searchString
      withCompletion:(NetworkCompletionBlock)completion;

-(void)getWinnersWithCompletion:(NetworkCompletionBlock)completion;

#pragma mark - User profile -

-(void)getUserProfileWithUserId:(NSString *)userId
                 withCompletion:(NetworkCompletionBlock)completion;

-(void)getPlatesForUser:(NSDictionary *)params
         withCompletion:(NetworkCompletionBlock)completion;

#pragma mark - Charity -

-(void)loadCharityChoiseBannersWithCompletion:(NetworkCompletionBlock)completion;

-(void)getWinnerBannerWithCompletion:(NetworkCompletionBlock)completion;

@end
