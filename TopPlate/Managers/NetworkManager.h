//
//  NetworkManager.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface NetworkManager : NSObject

+ (NetworkManager *) sharedManager;

-(void)getEnvironmentsWithCompletion:(void (^)(id response, NSError *error))completionBlock;

//plates

- (void)getPlates:(NSDictionary*)params
    andCompletion:(void (^)(id response, NSError *error))completionBlock;

- (void)getPlateWithId:(NSString *)plateId
         andCompletion:(void (^)(id response, NSError *error))completionBlock;


@end
