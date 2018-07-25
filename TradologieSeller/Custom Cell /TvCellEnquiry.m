//
//  TvCellEnquiry.m
//  Tradologie
//
//  Created by Chandresh Maurya on 18/05/18.
//  Copyright © 2018 Chandresh Maurya. All rights reserved.
//

#import "TvCellEnquiry.h"
#import "AppConstant.h"
#import "Constant.h"
#import "CommonUtility.h"

@implementation TvCellEnquiry
{
    UILabel *headLabel;
    UIButton *btnViewRate;
    UIView * bgView;
    NSMutableArray * labelArray;
    NSMutableArray * bgArray;
    NSMutableArray * btnArray;
    CGSize itemSize;
    NSArray * keyArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemSize:(CGSize)size
        headerArray:(NSArray*)headerArray
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
    int xx = 0;
    
    int width = itemSize.width;
    
    for(int i = 0 ; i < [keyArray count] ; i++)
    {
        if (i == 2)
        {
            bgView = [[UIView alloc] initWithFrame:CGRectMake(xx, 0, width, itemSize.height)];
            headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, width - 20, 50)];
            [headLabel setBackgroundColor:[UIColor clearColor]];

            btnViewRate = [[UIButton alloc]initWithFrame:CGRectMake(10, headLabel.frame.size.height, width - 20 , 60)];
            [btnViewRate setBackgroundColor:DefaultThemeColor];
            [btnViewRate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnViewRate.titleLabel setFont:UI_DEFAULT_FONT_MEDIUM(14)];
            
            [bgView addSubview:btnViewRate];
            [bgView addSubview:headLabel];
            [labelArray addObject:headLabel];
        }
        else
        {
            bgView = [[UIView alloc] initWithFrame:CGRectMake(xx, 0, width, itemSize.height)];
            if (i == 1)
            {
                headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, width - 20, itemSize.height)];
            }
            else
            {
                headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, itemSize.height)];
            }
            [bgView addSubview:headLabel];
            [labelArray addObject:headLabel];
        }
        [bgView setBackgroundColor:[UIColor whiteColor]];
        
        [headLabel setBackgroundColor:[UIColor clearColor]];
        [headLabel setFont:IS_IPHONE5? UI_DEFAULT_FONT_MEDIUM(15):UI_DEFAULT_FONT(18)];
        [headLabel setNumberOfLines:5];
        [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *lblline = [[UILabel alloc]init];
        [lblline setFrame:CGRectMake(0, bgView.frame.size.height + 5, width + 10, 1)];
        [lblline setBackgroundColor:[UIColor lightGrayColor]];
        [bgView addSubview:lblline];
        [self addSubview:bgView];
        [bgArray addObject:bgView];
        
        xx = xx + width + 10;
        
        if(i == keyArray.count - 3)
        {
            width = itemSize.width - 80;
        }
        else if(i == keyArray.count - 4)
        {
            width = itemSize.width - 80;
        }
        else if (i == keyArray.count - 5)
        {
            width = itemSize.width - 80;
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

    if (([dataDict valueForKey:@"btnTittle"] != nil) && ![[dataDict valueForKey:@"btnTittle"] isEqualToString:@" "])
    {
        [labelArray insertObject:btnViewRate atIndex:labelArray.count];
        [btnViewRate setBackgroundColor:DefaultThemeColor];

    }
    else
    {
        [btnViewRate setBackgroundColor:[UIColor whiteColor]];
        [btnViewRate addTarget:self action:@selector(btnViewRateTapped:) forControlEvents:UIControlEventTouchUpInside];

    }
    for (int i = 0; i < [labelArray count]; i++)
    {
        UILabel * tempLabel = [labelArray objectAtIndex:i];
        switch (i)
        {
            case 0:
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                break;
                
            case 1:
            {
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                [tempLabel setNumberOfLines:5];
                [tempLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [tempLabel setFont:UI_DEFAULT_FONT(16)];

            }
                break;
            case 2:
            {
                if ([[labelArray lastObject] isKindOfClass:[UIButton class]])
                {
                    UIButton *btnRate = [labelArray objectAtIndex:[labelArray count]-1];
                    [btnRate setTintColor:[UIColor clearColor]];
                    [btnRate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btnRate setTitle:[dataDict valueForKey:@"btnTittle"] forState:UIControlStateNormal];
                    [btnRate addTarget:self action:@selector(btnViewRateTapped:) forControlEvents:UIControlEventTouchUpInside];
                    [btnRate.titleLabel setTextAlignment:NSTextAlignmentCenter];
                    [btnRate.titleLabel setNumberOfLines:2];
                    [btnRate.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
                    [btnRate setDefaultButtonShadowStyle:DefaultThemeColor];
                    [btnRate.titleLabel setFont:UI_DEFAULT_FONT_MEDIUM(18)];

                }
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
            }
               
                break;
                
            case 3:
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                break;
                
            case 4:
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                break;
            case 5:
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                break;
            case 6:
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                break;
            case 7:
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                break;
            case 8:
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                break;
            case 9:
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                break;
            case 10:
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                break;
            default:
                break;
        }
    }
}
-(IBAction)btnViewRateTapped:(UIButton *)sender{
    if([_delegate respondsToSelector:@selector(setSelectItemViewWithData:withTittle:)])
    {
        NSIndexPath *indexPath = [CommonUtility MB_IndexPathForCellContainingView:sender];
        [_delegate setSelectItemViewWithData:indexPath withTittle:sender.titleLabel.text];
    }
}

@end
