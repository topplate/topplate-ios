//
//  PlateModel.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthorModel.h"
#import "User.h"

@interface PlateModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *plateId;
@property (nonatomic, strong) NSString *plateName;
@property (nonatomic, strong) NSArray<NSString *> *plateImages;
@property (nonatomic, strong) AuthorModel *plateAuthor;
@property (nonatomic, strong) NSString *plateAuthorLocation;
@property (nonatomic) NSInteger plateLikes;
@property (nonatomic, strong) NSMutableArray<NSString *> *plateIngredients;
@property (nonatomic, strong) NSString *plateReceipt;
@property (nonatomic) BOOL plateHasReceipt;
@property (nonatomic, strong) NSArray<PlateModel *> *relatedPlates; //used for detail plates

// used for uploading plate
@property (nonatomic, strong) UIImage *plateImage;
@property (nonatomic, strong) NSString *plateEnvironment;
@property (nonatomic, strong) NSString *plateRestaurantName;
@property (nonatomic, strong) User *plateUser;

-(NSMutableDictionary *)uploadPlateDictionaryRepresentation;

@end
