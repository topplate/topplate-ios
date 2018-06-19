//
//  CharityTableViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/15/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "CharityTableViewCell.h"

@implementation CharityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)charityVoted:(id)sender {
    
}

-(void)setupCellWithCharity:(Charity *)model {
    
    [self.charityVoteButton roundFrame];
    
    self.charityDescription.text = [NSString stringWithFormat:@"%@ %@", model.charityName, model.charityDescription];
    [self.charityImageView sd_setImageWithURL:[model.charityImageUrl withBaseUrl]];
    self.charityNumberOfVotes.text = [NSString stringWithFormat:@"%lu votes", (unsigned long)model.charityVotes.count];
}

@end
