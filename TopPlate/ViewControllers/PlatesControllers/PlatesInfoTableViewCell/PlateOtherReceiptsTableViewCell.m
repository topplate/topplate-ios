//
//  PlateOtherReceiptsTableViewCell.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "PlateOtherReceiptsTableViewCell.h"
#import "OtherReceipsCollectionViewCell.h"

@interface PlateOtherReceiptsTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation PlateOtherReceiptsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.otherPlatesCollectionView.delegate = self;
    self.otherPlatesCollectionView.dataSource = self;
    
    [self.otherPlatesCollectionView setCollectionViewLayout:[self setSubCategoriesCollectionViewLayout]];

    // Initialization code
}

- (UICollectionViewFlowLayout *) setSubCategoriesCollectionViewLayout {
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    [collectionLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [collectionLayout setMinimumInteritemSpacing:10.0f];
    [collectionLayout setMinimumLineSpacing:12.0f];
    
    return collectionLayout;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.model.relatedPlates.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OtherReceipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OtherReceipsCollectionViewCell" forIndexPath:indexPath];
    [cell.otherPlateImageView sd_setImageWithURL:[self.model.plateImages.firstObject withBaseUrl]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize tempSize;
    
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width / self.model.relatedPlates.count) - 15;
//    CGFloat height = ([UIScreen mainScreen].bounds.size.height / 3) - 10 - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height;
    
    tempSize = CGSizeMake(width, width);
    
    return tempSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    UIEdgeInsets tempInsets = UIEdgeInsetsZero;
    return tempInsets;
}

@end
