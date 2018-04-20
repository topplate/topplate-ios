//
//  AuthorModel.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/19/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *authorId;
@property (nonatomic, strong) NSURL *authorImageUrl;
@property (nonatomic, strong) NSString *authorName;

@end
