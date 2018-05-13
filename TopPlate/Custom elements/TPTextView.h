//
//  TPTextView.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/29/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPTextViewDelegate <NSObject>

-(void)textViewFrameChange:(UITextView *)textView;
-(void)textViewValueChange:(UITextView *)textView;

@end

typedef void (^TextViewValueChange)(NSString *text);

@interface TPTextView : UITextView <UITextViewDelegate>

@property (nonatomic, strong) NSString *placeholderText;

@property (nonatomic, strong) TextViewValueChange textViewValueChange;

@property (nonatomic, weak) id<TPTextViewDelegate>customDelegate;

@end
