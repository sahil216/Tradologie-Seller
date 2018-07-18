//
//  TVCellMemberShipPlan.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 18/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVCellMemberShipPlan.h"
#import "Constant.h"
#import "CommonUtility.h"

@implementation TVCellMemberShipPlan

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_viewBG setShadowBackGroundwitColor:[UIColor whiteColor]];
    [_viewBG.layer setBorderWidth:1.0f];
    [_viewBG.layer setBorderColor:[UIColor orangeColor].CGColor];
    
   
    [_txtMemberType setAdditionalInformationTextfieldStyle:@"--- Select Member Type ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnMemberTypeTaped:) withTag:0];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)btnMemberTypeTaped:(UIButton *)sender
{
    if([_delegate respondsToSelector:@selector(selectMemberShipPlan:withIndex:)])
    {
        NSIndexPath *indexPath = [CommonUtility MB_IndexPathForCellContainingView:sender];
        [_delegate selectMemberShipPlan:sender withIndex:indexPath];
    }
}
@end
