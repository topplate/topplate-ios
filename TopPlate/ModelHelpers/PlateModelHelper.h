//
//  PlateModelHelper.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PlateCompletionBlock)(NSArray *plates, NSString *errorString);


@protocol PlatesModelHelperDelegate <NSObject>

-(void)modelIsUpdated;

@end

@interface PlateModelHelper : NSObject

@property (nonatomic, strong) NSMutableArray *plates;
@property (nonatomic, strong) PlateModel *currentPlate;
@property (nonatomic, weak) id <PlatesModelHelperDelegate> delegate;

-(void)getPlatesForEnvironment:(NSString *)environment
                     withLimit:(NSNumber *)limit
                      withSkip:(NSNumber *)skip
               completionBlock:(PlateCompletionBlock)completion;

-(void)getPlateWithId:(NSString *)plateId
      completionBlock:(void(^)(PlateModel *plate, NSString *errorString))completion;

-(void)uploadPlateWithModel:(PlateModel *)model
                 completion:(void(^)(BOOL result, NSString *errorString))completion;

-(void)searchPlatesWithSearchString:(NSString *)searchString
                         completion:(void(^)(NSArray *searchResults, NSString *errorString))completion;

-(void)getWinnersWithCompletion:(PlateCompletionBlock)completion;

-(BOOL)isMyPlate:(PlateModel *)plate;


@end
