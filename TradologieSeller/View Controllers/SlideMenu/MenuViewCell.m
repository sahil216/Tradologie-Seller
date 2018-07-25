//
//  MenuViewCell.m
//  SelfStock
//
//  Created by Shiv Kumar on 16/09/16.
//  Copyright © 2016 Shiv Kumar. All rights reserved.
//

#import "MenuViewCell.h"
#import "Constant.h"


@implementation MenuViewCell
@synthesize lblTitile;
@synthesize imgView;
- (void)awakeFromNib
{
    [super awakeFromNib];
    [lblTitile setFont:(IS_IPHONE5)?UI_DEFAULT_FONT_MEDIUM(15):UI_DEFAULT_FONT_MEDIUM(17)];
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
   
    [super setSelected:selected animated:animated];
    self.selectedBackgroundView = [self selectedView];
}

#pragma mark ====: Cell Selected View :====
-(UIView *)selectedView
{
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.60f];
    return bgColorView;
}

@end
