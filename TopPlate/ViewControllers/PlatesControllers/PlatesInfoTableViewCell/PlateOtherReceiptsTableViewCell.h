//
//  PlateOtherReceiptsTableViewCell.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlateOtherReceiptsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *plateAuthorName;
@property (weak, nonatomic) IBOutlet UICollectionView *otherPlatesCollectionView;

@property (nonatomic, strong) PlateModel *model;

@end
