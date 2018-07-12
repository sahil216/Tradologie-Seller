//
//  TVCellAuthorizedPerson.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 12/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVCellAuthorizedPerson.h"
#import "Constant.h"

@implementation TVCellAuthorizedPerson

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)ConfigureAuthorizedPersonInfoCellwithSectionIndex:(NSString *)strTittle withPlaceholder:(NSString *)strPlaceHolder
{
    [_lblTittle setText:strTittle];
    [_txtInfoField setDefaultTextfieldStyleWithPlaceHolder:strPlaceHolder withTag:0];
}

- (void)ConfigureUploadPersonInfoPicCellwithSectionIndex:(NSInteger)index
{
    [_btnUploadFile setDefaultButtonStyle];
    [_btnUploadFile.titleLabel setFont:IS_IPHONE5? UI_DEFAULT_FONT_BOLD(12):UI_DEFAULT_FONT_BOLD(17)];

    [_btnSubmitAuthorized setDefaultButtonStyle];
    [_btnSubmitAuthorized.titleLabel setFont:IS_IPHONE5? UI_DEFAULT_FONT_BOLD(12):UI_DEFAULT_FONT_BOLD(20)];

}
- (void)ConfigureListAuthenticatePersonInfoCell:(NSInteger)Count withData:(id)authenticateData
{
    [_lblSrNo setText:[NSString stringWithFormat:@"%ld",(long)Count]];
    [_lblSrNo setTextAlignment:NSTextAlignmentCenter];
}

@end
