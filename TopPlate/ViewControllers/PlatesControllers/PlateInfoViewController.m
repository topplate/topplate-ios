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

@interface PlateInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PlateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 10;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self setNavigationTitleViewImage];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self getNumberOfSectionsInTableView];;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == SectionTypePlateIngredients) {
        return self.selectedPlate.plateIngredients.count;
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *baseCell = [UITableViewCell new];
    
    switch (indexPath.section) {
        case SectionTypePlateImage: {
            
            PlateImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlateImageTableViewCell" forIndexPath:indexPath];
            [cell setupCellWithModel:self.selectedPlate];
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
            baseCell = cell;
        }
            break;
            
        case SectionTypePlateIngredients: {
            
            PlateIngredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlateIngredientTableViewCell" forIndexPath:indexPath];
            [cell setupCellWithIngredient:self.selectedPlate.plateIngredients[indexPath.row]];
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
            baseCell = cell;
        }
            break;
            
        default:
            break;
    }
    
    return baseCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getHeightForCellWithIndexPath:indexPath];
}


-(NSInteger)getNumberOfSectionsInTableView {
    
    NSInteger numberOfSections = 7 + self.selectedPlate.plateIngredients.count;
    
    return numberOfSections;
}


-(CGFloat)getHeightForCellWithIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = UITableViewAutomaticDimension;
    
    switch (indexPath.section) {
        case SectionTypePlateImage:
            cellHeight = 315;
            break;
            
        case SectionTypePlateName:
            cellHeight = UITableViewAutomaticDimension;
            break;
            
        case SectionTypePlateReceipt:
            cellHeight = UITableViewAutomaticDimension;
            break;
            
        case SectionTypePlateAuthorInfo:
            cellHeight = UITableViewAutomaticDimension;
            break;
            
        case SectionTypePlateIngredients:
            cellHeight = UITableViewAutomaticDimension;
            break;
            
        case SectionTypePlateSocialShare:
            cellHeight = UITableViewAutomaticDimension;
            break;
            
        case SectionTypeOtherReceipes: {
            
//            float roundedup = ceil(otherfloat);

            CGFloat width = ([UIScreen mainScreen].bounds.size.width / self.selectedPlate.relatedPlates.count) - 15;
            
            cellHeight = width + 40;
            
//            ceil(self.selectedPlate.relatedPlates.count / 3) * 150;
        }
            break;
            
        default:
            break;
    }
    
    return cellHeight;
}


@end
