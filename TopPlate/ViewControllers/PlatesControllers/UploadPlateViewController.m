//
//  UploadPlateViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "UploadPlateViewController.h"
#import "IngredientTableViewCell.h"
#import "JSImagePickerViewController.h"
#import <Photos/Photos.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "KeyboardState.h"

static NSString *kPlateNamePlaceholderText = @"Plate name";
static NSString *kPlateRecipePlaceholderText = @"Plate recipe";
static NSString *kPlateRestaurantNamePlaceholderText = @"Restaurant name";
static NSString *kPlateRestaurantLocationPlaceholderText = @"Restaurant location";


@interface UploadPlateViewController () <UITableViewDelegate, UITableViewDataSource, IngredientTableViewCellDelegate, JSImagePickerViewControllerDelegate, TPTextFieldDelegate, TPTextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@property (nonatomic, strong) PlateModelHelper *modelHelper;

@property (weak, nonatomic) IBOutlet TPTextView *plateNameTextView;
@property (weak, nonatomic) IBOutlet UIImageView *plateImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plateImageViewAspectC;

@property (weak, nonatomic) IBOutlet UIView *plateRestaurantView;
@property (weak, nonatomic) IBOutlet TPTextField *plateRestaurantName;
@property (weak, nonatomic) IBOutlet TPTextField *plateRestaurantLocation;

@property (weak, nonatomic) IBOutlet UIView *plateHomeMadeView;
@property (weak, nonatomic) IBOutlet TPTextView *plateRecipeTextView;

@property (weak, nonatomic) IBOutlet UITableView *ingredientsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ingredientsTableViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offsetToHomemadeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offsetToRestaurantView;

@property (nonatomic) CGRect currentResponderFrame;
@property (nonatomic, strong) KeyboardState *state;

@end

@implementation UploadPlateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modelHelper = [modelsManager getModel:HelperTypePlates];
    
    self.ingredientsTableView.delegate = self;
    self.ingredientsTableView.dataSource = self;
    
    self.ingredientsTableView.estimatedRowHeight = 2.0;
    self.ingredientsTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setupViews];
    
    if (self.modelHelper.currentPlate) {
        [self fillViewsWithInfo];
    } else {
        self.modelHelper.currentPlate = [PlateModel new];
    }
    
    self.modelHelper.currentPlate.plateEnvironment = getCurrentEnvironment;
    
    if (self.modelHelper.currentPlate.plateIngredients.count == 0) {
        [self addIngredientAnimated:YES];
    }
    
    NSLog(@"");
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addIngredientAnimated:) name:kNotificationAddNewIngredient object:nil];
    
    [self registerForKeyboardNotifications];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JSImagePickerViewControllerDelegate -

-(void)showImageSelection {
    
    JSImagePickerViewController *imagePicker = [[JSImagePickerViewController alloc] init];
    imagePicker.delegate = self;
    [imagePicker showImagePickerInController:self animated:YES];
}

- (void)imagePicker:(JSImagePickerViewController *)imagePicker didSelectImages:(NSArray *)images {
    
    if (images.count > 0) {
        [self setImage:images.firstObject];
    }
}

- (void)imagePickerDidCancel {
    NSLog(@"");
}

#pragma mark - UITableViewDataSource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modelHelper.currentPlate.plateIngredients.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IngredientTableViewCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.textfield.customDelegate = self;
    [cell configureCellWithPlate:self.modelHelper.currentPlate andIndex:indexPath.row];
    
    if (indexPath.row == self.modelHelper.currentPlate.plateIngredients.count - 1) {
        cell.textFieldOffsetToView.constant = 38;
        [cell.addIngredientButton setHidden:NO];
    } else {
        cell.textFieldOffsetToView.constant = 0;
        [cell.addIngredientButton setHidden:YES];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - Actions -

- (IBAction)addIngredientAction:(id)sender {
    //
    //    if (self.modelHelper.currentPlate.plateIngredients.count == 0) {
    //        [self addIngredient];
    //    } else {
    //        NSString *lastIngredient = self.modelHelper.currentPlate.plateIngredients.lastObject;
    //
    //        if ([lastIngredient trimWhiteSpaces].length > 0) {
//    [self addIngredient];
    //        }
    //    }
}

-(void)addIngredientAnimated:(BOOL)animated {
    
    [self.modelHelper.currentPlate.plateIngredients addObject:@""];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.modelHelper.currentPlate.plateIngredients.count - 1 inSection:0];
    [self.ingredientsTableView beginUpdates];
    [self.ingredientsTableView
     insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationFade];
    [self.ingredientsTableView endUpdates];
    
    [self updateItemsTableViewHeight:!animated];
    
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width - 1, self.scrollView.contentSize.height - 1, 1, 1) animated:YES];
    
    [self.ingredientsTableView reloadData];
}

