//
//  LoginModelHelper.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoginCompletionBlock)(BOOL result, NSString *errorString);

@interface LoginModelHelper : NSObject

-(void)singIn:(LoginModel *)login withCompletion:(LoginCompletionBlock)completion;

@end
