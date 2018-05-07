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

@property (nonatomic, strong) PlateModel *uploadedPlate;
@property (nonatomic, strong) PlateModelHelper *modelHelper;

@property (weak, nonatomic) IBOutlet TPTextView *plateNameTextView;
@property (weak, nonatomic) IBOutlet UIImageView *plateImageView;

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
    
    self.uploadedPlate = [PlateModel new];
    self.modelHelper = [modelsManager getModel:HelperTypePlates];
    
    self.ingredientsTableView.delegate = self;
    self.ingredientsTableView.dataSource = self;
    
    self.ingredientsTableView.estimatedRowHeight = 2.0;
    self.ingredientsTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.uploadedPlate.plateEnvironment = getCurrentEnvironment;
    
    [self setLoginBackgroundImage];
    
    [self setupViews];
    
    // Do any additional setup after loading the view.
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
}

-(void)showImageSelection {
    
    JSImagePickerViewController *imagePicker = [[JSImagePickerViewController alloc] init];
    imagePicker.delegate = self;
    [imagePicker showImagePickerInController:self animated:YES];
}

- (void)imagePicker:(JSImagePickerViewController *)imagePicker didSelectImages:(NSArray *)images {
    
    if (images.count > 0) {
        self.plateImageView.image = images.firstObject;
        self.uploadedPlate.plateImage = images.firstObject;
    }
    
    NSLog(@"");
}

- (void)imagePickerDidCancel {
    NSLog(@"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.uploadedPlate.plateIngredients.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IngredientTableViewCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    [cell configureCellWithPlate:self.uploadedPlate andIndex:indexPath.row];
    
    cell.textfield.placeholder = @"Type in ingredient";
    return cell;
}


- (IBAction)submitAction:(id)sender {
    
    [self fillModelsWithData];
    
    if ([self validateTextFields]) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.modelHelper uploadPlateWithModel:self.uploadedPlate completion:^(BOOL result, NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"");
        }];
    }
}

-(void)fillModelsWithData {
    
    self.uploadedPlate.plateUser = getCurrentUser;
    
    self.uploadedPlate.plateName = self.plateNameTextView.text;
    self.uploadedPlate.plateReceipt = self.plateRecipeTextView.text;
    
    self.uploadedPlate.plateRestaurantName = self.plateRestaurantName.text;
    self.uploadedPlate.plateAuthorLocation = self.plateRestaurantLocation.text;
    self.uploadedPlate.plateEnvironment = getCurrentEnvironment;
}

- (IBAction)addIngredientAction:(id)sender {
    
    [self.uploadedPlate.plateIngredients addObject:@""];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.uploadedPlate.plateIngredients.count - 1 inSection:0];
    [self.ingredientsTableView beginUpdates];
    [self.ingredientsTableView
     insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationFade];
    [self.ingredientsTableView endUpdates];
    
    [self updateItemsTableViewHeight];
}

- (void)updateItemsTableViewHeight
{
    NSUInteger totalHeight = 0;
    
    for (NSUInteger index = 0; index < self.uploadedPlate.plateIngredients.count; index++) {
        CGFloat height =  [self tableView:self.ingredientsTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        totalHeight += height;
    }
    
    self.ingredientsTableViewHeight.constant = totalHeight;
    [self layoutIfNeeded];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)shouldReloadTableViewWithIndex:(NSInteger)index {
    
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    //    [self.ingredientsTableView beginUpdates];
    //    [self.ingredientsTableView
    //     deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
    //
    //    [self.ingredientsTableView endUpdates];
    
    [self.ingredientsTableView reloadData];
    
    [self updateItemsTableViewHeight];
}

-(BOOL)validateTextFields {
    
    BOOL validatationPassed = YES;
    
    NSMutableString *errorMesage = [NSMutableString new];
    
    if ([self.uploadedPlate.plateName isEqualToString:kPlateNamePlaceholderText] || self.uploadedPlate.plateName.length < 5) {
        [errorMesage appendString:@"Plate name cannot be less then 5 symbols\n"];
        validatationPassed = NO;
    }
    
    if (!self.uploadedPlate.plateImage) {
        [errorMesage appendString:@"Plate should have image\n"];
        validatationPassed = NO;
    }
    
    if (isHomeMadeEnv) {
        if ([self.uploadedPlate.plateReceipt isEqualToString:kPlateRecipePlaceholderText] || self.uploadedPlate.plateReceipt.length < 10 ) {
            [errorMesage appendString:@"Plate recipe could not be less then 10 symbols"];
            validatationPassed = NO;
        }
    } else {
        if ([self.uploadedPlate.plateRestaurantName isEqualToString:kPlateRestaurantNamePlaceholderText] ||  self.uploadedPlate.plateRestaurantName.length < 5) {
            [errorMesage appendString:@"Restaurant name can not be less then 5 symbols\n"];
            validatationPassed = NO;
        }
        
        if ([self.uploadedPlate.plateAuthorLocation isEqualToString:kPlateRestaurantLocationPlaceholderText] ||  self.uploadedPlate.plateAuthorLocation.length <= 0 ) {
            [errorMesage appendString:@"Restaurant location can not be empty"];
            validatationPassed = NO;
        }
    }
    
    if (!validatationPassed) {
        [Helper showWarningMessage:errorMesage forViewController:self];
    }
    
    return validatationPassed;
}

-(void)layoutIfNeeded {
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
