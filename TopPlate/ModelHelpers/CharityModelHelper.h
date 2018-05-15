//
//  CharityModelHelper.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/15/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CharityCompletionBlock)(NSArray *charities, NSString *errorString);

@interface CharityModelHelper : NSObject

-(void)loadCharitiesWithCompletion:(CharityCompletionBlock)completion;

@end
