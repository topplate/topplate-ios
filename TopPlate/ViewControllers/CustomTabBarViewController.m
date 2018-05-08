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
}

- (IBAction)uploadPlateSelected:(id)sender {
    
    if (getCurrentUser) {
        UIStoryboard *uploadPlatesStoryboard = [UIStoryboard storyboardWithName:@"UploadPlate" bundle:nil];
        UploadPlateViewController *uploadViewController = [uploadPlatesStoryboard instantiateViewControllerWithIdentifier:@"UploadPlateViewController"];
        
        if (![self sameAsCurrentViewController:uploadViewController]) {
            [self removeChildViewControllers];
            [self addChildViewController:uploadViewController];
            [self highLightButton:sender];
        }
        
    } else {
        [Helper showWelcomeScreen];
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

    if (getCurrentUser) {
        UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
        ProfileViewController *profileViewController = [profileStoryboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        
        if (![self sameAsCurrentViewController:profileViewController]) {
            [self removeChildViewControllers];
            [self addChildViewController:profileViewController];
            [self highLightButton:sender];
        }
        
    } else {
        [Helper showWelcomeScreen];
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
        [view setBackgroundColor:[UIColor clearColor]];
    }
    
    UIView *selectedView = self.bottomButtonsViews[button.tag - (button ? 101 : 0)];
    [selectedView setBackgroundColor:[UIColor yellowColor]];
}


@end
