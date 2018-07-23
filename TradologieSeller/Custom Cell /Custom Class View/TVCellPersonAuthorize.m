//
//  TVCellPersonAuthorize.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 20/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVCellPersonAuthorize.h"
#import "Constant.h"

@implementation TVCellPersonAuthorize

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat ScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if (ScreenWidth > 375)
    {
        _btnWidth.constant = ScreenWidth - 40;
        
    }
    else
    {
        _btnWidth.constant = 345;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)ConfigureUploadPersonInfoPicCellwithSectionIndex:(NSInteger)index
{
    [_btnUploadFile setDefaultButtonShadowStyle:DefaultThemeColor];
    [_btnSubmitAuthorized setDefaultButtonShadowStyle:DefaultThemeColor];

    [_switchEnable addTarget:self action:@selector(btnSwitchTapped:) forControlEvents:UIControlEventValueChanged];
    [_btnSubmitAuthorized.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    [_btnUploadFile.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];

    
}
-(IBAction)btnSwitchTapped:(UISwitch *)sender
{
    if([_delegate respondsToSelector:@selector(saveAuthorizePersonDetail:)])
    {
        [_delegate saveAuthorizePersonDetail:sender.on];
    }
}
@end
