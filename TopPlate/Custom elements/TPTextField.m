//
//  TPTextField.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/29/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "TPTextField.h"

@implementation TPTextField

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        
        [self initStuff];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initStuff];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initStuff];
    }
    return self;
}

- (void) initStuff {
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.type = TextFieldTypeOrdinary;
    self.delegate = self;
}

-(void)setType:(TextFieldType)type {
    
    _type = type;
    
    if (type == TextFieldTypeUnderLined) {
        self.borderStyle = UITextBorderStyleNone;
    } else if (type == TextFieldTypePlaceholder) {
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.placeholder = @"";
        self.backgroundColor = [UIColor clearColor];
    } else {
        self.borderStyle = UITextBorderStyleRoundedRect;
    }
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds {
    
    if (_type == TextFieldTypeLeftViewImage) {
        return CGRectMake(bounds.origin.x, bounds.origin.y, self.height, self.height);
    }
    
    return bounds;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds {
    
    if (_type == TextFieldTypeRightViewImage) {
        return CGRectMake(self.width - self.height, bounds.origin.y, self.height, self.height);
    }
    
    return bounds;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    if (_type == TextFieldTypeLeftViewImage) {
        return CGRectMake(self.leftView.width, bounds.origin.y,
                          bounds.size.width - self.rightView.width - self.leftView.width - 15, bounds.size.height);
    }
    
    if (_type == TextFieldTypeRightViewImage) {
        return CGRectMake(bounds.origin.x + 7 , bounds.origin.y,
                          bounds.size.width - self.rightView.width, bounds.size.height);
    }
    
    if (_type == TextFieldTypeOrdinary || _type == TextFieldTypeSecured || _type == TextFieldTypePlaceholder) {
        return CGRectMake(bounds.origin.x + 7 , bounds.origin.y,
                          bounds.size.width, bounds.size.height);
    }
    
    if (_type == TextFieldTypeUnderLined) {
        return CGRectMake(bounds.origin.x + 7 , bounds.origin.y,
                          bounds.size.width, bounds.size.height);
    }
    
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}


- (void)drawRect:(CGRect)rect {
    
    if (_type == TextFieldTypeUnderLined) {
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, self.height - 1, self.width, 1.0f);
        bottomBorder.backgroundColor = _underlineColor.CGColor;
        [self.layer addSublayer:bottomBorder];
    }
}

- (void)setPlaceHolderText:(NSString *)placeHolderText {
    self.text = placeHolderText;
    _placeHolderText = placeHolderText;
    
    [self defaultValues];
}

-(void)defaultValues {
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField.text isEqualToString:self.placeHolderText]) {
        self.text = @"";
        self.textAlignment = NSTextAlignmentLeft;
        
        if (self.type == TextFieldTypeSecured) {
            [self setSecureTextEntry:YES];
        } else {
            [self setSecureTextEntry:NO];
        }
        
    } else if (textField.text.length == 0) {
        self.text = self.placeHolderText;
        self.textAlignment = NSTextAlignmentCenter;
        [self setSecureTextEntry:NO];
    }
    
    if ([self.customDelegate respondsToSelector:@selector(textFieldIsCurrentResponder:)]) {
        [self.customDelegate textFieldIsCurrentResponder:self];
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.text = [textField.text trimWhiteSpaces];
    
    if ([textField.text isEqualToString:@""] || [textField.text isEqualToString:self.placeHolderText]) {
        self.text = self.placeHolderText;
        self.textAlignment = NSTextAlignmentCenter;
        [self setSecureTextEntry:NO];
        
    } else {
        
        if (self.type == TextFieldTypeSecured) {
            [self setSecureTextEntry:YES];
        } else {
            [self setSecureTextEntry:NO];
        }
        
        if (self.textFieldValueChange) {
            self.textFieldValueChange(textField.text);
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.customDelegate respondsToSelector:@selector(textFieldReturnPressed:)]) {
        [self.customDelegate textFieldReturnPressed:textField];
    }
    
    return NO;
}

@end
