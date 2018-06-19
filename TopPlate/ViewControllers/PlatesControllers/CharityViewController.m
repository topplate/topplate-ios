//
//  CharityViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 5/15/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "CharityViewController.h"
#import "CharityTableViewCell.h"

@interface CharityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *charityBanners;

@end

@implementation CharityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self loadBanners];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.charityBanners.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Charity *currentCharity = self.charityBanners[indexPath.row];
    
    CharityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CharityTableViewCell" forIndexPath:indexPath];
    [cell setupCellWithCharity:currentCharity];
    
    return  cell;
}

#pragma mark - API Requests -

-(void)loadBanners {
    
    CharityModelHelper *helper = [modelsManager getModel:HelperTypeCharity];
    [helper loadCharitiesWithCompletion:^(NSArray *charities, NSString *errorString) {
        if (errorString) {
            [Helper showErrorMessage:errorString forViewController:self];
        } else {
            self.charityBanners = [NSArray arrayWithArray:charities];
            [self.tableView reloadData];
        }
    }];
}

@end
