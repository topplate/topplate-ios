//
//  SignInViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "ForgotPasswordViewController.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLoginBackgroundImage];
    
    [self.signInButton roundCorners];
    [self.signUpButton roundCorners];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginSelected:(id)sender {
    
    [[Helper rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)forgotPasswordSelected:(id)sender {
    
    UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ForgotPasswordViewController *forgotPasswordViewController = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
}

- (IBAction)signUpSelected:(id)sender {
    
    UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SignUpViewController *signUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}


- (IBAction)goBackSelected:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