- (IBAction)submitAction:(id)sender {
    
    [self fillModelsWithData];
    
    if ([self validateTextFields]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.modelHelper uploadPlateWithModel:self.modelHelper.currentPlate completion:^(BOOL result, NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            //                    self.modelHelper.currentPlate = nil;
        }];
    }
}

#pragma mark - IngredientTableViewCellDelegate -

-(void)shouldReloadTableViewWithIndex:(NSInteger)index {
    
    [self.ingredientsTableView reloadData];
    
    [self updateItemsTableViewHeight:YES];
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
    
    self.state = [[KeyboardState alloc] initWithUserInfo:info];
    
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat currentResponderFinalPoint = self.currentResponderFrame.origin.y + self.currentResponderFrame.size.height;
    
    CGFloat maxValue;
    
    if (self.scrollView.contentSize.height > self.scrollView.height) {
        maxValue = self.scrollView.contentSize.height;
    } else { maxValue = self.scrollView.height; }
    
    
    CGFloat distToBottom = self.scrollView.height - currentResponderFinalPoint;
    
    
    if(distToBottom < keyboardRect.size.height) {
        
        CGFloat diff = currentResponderFinalPoint - keyboardRect.origin.y + 10;
        
        [UIView animateWithDuration:.25 animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, diff)];
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    
    self.state.isVisible = NO;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    //    [UIView animateWithDuration:.25 animations:^{
    //        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width - 1, self.scrollView.contentSize.height - 1, 1, 1) animated:NO];
    //    } completion:nil];
}

#pragma mark - LayoutHelpers -

- (void)updateItemsTableViewHeight:(BOOL)animated
{
    NSUInteger totalHeight = 0;
    
    for (NSUInteger index = 0; index < self.modelHelper.currentPlate.plateIngredients.count; index++) {
        CGFloat height =  [self tableView:self.ingredientsTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        totalHeight += height;
    }
    
    self.ingredientsTableViewHeight.constant = totalHeight;
    if (animated) {
        [self layoutIfNeeded];
    }
}

-(void)setupViews {
    
    self.plateRestaurantName.customDelegate = self;
    self.plateRestaurantLocation.customDelegate = self;
    self.plateNameTextView.customDelegate = self;
    self.plateRecipeTextView.customDelegate = self;
    
    self.plateNameTextView.placeholderText = kPlateNamePlaceholderText;
    self.plateRecipeTextView.placeholderText = kPlateRecipePlaceholderText;
    self.plateRestaurantName.placeHolderText = kPlateRestaurantNamePlaceholderText;
    self.plateRestaurantLocation.placeHolderText = kPlateRestaurantLocationPlaceholderText;
    
    if (isHomeMadeEnv) {
        self.offsetToHomemadeView.priority = 1000;
        self.offsetToRestaurantView.priority = 250;
        [self.plateRestaurantView setHidden:YES];
    } else {
        self.offsetToRestaurantView.priority = 1000;
        self.offsetToHomemadeView.priority = 250;
        [self.plateHomeMadeView setHidden:YES];
        [self.plateRestaurantName roundFrame];
        [self.plateRestaurantLocation roundFrame];
    }
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageSelection)];
    imageTap.numberOfTapsRequired = 1;
    [self.plateImageView addGestureRecognizer:imageTap];
    [self.plateImageView setUserInteractionEnabled:YES];
    [self.submitButton roundFrame];
    
    
    UITapGestureRecognizer *keyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    keyboardTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:keyboardTap];
    
    self.plateNameTextView.textViewValueChange = ^(NSString *text) {
        self.modelHelper.currentPlate.plateName = text;
    };
    
    self.plateRecipeTextView.textViewValueChange = ^(NSString *text) {
        self.modelHelper.currentPlate.plateReceipt = text;
    };
}

