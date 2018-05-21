//
//  WinnersViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "WinnersViewController.h"
#import "PlatesTableViewCell.h"
#import "PlateInfoViewController.h"

@interface WinnersViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *winnersArray;
@property (nonatomic, strong) PlateModelHelper *platesHelper;

@end

@implementation WinnersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.platesHelper = [modelsManager getModel:HelperTypePlates];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PlatesTableViewCell" bundle:nil] forCellReuseIdentifier:@"PlatesTableViewCell"];
    self.tableView.estimatedRowHeight = 315;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self loadWinners];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadWinners {
    
    [self.platesHelper getWinnersWithCompletion:^(NSArray *plates, NSString *errorString) {
        if (errorString) {
            [Helper showErrorMessage:errorString forViewController:self];
        } else {
            self.winnersArray = plates;
            [self.tableView reloadData];
        }
    }];
}

-(void)loadPlateForId:(NSString *)plateId {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.platesHelper getPlateWithId:plateId
                      completionBlock:^(PlateModel *plate, NSString *errorString) {
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                          if (plate && !errorString) {
                              UIStoryboard *platesStoryboard = [UIStoryboard storyboardWithName:@"Plates" bundle:nil];
                              PlateInfoViewController *plateVc = [platesStoryboard instantiateViewControllerWithIdentifier:@"PlateInfoViewController"];
                              plateVc.selectedPlate = plate;
                              [self.navigationController pushViewController:plateVc animated:YES];
                          }
                      }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.winnersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlateModel *winnerPlate = self.winnersArray[indexPath.row];
    
    PlatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlatesTableViewCell" forIndexPath:indexPath];
    
    cell.plateName.text = [winnerPlate.plateName uppercaseString];
    [cell.plateImage sd_setImageWithURL:[winnerPlate.plateImages.firstObject withBaseUrl]];
    cell.plateAuthorName.text = [winnerPlate.plateAuthor.authorName uppercaseString];
    cell.plateLocation.text = [winnerPlate.plateAuthorLocation uppercaseString];
    cell.plateLikes.text = [NSString stringWithFormat:@"%ld", (long)winnerPlate.plateLikes];
    [cell.plateReceiptImage setHidden:!winnerPlate.plateHasReceipt];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 315;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlateModel *selectedPlate = self.winnersArray[indexPath.row];
    [self loadPlateForId:selectedPlate.plateId];
}

@end
