//
//  PlateNameTableViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlateNameTableViewCell.h"

@implementation PlateNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellNameWithModel:(PlateModel *)model {
    self.plateNameLabel.text = [model.plateName uppercaseString];
}

-(void)setupCellReceiptWithModel:(PlateModel *)model {
    self.plateNameLabel.text = [model.plateReceipt uppercaseString];
}


@end
