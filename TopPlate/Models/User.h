//
//  User.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/1/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSMutableArray<NSString *> *likedPlates;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) AuthorModel *userInfo;

@end
