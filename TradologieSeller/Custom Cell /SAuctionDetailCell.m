//
//  SAuctionDetailCell.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 05/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "SAuctionDetailCell.h"
#import "AppConstant.h"
#import "Constant.h"
#import "CommonUtility.h"

@implementation SAuctionDetailCell
{
    UILabel *headLabel;
    UIImageView *imgPacking;
    UIView * bgView;
    NSMutableArray * labelArray;
    NSMutableArray * bgArray;
    CGSize itemSize;
    NSArray * keyArray;
    NSMutableArray *arrlabel;
    NSInteger IsNegotiation;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemSize:(CGSize)size headerArray:(NSArray*)headerArray isWithBoolValue:(NSInteger)IsfromNegotiation
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        itemSize = size;
        keyArray = headerArray;
        labelArray = [NSMutableArray new];
        bgArray = [NSMutableArray new];
        IsNegotiation = IsfromNegotiation;
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
        if (IsNegotiation == 1)
        {
            bgView = [[UIView alloc] initWithFrame:CGRectMake(xx, 0, width, itemSize.height)];

            if (i == 5)
            {
                imgPacking = [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 100 , itemSize.height - 20)];
                [imgPacking setBackgroundColor:[UIColor redColor]];
                [bgView addSubview:imgPacking];
                [labelArray addObject:imgPacking];
            }
            else
            {
                if (i == 0)
                {
                     headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgView.frame.size.width , bgView.frame.size.height)];
                }
                else
                {
                     headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgView.frame.size.width , bgView.frame.size.height)];
                }
               
                [headLabel setBackgroundColor:[UIColor clearColor]];
                [headLabel setFont:UI_DEFAULT_FONT(16)];
                [headLabel setNumberOfLines:5];
                [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [bgView addSubview:headLabel];
                [labelArray addObject:headLabel];
                
            }
        }
        else
        {
            bgView = [[UIView alloc] initWithFrame:CGRectMake(xx, 5, width, itemSize.height-10)];
            [bgView setBackgroundColor:[UIColor whiteColor]];

            if (i == 5)
            {
                imgPacking = [[UIImageView alloc]initWithFrame:CGRectMake(50 , 0, 100 , bgView.frame.size.height)];
                [imgPacking setBackgroundColor:[UIColor redColor]];
                [bgView addSubview:imgPacking];
                [labelArray addObject:imgPacking];
            }
            else
            {
                headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgView.frame.size.width , bgView.frame.size.height)];
                [headLabel setBackgroundColor:[UIColor clearColor]];
                [headLabel setFont:UI_DEFAULT_FONT(16)];
                [headLabel setNumberOfLines:5];
                [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [bgView addSubview:headLabel];
                [labelArray addObject:headLabel];
            }
           
        }
        [self addSubview:bgView];
    
        UILabel *lblline = [[UILabel alloc]init];
        [lblline setFrame:CGRectMake(0, bgView.frame.size.height + 10, width + 50, 1)];
        [lblline setBackgroundColor:[UIColor lightGrayColor]];
        [bgView addSubview:lblline];
        [bgArray addObject:bgView];
       
        xx = xx + width + 10;
        if (i == 0)
        {
            width = itemSize.width + 50;
            [headLabel setTextAlignment:NSTextAlignmentLeft];
            
        }
        else if (i == 1)
        {
            width = 120;
            [headLabel setTextAlignment:NSTextAlignmentLeft];
            
        }
        else
        {
            width = itemSize.width;
            [headLabel setTextAlignment:NSTextAlignmentCenter];
        }
    }
}
-(void)setlabelwithIndex:(UIView *)viewBG withFrame:(CGRect)frame withIndex:(NSInteger)Index
{
    UILabel *lblTittle = [[UILabel alloc]initWithFrame:frame];
    [lblTittle setBackgroundColor:[UIColor clearColor]];
    [lblTittle setFont:UI_DEFAULT_FONT(16)];
    [lblTittle setNumberOfLines:5];
    [lblTittle setTextAlignment:NSTextAlignmentCenter];
    [lblTittle setLineBreakMode:NSLineBreakByWordWrapping];
    [viewBG addSubview:lblTittle];
    [arrlabel insertObject:lblTittle atIndex:Index];
    
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
                if (IsNegotiation == 1)
                {
                    NSMutableArray *arrlbl = [labelArray objectAtIndex:0];
                    
                    UILabel * lblCount = [arrlbl objectAtIndex:0];
                    [lblCount setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                    [lblCount setTextAlignment:NSTextAlignmentCenter];
                    
                }
                else
                {
                    [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                    [tempLabel setTextAlignment:NSTextAlignmentCenter];
                }
            }
                break;
                
            case 1:
                [tempLabel setText:[dataDict objectForKey:[keyArray objectAtIndex:i]]];
                [tempLabel setNumberOfLines:5];
                [tempLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                break;
                
            case 2:
                [tempLabel setText:[NSString stringWithFormat:@"%@",[dataDict objectForKey:[keyArray objectAtIndex:i]]]];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
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
            {
                __weak UIImageView * imgProfilepic = [labelArray objectAtIndex:i];
                [imgProfilepic setBackgroundColor:[UIColor clearColor]];
                [imgProfilepic setImageWithURL:[NSURL URLWithString:[[dataDict objectForKey:[keyArray objectAtIndex:i]] checkIfEmpty]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                 {
                     if (!error)
                     {
                         if(cacheType == SDImageCacheTypeNone)
                         {
                             imgProfilepic.alpha = 0;
                             [UIView transitionWithView:imgProfilepic
                                               duration:1.0
                                                options:UIViewAnimationOptionTransitionCrossDissolve
                                             animations:^{
                                                 if (image==nil)
                                                 {
                                                     [imgProfilepic setImage:[UIImage imageNamed:@"IconNoImageAvailable"]];
                                                 }
                                                 else
                                                 {
                                                     [imgProfilepic setImage:image];
                                                 }
                                                 
                                                 imgProfilepic.alpha = 1.0;
                                             } completion:NULL];
                         }
                         else
                         {
                             imgProfilepic.alpha = 1;
                         }
                     }
                     else
                     {
                         [imgProfilepic setImage:[UIImage imageNamed:@"IconNoImageAvailable"]];
                     }
                 } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
            }
                break;
                
            default:
                break;
        }
    }
}
-(IBAction)btnDeleteTapped:(UIButton *)sender
{
    if([_delegate respondsToSelector:@selector(setSelectItemViewCodeWithData:)])
    {
        NSIndexPath *indexPath = [CommonUtility MB_IndexPathForCellContainingView:sender];
        [_delegate setSelectItemViewCodeWithData:indexPath];
    }
}
@end

