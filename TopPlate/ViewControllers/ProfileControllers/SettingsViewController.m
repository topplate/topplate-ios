//
//  SettingsViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/16/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import <StoreKit/StoreKit.h>
#import "ContactUsViewController.h"
#import "EditUserProfileViewController.h"

typedef NS_ENUM(NSInteger, CellType) {
    CellTypeEditProfile = 0,
    CellTypeContactUs,
    CellTypePrivacyPolicy,
    CellTypeTermsAndConditions,
    CellTypeRateUs,
    CellTypeLogOut
};

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<NSString *> *titlesArray;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArray = @[@"Edit profile", @"Contact us", @"Privacy policy", @"Terms & conditions", @"Rate us", @"Log out"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBounces:NO];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self setNavigationTitleViewImage];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titlesArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingsTableViewCell *settingsTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"SettingsTableViewCell" forIndexPath:indexPath];
    settingsTableViewCell.titleLabel.text = [self.titlesArray[indexPath.row] uppercaseString];
    
    if (indexPath.row % 2 == 0) {
        [settingsTableViewCell.contentView setBackgroundColor:[UIColor settingsDarkGreenColor]];
    } else {
        [settingsTableViewCell.contentView setBackgroundColor:[UIColor settingsLightGreenColor]];
    }
    
    [settingsTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return settingsTableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case CellTypeEditProfile: {
            EditUserProfileViewController *editUserProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditUserProfileViewController"];
            [self.navigationController pushViewController:editUserProfileViewController animated:YES];
        }
            break;
            
        case CellTypeContactUs: {
            ContactUsViewController *contactUsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            [self.navigationController pushViewController:contactUsViewController animated:YES];
        }
            break;
            
        case CellTypePrivacyPolicy: {
            
        }
            break;
            
        case CellTypeTermsAndConditions: {
            
        }
            break;
            
        case CellTypeRateUs: {
            [SKStoreReviewController requestReview];
        }
            break;
            
        case CellTypeLogOut: {
            
            UIAlertController *logoutAlert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you sure you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                SocialLoginModelHelper *helper = [modelsManager getModel:HelperTypeSocialLogin];
                [helper logout];
                [Helper showWelcomeScreenAsModal:NO];
            }];
            
            [logoutAlert addAction:cancelAction];
            [logoutAlert addAction:logoutAction];
            [self presentViewController:logoutAlert animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    
}


@end
