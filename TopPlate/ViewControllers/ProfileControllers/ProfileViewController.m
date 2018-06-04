//
//  ProfileViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

static int kDefaultLoadLimit = 10;

#import "ProfileViewController.h"
#import "UserInfoCollectionViewCell.h"
#import "PlateCollectionViewCell.h"
#import "PlateInfoViewController.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userBioLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (nonatomic, strong) AuthorModelHelper *authHelper;
@property (nonatomic, strong) PlateModelHelper *plateHelper;
@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger skip;

@property (nonatomic, strong) NSMutableArray *userPlates;
@property (nonatomic, strong) User *userInfo;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.scrollView setBounces:NO];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setCollectionViewLayout:[self setSubCategoriesCollectionViewLayout]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PlateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PlateCollectionViewCell"];
    
    self.limit = kDefaultLoadLimit;
    self.skip = 0;
    
    [self setBackgroundImage];
    
    self.authHelper = [AuthorModelHelper new];
    self.plateHelper = [PlateModelHelper new];
    
    if (self.userId) {
        [self loadUserInfoForUserId:self.userId];
    } else {
        if (getCurrentUser) {
            [self loadUserInfoForUserId:getCurrentUser.userId];

        }
    }
    
    [self.userImageView circleView];
}

-(void)loadUserInfoForUserId:(NSString *)userId {
    
    [MBProgressHUD showHUDAddedTo:self.profileView animated:YES];
    [self.authHelper getAuthorProfileInfoWithId:userId completionBlock:^(User *currentUserProfile, NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.profileView animated:YES];
        if (errorString) {
            [Helper showErrorMessage:errorString forViewController:self];
        } else {
            [self.userImageView sd_setImageWithURL:currentUserProfile.userInfo.authorImageUrl];
            self.userNameLabel.text = currentUserProfile.userInfo.authorName;
            self.userBioLabel.text = @"Some bio text";
        }
    }];
    
    [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    [self.authHelper getPlatesForAuthor:userId environment:getCurrentEnvironment withLimit:@(self.limit) withSkip:@(self.skip) completionBlock:^(NSArray *plates, NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.collectionView animated:YES];

        if (errorString) {
            [Helper showErrorMessage:errorString forViewController:self];
        } else {
            [self.collectionView reloadData];
            [self recalculateCollectionViewHeight];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.authHelper.userPlates.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlateModel *plate = self.authHelper.userPlates[indexPath.row];
    PlateCollectionViewCell *plateCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlateCollectionViewCell" forIndexPath:indexPath];
    [plateCollectionViewCell.plateImage sd_setImageWithURL:[plate.plateImages.firstObject withBaseUrl]];
    return plateCollectionViewCell;
}

- (UICollectionViewFlowLayout *)setSubCategoriesCollectionViewLayout {
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    [collectionLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [collectionLayout setMinimumInteritemSpacing:0.0f];
    [collectionLayout setMinimumLineSpacing:0.0f];
    collectionLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    
    return collectionLayout;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    UIEdgeInsets tempInsets = UIEdgeInsetsZero;
    return tempInsets;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PlateModel *plate = self.authHelper.userPlates[indexPath.row];
    [self loadPlateForId:plate.plateId];
}

-(void)recalculateCollectionViewHeight {
    
    if (self.authHelper.userPlates.count > 0) {
        float rows = ceilf(self.authHelper.userPlates.count / 3.);
        CGFloat cellHeight = [UIScreen mainScreen].bounds.size.width / 3;
        self.collectionViewHeight.constant = rows * cellHeight;
    } else {
        self.collectionViewHeight.constant = 0;
    }
}

-(void)loadPlateForId:(NSString *)plateId {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.plateHelper getPlateWithId:plateId
                     completionBlock:^(PlateModel *plate, NSString *errorString) {
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         
                         if (plate && !errorString) {
                             UIStoryboard *plateStoryboard = [UIStoryboard storyboardWithName:@"Plates" bundle:nil];
                             PlateInfoViewController *plateVc = [plateStoryboard instantiateViewControllerWithIdentifier:@"PlateInfoViewController"];
                             plateVc.selectedPlate = plate;
                             [self.navigationController pushViewController:plateVc animated:YES];
                         }
                     }];
}


@end
