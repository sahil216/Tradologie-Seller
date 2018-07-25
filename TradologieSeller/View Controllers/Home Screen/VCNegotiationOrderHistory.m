//
//  VCNegotiationOrderHistory.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 09/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "VCNegotiationOrderHistory.h"
#import "Constant.h"
#import "AppConstant.h"
#import "SharedManager.h"
#import "MBAPIManager.h"
#import "CommonUtility.h"
#import "MBDataBaseHandler.h"

#define K_CUSTOM_WIDTH 170

@interface VCNegotiationOrderHistory ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *arrTittle;
    NSMutableArray *arrData;
    float headerTotalWidth;
    NSInteger count;
    CGFloat height , lblHeight;
    UITextField *txtGPSCode, *txtSortBuy;
}
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, assign) BOOL hideStatusBar;
@end

@implementation VCNegotiationOrderHistory

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setNavigationTittleWithLogoforLanscapeMode:@"Negotiation List"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem SetBackButtonWithID:self withSelectorAction:@selector(btnBackItemTaped:)];
    
    lblHeight = 90;
    
    [self SetInitialSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if([self respondsToSelector:@selector(edgesForExtendedLayout)])
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.myTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    });
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
    
    headerTotalWidth =  SCREEN_WIDTH * 2.22;
    
    height = ([SDVersion deviceSize] > Screen4Dot7inch)?_contentView.frame.size.height - 75:([SDVersion deviceSize] < Screen4Dot7inch)?_contentView.frame.size.height - 65:_contentView.frame.size.height - 70;
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, headerTotalWidth, height) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.bounces=NO;
    self.myTableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIScrollView *myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
    myScrollView.bounces=NO;
    [myScrollView addSubview:tableView];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    myScrollView.contentSize = CGSizeMake(headerTotalWidth, 0);
    [_contentView addSubview:myScrollView];
    
    [self GetOrderHistoryWithData];
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW DELEGATE & DATA SOURCE CALLED HERE ===❉===❉
/*****************************************************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"cell_Identifier";
    TVCellOrderHistory *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[TVCellOrderHistory alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier itemSize:CGSizeMake(K_CUSTOM_WIDTH + 30, lblHeight) headerArray:arrTittle];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.dataDict = [arrData objectAtIndex:indexPath.row];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [arrTittle count] * K_CUSTOM_WIDTH + 30, 90)];
    [viewHeader setBackgroundColor:DefaultThemeColor];//
    
    UIView *ViewBG =[[UIView alloc]initWithFrame:CGRectMake(0, 50, ([arrTittle count] * K_CUSTOM_WIDTH) + 30, 50)];
    [ViewBG setBackgroundColor:DefaultThemeColor];
    int xx = 0;
    int width = 80;
    
    for(int i = 0 ; i < [arrTittle count]; i++)
    {
        UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(xx, 0, width, 50)];
        [headLabel setText:[arrTittle objectAtIndex:i]];
        [headLabel setTextAlignment:NSTextAlignmentCenter];
        [headLabel setNumberOfLines:0];
        [headLabel setTextColor:[UIColor whiteColor]];
        [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [headLabel setFont:IS_IPHONE5? UI_DEFAULT_FONT_MEDIUM(18):UI_DEFAULT_FONT_MEDIUM(20)];
        [ViewBG addSubview:headLabel];
    
        xx = xx + width;
        
        if(i == arrTittle.count - 5)
        {
            width = K_CUSTOM_WIDTH - 50;
        }
        else if(i == arrTittle.count - 4)
        {
            width = K_CUSTOM_WIDTH + 50;
        }
        else
        {
            width = K_CUSTOM_WIDTH + 30;
            
        }
    }
    [viewHeader addSubview:ViewBG];
  
    
    return viewHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return lblHeight + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== BUTTON ACTION EVENT CALLED HERE ===❉===❉
/*****************************************************************************************************************/
-(IBAction)btnBackItemTaped:(UIButton *)sender
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
/******************************************************************************************************************/
#pragma mark ❉===❉=== GET ORDER HISTORY API CALLED HERE ===❉===❉
/******************************************************************************************************************/
-(void)GetOrderHistoryWithData
{
    arrTittle = [[NSMutableArray alloc]initWithObjects:@"Sr.No",@"Negotiation No",@"Order Number",@"Order Status",@"Total Order Quantity",@"Delivery Last Date",@"Start Date",@"End Date",nil];
    
    arrData = [[NSMutableArray alloc]init];
    count = 0;
    
    [self GetAuctionOrderHistoryWithData];
}
/******************************************************************************************************************/
#pragma mark ❉===❉===  GET AUCTION ORDER HISTORY LIST API CALLED HERE ===❉===❉
/******************************************************************************************************************/
-(void)GetAuctionOrderHistoryWithData
{
    SellerUserDetail *objSellerUser = [MBDataBaseHandler getSellerUserDetailData];
    NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
    [dicParams setObject:objSellerUser.APIVerificationCode forKey:@"Token"];
    [dicParams setObject:objSellerUser.VendorID forKey:@"VendorID"];
    [dicParams setObject:@"" forKey:@"FilterAuction"];

    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait.."];
        
        MBCall_SupplierAuctionOrderHistoryWithVendorID(dicParams, ^(id response, NSString *error, BOOL status)
        {
            [CommonUtility HideProgress];
            
            if (status && [[response valueForKey:@"success"]isEqual:@1])
            {
                if (response != (NSDictionary *)[NSNull null])
                {
                    NSError* Error;
                    SellerAuctionOrderHistory *objOrderHistory = [[SellerAuctionOrderHistory alloc]initWithDictionary:response error:&Error];
                    [MBDataBaseHandler saveSellerAuctionOrderHistoryData:objOrderHistory];

                    for (SellerAuctionOrderHistoryData *data in objOrderHistory.detail)
                    {
                        NSMutableDictionary *dataDict = [NSMutableDictionary new];
                        self->count ++;

                        [dataDict setObject:[NSString stringWithFormat:@"%ld",(long)self->count] forKey:[self->arrTittle objectAtIndex:0]];
                        [dataDict setObject:data.AuctionCode forKey:[self->arrTittle objectAtIndex:1]];
                        [dataDict setObject:data.PONo forKey:[self->arrTittle objectAtIndex:2]];
                        [dataDict setObject:data.OrderStatus forKey:[self->arrTittle objectAtIndex:3]];
                        [dataDict setObject:data.TotalQuantity forKey:[self->arrTittle objectAtIndex:4]];

                         NSString *strStartDate = [CommonUtility getDateFromSting:data.StartDate fromFromate:@"MM/dd/yyyy hh:mm:ss a" withRequiredDateFormate:@"dd-MMM-yyyy HH:mm"];
                         NSString *strEndDate = [CommonUtility getDateFromSting:data.EndDate fromFromate:@"MM/dd/yyyy hh:mm:ss a" withRequiredDateFormate:@"dd-MMM-yyyy HH:mm"];
                         NSString *strDeliveryLastDate = [CommonUtility getDateFromSting:data.DeliveryLastDate fromFromate:@"MM/dd/yyyy hh:mm:ss a" withRequiredDateFormate:@"dd-MMM-yyyy HH:mm"];

                        [dataDict setObject:strDeliveryLastDate forKey:[self->arrTittle objectAtIndex:5]];
                        [dataDict setObject:strStartDate forKey:[self->arrTittle objectAtIndex:6]];
                        [dataDict setObject:strEndDate forKey:[self->arrTittle objectAtIndex:7]];
                        [self->arrData addObject:dataDict];

                    }
                    [self.myTableView reloadData];
                }
                else
                {
                    [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:[response valueForKey:@"message"]];
                }
            }
            else
            {
                [CommonUtility HideProgress];
                [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:error];
            }
        });
        
    }
    else{
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
    }
}
@end
