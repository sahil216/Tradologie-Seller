//
//  VCNegotiationScreen.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 09/06/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "VCNegotiationScreen.h"
#import "Constant.h"
#import "AppConstant.h"
#import "MBDataBaseHandler.h"
#import "CommonUtility.h"
#import "SharedManager.h"
#import "MBAPIManager.h"
#import "VCLoadLiveAuction.h"
#import "TVPaymentScreen.h"

#define K_CUSTOM_WIDTH 170

@interface VCNegotiationScreen ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TvCellEnquiryDelegate,INSSearchBarDelegate>
{
    NSMutableArray *arrTittle;
    NSMutableArray *arrData;
    float headerTotalWidth;
    NSInteger count;
    CGFloat height , lblHeight;
    UITextField *txtNegotiation;
    UILabel *headLabel;
    
    UIRefreshControl *refreshController;
    
}

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) INSSearchBar *searchBar;

@end

@implementation VCNegotiationScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setNavigationTittleWithLogoforLanscapeMode:@"Negotiation List"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem SetBackButtonWithID:self withSelectorAction:@selector(btnBackItemTaped:)];
    
    lblHeight = 110;
    
    arrTittle = [[NSMutableArray alloc]initWithObjects:@"Negotiation No",@"Negotiation Name",@"Order Status",@"Start Date",@"End Date",@"Prefered Date",@"Enquiry Status",@"Total Quantity",@"Minimum Quantity",@"Participate Quantity",@"Last Date of Delivery",nil];
    
    [self SetInitialSetup];
    
    // Do any additional setup after loading the view.
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
    
    headerTotalWidth =  ([arrTittle count] * K_CUSTOM_WIDTH) * 1.22 ;
    
    height = ([SDVersion deviceSize] > Screen4Dot7inch)?_contentView.frame.size.height - 75:([SDVersion deviceSize] < Screen4Dot7inch)?_contentView.frame.size.height - 65:_contentView.frame.size.height - 70;
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, headerTotalWidth, height) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.bounces = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView = tableView;
    
    UIScrollView *myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
    myScrollView.bounces=NO;
    [myScrollView addSubview:tableView];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    myScrollView.contentSize = CGSizeMake(headerTotalWidth, 0);
    [_contentView addSubview:myScrollView];
    
    
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handlePullRefresh:)
                forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:refreshController];
    
    [self GetNegotiationListUsingAuction];
}
/**************************************************************************/
#pragma mark ---- UIREFRESH CONTROL CALLED ----
/**************************************************************************/

