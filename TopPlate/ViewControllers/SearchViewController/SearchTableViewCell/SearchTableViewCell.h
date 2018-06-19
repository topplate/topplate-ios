//
//  SearchTableViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/14/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *plateImageView;
@property (weak, nonatomic) IBOutlet UILabel *plateNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *plateAuthorNameLabel;

-(void)setupCellWithModel:(PlateModel *)model;

@end
