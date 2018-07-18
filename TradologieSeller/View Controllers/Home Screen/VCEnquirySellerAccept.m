//
//  VCEnquirySellerAccept.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 04/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "VCEnquirySellerAccept.h"
#import "Constant.h"
#import "AppConstant.h"
#import "MBDataBaseHandler.h"
#import "CommonUtility.h"
#import "MBAPIManager.h"
#import "SharedManager.h"
#import "TVPaymentScreen.h"

#define K_CUSTOM_WIDTH 150

@interface VCEnquirySellerAccept ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,EnquirySellerAcceptCellDelegate>
{
    NSMutableArray *arrSellerAucList;
    NSMutableArray *arrSellerAucListData;
    float headerTotalWidth;
    NSInteger count,SupplierCount;
    CGFloat height , lblHeight;
    NSString *strTotalAmt;
    NSString *strTextValue;
    
    CGFloat viewHeight;
    UITextField *txtRemarks;
}
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) ViewEnquiryState * viewLandscape;

@end

@implementation VCEnquirySellerAccept

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setNavigationTittleWithLogoforLanscapeMode:@"Enquiry Seller Acceptance"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    arrSellerAucList = [[NSMutableArray alloc]initWithObjects:@"Sr.No",@"Grade",@"Quantity",@"Packing Type",@"Packing Size",@"Packing Image",nil];
    
    lblHeight = 120;
    strTotalAmt = @"0.0";
    [self SetInitialSetup];
    [self.navigationItem SetBackButtonWithID:self withSelectorAction:@selector(btnBackItem:)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== SET INITIAL SETUP ===❉===❉
/*****************************************************************************************************************/
-(void)SetInitialSetup
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT + 20)];
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_contentView];
    
    headerTotalWidth =  SCREEN_WIDTH * 1.70;
    
    height = ([SDVersion deviceSize] > Screen4Dot7inch)?_contentView.frame.size.height - 75:([SDVersion deviceSize] < Screen4Dot7inch)?_contentView.frame.size.height - 65:_contentView.frame.size.height - 70;
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, headerTotalWidth, height) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.bounces=NO;
    self.myTableView = tableView;
    [self.myTableView setBackgroundColor:[UIColor whiteColor]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIScrollView *myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
    myScrollView.bounces=NO;
    [myScrollView addSubview:tableView];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    myScrollView.contentSize = CGSizeMake(headerTotalWidth, 0);
    [_contentView addSubview:myScrollView];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"EnquirySellerAcceptCell" bundle:nil] forCellReuseIdentifier:@"Cell_ID"];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ViewEnquiryState" owner:self options:nil];
    _viewLandscape = [subviewArray objectAtIndex:0];
    viewHeight = _viewLandscape.frame.size.height - 250;
    
    [self getSellerAuctionDetailDataBase];
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW DELEGATE & DATA SOURCE CALLED HERE ===❉===❉
/*****************************************************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_isfromChargeAccount == 1)
    {
        return 3;
    }
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return  0;
    }
    else if (section == 1)
    {
        return  (arrSellerAucListData.count > 0) ?arrSellerAucListData.count:0;
    }
    else if (section == 2)
    {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"";
    
    if(indexPath.section == 1)
    {
        cellIdentifier = COMMON_CELL_ID;
        SAuctionDetailCell *cell = (SAuctionDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell=[[SAuctionDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier itemSize:CGSizeMake(K_CUSTOM_WIDTH + 50, lblHeight) headerArray:arrSellerAucList isWithBoolValue:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.dataDict = [arrSellerAucListData objectAtIndex:indexPath.row];
        
        return cell;
    }
    if(indexPath.section == 2)
    {
        cellIdentifier = @"Cell_ID";
        EnquirySellerAcceptCell *cell = (EnquirySellerAcceptCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell= [[EnquirySellerAcceptCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell ConfigureNotificationListbyCellwithSectionIndex:2 withAmtParticipate:strTotalAmt];
        [cell setDelegate:self];
        return cell;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==  0)
    {
        SellerAuctionDetail *data = [MBDataBaseHandler getSellerAuctionDetailData];
        [_viewLandscape setDataDict:data];
        return _viewLandscape;
    }
    else if (section ==  1)
    {
        UIView *Viewsection2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [arrSellerAucList count] * K_CUSTOM_WIDTH, 100)];
        [Viewsection2 setBackgroundColor:DefaultThemeColor];
        
        [self getLableAccordingtoView:Viewsection2 withTittle:@"Enquiry Product List" withfame:CGRectMake(10, 0, Viewsection2.frame.size.width - 10, 45) WithColor:[UIColor whiteColor]];
        
        int xx = 10;
        int width = 80;
        
        for(int i = 0 ; i < [arrSellerAucList count] ; i++)
        {
            UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(xx, Viewsection2.frame.size.height/2, width, 45)];
            [headLabel setText:[arrSellerAucList objectAtIndex:i]];
            [headLabel setTextAlignment:NSTextAlignmentCenter];
            [headLabel setNumberOfLines:0];
            [headLabel setTextColor:[UIColor whiteColor]];
            [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [headLabel setFont:UI_DEFAULT_FONT_MEDIUM(18)];
            [Viewsection2 addSubview:headLabel];
            
            xx = xx + width + 10;
            if (i == 0)
            {
                width = K_CUSTOM_WIDTH + 100;
                [headLabel setTextAlignment:NSTextAlignmentLeft];
                
            }
            else if (i == 1)
            {
                width = 120;
                [headLabel setTextAlignment:NSTextAlignmentLeft];
                
            }
            else
            {
                width = K_CUSTOM_WIDTH + 50;
                [headLabel setTextAlignment:NSTextAlignmentCenter];
            }
        }
        return Viewsection2;
    }
    
    UIView *tableViewHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [arrSellerAucList count] * K_CUSTOM_WIDTH, 150)];
    [tableViewHeadView setBackgroundColor:[UIColor whiteColor]];
    
    [self getLableAccordingtoView:tableViewHeadView withTittle:@"Remarks :- " withfame:CGRectMake(20, 0, tableViewHeadView.frame.size.width, 45) WithColor:DefaultThemeColor];
    
    txtRemarks = [[UITextField alloc]initWithFrame:CGRectMake(20, 45, SCREEN_HEIGHT * 2, 100)];
    [txtRemarks setDefaultTextfieldStyleWithPlaceHolder:@"Enter Your Remarks" withTag:1001];
    [txtRemarks setFont:UI_DEFAULT_FONT_MEDIUM(18)];
    [txtRemarks setDelegate:self];
    [tableViewHeadView addSubview:txtRemarks];
    
    return tableViewHeadView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return lblHeight + 10;
    }
    if (indexPath.section == 2)
    {
        return 110;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return viewHeight;
    }
    else if (section == 1)
    {
        return 100;
    }
    return 150;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [arrSellerAucList count] * K_CUSTOM_WIDTH, 60)];
    [viewBG setBackgroundColor:[UIColor whiteColor]];
    
    [self addButtonWithFrame:CGRectMake(15, 5, SCREEN_HEIGHT-20, 50) WithSubView:viewBG withbtnTittle:@"Participating" withAction:@selector(btnParticiPatingTapped:)];
    
    [self addButtonWithFrame:CGRectMake(SCREEN_HEIGHT + 30, 5, SCREEN_HEIGHT-20, 50) WithSubView:viewBG withbtnTittle:@"Not Participating" withAction:@selector(btnNotParticiPatingTapped:)];
    
    return viewBG;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 60;
    }
    return CGFLOAT_MIN;
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== TEXTFIELD DELEGATE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.myTableView.contentOffset = CGPointMake(0, SCREEN_HEIGHT + 400);
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.myTableView.contentOffset = CGPointMake(0, SCREEN_HEIGHT + 200);
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== CELL DELEGATE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

- (void)textFieldValueChange:(NSString *)txtAmtValue
{
    SellerAuctionDetail *objData = [MBDataBaseHandler getSellerAuctionDetailData];
    CGFloat price = [objData.AuctionRefAmt floatValue] * [txtAmtValue floatValue];
    CGFloat totalPrice = ( price * [objData.AuctionSellerMarginPer floatValue]) /100;
    strTotalAmt = [NSString stringWithFormat:@"%.1f",totalPrice];
    strTextValue = [NSString stringWithFormat:@"%@",txtAmtValue];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    EnquirySellerAcceptCell *cell = (EnquirySellerAcceptCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
    [cell.lblAmtPaticipating setText:@""];
    [cell.lblAmtPaticipating setText:strTotalAmt];
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== ADD BUTTON ON FOOTER  ===❉===❉
/*****************************************************************************************************************/

