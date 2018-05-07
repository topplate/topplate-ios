//
//  TPTextView.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/29/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "TPTextView.h"

@implementation TPTextView

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
    
    [self roundFrame];
    self.delegate = self;
}

-(void)setPlaceholderText:(NSString *)placeholderText {
    self.text = placeholderText;
    _placeholderText = placeholderText;
    
    [self defaultValues];
}

-(void)defaultValues {
    
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:self.placeholderText]) {
        self.text = @"";
        self.textAlignment = NSTextAlignmentLeft;
        self.textColor = [UIColor whiteColor];
    } else if (textView.text.length == 0) {
        self.textColor = [UIColor whiteColor];
        self.text = self.placeholderText;
        self.textAlignment = NSTextAlignmentCenter;
        [self resignFirstResponder];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.text.length == 0){
        self.textColor = [UIColor whiteColor];
        self.text = self.placeholderText;
        self.textAlignment = NSTextAlignmentCenter;
        [self resignFirstResponder];
    } else  {
        self.textColor = [UIColor whiteColor];
        self.text = textView.text;
        self.textAlignment = NSTextAlignmentLeft;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
   textView.text = [textView.text trimWhiteSpaces];
    
    if ([textView.text isEqualToString:@""] || [textView.text isEqualToString:self.placeholderText]) {
        self.textColor = [UIColor whiteColor];
        self.text = self.placeholderText;
        self.textAlignment = NSTextAlignmentCenter;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(self.text.length == 0){
            self.textColor = [UIColor whiteColor];
            self.text = self.placeholderText;
            self.textAlignment = NSTextAlignmentCenter;
            [self resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}


@end
