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
}

-(void)setType:(TextFieldType)type {
    
    _type = type;
    
    if (type == TextFieldTypeUnderLined) {
        self.borderStyle = UITextBorderStyleNone;
    } else {
        self.borderStyle = UITextBorderStyleRoundedRect;
    }
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds {
    
    if (_type == TextFieldTypeLeftViewImage) {
        return CGRectMake(bounds.origin.x + 7, bounds.origin.y, 25, 25);
    }
    
    return bounds;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds {
    
    if (_type == TextFieldTypeRightViewImage) {
        return CGRectMake(self.width - 25, bounds.origin.y + 5, 25, 25);
    }
    
    return bounds;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    if (_type == TextFieldTypeLeftViewImage) {
        return CGRectMake(self.leftView.frame.size.width + 10, bounds.origin.y,
                          bounds.size.width - self.rightView.width, bounds.size.height);
    }
    
    if (_type == TextFieldTypeRightViewImage) {
        return CGRectMake(bounds.origin.x + 7 , bounds.origin.y,
                          bounds.size.width - self.rightView.width, bounds.size.height);
    }
    
    if (_type == TextFieldTypeOrdinary) {
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

- (void) drawPlaceholderInRect:(CGRect)rect {
    
    NSTextAlignment alignment = NSTextAlignmentCenter;
    NSMutableParagraphStyle* alignmentSetting = [[NSMutableParagraphStyle alloc] init];
    alignmentSetting.alignment = alignment;
    
    [[self placeholder] drawInRect:rect withAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                         NSParagraphStyleAttributeName : alignmentSetting
                                                         }];
}

@end
