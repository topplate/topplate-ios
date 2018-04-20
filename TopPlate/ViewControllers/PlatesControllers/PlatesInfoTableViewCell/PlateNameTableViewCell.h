//
//  PlateNameTableViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlateNameTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *plateNameLabel;

-(void)setupCellNameWithModel:(PlateModel *)model;

-(void)setupCellReceiptWithModel:(PlateModel *)model;

@end
