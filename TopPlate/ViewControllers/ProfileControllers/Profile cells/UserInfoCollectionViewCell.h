//
//  UserInfoCollectionViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/6/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userBioLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLabelWidth;

@end
