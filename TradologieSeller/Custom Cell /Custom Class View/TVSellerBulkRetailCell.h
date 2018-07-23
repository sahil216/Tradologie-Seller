//
//  TVSellerBulkRetailCell.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 17/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TVSellerBulkRetailCellDelegate <NSObject>

- (void)selectBulkItemWithData:(UIButton *)sender withIndex:(NSIndexPath *)index;

@end

@interface TVSellerBulkRetailCell : UITableViewCell

@property (nonatomic,strong) UILabel *lblBulkTittle;
@property (nonatomic,strong) UITextField *txtBulkfield;


@property (nonatomic,assign) id<TVSellerBulkRetailCellDelegate> delegate;


- (void)ConfigureBulkRetailItemInfoCellData:(NSString *)strTittle withPlaceholder:(NSString *)strPlaceHolder withRowIndex:(NSIndexPath *)rowIndex;

@end
