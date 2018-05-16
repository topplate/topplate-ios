//
//  PlateCollectionViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/6/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlateCollectionViewCell.h"

@implementation PlateCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.contentViewWidth.constant = ([UIScreen mainScreen].bounds.size.width / 3);
    self.contentViewHeight.constant = ([UIScreen mainScreen].bounds.size.width / 3);

    // Initialization code
}

@end
