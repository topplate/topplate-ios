//
//  SignUpViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet TPTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet TPTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet TPTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet TPTextField *emailTextField;
@property (weak, nonatomic) IBOutlet TPTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet TPTextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLoginBackgroundImage];
    [self.registerButton roundCorners];
    
    [self.firstNameTextField roundFrame];
    [self.lastNameTextField roundFrame];
    [self.userNameTextField roundFrame];
    [self.emailTextField roundFrame];
    [self.passwordTextField roundFrame];
    [self.confirmPasswordTextField roundFrame];
    
    [self.firstNameTextField setPlaceHolderText:@"YOUR FIRST NAME"];
    [self.lastNameTextField setPlaceHolderText:@"YOUR LAST NAME"];
    [self.userNameTextField setPlaceHolderText:@"YOUR USERNAME"];
    [self.emailTextField setPlaceHolderText:@"YOUR EMAIL"];
    [self.passwordTextField setPlaceHolderText:@"YOUR PASSWORD"];
    [self.confirmPasswordTextField setPlaceHolderText:@"REPEAT PASSWORD"];
    
    [self.firstNameTextField setType:TextFieldTypePlaceholder];
    [self.lastNameTextField setType:TextFieldTypePlaceholder];
    [self.userNameTextField setType:TextFieldTypePlaceholder];
    [self.emailTextField setType:TextFieldTypePlaceholder];
    
    [self.passwordTextField setType:TextFieldTypeSecured];
    [self.confirmPasswordTextField setType:TextFieldTypeSecured];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
}

-(void)hideKeyboard {
    [self.view endEditing:YES];
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
    
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0)];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    
    [self.scrollView setContentInset:UIEdgeInsetsZero];
}

- (IBAction)registerAction:(id)sender {
    
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
