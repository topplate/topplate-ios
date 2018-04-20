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

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitleViewImage];
    [self platesSelected:nil];
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

- (IBAction)platesSelected:(id)sender {
//    [self removeChildViewControllers];
    
    UIStoryboard *platesStoryboard = [UIStoryboard storyboardWithName:@"Plates" bundle:nil];
    PlatesViewController *platesViewController = [platesStoryboard instantiateViewControllerWithIdentifier:@"PlatesViewController"];
    [self addChildViewController:platesViewController];
}

- (IBAction)searchSelected:(id)sender {
//    [self removeChildViewControllers];
    
    UIStoryboard *searchStoryboard = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
    SearchViewController *searchViewController = [searchStoryboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self addChildViewController:searchViewController];
}

- (IBAction)uploadPlateSelected:(id)sender {
//    [self removeChildViewControllers];
    
    UIStoryboard *uploadPlatesStoryboard = [UIStoryboard storyboardWithName:@"UploadPlate" bundle:nil];
    UploadPlateViewController *uploadViewController = [uploadPlatesStoryboard instantiateViewControllerWithIdentifier:@"UploadPlateViewController"];
    [self addChildViewController:uploadViewController];
}

- (IBAction)winnersSelected:(id)sender {
//    [self removeChildViewControllers];
    
    UIStoryboard *winnersStoryboard = [UIStoryboard storyboardWithName:@"Winners" bundle:nil];
    WinnersViewController *winnersViewController = [winnersStoryboard instantiateViewControllerWithIdentifier:@"WinnersViewController"];
    [self addChildViewController:winnersViewController];
}

- (IBAction)profileSelected:(id)sender {
//    [self removeChildViewControllers];
    
    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    ProfileViewController *profileViewController = [profileStoryboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self addChildViewController:profileViewController];
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
        UIViewController *currentViewController = self.parentViewController.childViewControllers.lastObject;
        
        [currentViewController willMoveToParentViewController:nil];
        [currentViewController.view removeFromSuperview];
        [currentViewController removeFromParentViewController];
    }
}


@end
