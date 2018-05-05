//
//  SocialLoginModel.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "SocialLoginModel.h"

@implementation SocialLoginModel

-(NSMutableDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setObject:self.email forKey:@"email"];
    [dict setObject:self.fullname forKey:@"name"];
    [dict setObject:self.imageUrl forKey:@"image"];
    [dict setObject:self.tokenId forKey:@"token"];

    return dict;
}

+(SocialLoginModel *)parseGoogleUser:(GIDGoogleUser *)googleUser {
    
    SocialLoginModel *googleLocalUser = [self new];
    googleLocalUser.fullname = googleUser.profile.name;
    googleLocalUser.email = googleUser.profile.email;
    googleLocalUser.imageUrl = [[googleUser.profile imageURLWithDimension:300] absoluteString];
    googleLocalUser.tokenId = googleUser.authentication.idToken;
    
    return googleLocalUser;
}

+(SocialLoginModel *)parseFacebookUser:(NSDictionary *)facebookUser {
    
    SocialLoginModel *facebookLocalUser = [self new];
    facebookLocalUser.email = [facebookUser valueForKey:@"email"];
    facebookLocalUser.fullname = [facebookUser valueForKey:@"name"];
    facebookLocalUser.imageUrl = [[[facebookUser valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];

    return facebookLocalUser;
}

@end
