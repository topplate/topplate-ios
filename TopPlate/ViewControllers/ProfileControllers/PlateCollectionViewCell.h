//
//  PlateCollectionViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/6/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlateCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *plateImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@end
