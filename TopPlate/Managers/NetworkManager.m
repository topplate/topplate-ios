//
//  NetworkManager.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation NetworkManager

+ (NetworkManager *)sharedManager {
    
    static dispatch_once_t pred = 0;
    __strong static NetworkManager *sharedObject = nil;
    dispatch_once(&pred, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (AFHTTPSessionManager *)sessionManager {

    @synchronized(self) {
        if ( ! _sessionManager) {
            AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://top-plate.herokuapp.com/"]];

            AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
            [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            sessionManager.requestSerializer = requestSerializer;

            AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
            NSArray *acceptableTypes = @[@"application/json",
                                         @"text/json"];
            [responseSerializer setAcceptableContentTypes:[NSSet setWithArray:acceptableTypes]];
            sessionManager.responseSerializer = responseSerializer;

            self.sessionManager = sessionManager;
        }
    }

    return _sessionManager;
}


-(void)signInWithGoogle:(SocialLoginModel *)userInfo
         withCompletion:(NetworkCompletionBlock)completion {
    
    [self.sessionManager POST:@"login_google"
                   parameters:[userInfo dictionaryRepresentation]
                     progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

-(void)signInWithFacebook:(SocialLoginModel *)userInfo
           withCompletion:(NetworkCompletionBlock)completion {

    [self.sessionManager POST:@"login_facebook"
                   parameters:[userInfo dictionaryRepresentation]
                     progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

-(void)getEnvironmentsWithCompletion:(NetworkCompletionBlock)completion {

    [self.sessionManager GET:@"get_environments"
                  parameters:nil
                    progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

#pragma mark - Plates -

- (void)getPlates:(NSDictionary*)params
   withCompletion:(NetworkCompletionBlock)completion {
    
    [self.sessionManager GET:@"get_plates"
                  parameters:params
                    progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)getPlateWithId:(NSString *)plateId
        withCompletion:(NetworkCompletionBlock)completion {
    
    [self.sessionManager GET:@"get_plate"
                  parameters:@{@"id" : plateId}
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        //
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        completion(responseObject, nil);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        completion(nil, error);
                    }];
}

- (void)uploadPlateWithModel:(PlateModel *)platemodel
               withCompletion:(NetworkCompletionBlock)completion {
    
    [self.sessionManager POST:@"add_plate"
                   parameters:[platemodel uploadPlateDictionaryRepresentation]
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(platemodel.plateImage)
                                    name:@"image"
                                fileName:@"plateImage.png"
                                mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

//user profile

-(void)getUserProfileWithUserId:(NSString *)userId
                 withCompletion:(NetworkCompletionBlock)completion {
    
    [self.sessionManager GET:@"get-user-profile"
                  parameters:@{@"id" : userId}
                    progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

-(void)getPlatesForUser:(NSDictionary *)params
         withCompletion:(NetworkCompletionBlock)completion {
    
    [self.sessionManager GET:@"get_plates_by_author"
                  parameters:params
                    progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

@end
