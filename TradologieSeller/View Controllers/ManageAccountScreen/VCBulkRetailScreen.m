

//
//  VCBulkRetailScreen.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 17/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "VCBulkRetailScreen.h"
#import "Constant.h"
#import "AppConstant.h"
#import "CommonUtility.h"
#import "MBAPIManager.h"
#import "MBDataBaseHandler.h"
#import "SharedManager.h"

#define K_CUSTOM_WIDTH 150

@interface VCBulkRetailScreen ()<THSegmentedPageViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrInfoTittle;
    NSMutableArray *arrHeaderTittle;
    NSMutableArray *arrPlaceHolder;
    BOOL isOpenSection;
    float headerTotalWidth;
    UILabel *headLabel;
    CGFloat height , lblHeight;
}
@property (nonatomic, strong) UIView * contentView;

@end

@implementation VCBulkRetailScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrInfoTittle = [[NSMutableArray alloc]initWithObjects:@"Group *",@"Retail Min Quantity *",@"Retail Max Quantity *",@"Bulk Min Quantity *",@"Bulk Max Quantity *",@"Priority *",nil];
    arrPlaceHolder = [[NSMutableArray alloc]initWithObjects:@"-- Select Group --",@"Enter Min Quantity",@"Enter Max Quantity",@"Enter Bulk Min Quantity",@"Enter Bulk Max Quantity",@"Enter Priority",nil];
    
    arrHeaderTittle = [[NSMutableArray alloc]initWithObjects:@"Sr.No",@"Group",@"Retail",@"BulK",@"Priority",@"Bidding",@"Is Active",nil];

    lblHeight = 90;
    

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
    
    headerTotalWidth =  ([arrHeaderTittle count] * K_CUSTOM_WIDTH) * 1.40 ;
    
    height = ([SDVersion deviceSize] > Screen4Dot7inch)?_contentView.frame.size.height - 75:([SDVersion deviceSize] < Screen4Dot7inch)?_contentView.frame.size.height - 65:_contentView.frame.size.height - 100;
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, headerTotalWidth, height) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.bounces=NO;
    self.tblBulkRetail = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIScrollView *myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 5, _contentView.frame.size.width, _contentView.frame.size.height)];
    myScrollView.bounces=NO;
    [myScrollView setBackgroundColor:[UIColor whiteColor]];
    [myScrollView addSubview:tableView];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    myScrollView.contentSize = CGSizeMake(headerTotalWidth, 0);
    [_contentView addSubview:myScrollView];
    
    [self.tblBulkRetail registerNib:[UINib nibWithNibName:@"TVSellerBulkRetailCell" bundle:nil] forCellReuseIdentifier:CELL_BULK_RETAIL_ID];
    
    [self.tblBulkRetail registerNib:[UINib nibWithNibName:@"TVCustomBulkRetailCell" bundle:nil] forCellReuseIdentifier:@"CellEnableIdentifier"];
   
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
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"";
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == arrInfoTittle.count)
        {
            cellIdentifier = @"CellEnableIdentifier";
            TVCustomBulkRetailCell *cell = (TVCustomBulkRetailCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if(!cell)
            {
                cell = [[TVCustomBulkRetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            [cell.btnSubmitBulk addTarget:self action:@selector(btnSubmitBulkDetail:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
       else
       {
           cellIdentifier = CELL_BULK_RETAIL_ID;
           TVSellerBulkRetailCell *cell = (TVSellerBulkRetailCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
           if(!cell)
           {
               cell = [[TVSellerBulkRetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
               cell.selectionStyle=UITableViewCellSelectionStyleNone;
           }
           
           [cell ConfigureBulkRetailItemInfoCellData:[arrInfoTittle objectAtIndex:indexPath.row] withPlaceholder:[arrPlaceHolder objectAtIndex:indexPath.row] withRowIndex:indexPath];
           return cell;
       }
    }
    cellIdentifier = @"Cell_Bulk_List_ID";
    
    TVCellBulkRetailList *cell =(TVCellBulkRetailList *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[TVCellBulkRetailList alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier itemSize:CGSizeMake(K_CUSTOM_WIDTH, lblHeight) headerArray:arrHeaderTittle];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
   // cell.dataDict = [arrData objectAtIndex:indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if (indexPath.row == arrInfoTittle.count)
        {
            return 180;
        }
        return 75;
    }
    return lblHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        [viewHeader setBackgroundColor:[UIColor whiteColor]];
 
        UIView *ViewBG = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, 60)];
        [ViewBG SetDefaultShadowBackGround];
        [ViewBG setBackgroundColor:[UIColor whiteColor]];
        [ViewBG.layer setBorderColor:DefaultButtonColor.CGColor];
        
        [self getLableAccordingtoView:ViewBG withTittle:@"ADD NEW BULK & RETAIL" withFrame:CGRectMake(5, 5,ViewBG.frame.size.width - 55, 50) withSize:18 withTextColor:[UIColor orangeColor] withAlignment:NSTextAlignmentLeft];
        
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

    UIView *viewSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, headerTotalWidth, 100)];
    [viewSection setBackgroundColor:[UIColor whiteColor]];
    
    UIView *ViewBG = [[UIView alloc]initWithFrame:CGRectMake(5, 5, headerTotalWidth - 10, 90)];
    [ViewBG SetDefaultShadowBackGround];
    [ViewBG setBackgroundColor:[UIColor whiteColor]];
    [ViewBG.layer setBorderColor:DefaultButtonColor.CGColor];
    
    int xx = 5;
    int width = 50;

    for(int i = 0 ; i < [arrHeaderTittle count] ; i++)
    {
        if (i == 2)
        {
            headLabel = [[UILabel alloc]initWithFrame:CGRectMake(xx, 0, width, 30)];

            [self getLableAccordingtoView:ViewBG withTittle:@"Min Qty" withFrame:CGRectMake(headLabel.frame.origin.x, 30, 100, 50) withSize:18 withTextColor:DefaultThemeColor withAlignment:NSTextAlignmentLeft];
             [self getLableAccordingtoView:ViewBG withTittle:@"Max Qty" withFrame:CGRectMake(headLabel.frame.origin.x + (headLabel.frame.size.width/2), 30, 100, 50) withSize:18 withTextColor:DefaultThemeColor withAlignment:NSTextAlignmentRight];
        }
        else if (i == 3)
        {
            headLabel = [[UILabel alloc]initWithFrame:CGRectMake(xx, 0, width, 30)];

            [self getLableAccordingtoView:ViewBG withTittle:@"Min Qty" withFrame:CGRectMake(headLabel.frame.origin.x, 30, 100, 50) withSize:18 withTextColor:DefaultThemeColor withAlignment:NSTextAlignmentLeft];
            [self getLableAccordingtoView:ViewBG withTittle:@"Max Qty" withFrame:CGRectMake(headLabel.frame.origin.x + (headLabel.frame.size.width/2), 30, 100, 50) withSize:18 withTextColor:DefaultThemeColor withAlignment:NSTextAlignmentRight];
        }
        else
        {
             headLabel=[[UILabel alloc]initWithFrame:CGRectMake(xx, 5, width, ViewBG.frame.size.height - 10)];
        }
        [headLabel setText:[arrHeaderTittle objectAtIndex:i]];
        [headLabel setTextAlignment:NSTextAlignmentCenter];
        [headLabel setNumberOfLines:0];
        [headLabel setTextColor:DefaultThemeColor];
        [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [headLabel setFont:IS_IPHONE5? UI_DEFAULT_FONT_MEDIUM(15):UI_DEFAULT_FONT_MEDIUM(18)];
        [ViewBG addSubview:headLabel];
        
//        CGFloat hue = ( arc4random() % 256 / 256.0 );
//        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
//        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
//        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//        [headLabel setBackgroundColor:color];
        
        xx = xx + width + 20;
        if (i == 0)
        {
            width = K_CUSTOM_WIDTH + 100;
        }
        else if (i == 1)
        {
            width = K_CUSTOM_WIDTH + 100;
        }
        else if (i == 2)
        {
            width = K_CUSTOM_WIDTH + 100;
        }
        else
        {
            width = K_CUSTOM_WIDTH;
        }
    }
    [viewSection addSubview:ViewBG];
    
    return viewSection;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 70;
    }
    return 100;
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== GET LABLE FOR HEADER HERE ===❉===❉
/*****************************************************************************************************************/

-(void)getLableAccordingtoView:(UIView *)viewBG withTittle:(NSString *)strTittle withFrame:(CGRect)frame withSize:(NSInteger)fontSize withTextColor:(UIColor *)color withAlignment:(NSTextAlignment )align
{
    UILabel *lblbHeaderTittle= [[UILabel alloc]initWithFrame:frame];
    [lblbHeaderTittle setText:strTittle];
    [lblbHeaderTittle setFont:UI_DEFAULT_FONT_MEDIUM(fontSize)];
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
- (IBAction)btnSubmitBulkDetail:(UIButton *)sender
{
    
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== RELOAD DATA HERE ===❉===❉
/*****************************************************************************************************************/
-(void)reloadTableInputViewsWithSection:(NSInteger )section
{
    NSRange range = NSMakeRange(0, 1);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tblBulkRetail reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
}
@end
