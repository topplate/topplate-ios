//
//  WelcomeViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SignInViewController.h"
#import "PlatesViewController.h"
#import "CustomTabBarViewController.h"
#import "ChooseEnvironmentViewController.h"

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, strong) NSString *environment;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLoginBackgroundImage];
    
    self.environment = @"restaurant";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions -

- (IBAction)segmentValueChange:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        self.environment = @"restaurant";
    } else {
        self.environment = @"homemade";
    }
}

- (IBAction)connectWithGoogle:(id)sender {
    
}

- (IBAction)connectWithFacebook:(id)sender {
    
}

- (IBAction)connectWithEmail:(id)sender {
    
    UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SignInViewController *signInViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self.navigationController pushViewController:signInViewController animated:YES];
}

- (IBAction)skipToPlates:(id)sender {
    
    PlateModelHelper *helper = [modelsManager getModel:HelperTypePlates];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [helper getPlatesForEnvironments:self.environment completionBlock:^(NSArray *plates, NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!errorString) {
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Plates" bundle:nil];
            
            
            ChooseEnvironmentViewController *test = [story instantiateViewControllerWithIdentifier:@"ChooseEnvironmentViewController"];
            
            
            
//            UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"CustomTabBar" bundle:nil];
//            UINavigationController *customTabBarNavigationController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"customTabBarNavigationController"];
//
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            window.rootViewController = test;
            [window makeKeyAndVisible];
        }
    }];
}

@end
