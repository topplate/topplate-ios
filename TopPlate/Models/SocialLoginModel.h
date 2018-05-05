//
//  SocialLoginModel.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleSignIn/GIDGoogleUser.h>

@interface SocialLoginModel : NSObject

@property (nonatomic, strong) NSString *tokenId;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSDate *tokenExpDate;

-(NSMutableDictionary *)dictionaryRepresentation;

+(SocialLoginModel *)parseGoogleUser:(GIDGoogleUser *)googleUser;

+(SocialLoginModel *)parseFacebookUser:(NSDictionary *)facebookUser;

@end
