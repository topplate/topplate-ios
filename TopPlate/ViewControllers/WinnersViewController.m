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

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *bannerLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *winnersArray;
@property (nonatomic, strong) PlateModelHelper *platesHelper;

@end

@implementation WinnersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundImage];
        
    [self setNavigationTitleViewImage];
    
    self.platesHelper = [modelsManager getModel:HelperTypePlates];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PlatesTableViewCell" bundle:nil] forCellReuseIdentifier:@"PlatesTableViewCell"];
    self.tableView.estimatedRowHeight = 315;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (self.winnersArray.count <= 0) {
        [self loadWinners];
    }
    
    [self loadBanner];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadWinners {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.platesHelper getWinnersWithCompletion:^(NSArray *plates, NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (errorString) {
            [Helper showErrorMessage:errorString forViewController:self];
        } else {
            self.winnersArray = plates;
            [self.tableView reloadData];
            
            if (self.tableView.contentSize.height > self.tableView.height) {
                [self.tableView setContentSize:CGSizeMake(self.tableView.width, self.tableView.contentSize.height + 50)];
            }
        }
    }];
}

-(void)loadBanner {
    
    [MBProgressHUD showHUDAddedTo:self.bannerView animated:YES];
    [[NetworkManager sharedManager] getWinnerBannerWithCompletion:^(id response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.bannerView animated:YES];
        
        if (error) {
            [Helper showErrorMessage:error.localizedDescription forViewController:self];
        } else {
            [self.bannerImageView sd_setImageWithURL:[[response valueForKey:@"icon"] withBaseUrl]];
            
            if ([[response valueForKey:@"text"] length] > 0) {
                [self.bannerLabel setAttributedText:[self getAttributedHtmlString:[response valueForKey:@"text"]]];
            }
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
                              plateVc.fromWinners = YES;
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
    [cell setupWinnersCellWithModel:winnerPlate];
    cell.parentViewController = self;
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

-(NSMutableAttributedString *)getAttributedHtmlString:(NSString *)string {
    
    //1. get the html string
    NSRange leftRange = [string rangeOfString:@"<%"];
    NSRange rightRange = [string rangeOfString:@"%>"];
    
    if (leftRange.location == NSNotFound || rightRange.location == NSNotFound) {
        return nil;
    } else {
        NSRange htmlStringRange = NSMakeRange(leftRange.location, rightRange.location + rightRange.length - leftRange.location);
        NSString *htmlString = [string substringWithRange:htmlStringRange];
        
        
        //2. get the hex string from html string
        NSString *hexString = @"";
        NSRange searchedRange = NSMakeRange(0, [string length]);
        NSString *pattern = @"#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})";
        NSError  *error = nil;
        
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
        NSArray* matches = [regex matchesInString:string options:0 range: searchedRange];
        for (NSTextCheckingResult* match in matches) {
            hexString = [string substringWithRange:[match range]];
        }
        
        //3. get the text to be colored
        NSString *textToBeAttributed = [htmlString removeTexts:@[@"<%(use_color:", @"%>", [NSString stringWithFormat:@"%@)", hexString]]];
        
        //4. Final cleared text
        NSString *finalText = [string removeTexts:@[@"<%(use_color:", @"%>", [NSString stringWithFormat:@"%@)", hexString]]];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[finalText uppercaseString]];
        [attributedString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithHexString:hexString andAlpha:1.f]
                        range:[finalText rangeOfString:textToBeAttributed]];
        
        return attributedString;
    }
}

@end
