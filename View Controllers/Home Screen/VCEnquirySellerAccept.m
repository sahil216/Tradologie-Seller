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

#define K_CUSTOM_WIDTH 150

@interface VCEnquirySellerAccept ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *arrSellerAucList;
    NSMutableArray *arrSellerAucListData;
    float headerTotalWidth;
    NSInteger count,SupplierCount;
    CGFloat height , lblHeight;
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
    [self.navigationController.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    
//    arrTittle = [[NSMutableArray alloc]initWithObjects:@"Sr.No",@"Grade",@"Quantity",@"Packing Type",@"Packing Size",@"Packing Image",nil];
//
    arrSellerAucList = [[NSMutableArray alloc]initWithObjects:@"Sr.No",@"Grade",@"Quantity",@"Packing Type",@"Packing Size",@"Packing Image",nil];
    
    lblHeight = 120;
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
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ViewEnquiryState" owner:self options:nil];
    _viewLandscape = [subviewArray objectAtIndex:0];
    
    [self getSellerAuctionDetailDataBase];
    
//    [self getAuctionSellerDataListfromDataBase];
    
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW DELEGATE & DATA SOURCE CALLED HERE ===❉===❉
/*****************************************************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
//    if(indexPath.section == 2)
//    {
//        cellIdentifier = @"Cell_ID";
//        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if(cell == nil)
//        {
//            cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        }
//        return cell;
//    }
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
//            CGFloat hue = ( arc4random() % 256 / 256.0 );
//            CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
//            CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
//            UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//            [headLabel setBackgroundColor:color];
        }
        return Viewsection2;
    }
    
    UIView *tableViewHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [arrSellerAucList count] * K_CUSTOM_WIDTH, 200)];
    [tableViewHeadView setBackgroundColor:[UIColor whiteColor]];
    
    [self getLableAccordingtoView:tableViewHeadView withTittle:@"Remarks :- " withfame:CGRectMake(20, 0, tableViewHeadView.frame.size.width, 45) WithColor:DefaultThemeColor];

    UITextField *txtRemarks=[[UITextField alloc]initWithFrame:CGRectMake(20, 45, SCREEN_HEIGHT * 2, 100)];
    [txtRemarks setDefaultTextfieldStyleWithPlaceHolder:@"Enter Your Remarks" withTag:1001];
    [txtRemarks setFont:UI_DEFAULT_FONT_MEDIUM(18)];
    [txtRemarks setDelegate:self];
    [tableViewHeadView addSubview:txtRemarks];
    
    [self getLableAccordingtoView:tableViewHeadView withTittle:@"Total Quantity Participating :- " withfame:CGRectMake(20, txtRemarks.frame.size.height + 55, 260, 45) WithColor:DefaultThemeColor];
    
    UITextField *txtQtyParticipate = [[UITextField alloc]initWithFrame:CGRectMake(260 + 10, txtRemarks.frame.size.height + 55, SCREEN_HEIGHT, 45)];
    [txtQtyParticipate setDefaultTextfieldStyleWithPlaceHolder:@"Enter Total Quantity" withTag:1002];
    [txtQtyParticipate setFont:UI_DEFAULT_FONT_MEDIUM(18)];
    [txtQtyParticipate setDelegate:self];
    [tableViewHeadView addSubview:txtQtyParticipate];
    
    [self getLableAccordingtoView:tableViewHeadView withTittle:@"Auction Charges Participating :-  0" withfame:CGRectMake(20,(txtRemarks.frame.size.height *2)+ 10 , txtQtyParticipate.frame.size.width * 1.50, 45) WithColor:DefaultThemeColor];
    
    return tableViewHeadView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return lblHeight + 10;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _viewLandscape.frame.size.height - 250;
    }
    else if (section == 1)
    {
        return 100;
    }
    return 260;
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
    self.myTableView.contentOffset = CGPointMake(0, SCREEN_HEIGHT * 10);
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.myTableView.contentOffset = CGPointMake(0, SCREEN_HEIGHT * 2);
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
    
}
-(IBAction)btnParticiPatingTapped:(UIButton *)sender
{
    
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
