//
//  PlateImageTableViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlateImageTableViewCell.h"
#import "NSString+Helper.h"

@implementation PlateImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeSelected:(UIButton *)sender {
    
}

-(void)setupCellWithModel:(PlateModel *)model {
    
    [self.plateImageView sd_setImageWithURL:[model.plateImages.firstObject withBaseUrl]];
    [self.plateReceiptAvaliable setHidden:(model.plateReceipt.length > 0 || model.plateIngredients.count > 0) ? NO : YES];
    self.plateNumberOfLikes.text = [NSString stringWithFormat:@"%ld", (long)model.plateLikes];
}

@end
