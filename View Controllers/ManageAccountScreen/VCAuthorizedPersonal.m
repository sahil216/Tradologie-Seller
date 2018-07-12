//
//  VCAuthorizedPersonal.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 12/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "VCAuthorizedPersonal.h"
#import "Constant.h"
#import "AppConstant.h"

@interface VCAuthorizedPersonal ()<THSegmentedPageViewControllerDelegate>
{
    NSMutableArray *arrInfoTittle;
    NSMutableArray *arrPlaceHolder;
    BOOL isOpenSection;

}
@end

@implementation VCAuthorizedPersonal

- (void)viewDidLoad
{
    [super viewDidLoad];
     arrInfoTittle = [[NSMutableArray alloc]initWithObjects:@"Authorize Person Name *",@"Email-ID *",@"Mobile *",@"Designation *", nil];
     arrPlaceHolder = [[NSMutableArray alloc]initWithObjects:@"Authorize Person Name",@"Your Email-ID",@"Your Mobile Number",@"Your Designation", nil];
    isOpenSection = NO;
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
        if(isOpenSection)
        {
            return arrInfoTittle.count + 1;
        }
        else
        {
            return 0;
        }
    }
    else if (section == 1)
    {
        return 4;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"";
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 4)
        {
             cellIdentifier = @"Cell_Upload_Identifier";
            TVCellAuthorizedPerson *cell = (TVCellAuthorizedPerson *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell)
            {
                cell = [[TVCellAuthorizedPerson alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            [cell ConfigureUploadPersonInfoPicCellwithSectionIndex:indexPath.row];
            return cell;
        }
        else
        {
            cellIdentifier=@"Cell_Personal_Identifier";
            
            TVCellAuthorizedPerson *cell = (TVCellAuthorizedPerson *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell)
            {
                cell = [[TVCellAuthorizedPerson alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            [cell ConfigureAuthorizedPersonInfoCellwithSectionIndex:[arrInfoTittle objectAtIndex:indexPath.row] withPlaceholder:[arrPlaceHolder objectAtIndex:indexPath.row]];
            return cell;
        }
    }
    
    cellIdentifier=@"Cell_List_ID";
    
    TVCellAuthorizedPerson *cell = (TVCellAuthorizedPerson *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[TVCellAuthorizedPerson alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [cell ConfigureListAuthenticatePersonInfoCell:indexPath.row withData:nil];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.section == 0)
   {
       if (indexPath.row == 4)
       {
           return 160;
       }
       return 75;
   }
    return 65;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
        [viewHeader setBackgroundColor:[UIColor whiteColor]];
        
        UIView *ViewBG = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, 60)];
        [ViewBG SetDefaultShadowBackGround];
        [ViewBG setBackgroundColor:[UIColor whiteColor]];
        [ViewBG.layer setBorderColor:DefaultButtonColor.CGColor];
        
        [self getLableAccordingtoView:ViewBG withTittle:@"ADD NEW AUTHORIZATION" withFrame:CGRectMake(5, 5,ViewBG.frame.size.width - 50, 50) withSize:18 withTextColor:[UIColor orangeColor] withAlignment:NSTextAlignmentLeft];
        
        UIButton *btnCollapse = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCollapse setFrame:CGRectMake(ViewBG.frame.size.width - 50, 15, 30, 30)];
        [btnCollapse setBackgroundColor:[UIColor clearColor]];
        
        if (isOpenSection)
        {
            [btnCollapse setImage:IMAGE(@"IconCloseCell") forState:UIControlStateNormal];
        }
        else
        {
            [btnCollapse setImage:IMAGE(@"IconOpenCell") forState:UIControlStateNormal];

        }
        [btnCollapse addTarget:self action:@selector(touchedSection:) forControlEvents:UIControlEventTouchUpInside];
        btnCollapse.tag = section;
        
        [ViewBG addSubview:btnCollapse];
        [viewHeader addSubview:ViewBG];
        
        return viewHeader;
    }
    UIView *viewHeaderSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [viewHeaderSection setBackgroundColor:[UIColor clearColor]];
    
    UIView *ViewBG2 = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, 60)];
    [ViewBG2 SetDefaultShadowBackGround];
    [ViewBG2 setBackgroundColor:DefaultThemeColor];
    [ViewBG2.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self getLableAccordingtoView:ViewBG2 withTittle:@"Sr" withFrame:CGRectMake(5, 5, 45, 50) withSize:17 withTextColor:[UIColor whiteColor] withAlignment:NSTextAlignmentCenter];
    [self getLableAccordingtoView:ViewBG2 withTittle:@"Authorize Person Name" withFrame:CGRectMake(55, 5, 150, 50) withSize:16 withTextColor:[UIColor whiteColor] withAlignment:NSTextAlignmentCenter];
    [self getLableAccordingtoView:ViewBG2 withTittle:@"Designation" withFrame:CGRectMake(225, 5, 120, 50) withSize:16 withTextColor:[UIColor whiteColor] withAlignment:NSTextAlignmentCenter];
    [viewHeaderSection addSubview:ViewBG2];
    
    return viewHeaderSection;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 75;
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
#pragma mark ❉===❉=== BUTTON ACTION EVENT CALLED HERE===❉===❉
/*****************************************************************************************************************/

- (IBAction)touchedSection:(id)sender
{
    UIButton *btnSection = (UIButton *)sender;
    
    NSInteger section = btnSection.tag;
    
    if(btnSection.tag == section)
    {
        NSLog(@"Touched Customers header");
        if(!isOpenSection)
        {
            isOpenSection = YES;
            [sender setImage:IMAGE(@"IconCloseCell") forState:UIControlStateNormal];

            [self reloadTableInputViewsWithSection:section];
        }
        else
        {
            isOpenSection = NO;
            [sender setImage:IMAGE(@"IconOpenCell") forState:UIControlStateNormal];

            [self reloadTableInputViewsWithSection:section];
        }
    }
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== RELOAD DATA HERE ===❉===❉
/*****************************************************************************************************************/
-(void)reloadTableInputViewsWithSection:(NSInteger )section
{
    NSRange range = NSMakeRange(0, 1);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tblPersonInfo reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
}
@end
