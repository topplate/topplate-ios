//
//  PlateAuthorInfoTableViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlateAuthorInfoTableViewCell.h"

@interface PlateAuthorInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *plateAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *plateLocation;

@property (nonatomic, strong) PlateModel *plateModel;

@end

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
    
    self.plateModel = model;
    
    self.plateAuthorName.text = [model.plateAuthor.authorName uppercaseString];
    self.plateLocation.text = [model.plateAuthorLocation uppercaseString];
    
    [self setupAuthorLabelGesture:self.plateAuthorName];
}

-(void)setupAuthorLabelGesture:(UILabel *)label {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile)];
    tapGesture.numberOfTapsRequired = 1;
    [label addGestureRecognizer:tapGesture];
}

-(void)showUserProfile {
    
    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    ProfileViewController *profileViewController = [profileStoryboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    profileViewController.userId = self.plateModel.plateAuthor.authorId;
    
    [self.parentViewController.navigationController pushViewController:profileViewController animated:YES];
}

@end
