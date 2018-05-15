//
//  Charity.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/15/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Charity : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *charityId;
@property (nonatomic, strong) NSString *charityName;
@property (nonatomic, strong) NSString *charityDescription;
@property (nonatomic, strong) NSString *charityImageUrl;
@property (nonatomic, strong) NSArray <NSString *> *charityVotes;

@end
