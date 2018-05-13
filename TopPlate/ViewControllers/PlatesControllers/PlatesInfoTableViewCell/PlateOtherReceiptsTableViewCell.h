//
//  PlateOtherReceiptsTableViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlateOtherReceiptsTableViewCellDelegate <NSObject>

-(void)relatedPlateSelected:(PlateModel *)plateModel;

@end

@interface PlateOtherReceiptsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *plateAuthorName;
@property (weak, nonatomic) IBOutlet UICollectionView *otherPlatesCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHightC;

@property (nonatomic, strong) PlateModel *model;
@property (nonatomic, weak) id<PlateOtherReceiptsTableViewCellDelegate>delegate;

@end
