//
//  PlatesTableViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *plateImage;
@property (weak, nonatomic) IBOutlet UILabel *plateName;
@property (weak, nonatomic) IBOutlet UILabel *plateAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *plateLocation;
@property (weak, nonatomic) IBOutlet UILabel *plateLikes;
@property (weak, nonatomic) IBOutlet UIImageView *plateReceiptImage;
@property (weak, nonatomic) IBOutlet UIButton *plateLikeButton;

@end
