//
//  PlateImageTableViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LikeStatusDidChange)(BOOL likeStatus);

@interface PlateImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *plateImageView;
@property (weak, nonatomic) IBOutlet UIImageView *plateReceiptAvaliable;
@property (weak, nonatomic) IBOutlet UIButton *plateLikeButton;
@property (weak, nonatomic) IBOutlet UILabel *plateNumberOfLikes;

-(void)setupCellWithModel:(PlateModel *)model indexPath:(NSIndexPath *)indexPath;

@property (nonatomic) BOOL fromWinners;

@property (nonatomic, copy) LikeStatusDidChange likeStatus;

@end

