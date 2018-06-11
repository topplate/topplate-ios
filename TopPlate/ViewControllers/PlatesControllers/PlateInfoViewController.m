//
//  PlateInfoViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlateInfoViewController.h"

#import "PlateImageTableViewCell.h"
#import "PlateNameTableViewCell.h"
#import "PlateAuthorInfoTableViewCell.h"
#import "PlateIngredientTableViewCell.h"
#import "PlateSocialShareTableViewCell.h"
#import "PlateOtherReceiptsTableViewCell.h"

typedef NS_ENUM(NSUInteger, SectionType)
{
    SectionTypePlateImage = 0,
    SectionTypePlateName,
    SectionTypePlateReceipt,
    SectionTypePlateAuthorInfo,
    SectionTypePlateIngredients,
    SectionTypePlateSocialShare,
    SectionTypeOtherReceipes
};

@interface PlateInfoViewController () <UITableViewDelegate, UITableViewDataSource, PlateOtherReceiptsTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PlateModelHelper *plateHelper;

@end

@implementation PlateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 10;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self setNavigationTitleViewImage];
    [self setLoginBackgroundImage];
    
    self.plateHelper = [modelsManager getModel:HelperTypePlates];
    
    if ([self.plateHelper isMyPlate:self.selectedPlate]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"editIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(editPlate)];
    }
    
    // Do any additional setup after loading the view.
}

-(void)editPlate {
    NSLog(@"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self getNumberOfSectionsInTableView];;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self getNumberOfRowsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *baseCell = [UITableViewCell new];
    
    switch (indexPath.section) {
        case SectionTypePlateImage: {
            
            PlateImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlateImageTableViewCell" forIndexPath:indexPath];
            cell.fromWinners = self.fromWinners;
            [cell setupCellWithModel:self.selectedPlate indexPath:indexPath];
            cell.likeStatus = ^(BOOL likeStatus) {
                
                if (likeStatus) {
                    self.selectedPlate.plateLikes += 1;
                } else {
                    self.selectedPlate.plateLikes -= 1;
                }
                
                self.selectedPlate.plateIsLiked = likeStatus;
                
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            };
            baseCell = cell;
        }
            break;
            
        case SectionTypePlateName: {
            
            PlateNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlateNameTableViewCell" forIndexPath:indexPath];
            [cell setupCellNameWithModel:self.selectedPlate];
            baseCell = cell;
        }
            break;
            
        case SectionTypePlateReceipt: {
            
            PlateNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlateNameTableViewCell" forIndexPath:indexPath];
            [cell setupCellReceiptWithModel:self.selectedPlate];
            baseCell = cell;
        }
            break;
            
        case SectionTypePlateAuthorInfo: {
            
            PlateAuthorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlateAuthorInfoTableViewCell" forIndexPath:indexPath];
            [cell setupCellWithModel:self.selectedPlate];
            cell.parentViewController = self;
            baseCell = cell;
        }
            break;
            
        case SectionTypePlateIngredients: {
            
            PlateIngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlateIngredientTableViewCell" forIndexPath:indexPath];
            if (indexPath.row == 0) {
                [cell setupCellWithIngredient:@"Ingredients:"];
            } else {
                [cell setupCellWithIngredient:self.selectedPlate.plateIngredients[indexPath.row - 1]];
            }
            
            baseCell = cell;
        }
            break;
            
        case SectionTypePlateSocialShare: {
            
            PlateSocialShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlateSocialShareTableViewCell" forIndexPath:indexPath];
            baseCell = cell;
        }
            break;
            
        case SectionTypeOtherReceipes: {
            
            PlateOtherReceiptsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlateOtherReceiptsTableViewCell" forIndexPath:indexPath];
            cell.model = self.selectedPlate;
            cell.delegate = self;
            baseCell = cell;
        }
            break;
            
        default:
            break;
    }
    
    [baseCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return baseCell;
}

#pragma mark - UITableViewDelegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewHelpers -

-(NSInteger)getNumberOfSectionsInTableView {
    
    NSInteger numberOfSections = 7 + self.selectedPlate.plateIngredients.count;
    
    return numberOfSections;
}

-(NSInteger)getNumberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfCells = 0;
    
    switch (section) {
        case SectionTypePlateImage:
            //plate image is mandatory
            numberOfCells = 1;
            break;
            
        case SectionTypePlateName:
            //plate name is mandatory
            numberOfCells = 1;
            break;
            
        case SectionTypePlateReceipt: {
            if (self.selectedPlate.plateReceipt.length <= 0) {
                numberOfCells = 0;
            } else {
                numberOfCells = 1;
            }
        }
            break;
            
        case SectionTypePlateAuthorInfo:
            //plate author info is mandatory
            numberOfCells = 1;
            break;
            
        case SectionTypePlateIngredients: {
            if (self.selectedPlate.plateIngredients.count <= 0) {
                numberOfCells = 0;
            } else {
                //one cell for "Ingredient" header
                numberOfCells = 1 + self.selectedPlate.plateIngredients.count;
            }
        }
            break;
            
        case SectionTypePlateSocialShare:
            //plate social share is mandatory
            numberOfCells = 1;
            break;
            
        case SectionTypeOtherReceipes: {
            if (self.selectedPlate.relatedPlates.count <= 0) {
                numberOfCells = 0;
            } else {
                numberOfCells = 1;
            }
        }
            break;
            
        default:
            break;
    }
    
    return numberOfCells;
}

#pragma mark - PlateOtherReceiptsTableViewCellDelegate -

-(void)relatedPlateSelected:(PlateModel *)plateModel {
    
    PlateModelHelper *helper = [modelsManager getModel:HelperTypePlates];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [helper getPlateWithId:plateModel.plateId
           completionBlock:^(PlateModel *plate, NSString *errorString) {
               [MBProgressHUD hideHUDForView:self.view animated:YES];
               
               if (plate && !errorString) {
                   PlateInfoViewController *plateVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlateInfoViewController"];
                   plateVc.selectedPlate = plate;
                   [self.navigationController pushViewController:plateVc animated:YES];
               }
           }];
}

@end