-(void)handlePullRefresh:(UIRefreshControl *)Control
{
    [refreshController endRefreshing];
    [self GetNegotiationListUsingAuction];
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW DELEGATE & DATA SOURCE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return [arrData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"cell_Identifier";
    TvCellEnquiry *cell = (TvCellEnquiry *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell=[[TvCellEnquiry alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier itemSize:CGSizeMake(K_CUSTOM_WIDTH + 30, lblHeight) headerArray:arrTittle];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.dataDict = [arrData objectAtIndex:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tableViewHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [arrTittle count] * K_CUSTOM_WIDTH, 50)];
    [tableViewHeadView setBackgroundColor:DefaultThemeColor];
    
    if (section ==  1)
    {
        int xx = 20;
        CGFloat width = K_CUSTOM_WIDTH + xx - 10;
        
        for(int i = 0 ; i < [arrTittle count]; i++)
        {
            if(i == 0)
            {
                headLabel=[[UILabel alloc]initWithFrame:CGRectMake(xx, 0, width, 50)];
                [headLabel setTextAlignment:NSTextAlignmentLeft];
            }
            else
            {
                headLabel=[[UILabel alloc]initWithFrame:CGRectMake(xx, 0, width, 50)];
                [headLabel setTextAlignment:NSTextAlignmentCenter];
            }
            [headLabel setText:[arrTittle objectAtIndex:i]];
            [headLabel setNumberOfLines:0];
            [headLabel setTextColor:[UIColor whiteColor]];
            [headLabel setBackgroundColor:[UIColor clearColor]];
            [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [headLabel setFont:IS_IPHONE5? UI_DEFAULT_FONT_MEDIUM(18):UI_DEFAULT_FONT_MEDIUM(20)];
            [tableViewHeadView addSubview:headLabel];
            
            xx = xx + width + 10;
            
            if(i == arrTittle.count - 3)
            {
                width = K_CUSTOM_WIDTH - 50;
            }
            else if(i == arrTittle.count - 4)
            {
                width = K_CUSTOM_WIDTH - 50;
            }
            else if (i == arrTittle.count - 5)
            {
                width = K_CUSTOM_WIDTH - 50;
            }
            else
            {
                width = K_CUSTOM_WIDTH + 30;
            }
            
        }
    }
    else
    {
        txtNegotiation = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 220, 40)];
        [self SetdefaultTextfieldwithView:tableViewHeadView withTextfield:txtNegotiation withTag:1001 withPlaceHolder:@"Negotiation No"];
        
        self.searchBar = [[INSSearchBar alloc] initWithFrame:CGRectMake(txtNegotiation.frame.size.width + 50, 5, 44.0, 40)];
        self.searchBar.delegate = self;
        
        [tableViewHeadView addSubview:self.searchBar];
        
    }
    return tableViewHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return lblHeight + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SellerAuctionList *objAuctionList = [MBDataBaseHandler getSellerAuctionList];
    SellerAuctionListData *data = [objAuctionList.detail objectAtIndex:indexPath.row];
    //    if([data.AcceptanceStatus isEqualToString:@"Pending"] && data.Isclosed == NO)
    //    {
    //        [self GetSupplierAuctionDetailAPI:data.AuctionCode WithBoolValue:1];
    //    }
    [self GetSupplierAuctionDetailAPI:data.AuctionCode WithBoolValue:0 withIsScreenFrom:1];
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== SEARCH -- BAR DELEGATE CALLED HERE ===❉===❉
/*****************************************************************************************************************/
- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar
{
    return CGRectMake(txtNegotiation.frame.size.width + 50, 5,txtNegotiation.frame.size.width + 150, 40);
}

- (void)searchBar:(INSSearchBar *)searchBar willStartTransitioningToState:(INSSearchBarState)destinationState
{
    // Do whatever you deem necessary.
}

- (void)searchBar:(INSSearchBar *)searchBar didEndTransitioningFromState:(INSSearchBarState)previousState
{
    // Do whatever you deem necessary.
}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
    // Do whatever you deem necessary.
    // Access the text from the search bar like searchBar.searchField.text
}

- (void)searchBarTextDidChange:(INSSearchBar *)searchBar
{
    // Do whatever you deem necessary.
    // Access the text from the search bar like searchBar.searchField.text
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== SCROLL VIEW DELEGATE CALLED HERE ===❉===❉
/*****************************************************************************************************************/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY= self.myTableView.contentOffset.y;
    if(offsetY==0)
    {
        self.myTableView.contentOffset=CGPointZero;
    }
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== CELL  DELEGATE CALLED HERE ===❉===❉
/*****************************************************************************************************************/
-(void)setSelectItemViewWithData:(NSIndexPath *)selectedIndex withTittle:(NSString *)btnState
{
    NSLog(@"%ld",(long)selectedIndex.row);
    SellerUserDetail *objseller = [MBDataBaseHandler getSellerUserDetailData];
    
    SellerAuctionList *objAuctionList = [MBDataBaseHandler getSellerAuctionList];
    SellerAuctionListData *data = [objAuctionList.detail objectAtIndex:selectedIndex.row];
    NSString *strBtnTittile = [NSString stringWithFormat:@"Charges of Enquiry: %@ Participate",data.AuctionCharge];
    
    if ([btnState isEqualToString:@"Update Rate"])
    {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        
        NSString *strUrl = @"http://supplier.tradologie.com/supplier/LiveAuctionSupplierForAPI.aspx?";
        NSString *strAuctionCode = [NSString stringWithFormat:@"AuctionCode=%@",data.AuctionCode];
        NSString *strToken = [NSString stringWithFormat:@"&Token=%@",objseller.APIVerificationCode];
        NSString *loadURL= [[strUrl stringByAppendingString:strAuctionCode] stringByAppendingString:strToken];
        
        VCLoadLiveAuction * objVCLoadLive = [self.storyboard instantiateViewControllerWithIdentifier:@"VCLoadLiveAuction"];
        objVCLoadLive.strUrlForLiveAuction = loadURL;
        [self.navigationController pushViewController:objVCLoadLive animated:YES];
    }
    else if ([btnState isEqualToString:@"POAccepted"])
    {
        
    }
    else if ([btnState isEqualToString:@"Payment Pending"])
    {
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
        
        TVPaymentScreen *objScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVPaymentScreen"];
        objScreen.strAuctionID = [data.AuctionID stringValue];
        [self.navigationController pushViewController:objScreen animated:YES];
    }
    else if ([btnState isEqualToString:@"Payment Process"])
    {
        
    }
    else if ([btnState isEqualToString:strBtnTittile])
    {
        [self GetSupplierAuctionDetailAPI:data.AuctionCode WithBoolValue:1 withIsScreenFrom:1];
    }
    else
    {
        [self GetSupplierAuctionDetailAPI:data.AuctionCode WithBoolValue:0 withIsScreenFrom:1];
    }
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== TEXTFIELD DELEGATE CALLED HERE ===❉===❉
/*****************************************************************************************************************/
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== BUTTON ACTION EVENT CALLED HERE ===❉===❉
/*****************************************************************************************************************/
-(void)SetdefaultTextfieldwithView:(UIView *)addView withTextfield:(UITextField *)txtfield withTag:(NSInteger)tag withPlaceHolder:(NSString *)placeholder
{
    [txtfield setAdditionalInformationTextfieldStyle:placeholder Withimage:[UIImage imageNamed:@"IconDropDownWhite"] withID:self withSelectorAction:@selector(btnDropDownTapped:) withTag:tag];
  //  [txtfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txtfield setBackgroundColor:DefaultThemeColor];
    [txtfield setFont:IS_IPHONE5? UI_DEFAULT_FONT_MEDIUM(15):UI_DEFAULT_FONT_MEDIUM(18)];
    [txtfield setTextColor:[UIColor whiteColor]];
    [txtfield setTag:tag];
    [txtfield.layer setBorderColor:[UIColor clearColor].CGColor];
    [txtfield setDelegate:self];
    [addView addSubview:txtfield];
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

-(IBAction)btnDropDownTapped:(UIButton *)sender
{
    NSMutableArray *arrNegotiation=[[NSMutableArray alloc]initWithObjects:@"Min Quantity",@"Total Quantity", nil];
    
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuRowHeight = 45;
    configuration.menuWidth = 150;
    
    [FTPopOverMenu showForSender:sender
                   withMenuArray:arrNegotiation
                      imageArray:nil
                       doneBlock:^(NSInteger selectedIndex)
    {
        [self->txtNegotiation setText:[arrNegotiation objectAtIndex:selectedIndex]];
    } dismissBlock:^{
        
    }];
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== GET DATA FROM DATABASE HERE ===❉===❉
/******************************************************************************************************************/
-(void)GetNegotiationListUsingAuction
{
    SellerUserDetail * objSellerdetail = [MBDataBaseHandler getSellerUserDetailData];
    NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
    [dicParams setObject:objSellerdetail.APIVerificationCode forKey:@"Token"];
    [dicParams setObject:objSellerdetail.VendorID forKey:@"VendorID"];
    [dicParams setObject:@"" forKey:@"FilterAuction"];
    
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait.."];

        MBCall_GetAuctionListUsingDashboardApi(dicParams, ^(id response, NSString *error, BOOL status)
        {
            if (status && [[response valueForKey:@"success"]isEqual:@1])
            {
                if (response != (NSDictionary *)[NSNull null])
                {
                    NSError* Error;
                    SellerAuctionList *objAuctionList = [[SellerAuctionList alloc]initWithDictionary:response error:&Error];
                    [MBDataBaseHandler saveSellerAuctionListData:objAuctionList];
                    
                    self->arrData = [[NSMutableArray alloc]init];
                    
                    for (SellerAuctionListData *data in objAuctionList.detail)
                    {
                        NSMutableDictionary *dataDict = [NSMutableDictionary new];
                        
                        [dataDict setObject:data.AuctionCode forKey:[self->arrTittle objectAtIndex:0]];
                        [dataDict setObject:data.AuctionName forKey:[self->arrTittle objectAtIndex:1]];
                        
                        if ([data.OrderStatus isEqualToString:@""])
                        {
                            [dataDict setObject:data.OrderStatus forKey:[self->arrTittle objectAtIndex:2]];
                        }
                        else
                        {
                            [dataDict setObject:data.PONo forKey:[self->arrTittle objectAtIndex:2]];
                        }
                        NSString *startDate = [CommonUtility getDateFromSting:data.StartDate fromFromate:@"MM/dd/yyyy hh:mm:ss a" withRequiredDateFormate:@"dd-MMM-yyyy HH:mm"];
                        NSString *EndDate = [CommonUtility getDateFromSting:data.EndDate fromFromate:@"MM/dd/yyyy hh:mm:ss a" withRequiredDateFormate:@"dd-MMM-yyyy HH:mm"];
                        
                        [dataDict setObject:startDate forKey:[self->arrTittle objectAtIndex:3]];
                        [dataDict setObject:EndDate forKey:[self->arrTittle objectAtIndex:4]];
                        NSString *strPreferredDate = [CommonUtility getDateFromSting:data.PreferredDate fromFromate:@"MM/dd/yyyy hh:mm:ss a" withRequiredDateFormate:@"dd-MMM-yyyy HH:mm"];
                        [dataDict setObject:strPreferredDate forKey:[self->arrTittle objectAtIndex:5]];
                        
                        if (data.IsStarted == true)
                        {
                            [dataDict setObject:@"Started" forKey:[self->arrTittle objectAtIndex:6]];
                        }
                        else if (data.IsStarted == 0 && data.Isclosed == 0)
                        {
                            [dataDict setObject:@"Not Started" forKey:[self->arrTittle objectAtIndex:6]];
                        }
                        else
                        {
                            [dataDict setObject:@"Closed" forKey:[self->arrTittle objectAtIndex:6]];
                        }
                        
                        [dataDict setObject:data.TotalQuantity forKey:[self->arrTittle objectAtIndex:7]];
                        [dataDict setObject:data.MinQuantity forKey:[self->arrTittle objectAtIndex:8]];
                        [dataDict setObject:data.ParticipateQuantity forKey:[self->arrTittle objectAtIndex:9]];
                        
                        NSString *strDeliveryLastDate = [CommonUtility getDateFromSting:data.DeliveryLastDate fromFromate:@"MM/dd/yyyy hh:mm:ss a" withRequiredDateFormate:@"dd-MMM-yyyy HH:mm"];
                        
                        [dataDict setObject:strDeliveryLastDate forKey:[self->arrTittle objectAtIndex:10]];
                        
                        if ((data.IsStarted == 1 && data.Isclosed == 0 && [data.AcceptanceStatus isEqualToString:@"Accepted"]))
                        {
                            [dataDict setObject:[NSString stringWithFormat:@"Update Rate"] forKey:@"btnTittle"];
                        }
                        else if([data.AcceptanceStatus isEqualToString:@"Pending"] && data.Isclosed == NO)
                        {
                            [dataDict setObject:[NSString stringWithFormat:@"Charges of Enquiry: %@ Participate",data.AuctionCharge] forKey:@"btnTittle"];
                        }
                        else if ([data.AcceptanceStatus isEqualToString:@"PaymentPending"] && data.Isclosed == NO)
                        {
                            [dataDict setObject:[NSString stringWithFormat:@"Payment Pending"] forKey:@"btnTittle"];
                        }
                        else if([data.AcceptanceStatus isEqualToString:@"PaymentProcess"])
                        {
                            [dataDict setObject:[NSString stringWithFormat:@"Payment Process"] forKey:@"btnTittle"];
                        }
                        else if([data.AcceptanceStatus isEqualToString:@"Accepted"]  && [data.OrderStatus isEqualToString:@"Accept"])
                        {
                            [dataDict setObject:[NSString stringWithFormat:@"View Order"] forKey:@"btnTittle"];
                        }
                        else if ([data.AcceptanceStatus isEqualToString:@"Accepted"] && [data.OrderStatus isEqualToString:@"POAccepted"])
                        {
                            [dataDict setObject:data.OrderStatus forKey:@"btnTittle"];
                        }
                        else if ([data.AcceptanceStatus isEqualToString:@"Accepted"] && [data.CounterStatus isEqualToString:@"TimeOut"])
                        {
                            [dataDict setObject:@" " forKey:@"btnTittle"];
                        }
                        else if ([data.AcceptanceStatus isEqualToString:@"Accepted"] && data.Isclosed == YES)
                        {
                            [dataDict setObject:@" " forKey:@"btnTittle"];
                        }
                        else
                        {
                            [dataDict setObject:@" " forKey:@"btnTittle"];
                        }
                        [self->arrData addObject:dataDict];
                    }
                    [self.myTableView reloadData];
                    [CommonUtility HideProgress];

                }
            }
            else
            {
                [CommonUtility HideProgress];
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

@end
