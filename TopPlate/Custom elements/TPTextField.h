//
//  TPTextField.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/29/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end
