//
//  TVSellerBulkRetailCell.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 17/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVSellerBulkRetailCell.h"
#import "Constant.h"
#import "CommonUtility.h"

@implementation TVSellerBulkRetailCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _lblBulkTittle = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 20)];
    [_lblBulkTittle setFont:UI_DEFAULT_FONT(16)];
    [self addSubview:_lblBulkTittle];
    
    _txtBulkfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH - 20, 45)];
    [_txtBulkfield setFont:UI_DEFAULT_FONT(16)];
    [self addSubview:_txtBulkfield];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}
- (void)ConfigureBulkRetailItemInfoCellData:(NSString *)strTittle withPlaceholder:(NSString *)strPlaceHolder withRowIndex:(NSIndexPath *)rowIndex
{
    
    [_lblBulkTittle setText:strTittle];
    
    if (rowIndex.row == 0)
    {
        [_txtBulkfield setAdditionalInformationTextfieldStyle:strPlaceHolder Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnSelectGroupProductTaped:) withTag:0];
    }
    else
    {
        [_txtBulkfield setDefaultTextfieldStyleWithPlaceHolder:strPlaceHolder withTag:rowIndex.row];
    }
    
}
-(IBAction)btnSelectGroupProductTaped:(UIButton *)sender
{
    if([_delegate respondsToSelector:@selector(selectBulkItemWithData:withIndex:)])
    {
        NSIndexPath *indexPath = [CommonUtility MB_IndexPathForCellContainingView:sender];
        [_delegate selectBulkItemWithData:sender withIndex:indexPath];
    }
}
@end
