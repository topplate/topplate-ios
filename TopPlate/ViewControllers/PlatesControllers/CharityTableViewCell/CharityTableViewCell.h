//
//  CharityTableViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/15/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *charityImageView;
@property (weak, nonatomic) IBOutlet UILabel *charityDescription;
@property (weak, nonatomic) IBOutlet UILabel *charityNumberOfVotes;
@property (weak, nonatomic) IBOutlet UIButton *charityVoteButton;

-(void)setupCellWithCharity:(Charity *)model;

@end
