//
//  SplashScreenViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 6/2/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupImageView];
    
    SocialLoginModelHelper *socialLoginModelHelper = [modelsManager getModel:HelperTypeSocialLogin];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [socialLoginModelHelper processLoginWithCompletion:^(id result, NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (errorString) {
            //there is an error, while user sign in
            [Helper showWelcomeScreenAsModal:NO];
        } if (!errorString && !result) {
            //
        } else {
            //user is signed in
            [Helper showPlatesScreen];
            
            //post notification to updated related datasources
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserSignIn object:nil];
        }
    }];

    // Do any additional setup after loading the view.
}

-(void)setupImageView {
   
    UIImage *splashImage = [UIImage new];
    
    if (IS_IPHONE_5 || IS_IPHONE_6) {
        splashImage = [UIImage imageNamed:@"splash4.7"];
    }
    
    if (IS_IPHONE_6P) {
        splashImage = [UIImage imageNamed:@"splash5.5"];
    }
    
    if(IS_IPHONE_X) {
        splashImage = [UIImage imageNamed:@"splashX"];
    }
    
    [self.imageView setImage:splashImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
