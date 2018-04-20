//
//  PlateSocialShareTableViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlateSocialShareTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *plateFacebookShare;
@property (weak, nonatomic) IBOutlet UIButton *plateInstagramShare;
@property (weak, nonatomic) IBOutlet UIButton *plateTwitterShare;
@property (weak, nonatomic) IBOutlet UIButton *plateGooglePlusShare;
@property (weak, nonatomic) IBOutlet UIButton *platePinterestShare;

@end
