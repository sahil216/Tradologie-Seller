//
//  TVCellBulkRetailList.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 17/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVCellBulkRetailList.h"
#import "AppConstant.h"
#import "Constant.h"
#import "CommonUtility.h"

@implementation TVCellBulkRetailList
{
    UILabel *headLabel;
    UIView * bgView;
    NSMutableArray * labelArray;
    NSMutableArray * bgArray;
    CGSize itemSize;
    NSArray * keyArray;
    NSMutableArray *arrlblObject;
}

- (void)awakeFromNib {
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
    if (self) {
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
    
    int width = 50;
    for(int i = 0 ; i < [keyArray count] ; i++)
    {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(xx, 0, width, itemSize.height)];
        [bgView setBackgroundColor:[UIColor grayColor]];
        [self addSubview:bgView];
       
        if (i == 2)
        {
            arrlblObject = [[NSMutableArray alloc]init];
            [self setlabelwithIndex:0 withFrame:CGRectMake(0, 0, 50, 50) withSubView:bgView];
            [self setlabelwithIndex:0 withFrame:CGRectMake(55, 0, 50, 50) withSubView:bgView];
        }
        else if (i == 3)
        {
            arrlblObject = [[NSMutableArray alloc]init];
            [self setlabelwithIndex:0 withFrame:CGRectMake(0, 0, 50, 50) withSubView:bgView];
            [self setlabelwithIndex:0 withFrame:CGRectMake(55, 0, 50, 50) withSubView:bgView];
        }
        else
        {
            headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width , itemSize.height)];
        }
        
        [headLabel setFont:UI_DEFAULT_FONT(16)];
        [headLabel setNumberOfLines:5];
        [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [headLabel setText:[NSString stringWithFormat:@"%d",i]];

        [bgView addSubview:headLabel];
        [labelArray addObject:headLabel];
        [bgArray addObject:bgView];
        
        xx = xx + width + 20;
        
        if(i == 0)
        {
            width = itemSize.width + 100;
        }
        else if(i == 1)
        {
            width = itemSize.width + 100;
        }
        else if(i == 2)
        {
            width = itemSize.width + 100;
            
        }
        else
        {
            width = itemSize.width;
        }
    }
}
-(void)setlabelwithIndex:(NSInteger)Index withFrame:(CGRect)frame withSubView:(UIView *)viewBG
{
    UILabel *lblTittle = [[UILabel alloc]initWithFrame:frame];
    [lblTittle setBackgroundColor:[UIColor clearColor]];
    [lblTittle setFont:UI_DEFAULT_FONT(16)];
    [lblTittle setNumberOfLines:5];
    [lblTittle setTextAlignment:NSTextAlignmentCenter];
    [lblTittle setLineBreakMode:NSLineBreakByWordWrapping];
    [viewBG addSubview:lblTittle];
    [arrlblObject insertObject:lblTittle atIndex:Index];
    
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
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                break;
                
            case 1:
            {
                NSString *strValue = [NSString stringWithFormat:@"%@",[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setText:strValue];
                [tempLabel setBackgroundColor:DefaultThemeColor];
                [tempLabel setTextColor:[UIColor whiteColor]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                break;
                
            case 2:
            {
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                [tempLabel setNumberOfLines:5];
                [tempLabel setLineBreakMode:NSLineBreakByWordWrapping];
            }
                break;
                
            case 3:
            {
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setBackgroundColor:DefaultThemeColor];
                [tempLabel setTextColor:[UIColor whiteColor]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                break;
                
            case 4:
            {
                [tempLabel setText:[NSString stringWithFormat:@"%@",[dataDict objectForKey:[keyArray objectAtIndex:i]]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                break;
            case 5:
            {
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
                break;
                
            case 6:
            {
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
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
                
            default:
                break;
        }
    }
}

@end
