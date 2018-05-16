//
//  UserInfoCollectionViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/6/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "UserInfoCollectionViewCell.h"

@implementation UserInfoCollectionViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self layoutIfNeeded];

    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.userNameLabelWidth.constant = [UIScreen mainScreen].bounds.size.width - 2 * 20;
    [self.userProfileImage circleView];
}


@end
