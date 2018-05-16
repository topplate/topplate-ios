//
//  CustomTabBarViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "PlatesViewController.h"
#import "SearchViewController.h"
#import "UploadPlateViewController.h"
#import "WinnersViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"

@interface CustomTabBarViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *bottomButtonsViews;

@property (weak, nonatomic) IBOutlet UIButton *platesButton;

@property (nonatomic, strong) UIBarButtonItem *rightBarItem;

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBarForPlatesScreen];
    
    [self platesSelected:nil];
    [self setBackgroundImage];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation bar helpers -

-(void)setupNavigationBarForPlatesScreen {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopPlateLogo"]];
    imageView.frame = CGRectMake(0, 0, 100, 40);
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItem = item;
    
    UIFont *font = [UIFont boldSystemFontOfSize:13.f];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    self.rightBarItem = [[UIBarButtonItem alloc] initWithTitle:getCurrentEnvironment style:UIBarButtonItemStylePlain target:self action:@selector(environmentChangeSelected)];
    [self.rightBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.rightBarItem setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    if (isRestaurantEnv) {
        [self restaurantEnvironmentSelected];
    } else {
        [self homemadeEnvironmentSelected];
    }
    
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    self.navigationItem.titleView = nil;
}

-(void)setupNavigationBarForOtherScreens {
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self setNavigationTitleViewImage];
}

-(void)setupNavigationBarForProfileSettingsScreen {
    
    self.navigationItem.leftBarButtonItem = nil;
    [self setNavigationTitleViewImage];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moreIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showProfileSettingsScreen)];
}

-(void)showProfileSettingsScreen {
    UIStoryboard *proileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    SettingsViewController *settingsViewController = [proileStoryboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

#pragma mark - Environment change helpers -

-(void)restaurantEnvironmentSelected {
    [self.platesButton setImage:[UIImage imageNamed:@"restaurant"] forState:UIControlStateNormal];
    self.rightBarItem.title = @"Restaurant";
    [[UserDefaultsManager standardUserDefaults] setObject:@"restaurant" forKey:Default_SelectedEnvironment];
}

-(void)homemadeEnvironmentSelected {
    [self.platesButton setImage:[UIImage imageNamed:@"homemade"] forState:UIControlStateNormal];
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
                                                                 
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationEnvironmentChange object:nil];
                                                             }];
    
    [restaurantAction setValue:[UIColor defaultDarkBackgroundColor] forKey:@"titleTextColor"];
    
    
    UIAlertAction *homeMadeAction = [UIAlertAction actionWithTitle:@"Homemade"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^void (UIAlertAction *action) {
                                                               NSLog(@"Selected homemade environment");
                                                               
                                                               [self homemadeEnvironmentSelected];
                                                               
                                                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationEnvironmentChange object:nil];
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

#pragma mark - Actions -

- (IBAction)platesSelected:(id)sender {
    
    [self setupNavigationBarForPlatesScreen];
    
    UIStoryboard *platesStoryboard = [UIStoryboard storyboardWithName:@"Plates" bundle:nil];
    PlatesViewController *platesViewController = [platesStoryboard instantiateViewControllerWithIdentifier:@"PlatesViewController"];
    
    if (![self sameAsCurrentViewController:platesViewController]) {
        [self removeChildViewControllers];
        [self addChildViewController:platesViewController];
        [self highLightButton:sender];
    }
}

- (IBAction)searchSelected:(id)sender {
    
    [self setupNavigationBarForOtherScreens];
    
    UIStoryboard *searchStoryboard = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
    SearchViewController *searchViewController = [searchStoryboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    
    if (![self sameAsCurrentViewController:searchViewController]) {
        [self removeChildViewControllers];
        [self addChildViewController:searchViewController];
        [self highLightButton:sender];
    }
    
//    [Helper showWelcomeScreenAsModal:YES];
}

- (IBAction)uploadPlateSelected:(id)sender {
    
    [self setupNavigationBarForOtherScreens];
    
    UIStoryboard *uploadPlatesStoryboard = [UIStoryboard storyboardWithName:@"UploadPlate" bundle:nil];
    UploadPlateViewController *uploadViewController = [uploadPlatesStoryboard instantiateViewControllerWithIdentifier:@"UploadPlateViewController"];
    if (![self sameAsCurrentViewController:uploadViewController]) {
        [self removeChildViewControllers];
        [self addChildViewController:uploadViewController];
        [self highLightButton:sender];
        
        if (!getCurrentUser) {
            [Helper showWelcomeScreenAsModal:YES];
        }
    }
}

- (IBAction)winnersSelected:(id)sender {
    
    [self setupNavigationBarForOtherScreens];
    
    UIStoryboard *winnersStoryboard = [UIStoryboard storyboardWithName:@"Winners" bundle:nil];
    WinnersViewController *winnersViewController = [winnersStoryboard instantiateViewControllerWithIdentifier:@"WinnersViewController"];
    
    if (![self sameAsCurrentViewController:winnersViewController]) {
        [self removeChildViewControllers];
        [self addChildViewController:winnersViewController];
        [self highLightButton:sender];
    }
}

- (IBAction)profileSelected:(id)sender {
    
    [self setupNavigationBarForProfileSettingsScreen];
    
    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    ProfileViewController *profileViewController = [profileStoryboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    if (![self sameAsCurrentViewController:profileViewController]) {
        [self removeChildViewControllers];
        [self addChildViewController:profileViewController];
        [self highLightButton:sender];
        
        if (!getCurrentUser) {
            [Helper showWelcomeScreenAsModal:YES ];
        }
    }
}

#pragma mark - Container view helpers -

-(void)addChildViewController:(UIViewController *)childController {
    
    [super addChildViewController:childController];
    
    [self.contentView addSubview:childController.view];
    childController.view.frame = self.contentView.bounds;
    childController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [childController didMoveToParentViewController:self];
}

-(void)removeChildViewControllers {
    
    if (self.childViewControllers.count > 0) {
        UIViewController *currentViewController = self.childViewControllers.lastObject;
        
        [currentViewController willMoveToParentViewController:nil];
        [currentViewController.view removeFromSuperview];
        [currentViewController removeFromParentViewController];
    }
}

-(BOOL)sameAsCurrentViewController:(UIViewController *)viewController {
    
    UIViewController *currentViewController = self.childViewControllers.firstObject;
    
    if ([currentViewController.restorationIdentifier isEqualToString:viewController.restorationIdentifier]) {
        return YES;
    }
    
    return NO;
}

-(void)highLightButton:(UIButton *)button {
    
    for (UIView *view in self.bottomButtonsViews) {
        
        [UIView animateWithDuration:.15 animations:^{
            
            [view setAlpha:0.f];
            [view setBackgroundColor:[UIColor clearColor]];
        }];
    }
    
    UIView *selectedView = self.bottomButtonsViews[button.tag - (button ? 101 : 0)];
    
    [selectedView setBackgroundColor:[UIColor yellowColor]];
    [UIView animateWithDuration:.15f animations:^{
        [selectedView setAlpha:1.f];
    }];
}


@end
