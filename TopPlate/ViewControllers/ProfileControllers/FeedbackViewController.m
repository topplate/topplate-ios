//
//  FeedbackViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/18/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitleViewImage];
    
    [self.sendButton roundFrame];
    [self.nameTextField roundFrame];
    [self.emailTextField roundFrame];
    [self.feedbackTextView roundFrame];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
