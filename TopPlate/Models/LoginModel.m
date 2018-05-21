//
//  LoginModel.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

-(NSDictionary *)signInRepresentation {
    
    NSDictionary *dictRepresentation = @{@"email" : self.email,
                                         @"password" : self.password};
    
    return dictRepresentation;
}

-(NSDictionary *)signUpRepresentation {
    
    NSDictionary *dictRepresentation = @{@"firstname" : self.firstName,
                                         @"lastname" : self.lastName,
                                         @"username" : self.userName,
                                         @"email" : self.email,
                                         @"password" : self.password
                                         };
    
    return dictRepresentation;
}


@end
