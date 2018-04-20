//
//  EnvironmentsModel.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/17/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "EnvironmentsModel.h"

@implementation EnvironmentsModel

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{@"environmentName" : @"name",
             @"environmentImage" : @"image",
             @"environmentNumberOfPlates" : @"numberOfPlates"
             };
}

@end