-(void)layoutIfNeeded {
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - ViewControllerHelpers -

-(void)setImage:(UIImage *)image {
    
    self.plateImageView.image = image;
    self.modelHelper.currentPlate.plateImage = image;
    
    [NSLayoutConstraint deactivateConstraints:self.plateImageView.constraints];
    
    [self.plateImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.plateImageView addConstraint:[NSLayoutConstraint
                                        constraintWithItem:self.plateImageView
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.plateImageView
                                        attribute:NSLayoutAttributeWidth
                                        multiplier:(self.plateImageView.image.size.height / self.plateImageView.image.size.width)
                                        constant:0]];
    [self layoutIfNeeded];
}

-(void)fillModelsWithData {
    
    self.modelHelper.currentPlate.plateUser = getCurrentUser;
    
    self.modelHelper.currentPlate.plateName = self.plateNameTextView.text;
    self.modelHelper.currentPlate.plateReceipt = self.plateRecipeTextView.text;
    
    self.modelHelper.currentPlate.plateRestaurantName = self.plateRestaurantName.text;
    self.modelHelper.currentPlate.plateAuthorLocation = self.plateRestaurantLocation.text;
    self.modelHelper.currentPlate.plateEnvironment = getCurrentEnvironment;
}

-(void)fillViewsWithInfo {
    
    NSString *modelPlateName = [self.modelHelper.currentPlate.plateName trimWhiteSpaces];
    
    if(modelPlateName.length > 0) {
        self.plateNameTextView.text = modelPlateName;
    }
    
    UIImage *modelPlateImage = self.modelHelper.currentPlate.plateImage;
    
    if (modelPlateImage) {
        [self setImage:modelPlateImage];
    }
    
    if(isRestaurantEnv) {
        
        NSString *modelRestaurantName = [self.modelHelper.currentPlate.plateRestaurantName trimWhiteSpaces];
        
        if (modelRestaurantName.length > 0) {
            self.plateRestaurantName.text = modelRestaurantName;
        }
        
        NSString *modelRestaurantLocation = [self.modelHelper.currentPlate.plateAuthorLocation trimWhiteSpaces];
        
        if (modelRestaurantLocation.length > 0) {
            self.plateRestaurantLocation.text = modelRestaurantLocation;
        }
    } else {
        
        NSString *modelPlateRecipe = [self.modelHelper.currentPlate.plateReceipt trimWhiteSpaces];
        
        if (modelPlateRecipe.length > 0) {
            self.plateRecipeTextView.text = modelPlateRecipe;
        }
        
        [self.ingredientsTableView reloadData];
        [self updateItemsTableViewHeight:NO];
    }
}

-(void)hideKeyboard {
    
    [self.view endEditing:YES];
}

-(BOOL)validateTextFields {
    
    BOOL validatationPassed = YES;
    
    NSMutableString *errorMesage = [NSMutableString new];
    
    if ([self.modelHelper.currentPlate.plateName isEqualToString:kPlateNamePlaceholderText] || self.modelHelper.currentPlate.plateName.length < 2) {
        [errorMesage appendString:@"Plate name cannot be less then 5 letters\n"];
        validatationPassed = NO;
    }
    
    if (!self.modelHelper.currentPlate.plateImage) {
        [errorMesage appendString:@"Plate should have an image\n"];
        validatationPassed = NO;
    }
    
    if (isHomeMadeEnv) {
        if ([self.modelHelper.currentPlate.plateReceipt isEqualToString:kPlateRecipePlaceholderText] || self.modelHelper.currentPlate.plateReceipt.length < 2 ) {
            [errorMesage appendString:@"Plate recipe cannot be less then 10 symbols"];
            validatationPassed = NO;
        }
    } else {
        if ([self.modelHelper.currentPlate.plateRestaurantName isEqualToString:kPlateRestaurantNamePlaceholderText] ||  self.modelHelper.currentPlate.plateRestaurantName.length < 2) {
            [errorMesage appendString:@"Restaurant name cannot be less then 5 symbols\n"];
            validatationPassed = NO;
        }
        
        if ([self.modelHelper.currentPlate.plateAuthorLocation isEqualToString:kPlateRestaurantLocationPlaceholderText] ||  self.modelHelper.currentPlate.plateAuthorLocation.length <= 0 ) {
            [errorMesage appendString:@"Restaurant location cannot be empty"];
            validatationPassed = NO;
        }
    }
    
    if (!validatationPassed) {
        [Helper showWarningMessage:errorMesage forViewController:self];
    }
    
    return validatationPassed;
}

#pragma mark - TPTextFieldDelegate -

-(void)textFieldIsCurrentResponder:(UITextField *)textField {
    
    if (isRestaurantEnv) {
        self.currentResponderFrame = [self getRectForTextFieldInView:textField];
    } else {
        self.currentResponderFrame = [self getRectForTextFieldInTableView:textField];
    }
}

- (void)textFieldReturnPressed:(UITextField *)textField {
    
    UITextField *nextResponder = [textField.window viewWithTag:textField.tag + 1];
    
    //    if (nextResponder) {
    //        [nextResponder becomeFirstResponder];
    //        [self scrollToNextResponder:nextResponder];
    //    } else {
    [textField resignFirstResponder];
    //    }
}


#pragma mark - TPTextViewDelegate -

-(void)textViewFrameChange:(UITextView *)textView {
    self.currentResponderFrame = [self getRectForTextFieldInView:textView];
    if ([self.state isVisible]) {
        [self adoptViewForKeyboard];
    }
}

-(void)textViewValueChange:(UITextView *)textView {
    self.currentResponderFrame = [self getRectForTextFieldInView:textView];
}

#pragma mark - KeyboardHelpers -

-(void)adoptViewForKeyboard {
    
    CGFloat currentResponderFinalPoint = self.currentResponderFrame.origin.y + self.currentResponderFrame.size.height;
    
    CGFloat distToBottom = self.scrollView.height - currentResponderFinalPoint;
    
    if(distToBottom < self.state.keyboardRect.size.height) {
        
        CGFloat diff = currentResponderFinalPoint - self.state.keyboardRect.origin.y + 10;
        
        [self.scrollView setContentOffset:CGPointMake(0, diff) animated:NO];
    }
}

-(CGRect)getRectForTextFieldInTableView:(UITextField *)textField {
    
    IngredientTableViewCell *cell = (IngredientTableViewCell *)[[textField superview] superview];
    
    NSIndexPath *indexPath = [self.ingredientsTableView indexPathForCell:cell];
    CGRect cellRect = [self.ingredientsTableView rectForRowAtIndexPath:indexPath];
    
    CGRect cellContentView = [self.ingredientsTableView convertRect:cellRect toView:self.scrollContentView];
    CGFloat realY = [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom - self.view.height;
    
    cellContentView.origin.y += realY;
    return cellContentView;
}

-(CGRect)getRectForTextFieldInView:(UIView *)textField {
    
    UIView *textFieldSuperView = [textField superview];
    
    CGRect textFieldFrame = [textFieldSuperView convertRect:textField.frame toView:self.scrollContentView];
    CGFloat realY = [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom - self.view.height;
    
    textFieldFrame.origin.y += realY;
    
    return textFieldFrame;
}

-(void)scrollToNextResponder:(UITextField *)responder {
    
    CGRect responderRect;
    
    if (isRestaurantEnv) {
        responderRect = [self getRectForTextFieldInView:responder];
    } else {
        responderRect = [self getRectForTextFieldInTableView:responder];
    }
    
    [UIView animateWithDuration:.25 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, responderRect.origin.y + responderRect.size.height + 10) animated:NO];
    }];
}

@end
