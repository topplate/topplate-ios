//
//  TPTextView.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/29/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TextViewValueChange)(NSString *text);

@interface TPTextView : UITextView <UITextViewDelegate>

@property (nonatomic, strong) NSString *placeholderText;

@property (nonatomic, strong) TextViewValueChange textViewValueChange;

@end
