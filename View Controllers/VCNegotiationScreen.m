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
#define K_CUSTOM_WIDTH 170

@interface VCNegotiationScreen ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TvCellEnquiryDelegate,INSSearchBarDelegate>
{
    NSMutableArray *arrTittle;
    NSMutableArray *arrData;
    float headerTotalWidth;
    NSInteger count;
    CGFloat height , lblHeight;
    UITextField *txtNegotiation;
}

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) INSSearchBar *searchBar;

@end

@implementation VCNegotiationScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setNavigationTittleWithLogoforLanscapeMode:@"tradologie.com"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem SetBackButtonWithID:self withSelectorAction:@selector(btnBackItemTaped:)];
    [self.navigationItem SetRightButtonWithID:self withSelectorAction:@selector(btnRightItemTaped:)withImage:@"IconAddNegotiation"];
    
    lblHeight = 110;

    
    arrTittle = [[NSMutableArray alloc]initWithObjects:@"Negotiation No.",@"Negotiation Name",@"Order Status",@"Start Date",@"End Date",@"Prefered Date",@"Enquiry Status",@"Total Quantity",@"Min Quantity",@"Participate Quantity",@"Last Date of Delivery",nil];
    
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
    
    headerTotalWidth =  [arrTittle count] * K_CUSTOM_WIDTH + SCREEN_WIDTH - 100;
    
    height = ([SDVersion deviceSize] > Screen4Dot7inch)?_contentView.frame.size.height - 75:([SDVersion deviceSize] < Screen4Dot7inch)?_contentView.frame.size.height - 65:_contentView.frame.size.height - 70;
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, headerTotalWidth, height) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.bounces=NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView = tableView;
    
    UIScrollView *myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
    myScrollView.bounces=NO;
    [myScrollView addSubview:tableView];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    myScrollView.contentSize = CGSizeMake(headerTotalWidth, 0);
    [_contentView addSubview:myScrollView];
    
    
    
    [self getAuctionDataListfromDataBase];
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
        cell=[[TvCellEnquiry alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier itemSize:CGSizeMake(K_CUSTOM_WIDTH +30, lblHeight) headerArray:arrTittle];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.dataDict = [arrData objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tableViewHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [arrTittle count] * K_CUSTOM_WIDTH, 45)];
    [tableViewHeadView setBackgroundColor:DefaultThemeColor];
    
    if (section ==  1)
    {
        int xx = 0;
        for(int i = 0 ; i < [arrTittle count] ; i++)
        {
            UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(xx, 0, K_CUSTOM_WIDTH + 30, 45)];
            
            [headLabel setText:[arrTittle objectAtIndex:i]];
            [headLabel setTextAlignment:NSTextAlignmentCenter];
            [headLabel setNumberOfLines:0];
            [headLabel setTextColor:[UIColor whiteColor]];
            [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [headLabel setFont:UI_DEFAULT_FONT_MEDIUM(18)];
            [tableViewHeadView addSubview:headLabel];
            
            xx = xx + K_CUSTOM_WIDTH +30;
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
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return lblHeight + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    if ([btnState isEqualToString:@"Update Rate"])
    {
        
    }
    else if ([btnState isEqualToString:@"po Accepted"])
    {
        
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
    [txtfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txtfield setBackgroundColor:DefaultThemeColor];
    [txtfield setFont:UI_DEFAULT_FONT_MEDIUM(18)];
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
-(IBAction)btnRightItemTaped:(UIButton *)sender
{
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];

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
-(void)getAuctionDataListfromDataBase
{
    SellerAuctionList *objAuctionList = [MBDataBaseHandler getSellerAuctionList];
    arrData = [[NSMutableArray alloc]init];
    
    for (SellerAuctionListData *data in objAuctionList.detail)
    {
        NSMutableDictionary *dataDict = [NSMutableDictionary new];
        
        [dataDict setObject:data.AuctionCode forKey:[arrTittle objectAtIndex:0]];
        [dataDict setObject:data.AuctionName forKey:[arrTittle objectAtIndex:1]];
        
        if ([data.OrderStatus isEqualToString:@""])
        {
            [dataDict setObject:data.OrderStatus forKey:[arrTittle objectAtIndex:2]];
        }
        else
        {
            [dataDict setObject:data.PONo forKey:[arrTittle objectAtIndex:2]];
        }
        NSString *startDate = [NSString stringWithFormat:@"%@",[self dateFromString:[NSString stringWithFormat:@"%@",data.StartDate]]];
        NSString *EndDate = [NSString stringWithFormat:@" %@",[self dateFromString:[NSString stringWithFormat:@"%@",data.EndDate]]];
        [dataDict setObject:startDate forKey:[arrTittle objectAtIndex:3]];
        [dataDict setObject:EndDate forKey:[arrTittle objectAtIndex:4]];
        [dataDict setObject:data.PreferredDate forKey:[arrTittle objectAtIndex:5]];
        if (data.IsStarted == true)
        {
            [dataDict setObject:@"Started" forKey:[arrTittle objectAtIndex:6]];
        }
        else
        {
            [dataDict setObject:@"Closed" forKey:[arrTittle objectAtIndex:6]];
        }

        [dataDict setObject:data.TotalQuantity forKey:[arrTittle objectAtIndex:7]];
        [dataDict setObject:data.MinQuantity forKey:[arrTittle objectAtIndex:8]];
        [dataDict setObject:data.ParticipateQuantity forKey:[arrTittle objectAtIndex:9]];
        [dataDict setObject:data.DeliveryLastDate forKey:[arrTittle objectAtIndex:10]];
        
        if([data.AcceptanceStatus isEqualToString:@"Pending"])
        {
            [dataDict setObject:[NSString stringWithFormat:@"Charges of Enquiry: %@ Participate",data.AuctionCharge] forKey:@"btnTittle"];
        }
        else if([data.AcceptanceStatus isEqualToString:@"Accepted"]  && [data.OrderStatus isEqualToString:@"Accept"])
        {
            [dataDict setObject:[NSString stringWithFormat:@"View Order"] forKey:@"btnTittle"];
        }
        else if ([data.AcceptanceStatus isEqualToString:@"Accepted"] && [data.CounterStatus isEqualToString:@"TimeOut"])
        {
            [dataDict setObject:@"" forKey:@"btnTittle"];
        }
        else if ([data.AcceptanceStatus isEqualToString:@"Accepted"] && [data.OrderStatus isEqualToString:@"POAccepted"])
        {
            [dataDict setObject:data.OrderStatus forKey:@"btnTittle"];
        }
        
        [arrData addObject:dataDict];
        
    }
    [self.myTableView reloadData];
}
-(NSString *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/mm/yyyy hh:mm:ss a"];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:mm"];
    NSString *newDate = [dateFormatter stringFromDate:date];
    
    return newDate;
}

@end
