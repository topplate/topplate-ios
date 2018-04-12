//
//  WelcomeViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "WelcomeViewController.h"
#import "PlatesViewController.h"

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
}

- (IBAction)connectWithGoogle:(id)sender {
    
}

- (IBAction)connectWithFacebook:(id)sender {
    
}

- (IBAction)connectWithEmail:(id)sender {
    
}

- (IBAction)skipToPlates:(id)sender {
    
    UIStoryboard *storyboard =  [UIStoryboard storyboardWithName:@"Plates" bundle:nil];
    PlatesViewController *platesViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlatesViewController"];
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    window.rootViewController = platesViewController;
    [window makeKeyAndVisible];
}

@end
