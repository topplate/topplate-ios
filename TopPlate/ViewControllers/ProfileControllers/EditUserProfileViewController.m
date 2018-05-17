//
//  EditUserProfileViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/17/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "EditUserProfileViewController.h"

@interface EditUserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *maleGenderButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleGenderButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet TPTextView *descriptionTextView;

@property (nonatomic, strong) UIBarButtonItem *rightBarButton;
@property (nonatomic, strong) UIBarButtonItem *leftBarButton;

@end

@implementation EditUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self feelViewWithData];
    
    self.rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"editIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(editMode)];
    
    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    
    [self finishEditMode];
    
    // Do any additional setup after loading the view.
}

-(void)editMode {
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"confirm"] style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancelIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];

    self.navigationItem.rightBarButtonItems = @[saveButton, cancelButton];
    
    [self enterEditMode];
}

-(void)saveAction {
    
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = self.rightBarButton;

    [self finishEditMode];
}

-(void)cancelAction {
    
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    
    [self feelViewWithData];
    
    [self finishEditMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupViews {
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBounces:NO];
    
    [self.profileImageView circleView];
    [self.maleGenderButton roundFrame];
    [self.femaleGenderButton roundFrame];
    [self.descriptionTextView setPlaceholderText:@"Edit your description to tell us about yourself."];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyaboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

-(void)hideKeyaboard {
    [self.view endEditing:YES];
}

-(void)feelViewWithData {
    User *currentUser = getCurrentUser;
    
    [self.profileImageView sd_setImageWithURL:currentUser.userInfo.authorImageUrl];
    
    self.profileNameLabel.text = currentUser.userInfo.authorName;
    
    self.nameTextField.text = currentUser.userInfo.authorName;
}

-(void)enterEditMode {
    
    [self prepareTextFieldForEdit:self.nameTextField];
    [self prepareTextFieldForEdit:self.emailTextField];
    [self prepareTextFieldForEdit:self.passwordTextField];
    [self.descriptionTextView setUserInteractionEnabled:YES];
}

-(void)finishEditMode {
    
    [self finishTextField:self.nameTextField];
    [self finishTextField:self.emailTextField];
    [self finishTextField:self.passwordTextField];
    [self.descriptionTextView setUserInteractionEnabled:NO];
}

-(void)prepareTextFieldForEdit:(UITextField *)textField {
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setUserInteractionEnabled:YES];
    [textField setTextColor:[UIColor blackColor]];
}

-(void)finishTextField:(UITextField *)textField {
    [textField setBorderStyle:UITextBorderStyleNone];
    [textField setBackgroundColor:[UIColor clearColor]];
    [textField setUserInteractionEnabled:NO];
    [textField setTextColor:[UIColor whiteColor]];
}


@end
