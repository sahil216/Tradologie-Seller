//
//  UIView+Extra.m
//  OrderApp
//
//  Created by MMI IOS on 16/02/17.
//  Copyright © 2017 MMI IOS. All rights reserved.
//

#import "UIView+Extra.h"

@implementation UIView (Extra)

-(void)SetDefaultTextfieldBackGroundView
{
    [self.layer setBorderWidth:1.0f];
    [self.layer setCornerRadius:5.0f];
    [self.layer setBorderColor:[UIColor colorWithRed:156.0f/255.0f green:156.0f/255.0f blue:156.0f/255.0f alpha:1.0f].CGColor];
    self.layer.shadowColor = GET_COLOR_WITH_RGB(120, 51, 16, 1).CGColor;
    self.layer.shadowOpacity = .80;
    self.layer.shadowRadius = 1.0;
    self.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
    [self.layer setBorderWidth:2.0f];
}

-(void)SetDefaultBackGroundView
{
    [self.layer setCornerRadius:5.0f];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOpacity = 2.00;
    self.layer.shadowRadius = 1.50;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self.layer setBorderWidth:1.0f];
}
-(void)SetDefaultShadowBackGround
{
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;

    [self.layer setCornerRadius:5.0f];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    self.layer.shadowColor = DefaultThemeColor.CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 6.0f;
    [self.layer setBorderWidth:2.0f];

}
-(void)setShadowBackGroundWithColor:(UIColor *)color
{
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
    
    [self.layer setCornerRadius:5.0f];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 6.0f;
    [self.layer setBorderWidth:2.0f];
    [self setBackgroundColor:color];

//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.frame];
//    self.layer.masksToBounds = YES;
//    self.layer.opaque = NO;
//
//    [self.layer setCornerRadius:5.0f];
//    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    self.layer.shadowOpacity = 1.50f;
//    self.layer.shadowRadius = 5.0f;
//    self.layer.shadowPath = shadowPath.CGPath;
}

@end
