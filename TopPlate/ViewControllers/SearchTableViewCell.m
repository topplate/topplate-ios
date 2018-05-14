//
//  SearchTableViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/14/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithModel:(PlateModel *)model {
    
    [self.plateImageView sd_setImageWithURL:[[model.plateImages firstObject] withBaseUrl]];
    self.plateNameLabel.text = [model.plateName uppercaseString];
    self.plateAuthorNameLabel.text = [model.plateAuthor.authorName uppercaseString];
}

@end
