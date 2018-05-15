//
//  Charity.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/15/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "Charity.h"

@implementation Charity

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{@"charityId" : @"_id",
             @"charityName" : @"name",
             @"charityDescription" : @"description",
             @"charityImageUrl" : @"image",
             @"charityVotes" : @"votes"
             };
}

@end
