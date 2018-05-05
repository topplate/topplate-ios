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

@interface NetworkManager : NSObject

+ (NetworkManager *) sharedManager;

-(void)getEnvironmentsWithCompletion:(void (^)(id response, NSError *error))completionBlock;


-(void)signInWithGoogle:(SocialLoginModel *)userInfo
         withCompletion:(void(^)(id response, NSError *error))completion;

-(void)signInWithFacebook:(SocialLoginModel *)userInfo
           withCompletion:(void(^)(id response, NSError *error))completionBlock;

//plates

- (void)getPlates:(NSDictionary*)params
    andCompletion:(void (^)(id response, NSError *error))completionBlock;

- (void)getPlateWithId:(NSString *)plateId
         andCompletion:(void (^)(id response, NSError *error))completionBlock;

- (void)uploadPlateWithModel:(PlateModel *)platemodel
               andCompletion:(void (^)(id response, NSError *error))completionBlock;


@end
