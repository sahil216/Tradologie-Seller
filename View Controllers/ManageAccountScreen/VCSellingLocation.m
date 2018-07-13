//
//  VCSellingLocation.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 13/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "VCSellingLocation.h"
#import "Constant.h"
#import "AppConstant.h"
#import "CommonUtility.h"

@interface VCSellingLocation ()<THSegmentedPageViewControllerDelegate,TVCellSellingLocationDelegate>
{
    NSMutableArray *arrInfoTittle;
    NSMutableArray *arrPlaceHolder;
    NSMutableArray *arrStateList;

}
@end

@implementation VCSellingLocation

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrInfoTittle = [[NSMutableArray alloc]initWithObjects:@"State / Province *",@"City *",nil];
    arrPlaceHolder = [[NSMutableArray alloc]initWithObjects:@"-- Select State --",@"-- Select City --", nil];
    arrStateList = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW DELEGATE & DATA SOURCE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return arrInfoTittle.count + 1;
    }
    else if (section == 1)
    {
        return 3;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell_ID_Location = @"";
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 2)
        {
            cell_ID_Location = @"cell_btn_Identifier";
            
            TVCellSellingLocation *cell = (TVCellSellingLocation *)[tableView dequeueReusableCellWithIdentifier:cell_ID_Location];
            
            if(!cell)
            {
                cell = [[TVCellSellingLocation alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_ID_Location];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.btnSubmitLocation setDefaultButtonShadowStyle:DefaultThemeColor];
            [cell.btnSubmitLocation.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
            [cell.btnSubmitLocation addTarget:self action:@selector(btnSubmitLocationDetail:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        else
        {
            cell_ID_Location = @"Cell_Location_Identifier";

            TVCellSellingLocation *cell = (TVCellSellingLocation *)[tableView dequeueReusableCellWithIdentifier:cell_ID_Location];

            if(!cell)
            {
                cell = [[TVCellSellingLocation alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_ID_Location];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell ConfigureSellingLocationInfoCellData:[arrInfoTittle objectAtIndex:indexPath.row] withPlaceholder:[arrPlaceHolder objectAtIndex:indexPath.row]];
            [cell setDelegate:self];
            return cell;
        }
    }
    cell_ID_Location = @"Cell_Location_List_ID";
    
    TVCellSellingLocation *cell = (TVCellSellingLocation *)[tableView dequeueReusableCellWithIdentifier:cell_ID_Location];
    if(!cell)
    {
        cell = [[TVCellSellingLocation alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_ID_Location];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 80;
    }
    return 65;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [viewHeader setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *lblline= [[UILabel alloc]initWithFrame:CGRectMake(10, viewHeader.frame.size.height - 0.50, SCREEN_WIDTH - 20, 0.50)];
        [lblline setBackgroundColor:[UIColor lightGrayColor]];
        [viewHeader addSubview:lblline];
        
        [self getLableAccordingtoView:viewHeader withTittle:@"VENDOR SELLING LOCATION DETAILS" withFrame:CGRectMake(10, 5,viewHeader.frame.size.width - 20, viewHeader.frame.size.height - 10) withSize:18 withTextColor:[UIColor orangeColor] withAlignment:NSTextAlignmentLeft];
        return viewHeader;
    }
    UIView *viewHeaderSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    [viewHeaderSection setBackgroundColor:[UIColor clearColor]];
    
    UIView *ViewBG2 = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, 50)];
    [ViewBG2 SetDefaultShadowBackGround];
    [ViewBG2 setBackgroundColor:DefaultThemeColor];
    [ViewBG2.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self getLableAccordingtoView:ViewBG2 withTittle:@"Sr.No" withFrame:CGRectMake(5, 0, 40, 50) withSize:15 withTextColor:[UIColor whiteColor] withAlignment:NSTextAlignmentLeft];
    [self getLableAccordingtoView:ViewBG2 withTittle:@"State Name" withFrame:CGRectMake(50, 0, 115, 50) withSize:15 withTextColor:[UIColor whiteColor] withAlignment:NSTextAlignmentCenter];
    [self getLableAccordingtoView:ViewBG2 withTittle:@"City Name" withFrame:CGRectMake(170, 0, 110, 50) withSize:15 withTextColor:[UIColor whiteColor] withAlignment:NSTextAlignmentCenter];
    [self getLableAccordingtoView:ViewBG2 withTittle:@"Is Active" withFrame:CGRectMake(285, 0, 75, 50) withSize:15 withTextColor:[UIColor whiteColor] withAlignment:NSTextAlignmentCenter];
    
    [viewHeaderSection addSubview:ViewBG2];
    
    return viewHeaderSection;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== GET LABLE FOR HEADER HERE ===❉===❉
/*****************************************************************************************************************/

-(void)getLableAccordingtoView:(UIView *)viewBG withTittle:(NSString *)strTittle withFrame:(CGRect)frame withSize:(NSInteger)fontSize withTextColor:(UIColor *)color withAlignment:(NSTextAlignment )align
{
    UILabel *lblbHeaderTittle= [[UILabel alloc]initWithFrame:frame];
    [lblbHeaderTittle setText:strTittle];
    [lblbHeaderTittle setFont:UI_DEFAULT_FONT_BOLD(fontSize)];
    [lblbHeaderTittle setTextColor:color];
    [lblbHeaderTittle setTextAlignment:align];
    [lblbHeaderTittle setBackgroundColor:[UIColor clearColor]];
    [lblbHeaderTittle setNumberOfLines:0];
    [lblbHeaderTittle setLineBreakMode:NSLineBreakByWordWrapping];
    [viewBG addSubview:lblbHeaderTittle];
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== THSegmentedPageViewControllerDelegate ===❉===❉
/*****************************************************************************************************************/

-(NSString *)viewControllerTitle
{
    return _strManageAcTittle;
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== CELL DELEGATE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

-(void)setSelectItemViewWithData:(UIButton *)sender withIndex:(NSIndexPath *)index
{
    if (index.row == 0)
    {
        [CommonUtility showPopUpWithData:sender withArray:arrInfoTittle withCompletion:^(NSInteger response)
         {
             
         } withDismissBlock:^{
         }];
    }
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== BUTTON ACTION EVENT CALLED HERE ===❉===❉
/******************************************************************************************************************/

-(IBAction)btnSubmitLocationDetail:(UIButton *)sender
{
   
}


/******************************************************************************************************************/
#pragma mark ❉===❉=== TEXTFIELD DELEGATE CALLED HERE ===❉===❉
/******************************************************************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
