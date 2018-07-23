//
//  TVCustomBulkRetailCell.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 17/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVCustomBulkRetailCell.h"
#import "Constant.h"

@implementation TVCustomBulkRetailCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _btnSubmitBulk = [[UIButton alloc]initWithFrame:CGRectMake(10, self.frame.size.height - 50, SCREEN_WIDTH - 20, 45)];
    [self.btnSubmitBulk setDefaultButtonShadowStyle:DefaultThemeColor];
    [self.btnSubmitBulk setTitle:@"SUBMIT" forState:UIControlStateNormal];;
    [self.btnSubmitBulk.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    [self addSubview:_btnSubmitBulk];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
