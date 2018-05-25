//
//  PlatesTableViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlatesTableViewCell.h"

@implementation PlatesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithModel:(PlateModel *)model {
    self.plateName.text = [model.plateName uppercaseString];
    [self.plateImage sd_setImageWithURL:[model.plateImages.firstObject withBaseUrl]];
    self.plateAuthorName.text = [model.plateAuthor.authorName uppercaseString];
    self.plateLocation.text = [model.plateAuthorLocation uppercaseString];
    self.plateLikes.text = [NSString stringWithFormat:@"%ld", (long)model.plateLikes];
    [self.plateReceiptImage setHidden:!model.plateHasReceipt];
}

- (IBAction)likePlateAction:(id)sender {
    
    if (getCurrentUser) {
        NSLog(@"Plate liked");
    } else {
        [Helper showWelcomeScreenAsModal:YES];
    }
}


@end
