//
//  PlateModelHelper.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PlateCompletionBlock)(NSArray *plates, NSString *errorString);

@interface PlateModelHelper : NSObject

@property (nonatomic, strong) NSMutableArray *plates;
@property (nonatomic, strong) PlateModel *currentPlate;

-(void)getPlatesForEnvironments:(NSString *)environment
                completionBlock:(PlateCompletionBlock)completion;

-(void)getPlateWithId:(NSString *)plateId
      completionBlock:(void(^)(PlateModel *plate, NSString *errorString))completion;

@end
