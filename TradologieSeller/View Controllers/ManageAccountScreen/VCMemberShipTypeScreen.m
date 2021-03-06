//
//  VCMemberShipTypeScreen.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 18/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "VCMemberShipTypeScreen.h"
#import "Constant.h"
#import "AppConstant.h"
#import "CommonUtility.h"
#import "MBAPIManager.h"
#import "MBDataBaseHandler.h"
#import "SharedManager.h"

#define K_CUSTOM_WIDTH 150


@interface VCMemberShipTypeScreen ()<THSegmentedPageViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,
TVCellMemberShipPlanDelegate,UITextFieldDelegate>
{
    NSMutableArray *arrHeaderTittle;
    NSMutableArray *arrMemberData;
    NSMutableArray *arrStaticValue;
    NSMutableDictionary *dicMemberShipPlan;
  
    float headerTotalWidth;
    UILabel *headLabel;
    CGFloat height , lblHeight;
}
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic,strong)  UITableView *tblMemberType;
@end


@implementation VCMemberShipTypeScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrHeaderTittle = [[NSMutableArray alloc]initWithObjects:@" Plan",@"MemberShip fee (INR)",@"Participation fee (INR)",@"No.of free Participation",@"Email Marketing to Buyers",@"Commission",@"E-Brochure",@"Microsite",@"Advertisement",nil];
    
    arrStaticValue = [[NSMutableArray alloc]initWithObjects:@"Inaugural Offer: - ",@"❉ The Cost of Membership includes Service Tax @ 15%.",@"❉ Any Convenience Fee, if applicable shall be charged extra.",@"❉ The rates for the yearly subscription are discounted by 10%.",@"❉ The rates are subject to change without any prior intimation. ",@"❉ Changes in rates shall not affect your current membership for the duration of the membership. ",@"❉ Renewal of Membership shall be done only on the applicable rates at the time of Renewal.",@"❉ Participation fee of the successful seller shall be adjusted against his commission.",@"❉ The Inaugural offer of an additional period in the same price is valid for limited period and can be withdrawn at any time at the discretion of tradologie.com.",nil];
    
    lblHeight = 60;
    
    [self setInitialSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setInitialSetup
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0 , SCREEN_WIDTH , SCREEN_HEIGHT - 20)];
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_contentView];
    
    headerTotalWidth =  ([arrHeaderTittle count] * K_CUSTOM_WIDTH) * 1.20;
    
    height = ([SDVersion deviceSize] > Screen4Dot7inch)?_contentView.frame.size.height - 75:([SDVersion deviceSize] < Screen4Dot7inch)?_contentView.frame.size.height - 65:_contentView.frame.size.height - 90;
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, headerTotalWidth, height) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.bounces=NO;
    self.tblMemberType = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIScrollView *myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 5, _contentView.frame.size.width, _contentView.frame.size.height)];
    myScrollView.bounces=NO;
    [myScrollView setBackgroundColor:[UIColor whiteColor]];
    [myScrollView addSubview:tableView];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    myScrollView.contentSize = CGSizeMake(headerTotalWidth, 0);
    [_contentView addSubview:myScrollView];
    
    [self getSupplierInformationServiceCalled];
    [self MBCall_GetParticularVendorMemberShipPlanAPI];

    [self.tblMemberType registerNib:[UINib nibWithNibName:@"TVCellMemberShipPlan" bundle:nil] forCellReuseIdentifier:CELL_MEMBERSHIP_ID];
    
    [self.tblMemberType registerNib:[UINib nibWithNibName:@"TVStaticMemberCell" bundle:nil] forCellReuseIdentifier:@"CellStaticDetailID"];
    
    [self.tblMemberType registerNib:[UINib nibWithNibName:@"TVStaticBankDetailCell" bundle:nil] forCellReuseIdentifier:@"CellStaticBankDetailID"];
    
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW DELEGATE & DATA SOURCE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(arrMemberData.count > 0)
    {
        if (section == 0)
        {
            return arrMemberData.count;
        }
        else if (section == 1)
        {
            return 1;
        }
        else if (section == 2)
        {
            return arrStaticValue.count;
        }
        return 1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"";
    
    if (indexPath.section == 0)
    {
        cellIdentifier = @"CellMemberTypeIdentifier";
        
        TVCellMembershipType *cell = (TVCellMembershipType *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil)
        {
            cell = [[TVCellMembershipType alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier itemSize:CGSizeMake(K_CUSTOM_WIDTH, lblHeight) headerArray:arrHeaderTittle];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row % 2)
        {
            cell.backgroundColor = [UIColor whiteColor];
        } else
        {
            cell.backgroundColor = GET_COLOR_WITH_RGB(240, 235, 235, 1.0f);
        }
        cell.dataDict = [arrMemberData objectAtIndex:indexPath.row];
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        cellIdentifier = CELL_MEMBERSHIP_ID;
        
        TVCellMemberShipPlan *cell = (TVCellMemberShipPlan *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil)
        {
            cell = [[TVCellMemberShipPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell setDelegate:self];
        [cell.txtMemberType setDelegate:self];
        [cell.txtMemberType setText:[dicMemberShipPlan valueForKey:@"MembershipPlan"]];
        NSNumber * amt = [NSNumber numberWithInteger:[[dicMemberShipPlan valueForKey:@"MembershipAmount"] intValue]];
        [cell.lblMemberAmount setText:[NSString stringWithFormat:@"MemberShip Amount (INR) : - %@.0",amt]];
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        cellIdentifier = @"CellStaticDetailID";
        
        TVStaticMemberCell *cell = (TVStaticMemberCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[TVStaticMemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        [cell ConfigureStaticMemberTypeCellData:[arrStaticValue objectAtIndex:indexPath.row]];
        
        return cell;
    }
    cellIdentifier = @"CellStaticBankDetailID";
    
    TVStaticBankDetailCell *cell = (TVStaticBankDetailCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[TVStaticBankDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return lblHeight;
    }
    else if (indexPath.section == 1)
    {
        return 275;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == arrStaticValue.count - 1)
        {
            return 90;
        }
        return 50;
    }
    else
    {
        return 220;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *viewSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, headerTotalWidth, 80)];
        [viewSection setBackgroundColor:[UIColor whiteColor]];
        
        UIView *ViewBG = [[UIView alloc]initWithFrame:CGRectMake(5, 5, headerTotalWidth - 10, 70)];
        [ViewBG SetDefaultShadowBackGround];
        [ViewBG setBackgroundColor:DefaultThemeColor];
        [ViewBG.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        int xx = 5;
        int width = 150;
        
        for(int i = 0 ; i < [arrHeaderTittle count] ; i++)
        {
            headLabel=[[UILabel alloc]initWithFrame:CGRectMake(xx, 5, width, ViewBG.frame.size.height - 10)];
            [headLabel setText:[arrHeaderTittle objectAtIndex:i]];
            [headLabel setNumberOfLines:0];
            [headLabel setTextColor:[UIColor whiteColor]];
            [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [headLabel setFont:UI_DEFAULT_FONT_MEDIUM(18)];
            [ViewBG addSubview:headLabel];
            
            xx = xx + width + 10;
            if (i == 0)
            {
                [headLabel setTextAlignment:NSTextAlignmentLeft];
            }
            else if (i == 3)
            {
                width = K_CUSTOM_WIDTH + 30;
                [headLabel setTextAlignment:NSTextAlignmentCenter];
                
            }
            else
            {
                width = K_CUSTOM_WIDTH;
                [headLabel setTextAlignment:NSTextAlignmentCenter];
            }
        }
        [viewSection addSubview:ViewBG];
        
        return viewSection;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 80;
    }
    return CGFLOAT_MIN;
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

-(void)selectMemberShipPlan:(UIButton *)sender withIndex:(NSIndexPath *)index
{
    NSMutableArray *arrInfoTittle = [[NSMutableArray alloc]initWithObjects:@"Basic", nil];
    TVCellMemberShipPlan *cell = [self.tblMemberType cellForRowAtIndexPath:index];
    if (index.row == 0)
    {
        [CommonUtility showPopUpWithData:sender withArray:arrInfoTittle withCompletion:^(NSInteger response)
        {
            [cell.txtMemberType setText:[NSString stringWithFormat:@"%@",[arrInfoTittle objectAtIndex:response]]];
        } withDismissBlock:^{
        }];
    }
}
-(void)btnSubmitPlanTapped:(UIButton *)sender
{
    [self postUpdateMembershipDetailAPI];
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== TEXTFIELD DELEGATE CALLED HERE ===❉===❉
/******************************************************************************************************************/
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return NO;
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== GET SUPPLIER INFORMATION SERVICE CALLED ===❉===❉
/******************************************************************************************************************/
-(void)getSupplierInformationServiceCalled
{
    SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:objSeller.APIVerificationCode forKey:@"Token"];
    [dic setValue:objSeller.VendorID forKey:@"VendorID"];
    
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait...!"];
        
        MBCall_GetVendorMemberShipPlanListAPI(dic, ^(id response, NSString *error, BOOL status)
        {
            [CommonUtility HideProgress];
            
            self->arrMemberData = [[NSMutableArray alloc]init];
            
            if (status && [[response valueForKey:@"success"]  isEqual: @1])
            {
                for (NSMutableDictionary *data in [response valueForKey:@"detail"])
                {
                    NSMutableDictionary *dataDict = [NSMutableDictionary new];
                    
                    [dataDict setObject:[data valueForKey:@"MembershipPlan"] forKey:[self->arrHeaderTittle objectAtIndex:0]];
                    [dataDict setObject:[data valueForKey:@"MembershipFeePerQuarterINR"] forKey:[self->arrHeaderTittle objectAtIndex:1]];
                    [dataDict setObject:[data valueForKey:@"ParticipationFeeINR"] forKey:[self->arrHeaderTittle objectAtIndex:2]];
                    [dataDict setObject:[data valueForKey:@"FreeAuctions"] forKey:[self->arrHeaderTittle objectAtIndex:3]];
                    [dataDict setObject:[data valueForKey:@"BuyersEmailMarketing"] forKey:[self->arrHeaderTittle objectAtIndex:4]];
                    [dataDict setObject:[data valueForKey:@"GrossTransactionValueCommission"] forKey:[self->arrHeaderTittle objectAtIndex:5]];
                    [dataDict setObject:[data valueForKey:@"EBrochure"] forKey:[self->arrHeaderTittle objectAtIndex:6]];
                    [dataDict setObject:[data valueForKey:@"Microsite"]forKey:[self->arrHeaderTittle objectAtIndex:7]];
                    [dataDict setObject:[data valueForKey:@"Advertisement"]forKey:[self->arrHeaderTittle objectAtIndex:8]];
                    
                    [self->arrMemberData addObject:dataDict];
                    
                }
                [self.tblMemberType reloadData];
            }
            else
            {
                [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:[response valueForKey:@"message"]];
            }
        });
    }
    else
    {
        [CommonUtility HideProgress];
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
    }
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== GET SUPPLIER INFORMATION SERVICE CALLED ===❉===❉
/******************************************************************************************************************/
-(void)postUpdateMembershipDetailAPI
{
    SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:objSeller.APIVerificationCode forKey:@"Token"];
    [dic setValue:objSeller.VendorID forKey:@"VendorID"];
    [dic setValue:@1 forKey:@"MembershipTypeID"];/* MemberShipId Is Static Once we get List from Backend then it would be comming from list */
    
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait...!"];
        
        MBCall_GetUpdateMembershipDetailAPI(dic, ^(id response, NSString *error, BOOL status)
        {
            [CommonUtility HideProgress];
            if (status && [[response valueForKey:@"success"]  isEqual: @1])
            {
                
            }
            else
            {
                [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:[response valueForKey:@"message"]];
            }
        });
    }
    else
    {
        [CommonUtility HideProgress];
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
    }
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== GET SUPPLIER INFORMATION SERVICE CALLED ===❉===❉
/******************************************************************************************************************/
-(void)MBCall_GetParticularVendorMemberShipPlanAPI
{
    SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:objSeller.APIVerificationCode forKey:@"Token"];
    [dic setValue:objSeller.VendorID forKey:@"VendorID"];
    
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait...!"];
        
        MBCall_GetParticularVendorMemberShipPlanAPI(dic, ^(id response, NSString *error, BOOL status)
        {
            [CommonUtility HideProgress];
            self->dicMemberShipPlan = [[NSMutableDictionary alloc]init];

            if (status && [[response valueForKey:@"success"]  isEqual: @1])
            {
                self->dicMemberShipPlan = [[[response valueForKey:@"detail"]objectAtIndex:0] mutableCopy];
                [self reloadTableInputViewsWithSection:1];
            }
            else
            {
                [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:[response valueForKey:@"message"]];
            }
        });
    }
    else
    {
        [CommonUtility HideProgress];
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
    }
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== RELOAD DATA HERE ===❉===❉
/*****************************************************************************************************************/
-(void)reloadTableInputViewsWithSection:(NSInteger )section
{
    NSRange range = NSMakeRange(section, 0);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tblMemberType reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
}
@end
