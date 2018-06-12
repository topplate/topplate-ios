//
//  TabBarViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 6/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "TabBarViewController.h"
#import "PlatesViewController.h"
#import "SearchViewController.h"
#import "UploadPlateViewController.h"
#import "WinnersViewController.h"
#import "ProfileViewController.h"

@interface TabBarViewController () <UITabBarControllerDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    PlatesViewController *platesViewController = [getPlatesStoryboard instantiateViewControllerWithIdentifier:@"PlatesViewController"];
    UINavigationController *platesNavigationController = [[UINavigationController alloc] initWithRootViewController:platesViewController];
    platesViewController.title = @"";
    NSString *imageName = isRestaurantEnv ? @"restaurant" : @"homemade";
    platesViewController.tabBarItem.image = [UIImage imageNamed:imageName];
    
    SearchViewController *searchViewController = [getSearchStoryboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchViewController.title = @"";
    searchViewController.tabBarItem.image = [UIImage imageNamed:@"search"];
    
    UploadPlateViewController *uploadPlateViewController = [getUploadPlateStoryboard instantiateViewControllerWithIdentifier:@"UploadPlateViewController"];
    UINavigationController *uploadPlateNavigationController = [[UINavigationController alloc] initWithRootViewController:uploadPlateViewController];
    uploadPlateViewController.title = @"";
    uploadPlateViewController.tabBarItem.image = [UIImage imageNamed:@"submit photo"];
    
    WinnersViewController *winnersViewController = [getWinnersStoryboard instantiateViewControllerWithIdentifier:@"WinnersViewController"];
    UINavigationController *winnersNavigationController = [[UINavigationController alloc] initWithRootViewController:winnersViewController];
    winnersViewController.title = @"";
    winnersViewController.tabBarItem.image = [UIImage imageNamed:@"winners"];
    
    ProfileViewController *profileViewController = [getProfileStoryboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    profileViewController.title = @"";
    profileViewController.tabBarItem.image = [UIImage imageNamed:@"profile"];
    
    self.viewControllers= [NSArray arrayWithObjects:
                           platesNavigationController,
                           searchNavigationController,
                           uploadPlateNavigationController,
                           winnersNavigationController,
                           profileNavigationController,
                           nil];
    
    self.tabBar.barTintColor = [UIColor clearColor];
    
    [self.tabBar setTranslucent:YES];
    
    // Do any additional setup after loading the view.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
