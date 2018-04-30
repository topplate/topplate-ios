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
    
    self.uploadedPlate.plateEnvironment = [UserDefaultsManager loadCustomObjectForKey:Default_SelectedEnvironment];
    
    [self setLoginBackgroundImage];
    
    [self setupViews];
    
    // Do any additional setup after loading the view.
}

-(void)setupViews {
    
    self.plateNameTextView.placeholderText = @"Plate name";
    self.plateRecipeTextView.placeholderText = @"Plate recipe";
    
    
//    if ([[UserDefaultsManager loadCustomObjectForKey:Default_SelectedEnvironment] isEqualToString:@"homemade"]) {
        self.offsetToHomemadeView.priority = 1000;
        self.offsetToRestaurantView.priority = 250;
        [self.plateRestaurantView setHidden:YES];
//    } else {
//        self.offsetToRestaurantView.priority = 1000;
//        self.offsetToHomemadeView.priority = 250;
//        [self.plateHomeMadeView setHidden:YES];
//        [self.plateRestaurantName roundFrame];
//        [self.plateRestaurantLocation roundFrame];
//    }
    
    
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
    
    if ([self validateTextFields]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.modelHelper uploadPlateWithModel:self.uploadedPlate completion:^(BOOL result, NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"");
        }];
    }
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
    
    if (self.uploadedPlate.plateName.length <= 0) {
        [errorMesage appendString:@"Plate name cannot be empty\n"];
        validatationPassed = NO;
    }
    
    if (!self.uploadedPlate.plateImage) {
        [errorMesage appendString:@"Plate should have image\n"];
        validatationPassed = NO;
    }
    
    if (self.uploadedPlate.plateReceipt.length <= 0) {
        [errorMesage appendString:@"Plate recipe could not be empty"];
        validatationPassed = NO;
    }
    
    if (!validatationPassed) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:errorMesage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    return validatationPassed;
}

-(void)layoutIfNeeded {
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
