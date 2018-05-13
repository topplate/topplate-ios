//
//  TPButton.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/10/18.
//  Copyright © 2018 Enke. All rights reserved.
//

static CGFloat defaultImageBlurWidth = 45.f;
static CGFloat defaultTextLabelOffsetMuptilplier = 1.2;

#import "TPButton.h"

@implementation TPButton

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        
        [self aftherInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self aftherInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self aftherInit];
    }
    return self;
}

- (void)aftherInit {
    
}

-(void)setImageWithName:(NSString *)imageName backgroundСolor:(UIColor *)imageColor andTitle:(NSString *)title {
    
    UIView *blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, defaultImageBlurWidth, self.height)];
    [blurView setBackgroundColor:[UIColor blackColor]];
    [blurView setAlpha:.1f];
    [self addSubview:blurView];
    
    UIImageView *cutomButtonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [cutomButtonImage setFrame:blurView.bounds];
    [cutomButtonImage setContentMode:UIViewContentModeCenter];
    [self addSubview:cutomButtonImage];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(blurView.width * defaultTextLabelOffsetMuptilplier, 0, self.width - blurView.width * defaultTextLabelOffsetMuptilplier, self.height)];
    [titleLabel setText:title];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:13.f]];
    [self addSubview:titleLabel];
    
    [self setBackgroundColor:imageColor];
    [self roundCorners];
    
    [blurView setUserInteractionEnabled:NO];
    [cutomButtonImage setUserInteractionEnabled:NO];
    [titleLabel setUserInteractionEnabled:NO];
}

@end
