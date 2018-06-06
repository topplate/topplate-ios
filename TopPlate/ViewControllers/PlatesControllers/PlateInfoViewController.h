//
//  PlateInfoViewController.h
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlateInfoViewControllerDelegate <NSObject>

-(void)plateUpdatedAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PlateInfoViewController : UIViewController

@property (nonatomic, strong) PlateModel *selectedPlate;
@property (nonatomic) BOOL fromWinners;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id <PlateInfoViewControllerDelegate> delegate;

@end
