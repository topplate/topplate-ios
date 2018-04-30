//
//  IngredientTableViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/29/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "IngredientTableViewCell.h"

@interface IngredientTableViewCell ()

@property (nonatomic, strong) PlateModel *model;

@property (nonatomic) NSInteger index;

@end

@implementation IngredientTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textfield.delegate = self;
    // Initialization code
}

-(void)removeItem {
    
    [self.model.plateIngredients removeObjectAtIndex:self.index];
    
    if ([self.delegate respondsToSelector:@selector(shouldReloadTableViewWithIndex:)]) {
        [self.delegate shouldReloadTableViewWithIndex:self.index];
    }
}

- (IBAction)valueChangedAction:(id)sender {
        
    self.model.plateIngredients[self.index] = self.textfield.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithPlate:(PlateModel *)plateModel andIndex:(NSUInteger)index {
    
    self.model = plateModel;
    self.index = index;
    
    UIButton *textFieldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [textFieldButton setImage:[UIImage imageNamed:@"textFieldRemoveIcon"] forState:UIControlStateNormal];
    [textFieldButton setAlpha:.3];
    self.textfield.type = TextFieldTypeRightViewImage;
    self.textfield.rightView = textFieldButton;
    [textFieldButton addTarget:self action:@selector(removeItem) forControlEvents:UIControlEventTouchUpInside];
    self.textfield.text = plateModel.plateIngredients[index];
    [self.textfield roundFrame];
}

@end
