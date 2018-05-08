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

static NSString *kPlateNamePlaceholderText = @"Plate name";
static NSString *kPlateRecipePlaceholderText = @"Plate recipe";
static NSString *kPlateRestaurantNamePlaceholderText = @"Restaurant name";
static NSString *kPlateRestaurantLocationPlaceholderText = @"Restaurant location";


@interface UploadPlateViewController () <UITableViewDelegate, UITableViewDataSource, IngredientTableViewCellDelegate, JSImagePickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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

@property (weak, nonatomic) IBOutlet UIButton *addIngredientButton;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offsetToHomemadeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offsetToRestaurantView;

@end

@implementation UploadPlateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modelHelper = [modelsManager getModel:HelperTypePlates];
    
    self.ingredientsTableView.delegate = self;
    self.ingredientsTableView.dataSource = self;
    
    self.ingredientsTableView.estimatedRowHeight = 2.0;
    self.ingredientsTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self setLoginBackgroundImage];
    
    [self setupViews];
    
    if (self.modelHelper.currentPlate) {
        [self fillViewsWithInfo];
    } else {
        self.modelHelper.currentPlate = [PlateModel new];
    }
    
    self.modelHelper.currentPlate.plateEnvironment = getCurrentEnvironment;

     // Do any additional setup after loading the view.
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
    [cell configureCellWithPlate:self.modelHelper.currentPlate andIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - Actions -

- (IBAction)addIngredientAction:(id)sender {
    
    if (self.modelHelper.currentPlate.plateIngredients.count == 0) {
        [self addIngredient];
    } else {
        NSString *lastIngredient = self.modelHelper.currentPlate.plateIngredients.lastObject;
        
        if ([lastIngredient trimWhiteSpaces].length > 0) {
            [self addIngredient];
        }
    }
}

-(void)addIngredient {
    [self.modelHelper.currentPlate.plateIngredients addObject:@""];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.modelHelper.currentPlate.plateIngredients.count - 1 inSection:0];
    [self.ingredientsTableView beginUpdates];
    [self.ingredientsTableView
     insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationFade];
    [self.ingredientsTableView endUpdates];
    
    [self updateItemsTableViewHeight:YES];
    
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width - 1, self.scrollView.contentSize.height - 1, 1, 1) animated:YES];
}

- (IBAction)submitAction:(id)sender {
    
    [self fillModelsWithData];
    
    if ([self validateTextFields]) {
        
        self.modelHelper.currentPlate = nil;
        
        //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        [self.modelHelper uploadPlateWithModel:self.uploadedPlate completion:^(BOOL result, NSString *errorString) {
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //
        //            NSLog(@"");
        //        }];
    }
}

#pragma mark - IngredientTableViewCellDelegate -

-(void)shouldReloadTableViewWithIndex:(NSInteger)index {
    
    [self.ingredientsTableView reloadData];
    
    [self updateItemsTableViewHeight:YES];
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
    [self.addIngredientButton roundCorners];
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
    
    if ([self.modelHelper.currentPlate.plateName isEqualToString:kPlateNamePlaceholderText] || self.modelHelper.currentPlate.plateName.length < 5) {
        [errorMesage appendString:@"Plate name cannot be less then 5 letters\n"];
        validatationPassed = NO;
    }
    
    if (self.modelHelper.currentPlate.plateImage) {
        [errorMesage appendString:@"Plate should have an image\n"];
        validatationPassed = NO;
    }
    
    if (isHomeMadeEnv) {
        if ([self.modelHelper.currentPlate.plateReceipt isEqualToString:kPlateRecipePlaceholderText] || self.modelHelper.currentPlate.plateReceipt.length < 10 ) {
            [errorMesage appendString:@"Plate recipe cannot be less then 10 symbols"];
            validatationPassed = NO;
        }
    } else {
        if ([self.modelHelper.currentPlate.plateRestaurantName isEqualToString:kPlateRestaurantNamePlaceholderText] ||  self.modelHelper.currentPlate.plateRestaurantName.length < 5) {
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

@end
