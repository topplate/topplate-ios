//
//  PlateAuthorInfoTableViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlateAuthorInfoTableViewCell.h"

@implementation PlateAuthorInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithModel:(PlateModel *)model {
    
    self.plateAuthorName.text = [model.plateAuthor.authorName uppercaseString];
    self.plateLocation.text = [model.plateAuthorLocation uppercaseString];
}

@end
