//
//  TPTextField.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/29/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPTextFieldDelegate <NSObject>

-(void)textFieldIsCurrentResponder:(UITextField *)textField;
-(void)textFieldReturnPressed:(UITextField *)textField;

@end

typedef NS_ENUM(NSInteger, TextFieldType) {
    TextFieldTypeOrdinary = 0,
    TextFieldTypeUnderLined,
    TextFieldTypeLeftViewImage,
    TextFieldTypeRightViewImage
};

typedef void (^TextFieldValueChange)(NSString *text);

@interface TPTextField : UITextField <UITextFieldDelegate>

@property (nonatomic, assign) TextFieldType type;

@property (nonatomic, strong) UIColor *underlineColor;

@property (nonatomic, strong) NSString *placeHolderText;

@property (nonatomic, copy) TextFieldValueChange textFieldValueChange;

@property (nonatomic, weak) id<TPTextFieldDelegate>customDelegate;

@end
