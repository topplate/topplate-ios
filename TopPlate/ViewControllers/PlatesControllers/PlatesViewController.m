//
//  PlatesViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlatesViewController.h"
#import "PlatesTableViewCell.h"
#import "PlateInfoViewController.h"
#import "PlateModelHelper.h"
#import <UIImageView+WebCache.h>
#import "CharityTableViewCell.h"
#import "CharityViewController.h"

static int kDefaultLoadLimit = 10;

@interface PlatesViewController () <UITableViewDelegate, UITableViewDataSource, PlatesModelHelperDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PlateModelHelper *platesHelper;

@property (nonatomic) NSInteger limit;

@end

@implementation PlatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PlatesTableViewCell" bundle:nil] forCellReuseIdentifier:@"PlatesTableViewCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView.frame = CGRectZero;
    
    self.tableView.estimatedRowHeight = 315;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.limit = kDefaultLoadLimit;
    
    self.platesHelper = [modelsManager getModel:HelperTypePlates];
    self.platesHelper.delegate = self;
    
    if (self.platesHelper.plates.count <= 0) {
        [self loadPlates];
    }
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPlates) name:kNotificationEnvironmentChange object:nil];
}

-(void)reloadPlates {
    self.limit = kDefaultLoadLimit;
    self.platesHelper.plates = nil;
    
    [self loadPlates];
}

-(void)loadPlates {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.platesHelper getPlatesForEnvironment:getCurrentEnvironment
                                     withLimit:@(self.limit)
                               withLastPlateId:self.platesHelper.plates.count > 0 ? self.platesHelper.plates.lastObject.plateId : @""
                               completionBlock:^(NSArray *plates, NSString *errorString) {
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   if (!errorString && plates.count < kDefaultLoadLimit) {
                                       self.limit = -1;
                                   }
                                   NSLog(@"");
                               }];
}

-(void)loadPlateForId:(NSString *)plateId {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.platesHelper getPlateWithId:plateId
                      completionBlock:^(PlateModel *plate, NSString *errorString) {
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                          if (plate && !errorString) {
                              PlateInfoViewController *plateVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlateInfoViewController"];
                              plateVc.selectedPlate = plate;
                              [self.navigationController pushViewController:plateVc animated:YES];
                          }
                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.platesHelper.plates.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlateModel *plate = self.platesHelper.plates[indexPath.row];
    
    PlatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlatesTableViewCell" forIndexPath:indexPath];
    [cell setupCellWithModel:plate];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - UITableViewDelegate -

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.platesHelper.plates.count - 1 && self.limit != -1) {
        [self loadPlates];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 315;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlateModel *selectedPlate = self.platesHelper.plates[indexPath.row];
    [self loadPlateForId:selectedPlate.plateId];
}

#pragma mark - PlatesModelHelperDelegate -

-(void)modelIsUpdated {
    
    [self.tableView reloadData];
    
    if (self.tableView.contentSize.height > self.tableView.height) {
        [self.tableView setContentSize:CGSizeMake(self.tableView.width, self.tableView.contentSize.height + 50)];
    }
}

- (IBAction)showCharities:(id)sender {
    
    CharityViewController *charity = [self.storyboard instantiateViewControllerWithIdentifier:@"CharityViewController"];
    [self.navigationController pushViewController:charity animated:YES];
}

@end
