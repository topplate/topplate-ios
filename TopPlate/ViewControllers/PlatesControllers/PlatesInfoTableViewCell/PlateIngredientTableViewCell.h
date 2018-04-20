//
//  PlateIngredientTableViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlateIngredientTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *plateIngredient;

-(void)setupCellWithIngredient:(NSString *)ingredient;

@end
