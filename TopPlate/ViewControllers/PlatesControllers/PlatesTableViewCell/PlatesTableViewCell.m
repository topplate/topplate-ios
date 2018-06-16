//
//  PlatesTableViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlatesTableViewCell.h"

@interface PlatesTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *winnersView;
@property (weak, nonatomic) IBOutlet UILabel *winnersDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *winnersLikesLabel;

@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UILabel *plateLikes;

@property (weak, nonatomic) IBOutlet UIImageView *plateImage;
@property (weak, nonatomic) IBOutlet UILabel *plateName;
@property (weak, nonatomic) IBOutlet UILabel *plateAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *plateLocation;
@property (weak, nonatomic) IBOutlet UIImageView *plateReceiptImage;
@property (weak, nonatomic) IBOutlet UIButton *plateLikeButton;

@property (nonatomic, strong) PlateModel *plateModel;

@end

@implementation PlatesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setupLikeCellWithModel:(PlateModel *)model {
    
    self.plateModel = model;
    
    self.plateName.text = [model.plateName uppercaseString];
    [self.plateImage sd_setImageWithURL:[model.plateImages.firstObject withBaseUrl]];
    self.plateAuthorName.text = [model.plateAuthor.authorName uppercaseString];
    self.plateLocation.text = [model.plateAuthorLocation uppercaseString];
    self.plateLikes.text = [NSString stringWithFormat:@"%ld", (long)model.plateLikes];
    [self.plateReceiptImage setHidden:!model.plateHasReceipt];
    
    [self.winnersView setHidden:YES];
    [self.likeView setHidden:NO];
    
    [self setupAuthorLabelGesture:self.plateAuthorName];
    
    [self.plateLikeButton setUserInteractionEnabled:self.plateModel.plateCanLike];
    
    if (model.plateCanLike) {
        if (self.plateModel.plateIsLiked) {
            [self.plateLikeButton setImage:[UIImage imageNamed:@"likeIcon"] forState:UIControlStateNormal];
        } else {
            [self.plateLikeButton setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        }
    } else {
        [self.plateLikeButton setImage:[UIImage imageNamed:@"nonlike"] forState:UIControlStateNormal];
    }
}

-(void)setupWinnersCellWithModel:(PlateModel *)model {
    
    self.plateModel = model;
    
    self.plateName.text = [model.plateName uppercaseString];
    [self.plateImage sd_setImageWithURL:[model.plateImages.firstObject withBaseUrl]];
    self.plateAuthorName.text = [model.plateAuthor.authorName uppercaseString];
    self.plateLocation.text = [model.plateAuthorLocation uppercaseString];
    self.winnersLikesLabel.text = [NSString stringWithFormat:@"%ld", (long)model.plateLikes];
    [self.plateReceiptImage setHidden:!model.plateHasReceipt];
    self.winnersDateLabel.text = @"APRIL, 30 WINNER";
    
    [self.winnersView setHidden:NO];
    [self.likeView setHidden:YES];
    
    [self setupAuthorLabelGesture:self.plateAuthorName];
    
    [self.plateLikeButton setUserInteractionEnabled:NO];
}

- (IBAction)likePlateAction:(id)sender {
    
    if (getCurrentUser) {

        PlateModelHelper *plateHelper = [modelsManager getModel:HelperTypePlates];
        
        if (self.plateModel.plateIsLiked) {
            
            [MBProgressHUD showHUDAddedTo:self.plateLikeButton animated:YES];
            [plateHelper unlikePlate:self.plateModel.plateId completion:^(PlateModel *plate, NSString *errorString) {
                [MBProgressHUD hideHUDForView:self.plateLikeButton animated:YES];
                if (errorString) {
                    [Helper showErrorMessage:errorString forViewController:nil];
                }
            }];
            
        } else {
            [MBProgressHUD showHUDAddedTo:self.plateLikeButton animated:YES];
            [plateHelper likePlate:self.plateModel.plateId completion:^(PlateModel *plate, NSString *errorString) {
                [MBProgressHUD hideHUDForView:self.plateLikeButton animated:YES];
                if (errorString) {
                    [Helper showErrorMessage:errorString forViewController:nil];
                }
            }];
        }
        
    } else {
        [Helper showWelcomeScreenAsModal:YES];
    }
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
