//
//  PlateAuthorInfoTableViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlateAuthorInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *plateAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *plateLocation;

-(void)setupCellWithModel:(PlateModel *)model;

@end
