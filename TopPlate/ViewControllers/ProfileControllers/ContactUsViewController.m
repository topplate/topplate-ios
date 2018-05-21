//
//  ContactUsViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/17/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "ContactUsViewController.h"
#import "FeedbackViewController.h"

@interface ContactUsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sendFeedbackButton;

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitleViewImage];
    
    [self.sendFeedbackButton roundFrame];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendFeedbackAction:(id)sender {
    
    FeedbackViewController *feedbackViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}

@end
