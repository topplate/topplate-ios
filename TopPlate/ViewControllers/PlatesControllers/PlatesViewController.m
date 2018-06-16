//
//  PlatesViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlatesViewController.h"
#import "PlatesTableViewCell.h"
#import "PlateInfoViewController.h"
#import "PlateModelHelper.h"
#import <UIImageView+WebCache.h>
#import "CharityTableViewCell.h"
#import "CharityViewController.h"

static int kDefaultLoadLimit = 10;

@interface PlatesViewController () <UITableViewDelegate, UITableViewDataSource, PlatesModelHelperDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PlateModelHelper *platesHelper;

@property (nonatomic, strong) UIRefreshControl *topRefreshControl;

@property (nonatomic, strong) UIBarButtonItem *rightBarItem;

@property (nonatomic) NSInteger limit;

@end

@implementation PlatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PlatesTableViewCell" bundle:nil] forCellReuseIdentifier:@"PlatesTableViewCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView.frame = CGRectZero;
    
    self.tableView.estimatedRowHeight = 315;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.limit = kDefaultLoadLimit;
    
    self.platesHelper = [modelsManager getModel:HelperTypePlates];
    self.platesHelper.delegate = self;
    
    if (self.platesHelper.plates.count <= 0) {
        [self loadPlates];
    }
    
    self.topRefreshControl = [[UIRefreshControl alloc] init];
    self.topRefreshControl.backgroundColor = [UIColor purpleColor];
    self.topRefreshControl.tintColor = [UIColor whiteColor];
    [self.topRefreshControl addTarget:self
                            action:@selector(refreshPlates)
                  forControlEvents:UIControlEventValueChanged];
    
    self.tableView.refreshControl = self.topRefreshControl;
    
    [self setupNavigationBar];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPlates) name:kNotificationUserSignIn object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNavigationBar {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopPlateLogo"]];
    imageView.frame = CGRectMake(0, 0, 100, 40);
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItem = item;
    
    UIFont *font = [UIFont boldSystemFontOfSize:13.f];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    self.rightBarItem = [[UIBarButtonItem alloc] initWithTitle:getCurrentEnvironment style:UIBarButtonItemStylePlain target:self action:@selector(environmentChangeSelected)];
    [self.rightBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.rightBarItem setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
    
    if (isRestaurantEnv) {
        [self restaurantEnvironmentSelected];
    } else {
        [self homemadeEnvironmentSelected];
    }
    
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    self.navigationItem.titleView = nil;
}

#pragma mark - UITableViewDataSource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.platesHelper.plates.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlateModel *plate = self.platesHelper.plates[indexPath.row];
    
    PlatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlatesTableViewCell" forIndexPath:indexPath];
    [cell setupLikeCellWithModel:plate];
    cell.parentViewController = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - UITableViewDelegate -

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.platesHelper.plates.count - 1 && self.limit != -1) {
        [self loadPlates];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 315;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlateModel *selectedPlate = self.platesHelper.plates[indexPath.row];
    [self loadPlateForId:selectedPlate.plateId atIndexPath:indexPath];
}

#pragma mark - PlatesModelHelperDelegate -

-(void)platesUpdated {
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)plateAtIndexIsUpdated:(NSInteger)plateIndex {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:plateIndex inSection:0];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

#pragma mark - Actions -

- (IBAction)showCharities:(id)sender {
    
    CharityViewController *charity = [self.storyboard instantiateViewControllerWithIdentifier:@"CharityViewController"];
    [self.navigationController pushViewController:charity animated:YES];
}

#pragma mark - Environment change -

-(void)restaurantEnvironmentSelected {
    
    self.tabBarController.tabBar.items[0].selectedImage = [[UIImage imageNamed:@"restaurant"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.rightBarItem.title = @"Restaurant";
    [[UserDefaultsManager standardUserDefaults] setObject:@"restaurant" forKey:Default_SelectedEnvironment];
}

-(void)homemadeEnvironmentSelected {
    
    self.tabBarController.tabBar.items[0].selectedImage = [[UIImage imageNamed:@"homemade"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.rightBarItem.title = @"Homemade";
    [[UserDefaultsManager standardUserDefaults] setObject:@"homemade" forKey:Default_SelectedEnvironment];
}

-(void)environmentChangeSelected {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select environment"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *restaurantAction = [UIAlertAction actionWithTitle:@"Restaurant"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^void (UIAlertAction *action) {
                                                                 NSLog(@"Selected restaurant environment");
                                                                 [self restaurantEnvironmentSelected];
                                                                 
                                                                 [self reloadPlates];
                                                                 
//                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationEnvironmentChange object:nil];
                                                             }];
    
    [restaurantAction setValue:[UIColor defaultDarkBackgroundColor] forKey:@"titleTextColor"];
    
    
    UIAlertAction *homeMadeAction = [UIAlertAction actionWithTitle:@"Homemade"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^void (UIAlertAction *action) {
                                                               NSLog(@"Selected homemade environment");
                                                               
                                                               [self reloadPlates];
                                                               
                                                               [self homemadeEnvironmentSelected];
                                                               
//                                                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationEnvironmentChange object:nil];
                                                           }];
    [homeMadeAction setValue:[UIColor defaultDarkBackgroundColor] forKey:@"titleTextColor"];
    
    if (isRestaurantEnv) {
        [restaurantAction setValue:[[UIImage imageNamed:@"ActionCheck"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    } else {
        [homeMadeAction setValue:[[UIImage imageNamed:@"ActionCheck"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^void (UIAlertAction *action) {
                                                             [self dismissViewControllerAnimated:alert completion:nil];
                                                         }];
    [cancelAction setValue:[UIColor defaultDarkBackgroundColor] forKey:@"titleTextColor"];
    
    [alert addAction:restaurantAction];
    [alert addAction:homeMadeAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Loading plates -

-(void)reloadPlates {
    self.limit = kDefaultLoadLimit;
    self.platesHelper.plates = nil;
    
    [self loadPlates];
}

-(void)refreshPlates {
    self.limit = kDefaultLoadLimit;
    
    [self loadPlates];
}

-(void)loadPlates {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.platesHelper getPlatesForEnvironment:getCurrentEnvironment
                                     withLimit:@(self.limit)
                               withLastPlateId:@""
                               completionBlock:^(NSArray *plates, NSString *errorString) {
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   
                                   [self.topRefreshControl endRefreshing];
                                   if (!errorString && plates.count < kDefaultLoadLimit) {
                                       self.limit = -1;
                                   }
                               }];
}

-(void)loadPlateForId:(NSString *)plateId atIndexPath:(NSIndexPath *)indexPath {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.platesHelper getPlateWithId:plateId
                      completionBlock:^(PlateModel *plate, NSString *errorString) {
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                          if (plate && !errorString) {
                              PlateInfoViewController *plateVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlateInfoViewController"];
                              plateVc.selectedPlate = plate;
                              [self.navigationController pushViewController:plateVc animated:YES];
                          }
                      }];
}

@end
