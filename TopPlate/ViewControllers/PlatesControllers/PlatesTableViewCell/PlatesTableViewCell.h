//
//  PlatesTableViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatesTableViewCell : UITableViewCell

@property (nonatomic, strong) UIViewController *parentViewController;

-(void)setupLikeCellWithModel:(PlateModel *)model;

-(void)setupWinnersCellWithModel:(PlateModel *)model;

@end
