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
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 20;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OtherReceipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OtherReceipsCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}

@end
