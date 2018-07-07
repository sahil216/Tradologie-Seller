//
//  EnquirySellerAcceptCell.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 07/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "EnquirySellerAcceptCell.h"
#import "Constant.h"
#import "CommonUtility.h"

@implementation EnquirySellerAcceptCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)ConfigureNotificationListbyCellwithSectionIndex:(NSInteger)section withAmtParticipate:(NSString *)strAmtValue
{
    [_txtQtyParticipate setDefaultTextfieldStyleWithPlaceHolder:@"Enter Total Quantity" withTag:1002];
    [_txtQtyParticipate setFont:UI_DEFAULT_FONT_MEDIUM(18)];
    [CommonUtility setTooBarOnTextfield:_txtQtyParticipate withTargetId:self withActionEvent:@selector(btnToolbarTapped:)];
    
    [_lblAmtPaticipating setText:strAmtValue];
    [_lblAmtPaticipating setFont:UI_DEFAULT_FONT_MEDIUM(18)];
    [_lblAmtPaticipating setTextColor:DefaultThemeColor];
    [_lblAmtPaticipating setBackgroundColor:[UIColor clearColor]];
}
-(void)btnToolbarTapped:(UIToolbar *)toolBar
{
    [self.superview endEditing:YES];
    UITableView *tableView = (UITableView *)self.superview;
    tableView.contentOffset = CGPointMake(0, SCREEN_HEIGHT + 200);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * strValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.isEditing)
    {
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"textFieldValueChange" object:strValue];
        if([_delegate respondsToSelector:@selector(textFieldValueChange:)])
        {
            //NSIndexPath *indexPath = [CommonUtility MB_IndexPathForCellContainingView:sender];
            [_delegate textFieldValueChange:strValue];
        }
        return YES;
    }
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableView *tableView = (UITableView *)self.superview;
    tableView.contentOffset = CGPointMake(0, SCREEN_HEIGHT + SCREEN_WIDTH);
}

@end
