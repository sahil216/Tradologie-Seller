//
//  TVSaveAuthorizePerson.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 20/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVSaveAuthorizePerson.h"
#import "AppConstant.h"
#import "Constant.h"
#import "CommonUtility.h"

@implementation TVSaveAuthorizePerson
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
    
    int width = 80;
    for(int i = 0 ; i < [keyArray count] ; i++)
    {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(xx, 0, width, itemSize.height)];
        [bgView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bgView];
        
        if (i == keyArray.count - 1)
        {
            arrlblObject = [[NSMutableArray alloc]init];
            [self setActiveStatewithFrame:CGRectMake(10, 15, 30, 30) withSubView:bgView
                                withFrame:CGRectMake(70, 10, 40, 40)];
            [labelArray addObject:arrlblObject];
            
        }
        else
        {
            headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width , itemSize.height)];
            [headLabel setFont:UI_DEFAULT_FONT(16)];
            [headLabel setBackgroundColor:[UIColor clearColor]];
            [headLabel setNumberOfLines:5];
            [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [headLabel setText:[NSString stringWithFormat:@"%d",i]];
            [bgView addSubview:headLabel];
            [labelArray addObject:headLabel];
        }
        
        UILabel *lblline = [[UILabel alloc]init];
        [lblline setFrame:CGRectMake(0, bgView.frame.size.height, width + 10, 1)];
        [lblline setBackgroundColor:[UIColor lightGrayColor]];
        [bgView addSubview:lblline];
        [bgArray addObject:bgView];
    
        xx = xx + width + 10;
        
        if (i == 0)
        {
            width = itemSize.width + 50;
        }
        else if (i == keyArray.count - 2)
        {
            width = itemSize.width - 60;
        }
        else
        {
            width = itemSize.width;
        }
    }
}
-(void)setActiveStatewithFrame:(CGRect)Imgframe withSubView:(UIView *)viewBG withFrame:(CGRect)btnframe
{
    UIImageView *imgActive = [[UIImageView alloc]initWithFrame:Imgframe];
    [imgActive setBackgroundColor:[UIColor clearColor]];
    [imgActive setImage:IMAGE(@"IconRadioCheck")];//IconEditAuthorise
    
    UIButton *btnEdit = [[UIButton alloc]initWithFrame:btnframe];
    [btnEdit setBackgroundColor:[UIColor clearColor]];
    [btnEdit setImage:IMAGE(@"IconEditAuthorise") forState:UIControlStateNormal];
    [viewBG addSubview:imgActive];
    [viewBG addSubview:btnEdit];

    [arrlblObject insertObject:imgActive atIndex:0];
    [arrlblObject insertObject:btnEdit atIndex:1];
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
                [tempLabel setText:[NSString stringWithFormat:@"   %@",[dataDict objectForKey:[keyArray objectAtIndex:i]]]];
                [tempLabel setTextAlignment:NSTextAlignmentLeft];
            }
                break;
            case 1:
            {
                NSString *strValue = [NSString stringWithFormat:@"%@",[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setText:strValue];
                [tempLabel setNumberOfLines:5];
                [tempLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [tempLabel setTextAlignment:NSTextAlignmentLeft];
            }
                break;
                
            case 2:
            {
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setNumberOfLines:5];
                [tempLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [tempLabel setTextAlignment:NSTextAlignmentLeft];

            }
                break;
                
            case 3:
            {
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setTextAlignment:NSTextAlignmentLeft];
            }
                break;
                
            case 4:
            {
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setNumberOfLines:5];
                [tempLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [tempLabel setTextAlignment:NSTextAlignmentLeft];
            }
                break;
            case 5:
            {
                NSMutableArray *arrObject = [labelArray objectAtIndex:i];
                for (NSInteger K = 0; K < arrObject.count; K++)
                {
                    if (K == 0)
                    {
                        NSInteger IsActive = [[dataDict objectForKey:[keyArray objectAtIndex:i]]integerValue];
                        UIImageView * imgActive = [arrObject objectAtIndex:K];
                        
                        if(IsActive == 1)
                        {
                            [imgActive setImage:IMAGE(@"IconRadioCheck")];
                        }
                        else{
                           [imgActive setImage:IMAGE(@"")];
                        }
                       
                    }
                    else
                    {
                        UIButton * btnEdit = [arrObject objectAtIndex:K];
                        [btnEdit setBackgroundColor:[UIColor clearColor]];
                        [btnEdit addTarget:self action:@selector(btnSavePersonDetailTaped:) forControlEvents:UIControlEventTouchUpInside];

                    }
                }
            }
                
                break;
                
            default:
                break;
        }
    }
}
-(IBAction)btnSavePersonDetailTaped:(UIButton *)sender
{
    if([_delegate respondsToSelector:@selector(setAuthorizePersionDetailWithData:withIndex:withEdit:)])
    {
        NSIndexPath *indexPath = [CommonUtility MB_IndexPathForCellContainingView:sender];
        [_delegate setAuthorizePersionDetailWithData:sender withIndex:indexPath withEdit:1];
    }
}
@end

