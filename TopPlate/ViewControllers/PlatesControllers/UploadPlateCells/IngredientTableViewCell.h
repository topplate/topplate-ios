//
//  IngredientTableViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/29/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPTextField.h"

@protocol IngredientTableViewCellDelegate <NSObject>

-(void)shouldReloadTableViewWithIndex:(NSInteger)index;

@end

@interface IngredientTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TPTextField *textfield;

@property (nonatomic, weak) id <IngredientTableViewCellDelegate> delegate;

-(void)configureCellWithPlate:(PlateModel *)plateModel
                     andIndex:(NSUInteger)index;

@end
