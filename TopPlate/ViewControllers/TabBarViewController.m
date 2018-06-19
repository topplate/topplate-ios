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

@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    PlatesViewController *platesViewController = [getPlatesStoryboard instantiateViewControllerWithIdentifier:@"PlatesViewController"];
    UINavigationController *platesNavigationController = [[UINavigationController alloc] initWithRootViewController:platesViewController];
    platesViewController.title = @"";
    NSString *imageName = isRestaurantEnv ? @"restaurant" : @"homemade";
    platesViewController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    platesViewController.tabBarItem.tag = 0;
    
    SearchViewController *searchViewController = [getSearchStoryboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchViewController.title = @"";
    searchViewController.tabBarItem.image = [[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    searchViewController.tabBarItem.tag = 1;
    
    UploadPlateViewController *uploadPlateViewController = [getUploadPlateStoryboard instantiateViewControllerWithIdentifier:@"UploadPlateViewController"];
    UINavigationController *uploadPlateNavigationController = [[UINavigationController alloc] initWithRootViewController:uploadPlateViewController];
    uploadPlateViewController.title = @"";
    uploadPlateViewController.tabBarItem.image = [[UIImage imageNamed:@"submit photo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    uploadPlateViewController.tabBarItem.tag = 2;
    
    WinnersViewController *winnersViewController = [getWinnersStoryboard instantiateViewControllerWithIdentifier:@"WinnersViewController"];
    UINavigationController *winnersNavigationController = [[UINavigationController alloc] initWithRootViewController:winnersViewController];
    winnersViewController.title = @"";
    winnersViewController.tabBarItem.image = [[UIImage imageNamed:@"winners"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    winnersViewController.tabBarItem.tag = 3;
    
    ProfileViewController *profileViewController = [getProfileStoryboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    profileViewController.title = @"";
    profileViewController.tabBarItem.image = [[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    profileViewController.tabBarItem.tag = 4;
    
    self.viewControllers= [NSArray arrayWithObjects:
                           platesNavigationController,
                           searchNavigationController,
                           uploadPlateNavigationController,
                           winnersNavigationController,
                           profileNavigationController,
                           nil];
    
    self.tabBar.barTintColor = [UIColor clearColor];
    
    [self.tabBar setTranslucent:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self underLineTabBarItem:nil];
    });
    
    // Do any additional setup after loading the view.
}

-(void)underLineTabBarItem:(UITabBarItem *)tabBarItem {
    
    [self.bottomLineView removeFromSuperview];
    
    UIView *selectedItemView = [self getTabBarItemsViews][tabBarItem.tag ?: 0];
    
    self.bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, selectedItemView.height - 1, 0, 1)];
    [self.bottomLineView setBackgroundColor:[UIColor yellowColor]];
    self.bottomLineView.tag = 777;
    [selectedItemView addSubview:self.bottomLineView];
    
    [UIView animateWithDuration:.25 animations:^{
        self.bottomLineView.width = selectedItemView.width;
    }];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self underLineTabBarItem:item];
}

-(NSArray *)getTabBarItemsViews {
    
    //sorting TabBar subview by origin.x
    //all the element are in order by origin.x
    
    NSComparator comparatorBlock = ^(UIView *obj1, UIView *obj2) {
        if (obj1.x > obj2.x) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (obj1.x < obj2.x) {
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            
            return (NSComparisonResult)NSOrderedSame;
        }
    };
    
    NSMutableArray *sortedSubViews = [NSMutableArray new];
    sortedSubViews = [self.tabBar.subviews mutableCopy];
    
    [sortedSubViews sortUsingComparator:comparatorBlock];
    
    
    for (int i = 0; i < sortedSubViews.count; i++) {
        UIView *constView = sortedSubViews[i];
        
        //looking for a UIBarBackground, which width is always equals to screen width
        if (constView.width == [UIScreen mainScreen].bounds.size.width) {
            
            //removing this view
            [sortedSubViews removeObject:constView];
        }
        
        //as a result we are having just sorted UITabBarButtons
    }
    
    return sortedSubViews;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
