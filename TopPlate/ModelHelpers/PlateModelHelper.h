//
//  PlateModelHelper.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PlatesCompletionBlock)(NSArray *plates, NSString *errorString);
typedef void(^PlateCompletionBlock)(PlateModel *plate, NSString *errorString);


@protocol PlatesModelHelperDelegate <NSObject>

-(void)platesUpdated;

-(void)plateAtIndexIsUpdated:(NSInteger)plateIndex;

@end

@interface PlateModelHelper : NSObject

@property (nonatomic, strong) NSMutableArray<PlateModel *> *plates;
@property (nonatomic, strong) PlateModel *currentPlate;
@property (nonatomic, weak) id <PlatesModelHelperDelegate> delegate;

-(void)getPlatesForEnvironment:(NSString *)environment
                     withLimit:(NSNumber *)limit
                      withLastPlateId:(NSString *)lastPlateId
               completionBlock:(PlatesCompletionBlock)completion;

-(void)getPlateWithId:(NSString *)plateId
      completionBlock:(void(^)(PlateModel *plate, NSString *errorString))completion;

-(void)likePlate:(NSString *)plateId
      completion:(PlateCompletionBlock)completion;

-(void)unlikePlate:(NSString *)plateId
        completion:(PlateCompletionBlock)completion;

-(void)uploadPlateWithModel:(PlateModel *)model
                 completion:(void(^)(BOOL result, NSString *errorString))completion;

-(void)editPlateWithModel:(PlateModel *)model
               completion:(void(^)(BOOL result, NSString *errorString))completion;

-(void)searchPlatesWithSearchString:(NSString *)searchString
                         completion:(void(^)(NSArray *searchResults, NSString *errorString))completion;

-(void)getWinnersWithCompletion:(PlatesCompletionBlock)completion;

-(BOOL)isEditable:(PlateModel *)plate;

@end
