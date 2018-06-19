//
//  ChooseEnvironmentViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/16/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "ChooseEnvironmentViewController.h"
#import <UIButton+WebCache.h>
#import "EnvironmentsModel.h"
#import "EnvironmentButton.h"

@interface ChooseEnvironmentViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIImageView *fakeSplashImageView;

@property (nonatomic, strong) NSArray *environments;

@end

@implementation ChooseEnvironmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLoginBackgroundImage];
    [self loadEnvironments];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadEnvironments {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkManager sharedManager] getEnvironmentsWithCompletion:^(id response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *localError = nil;
        if (!error) {
            NSArray *environments = [MTLJSONAdapter modelsOfClass:[EnvironmentsModel class] fromJSONArray:[response allValues] error:&localError];
            
            if (environments.count > 0) {
                
                for (EnvironmentsModel *model in environments) {
                    [self setupViewsForEnvironment:model];
                }
                
                [self.stackView setDistribution:UIStackViewDistributionFillEqually];
            }
        }
        
        NSLog(@"");
    }];
}

-(void)setupViewsForEnvironment:(EnvironmentsModel *)model {
    
    UIView *contentView = [UIView new];
    
    EnvironmentButton *backgroundButton = [[EnvironmentButton alloc] init];
    backgroundButton.environment = model.environmentName;
    [backgroundButton addTarget:self action:@selector(environmentSelected:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundButton sd_setImageWithURL:[model.environmentImage withBaseUrl] forState:UIControlStateNormal];
    [backgroundButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    UILabel *contentLabel = [UILabel new];
    [contentLabel setFont:[UIFont fontWithName:@"Oswald-Light" size:30.f]];
    contentLabel.text = [model.environmentName uppercaseString];
    [contentLabel setUserInteractionEnabled:NO];
    contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [contentLabel setTextColor:[UIColor whiteColor]];
    [contentLabel setTextAlignment:NSTextAlignmentCenter];
    [backgroundButton addSubview:contentLabel];
    
    
    backgroundButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [contentView addSubview:backgroundButton];

    [self.stackView addArrangedSubview:contentView];
}

-(void)environmentSelected:(EnvironmentButton *)button {
    
    [[UserDefaultsManager standardUserDefaults] setObject:button.environment forKey:Default_SelectedEnvironment];
         
    [Helper showPlatesScreen];
}

@end
