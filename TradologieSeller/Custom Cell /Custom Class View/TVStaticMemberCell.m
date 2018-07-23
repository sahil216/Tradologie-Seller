//
//  TVStaticMemberCell.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 18/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVStaticMemberCell.h"

@implementation TVStaticMemberCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat ScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if (ScreenWidth > 375)
    {
        _viewWidth.constant = 375;
        
    }
    else
    {
        _viewWidth.constant = 355;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)ConfigureStaticMemberTypeCellData:(NSString *)strValue
{
    [_lblStaticValue setText:strValue];
}

@end
