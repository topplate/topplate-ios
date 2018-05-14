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

@interface CustomTabBarViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *bottomButtonsViews;

@property (weak, nonatomic) IBOutlet UIButton *platesButton;

@property (nonatomic, strong) UIBarButtonItem *leftBarItem;

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopPlateLogo"]];
    imageView.frame = CGRectMake(0, 0, self.view.width / 4, 40);
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItem = item;
    
    UIFont *font = [UIFont boldSystemFontOfSize:13.f];
    NSDictionary *attributes = @{NSFontAttributeName: font};

    self.leftBarItem = [[UIBarButtonItem alloc] initWithTitle:getCurrentEnvironment style:UIBarButtonItemStylePlain target:self action:@selector(environmentChangeSelected)];
    [self.leftBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.leftBarItem setTitleTextAttributes:attributes forState:UIControlStateSelected];

    self.navigationItem.rightBarButtonItem = self.leftBarItem;
    
//    [self setNavigationTitleViewImage];
    [self platesSelected:nil];
    [self setBackgroundImage];
    
    if (isRestaurantEnv) {
        [self.platesButton setImage:[UIImage imageNamed:@"restaurant"] forState:UIControlStateNormal];
    } else {
        [self.platesButton setImage:[UIImage imageNamed:@"homemade"] forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view.
}

-(void)environmentChangeSelected {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select environment"
                                        message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Restaurant"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Gallery");
                                                
                                                self.leftBarItem.title = @"Restaurant";
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Homemade"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Camera");
                                                self.leftBarItem.title = @"Homemade";

                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Camera");
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions -

- (IBAction)platesSelected:(id)sender {
    
    UIStoryboard *platesStoryboard = [UIStoryboard storyboardWithName:@"Plates" bundle:nil];
    PlatesViewController *platesViewController = [platesStoryboard instantiateViewControllerWithIdentifier:@"PlatesViewController"];
    
    if (![self sameAsCurrentViewController:platesViewController]) {
        [self removeChildViewControllers];
        [self addChildViewController:platesViewController];
        [self highLightButton:sender];
    }
}

- (IBAction)searchSelected:(id)sender {
    
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
    
    UIStoryboard *winnersStoryboard = [UIStoryboard storyboardWithName:@"Winners" bundle:nil];
    WinnersViewController *winnersViewController = [winnersStoryboard instantiateViewControllerWithIdentifier:@"WinnersViewController"];
    
    if (![self sameAsCurrentViewController:winnersViewController]) {
        [self removeChildViewControllers];
        [self addChildViewController:winnersViewController];
        [self highLightButton:sender];
    }
}

- (IBAction)profileSelected:(id)sender {
    
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

-(BOOL)sameAsCurrentViewController:(UIViewController *)viewController {
    
    UIViewController *currentViewController = self.childViewControllers.firstObject;
    
    if ([currentViewController.restorationIdentifier isEqualToString:viewController.restorationIdentifier]) {
        return YES;
    }
    
    return NO;
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
