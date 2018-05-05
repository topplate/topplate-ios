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
#import "SocialLoginModelHelper.h"

@import GoogleSignIn;

@interface WelcomeViewController () <GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, strong) NSString *environment;

@property (nonatomic, strong) SocialLoginModelHelper *modelHelper;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLoginBackgroundImage];
    
    self.modelHelper = [modelsManager getModel:HelperTypeSocialLogin];
    
    [self.segmentControl setSelectedSegmentIndex:[self getSelectedEnvironmentIndex]];
    [self segmentValueChange:self.segmentControl];
    
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
        [[UserDefaultsManager standardUserDefaults] setObject:@"restaurant" forKey:Default_SelectedEnvironment];
    } else {
        [[UserDefaultsManager standardUserDefaults] setObject:@"homemade" forKey:Default_SelectedEnvironment];
    }
}

- (IBAction)connectWithGoogle:(id)sender {
    
    [self.modelHelper loginWithGoogle:self];
    [self setEnvironment];
}

- (IBAction)connectWithFacebook:(id)sender {
    
    [self.modelHelper loginWithFacebook:self];
    [self setEnvironment];
}

- (IBAction)connectWithEmail:(id)sender {
    
    [self setEnvironment];
    
    UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SignInViewController *signInViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self.navigationController pushViewController:signInViewController animated:YES];
}

- (IBAction)skipToPlates:(id)sender {
    
    [Helper showPlatesScreen];
}

-(void)setEnvironment {
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [[UserDefaultsManager standardUserDefaults] setObject:@"restaurant" forKey:Default_SelectedEnvironment];
    } else {
        [[UserDefaultsManager standardUserDefaults] setObject:@"homemade" forKey:Default_SelectedEnvironment];
    }
}

-(NSInteger)getSelectedEnvironmentIndex {
    if (isHomeMadeEnv) {
        return 1;
    } else {
        return 0;
    }
}

@end
