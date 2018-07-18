//
//  TVCellMembershipType.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 18/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVCellMembershipType.h"
#import "AppConstant.h"
#import "Constant.h"
#import "CommonUtility.h"

@implementation TVCellMembershipType
{
    UILabel *headLabel;
    UIView * bgView;
    NSMutableArray * labelArray;
    NSMutableArray * bgArray;
    CGSize itemSize;
    NSArray * keyArray;
    NSMutableArray *arrlblObject;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemSize:(CGSize)size headerArray:(NSArray*)headerArray
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        itemSize = size;
        keyArray = headerArray;
        labelArray = [NSMutableArray new];
        bgArray = [NSMutableArray new];
        [self setupLabel];
    }
    return self;
}

- (void)setupLabel
{
    int xx = 10;
    
    int width = 150;
    for(int i = 0 ; i < [keyArray count] ; i++)
    {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(xx, 0, width, itemSize.height)];
        [bgView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bgView];
        
        headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgView.frame.size.width , itemSize.height)];
        [headLabel setFont:UI_DEFAULT_FONT(15)];
        [headLabel setNumberOfLines:0];
        [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [headLabel setText:[NSString stringWithFormat:@"%d",i]];
        [headLabel setBackgroundColor:[UIColor clearColor]];

        [bgView addSubview:headLabel];
        [labelArray addObject:headLabel];
        [bgArray addObject:bgView];
        
        xx = xx + width + 10;
        
        if(i == 3)
        {
            width = itemSize.width + 30;
        }
        
        else
        {
            width = itemSize.width;
        }
    }
}

-(void)setDataDict:(NSMutableDictionary *)dataDict
{
    _dataDict = dataDict;
    
    for (int i = 0; i < [labelArray count]; i++)
    {
        UILabel * tempLabel = [labelArray objectAtIndex:i];
        
        switch (i)
        {
            case 0:
            {
                NSString *strValue = [NSString stringWithFormat:@" %@",[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setText:strValue];
                [tempLabel setTextAlignment:NSTextAlignmentLeft];
            }
                break;
                
            case 1:
            {
                NSString *strValue = [NSString stringWithFormat:@"%@",[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setText:strValue];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                break;
                
            case 2:
            {
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                break;
                
            case 3:
            {
                NSString *strValue = [NSString stringWithFormat:@"%@",[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setText:strValue];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                break;
                
            case 4:
            {
                NSString *strValue = [NSString stringWithFormat:@"%@",[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setText:strValue];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                break;
            case 5:
            {
                NSString *strValue = [NSString stringWithFormat:@"%@",[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setText:strValue];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                break;
                
            case 6:
            {
                NSString *strValue = [NSString stringWithFormat:@"%@",[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setText:strValue];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                break;
                
            case 7:
            {
                NSString *strValue = [NSString stringWithFormat:@"%@",[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setText:strValue];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                
                break;
            case 8:
            {
                NSString *strValue = [NSString stringWithFormat:@"%@",[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setText:strValue];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                
                break;
                
            default:
                break;
        }
    }
}
@end
