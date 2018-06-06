//
//  PlateImageTableViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlateImageTableViewCell.h"
#import "NSString+Helper.h"

@interface PlateImageTableViewCell ()

@property (nonatomic, strong) PlateModel *plateModel;
@property (nonatomic, strong) NSIndexPath *plateIndexPath;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeButtonWidth;

@end

@implementation PlateImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeSelected:(UIButton *)sender {
    
    if (getCurrentUser) {
        
        if (!self.plateModel.plateIsLiked) {
            PlateModelHelper *plateHelper = [modelsManager getModel:HelperTypePlates];
            
            [MBProgressHUD showHUDAddedTo:self.plateLikeButton animated:YES];
            [plateHelper likePlate:self.plateModel.plateId completion:^(BOOL result, NSString *errorString) {
                [MBProgressHUD hideHUDForView:self.plateLikeButton animated:YES];
                
                if (errorString) {
                    [Helper showErrorMessage:errorString forViewController:nil];
                } else {
                    self.plateModel.plateIsLiked = YES;
                    self.plateModel.plateLikes++;
                    
                    self.plateNumberOfLikes.text = [NSString stringWithFormat:@"%ld", (long)self.plateModel.plateLikes];
                    [self.plateLikeButton setImage:[UIImage imageNamed:@"likeIcon"] forState:UIControlStateNormal];

                    self.likeStatus(YES);
                }
            }];
        }
        
    } else {
        [Helper showWelcomeScreenAsModal:YES];
    }
}

-(void)setupCellWithModel:(PlateModel *)model indexPath:(NSIndexPath *)indexPath {
    
    self.plateModel = model;
    self.plateIndexPath = indexPath;
    
    [self.plateImageView sd_setImageWithURL:[model.plateImages.firstObject withBaseUrl]];
    [self.plateReceiptAvaliable setHidden:(model.plateReceipt.length > 0 || model.plateIngredients.count > 0) ? NO : YES];
    self.plateNumberOfLikes.text = [NSString stringWithFormat:@"%ld", (long)model.plateLikes];
    
    if (self.fromWinners) {
        self.likeButtonWidth.constant = 0;
    } else {
        if (self.plateModel.plateIsLiked) {
            [self.plateLikeButton setImage:[UIImage imageNamed:@"likeIcon"] forState:UIControlStateNormal];
        } else {
            [self.plateLikeButton setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        }
    }
    
}

@end
