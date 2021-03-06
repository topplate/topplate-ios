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
#import "NSString+Helper.h"

@interface SignInViewController ()

@property (weak, nonatomic) IBOutlet TPTextField *emailTextField;
@property (weak, nonatomic) IBOutlet TPTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (nonatomic, strong) LoginModel *loginModel;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginModel = [LoginModel new];
    
    [self setLoginBackgroundImage];
    
    [self.signInButton roundCorners];
    [self.signUpButton roundCorners];
    
    [self.emailTextField roundFrame];
    [self.passwordTextField roundFrame];
    
    [self.passwordTextField setType:TextFieldTypeSecured];
    [self.emailTextField setPlaceHolderText:@"YOUR EMAIL"];
    [self.passwordTextField setPlaceHolderText:@"YOUR PASSWORD"];
    
    [self.emailTextField setType:TextFieldTypePlaceholder];
    [self.passwordTextField setType:TextFieldTypePlaceholder];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    
    self.passwordTextField.text = @"test";
    self.emailTextField.text = @"michael.myers@gmail.com";

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

-(void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Notification -

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    
    
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    

}

- (IBAction)loginSelected:(id)sender {
    
    LoginModelHelper *loginModel = [LoginModelHelper new];
    
    self.loginModel.email = self.emailTextField.text;
    self.loginModel.password = self.passwordTextField.text;
    
    if ([self validateTextFields]) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [loginModel singIn:self.loginModel withCompletion:^(BOOL result, NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:YES]; 
            
            if (errorString) {
                [Helper showErrorMessage:errorString forViewController:self];
            } else {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserSignIn object:nil];
                
                if (self.presentedModaly) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [Helper showPlatesScreen];
                }
            }
        }];
    }
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

-(BOOL)validateTextFields {
    
    BOOL validatationPassed = YES;
    
    NSMutableString *errorMesage = [NSMutableString new];
    
    if (![[self.loginModel.email trimWhiteSpaces] isValidEmailAddress]) {
        [errorMesage appendString:@"Email is invalid\n"];
        validatationPassed = NO;
    }
    
    if (self.loginModel.password.length < 4) {
        [errorMesage appendString:@"Password lenght should be greater then 4 symbols"];
        validatationPassed = NO;
    }
    
    if (!validatationPassed) {
        [Helper showWarningMessage:errorMesage forViewController:self];
    }
    
    return validatationPassed;
}



@end
