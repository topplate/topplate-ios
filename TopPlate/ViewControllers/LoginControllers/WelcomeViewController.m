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
@property (weak, nonatomic) IBOutlet TPButton *googleButton;
@property (weak, nonatomic) IBOutlet TPButton *facebookButton;
@property (weak, nonatomic) IBOutlet TPButton *emailButton;

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
    
    [self.googleButton setImageWithName:@"googlePlusIcon" backgroundСolor:[UIColor googleButtonBackgroundColor] andTitle:@"Connect with G+"];
    [self.facebookButton setImageWithName:@"facebookIcon" backgroundСolor:[UIColor facebookButtonBackgroundColor] andTitle:@"Connect with Facebook"];
    [self.emailButton setImageWithName:@"emailIcon" backgroundСolor:[UIColor emailButtonBackgroundColor] andTitle:@"Connect with Email"];
    
    NSDictionary *segmentedSelectedTitleColor = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:13.f]};
    [self.segmentControl setTitleTextAttributes:segmentedSelectedTitleColor forState:UIControlStateSelected];
    
    NSDictionary *segmentedUnSelectedTitleColor = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    [self.segmentControl setTitleTextAttributes:segmentedUnSelectedTitleColor forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions -

- (IBAction)segmentValueChange:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        [[UserDefaultsManager standardUserDefaults] setObject:@"restaurant" forKey:Default_SelectedEnvironment];
    } else {
        [[UserDefaultsManager standardUserDefaults] setObject:@"homemade" forKey:Default_SelectedEnvironment];
    }
}

- (IBAction)connectWithGoogle:(id)sender {
    
    [self.modelHelper loginWithGoogle:self withCompletion:^(id result, NSString *errorString) {
        if (errorString) {
            [Helper showErrorMessage:errorString forViewController:self];
        } else {
            [self setEnvironment];
            
            if (self.presentedModaly) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [Helper showPlatesScreen];
            }
        }
    }];
}

- (IBAction)connectWithFacebook:(id)sender {
    
    [self.modelHelper loginWithFacebook:self withCompletion:^(id result, NSString *errorString) {
        if (errorString) {
            [Helper showErrorMessage:errorString forViewController:self];
        } else {
            [self setEnvironment];
            
            if (self.presentedModaly) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [Helper showPlatesScreen];
            }        }
    }];
}

- (IBAction)connectWithEmail:(id)sender {
    
    [self setEnvironment];
    
    UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SignInViewController *signInViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self.navigationController pushViewController:signInViewController animated:YES];
}

- (IBAction)skipToPlates:(id)sender {
    
    [Helper showPlatesScreen];
    [self.modelHelper logout];
}

-(void)setEnvironment {
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [[UserDefaultsManager standardUserDefaults] setObject:@"restaurant" forKey:Default_SelectedEnvironment];
    } else {
        [[UserDefaultsManager standardUserDefaults] setObject:@"homemade" forKey:Default_SelectedEnvironment];
    }
}

-(NSInteger)getSelectedEnvironmentIndex {
    if (getCurrentEnvironment) {
        if (isHomeMadeEnv) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
    
}

@end
