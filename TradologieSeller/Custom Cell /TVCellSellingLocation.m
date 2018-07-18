
//
//  TVCellSellingLocation.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 13/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVCellSellingLocation.h"
#import "Constant.h"
#import "CommonUtility.h"

@implementation TVCellSellingLocation

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)ConfigureSellingLocationInfoCellData:(NSString *)strTittle withPlaceholder:(NSString *)strPlaceHolder;
{
    
    [_lblLocationTittle setText:strTittle];
    [_txtLocations setAdditionalInformationTextfieldStyle:strPlaceHolder Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnSelectStateTaped:) withTag:0];
}


-(IBAction)btnSelectStateTaped:(UIButton *)sender 
{
    if([_delegate respondsToSelector:@selector(setSelectItemViewWithData:withIndex:)])
    {
        NSIndexPath *indexPath = [CommonUtility MB_IndexPathForCellContainingView:sender];
        [_delegate setSelectItemViewWithData:sender withIndex:indexPath];
    }
}

- (void)ConfigureSellingLocationListWithData:(NSInteger)Count withData:(id)locationListData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
