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

static int kDefaultLoadLimit = 10;

@interface PlatesViewController () <UITableViewDelegate, UITableViewDataSource, PlatesModelHelperDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PlateModelHelper *platesHelper;

@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger skip;

@end

@implementation PlatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLoginBackgroundImage];
    [self setNavigationTitleViewImage];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView.frame = CGRectZero;
    
    self.tableView.estimatedRowHeight = 315;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.limit = kDefaultLoadLimit;
    self.skip = 0;
    
    self.platesHelper = [modelsManager getModel:HelperTypePlates];
    self.platesHelper.delegate = self;
    
    if (self.platesHelper.plates.count <= 0) {
        [self loadPlates];
    }
    
    // Do any additional setup after loading the view.
}

-(void)loadPlates {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.platesHelper getPlatesForEnvironment:getCurrentEnvironment
                                     withLimit:@(self.limit)
                                      withSkip:@(self.skip)
                               completionBlock:^(NSArray *plates, NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!errorString && plates.count < kDefaultLoadLimit) {
            self.limit = -1;
            self.skip = -1;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.platesHelper.plates.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CharityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CharityTableViewCell"];
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlatesTableViewCell" forIndexPath:indexPath];
    
    PlateModel *plate = self.platesHelper.plates[indexPath.row];
    
    cell.plateName.text = [plate.plateName uppercaseString];
    [cell.plateImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"https://top-plate.herokuapp.com/", plate.plateImages.firstObject]]];
    cell.plateAuthorName.text = [plate.plateAuthor.authorName uppercaseString];
    cell.plateLocation.text = [plate.plateAuthorLocation uppercaseString];
    cell.plateLikes.text = [NSString stringWithFormat:@"%ld", (long)plate.plateLikes];
    [cell.plateReceiptImage setHidden:!plate.plateHasReceipt];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.platesHelper.plates.count - 1 && self.limit != -1 && self.skip != -1) {
        //        self.limit += kDefaultLoadLimit;
        self.skip += kDefaultLoadLimit;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - PlatesModelHelperDelegate -

-(void)modelIsUpdated {
    
    [self.tableView reloadData];
}

@end
