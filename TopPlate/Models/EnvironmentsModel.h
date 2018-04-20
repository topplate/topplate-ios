//
//  EnvironmentsModel.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/17/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvironmentsModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *environmentName;
@property (nonatomic, strong) NSString *environmentImage;
@property (nonatomic) NSInteger environmentNumberOfPlates;

@end
