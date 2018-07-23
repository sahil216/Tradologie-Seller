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
   
    CGFloat ScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if (ScreenWidth > 375)
    {
        _viewWidth.constant = 350;
        
    }
    else
    {
        _viewWidth.constant = 315;
    }
    [_viewBG setShadowBackGroundWithColor:[UIColor whiteColor]];
    [_viewBG.layer setBorderWidth:2.0f];
    [_viewBG.layer setBorderColor:[UIColor orangeColor].CGColor];
   
    
    
    [_btnSubmitPlan setDefaultButtonShadowStyle:DefaultThemeColor];
    [_btnSubmitPlan.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];

    [self.btnSubmitPlan addTarget:self action:@selector(btnSubmitPlanTapped:) forControlEvents:UIControlEventTouchUpInside];
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
-(IBAction)btnSubmitPlanTapped:(UIButton *)sender
{
    if([_delegate respondsToSelector:@selector(btnSubmitPlanTapped:)])
    {
        [_delegate btnSubmitPlanTapped:sender];
    }
}
@end
