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

//sing in

-(void)signInWithGoogle:(SocialLoginModel *)userInfo
         withCompletion:(NetworkCompletionBlock)completion;

-(void)signInWithFacebook:(SocialLoginModel *)userInfo
           withCompletion:(NetworkCompletionBlock)completion;

//plates

- (void)getPlates:(NSDictionary*)params
   withCompletion:(NetworkCompletionBlock)completion;

- (void)getPlateWithId:(NSString *)plateId
        withCompletion:(NetworkCompletionBlock)completion;

- (void)uploadPlateWithModel:(PlateModel *)platemodel
              withCompletion:(NetworkCompletionBlock)completion;

- (void)searchPlates:(NSString *)searchString
      withCompletion:(NetworkCompletionBlock)completion;

//user profile

-(void)getUserProfileWithUserId:(NSString *)userId
                 withCompletion:(NetworkCompletionBlock)completion;

-(void)getPlatesForUser:(NSDictionary *)params
         withCompletion:(NetworkCompletionBlock)completion;

- (void)loadCharityChoiseBannersWithCompletion:(NetworkCompletionBlock)completion;
@end
