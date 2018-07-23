//
//  TVCellAuthorizePerson.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 20/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVCellAuthorizePerson.h"
#import "Constant.h"
#import "AppConstant.h"

@implementation TVCellAuthorizePerson

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat ScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if (ScreenWidth > 375)
    {
        _viewWidth.constant = ScreenWidth - 20;
        
    }
    else
    {
        _viewWidth.constant = 355;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAuthorizedPersonDetailNotification:)
                                                 name:@"AuthorizedPersonDetail"
                                               object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)ConfigureAuthorizedPersonInfoCellwithData:(NSString *)strTittle withPlaceholder:(NSString *)strPlaceHolder withIndex: (NSIndexPath *)index;
{
    [_lblTittle setText:strTittle];
    [_txtInfoField setDefaultTextfieldStyleWithPlaceHolder:strPlaceHolder withTag:index.row];
    [_txtInfoField setTag:index.row + 10];
}
- (void) receiveAuthorizedPersonDetailNotification:(NSNotification *) notification
{
    AuthorizePersonData *data = [notification.object copy];
    
    if (_txtInfoField.tag == 10 && [_txtInfoField.placeholder isEqualToString:@"Authorize Person Name"])
    {
        [_txtInfoField setText: data.AuthorizePersonName];
    }
    else if (_txtInfoField.tag == 11 && [_txtInfoField.placeholder isEqualToString:@"Your Email-ID"])
    {
        [_txtInfoField setText: data.EmailID];

    }
    else if (_txtInfoField.tag == 12 && [_txtInfoField.placeholder isEqualToString:@"Your Mobile Number"])
    {
        [_txtInfoField setText:[NSString stringWithFormat:@"%@",data.MobileNo]];
    }
    else if (_txtInfoField.tag == 13 && [_txtInfoField.placeholder isEqualToString:@"Your Designation"])
    {
        [_txtInfoField setText:[NSString stringWithFormat:@"%@",data.Designation]];
    }
}

@end