-(void)addButtonWithFrame:(CGRect)frame WithSubView:(UIView *)viewBG withbtnTittle:(NSString *)strBtnTittle
               withAction:(SEL)selector
{
    UIButton *btnView = [[UIButton alloc]initWithFrame:frame];
    [btnView setDefaultButtonShadowStyle:DefaultThemeColor];
    [btnView setTitle:strBtnTittle forState:UIControlStateNormal];
    [btnView.titleLabel setFont:UI_DEFAULT_FONT_MEDIUM(18)];
    [btnView addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [viewBG addSubview:btnView];
}
-(IBAction)btnNotParticiPatingTapped:(UIButton *)sender
{
    [self SupplierAuctionAcceptanceWithID:@"NotAccepted"];

}
-(IBAction)btnParticiPatingTapped:(UIButton *)sender
{
    [self SupplierAuctionAcceptanceWithID:@"PaymentPending"];
}

/******************************************************************************************************************/
#pragma mark ❉===❉===  GET DASHBOARD NOTIFICATION API CALLED HERE ===❉===❉
/******************************************************************************************************************/

-(void)SupplierAuctionAcceptanceWithID:(NSString *)strParticipate
{
    if ([strTextValue isEqualToString:@""] || strTextValue == nil)
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter Total Quantity for Participating..!"];
        return;
    }
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait.."];
        SellerUserDetail *objseller = [MBDataBaseHandler getSellerUserDetailData];
        SellerAuctionDetail *objData = [MBDataBaseHandler getSellerAuctionDetailData];

        NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
        [dicParams setObject:objseller.APIVerificationCode forKey:@"Token"];
        [dicParams setObject:objData.AuctionID forKey:@"AuctionID"];
        [dicParams setObject:objseller.VendorID forKey:@"VendorID"];
        [dicParams setObject:strParticipate forKey:@"ParticipateStatus"];
        [dicParams setObject:strTextValue forKey:@"ParticipateQty"];
        [dicParams setObject:strTotalAmt forKey:@"AuctionCharges"];
        [dicParams setObject:txtRemarks.text forKey:@"Remarks"];
    
        MBCall_SupplierAuctionAcceptanceAPI(dicParams, ^(id response, NSString *error, BOOL status)
        {
            [CommonUtility HideProgress];
            if (status && [[response valueForKey:@"success"]isEqual:@1])
            {
                if (response != (NSDictionary *)[NSNull null])
                {
                    [[UIDevice currentDevice] setValue:
                     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
                    
                    TVPaymentScreen *objScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVPaymentScreen"];
                    objScreen.strAuctionID = [objData.AuctionID stringValue];
                    [self.navigationController pushViewController:objScreen animated:YES];
                    
                }
            }
            else
            {
                [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:error];
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
#pragma mark ❉===❉=== ADD LEVEL ON HEADER ===❉===❉
/*****************************************************************************************************************/

-(void)getLableAccordingtoView:(UIView *)viewBG withTittle:(NSString *)strTittle withfame:(CGRect)frame WithColor:(UIColor *)color
{
    UILabel *lblbHeaderTittle= [[UILabel alloc]initWithFrame:frame];
    [lblbHeaderTittle setText:strTittle];
    [lblbHeaderTittle setFont:UI_DEFAULT_FONT_MEDIUM(18)];
    [lblbHeaderTittle setTextColor:color];
    [lblbHeaderTittle setBackgroundColor:[UIColor clearColor]];
    [viewBG addSubview:lblbHeaderTittle];
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== BUTTON ACTION EVENT CALLED HERE ===❉===❉
/*****************************************************************************************************************/

-(IBAction)btnBackItem:(UIButton *)sender
{
    if (_isScreenFrom == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
        [self.navigationItem setNavigationTittleWithLogo:@"tradologie.com"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            RootViewController * rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
            AppDelegate *delegateClass = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [delegateClass setRootViewController:rootVC];
        });
    }
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== GET DATA FROM DATABASE HERE ===❉===❉
/******************************************************************************************************************/
-(void)getSellerAuctionDetailDataBase
{
    SellerAuctionDetail *objData = [MBDataBaseHandler getSellerAuctionDetailData];
    arrSellerAucListData = [[NSMutableArray alloc]init];
    count = 0;
    
    for (SellerAuctionTranList *data in objData.AuctionTranList)
    {
        NSMutableDictionary *dataDict = [NSMutableDictionary new];
        count ++;
        
        [dataDict setObject:[NSString stringWithFormat:@"%lu",count] forKey:[arrSellerAucList objectAtIndex:0]];
        [dataDict setObject:[data.CustomCategory stringByAppendingString:[@"\n " stringByAppendingString:[data.AttributeValue1 stringByAppendingString:[@"\n " stringByAppendingString:data.AttributeValue2]]]] forKey:[arrSellerAucList objectAtIndex:1]];
        [dataDict setObject:data.Quantity forKey:[arrSellerAucList objectAtIndex:2]];
        [dataDict setObject:data.PackingType forKey:[arrSellerAucList objectAtIndex:3]];
        [dataDict setObject:data.PackingSize forKey:[arrSellerAucList objectAtIndex:4]];
        [dataDict setObject:data.PackingImageUrl forKey:[arrSellerAucList objectAtIndex:5]];
        
        [arrSellerAucListData addObject:dataDict];
    }
    [self.myTableView reloadData];
}
@end
