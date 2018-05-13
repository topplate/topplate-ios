//
//  ProfileViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

typedef NS_ENUM(NSInteger, SectionType) {
    SectionTypeProfile = 0,
    SectionTypePlates
};

static int kDefaultLoadLimit = 10;

#import "ProfileViewController.h"
#import "UserInfoCollectionViewCell.h"
#import "PlateCollectionViewCell.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) AuthorModelHelper *authHelper;
@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger skip;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setCollectionViewLayout:[self setSubCategoriesCollectionViewLayout]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PlateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PlateCollectionViewCell"];
    
    self.limit = kDefaultLoadLimit;
    self.skip = 0;
    
    [self setBackgroundImage];
    
    self.authHelper = [modelsManager getModel:HelperTypeAuthor];
    
    if (self.authHelper.currentUserPlates.count <= 0) {
        [self loadUserInfo];
    }

    // Do any additional setup after loading the view.
}

-(void)loadUserInfo {
    
    [self.authHelper getAuthorProfileInfoWithId:getCurrentUser.userId completionBlock:^(User *currentUserProfile, NSString *errorString) {
        
        if (errorString) {
            [Helper showErrorMessage:errorString forViewController:self];
        } else {
            [self.collectionView reloadData];
        }
        
        NSLog(@"");
    }];
    
    [self.authHelper getPlatesForAuthor:getCurrentUser.userId environment:getCurrentEnvironment withLimit:@(self.limit) withSkip:@(self.skip) completionBlock:^(NSArray *plates, NSString *errorString) {
        
        if (errorString) {
            [Helper showErrorMessage:errorString forViewController:self];
        } else {
            [self.collectionView reloadData];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == SectionTypeProfile) {
        return self.authHelper.currentUserInfo ? 1 : 0;
    }
    
    if (section == SectionTypePlates) {
        return self.authHelper.currentUserPlates.count;
    }
    
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *baseCell = [UICollectionViewCell new];
    
    if (indexPath.section == SectionTypeProfile) {
        UserInfoCollectionViewCell *userInfoCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserInfoCollectionViewCell" forIndexPath:indexPath];
        [userInfoCollectionViewCell.userProfileImage sd_setImageWithURL:self.authHelper.currentUserInfo.userInfo.authorImageUrl];
        userInfoCollectionViewCell.userNameLabel.text = self.authHelper.currentUserInfo.userInfo.authorName;
        userInfoCollectionViewCell.userBioLabel.text = @"Some bio text";
        baseCell = userInfoCollectionViewCell;
    } else {
        
        PlateModel *plate = self.authHelper.currentUserPlates[indexPath.row];
        PlateCollectionViewCell *plateCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlateCollectionViewCell" forIndexPath:indexPath];
        [plateCollectionViewCell.plateImage sd_setImageWithURL:[plate.plateImages.firstObject withBaseUrl]];
        baseCell = plateCollectionViewCell;
    }
    
    return baseCell;
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


@end
