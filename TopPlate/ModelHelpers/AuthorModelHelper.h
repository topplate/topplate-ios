//
//  AuthorModelHelper.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/6/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AuthorCompletionBlock)(NSArray *plates, NSString *errorString);

@interface AuthorModelHelper : NSObject

@property (nonatomic, strong) NSMutableArray *userPlates;
@property (nonatomic, strong) User *userInfo;

-(void)getPlatesForAuthor:(NSString *)userId
              environment:(NSString *)environment
                withLimit:(NSNumber *)limit
                 withSkip:(NSNumber *)skip
          completionBlock:(AuthorCompletionBlock)completion;

-(void)getAuthorProfileInfoWithId:(NSString *)userId
                  completionBlock:(void(^)(User *currentUserProfile, NSString *errorString))completion;

@end
