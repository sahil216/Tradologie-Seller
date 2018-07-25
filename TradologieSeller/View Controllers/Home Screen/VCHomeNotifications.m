//
//  VCHomeNotifications.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 09/05/18.
//  Copyright © 2018 Chandresh Maurya. All rights reserved.
//

#import "VCHomeNotifications.h"
#import "MBAPIManager.h"
#import "SharedManager.h"
#import "CommonUtility.h"
#import "MBDataBaseHandler.h"
#import "VCLoadLiveAuction.h"
#import "TVPaymentScreen.h"


@interface VCHomeNotifications()
{
    NSMutableArray *arrUpCommingNotify;
    NSMutableArray *arrLiveNotify;
    NSMutableArray *arrPendingNotify;
    
    NSString *strTimer;
    NSTimer *timer;
    
    UILabel *lblMessage;
    int hours, minutes, seconds;
    int secondsLeft;
    
    UIRefreshControl *refreshController;
    
}
@end

@implementation VCHomeNotifications

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tbtNotify setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationItem setNavigationTittleWithLogo:@"tradologie.com"];
    lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 50)];
    [lblMessage setText:@"No Record Found..!"];
    [lblMessage setTextAlignment:NSTextAlignmentCenter];
    [lblMessage setHidden:YES];
    [self.tbtNotify setBackgroundView:lblMessage];
    
    [btnContactUs addTarget:self action:@selector(btnContactUsCalled:) forControlEvents:UIControlEventTouchUpInside];
    
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handlePulltoRefresh:)
                forControlEvents:UIControlEventValueChanged];
    [self.tbtNotify addSubview:refreshController];
    
    [self getDashboardNotificationAPI];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
}

/**************************************************************************/
#pragma mark ---- UIREFRESH CONTROL CALLED ----
/**************************************************************************/
-(void)handlePulltoRefresh:(UIRefreshControl *)Control
{
    [refreshController endRefreshing];
    [self getDashboardNotificationAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW DELEGATE & DATA SOURCE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return (arrUpCommingNotify.count > 0)?arrUpCommingNotify.count:1;
    }
    else if (section == 1)
    {
        return (arrLiveNotify.count > 0)?arrLiveNotify.count:1;
    }
    else if (section == 2)
    {
        return (arrPendingNotify.count > 0)?arrPendingNotify.count:1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrUpCommingNotify.count > 0 && indexPath.section == 0)
    {
        NotificationList *cell = (NotificationList *) [tableView dequeueReusableCellWithIdentifier:COMMON_CELL_ID];
        if (!cell)
        {
            cell = [[NotificationList alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:COMMON_CELL_ID];
        }
        [cell ConfigureNotificationListbyCellwithData:[arrUpCommingNotify objectAtIndex:indexPath.row] withSectionIndex:0];
        return cell;
    }
    else if (arrLiveNotify.count > 0 && indexPath.section == 1)
    {
        NotificationList *cell = (NotificationList *) [tableView dequeueReusableCellWithIdentifier:COMMON_CELL_ID];
        if (!cell)
        {
            cell = [[NotificationList alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:COMMON_CELL_ID];
        }
        [cell ConfigureNotificationListbyCellwithData:[arrLiveNotify objectAtIndex:indexPath.row] withSectionIndex:1];
        return cell;
    }
    else if (arrPendingNotify.count > 0 && indexPath.section == 2)
    {
        NotificationList *cell = (NotificationList *) [tableView dequeueReusableCellWithIdentifier:COMMON_CELL_ID];
        if (!cell)
        {
            cell = [[NotificationList alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:COMMON_CELL_ID];
        }
        [cell ConfigureNotificationListbyCellwithData:[arrPendingNotify objectAtIndex:indexPath.row] withSectionIndex:2];
        return cell;
    }
    NotificationList *cell =(NotificationList *) [tableView dequeueReusableCellWithIdentifier:@"Cell_ID"];
    if (!cell)
    {
        cell = [[NotificationList alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:COMMON_CELL_ID];
    }
    if (indexPath.section == 0)
    {
        [cell.lblMessage setText:@"No Negotiation Complete Or Going to Start..!"];
    }
    else if (indexPath.section == 1)
    {
        [cell.lblMessage setText:@"No Negotiation Live..!"];
    }
    else
    {
        [cell.lblMessage setText:@"No Negotiation Order is Pending..!"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrUpCommingNotify.count > 0 || arrLiveNotify.count > 0 || arrPendingNotify.count > 0)
    {
        SellerUserDetail *objseller = [MBDataBaseHandler getSellerUserDetailData];
        
        if (indexPath.section == 0)
        {
            SellerAuctionDetailData *data  = [arrUpCommingNotify objectAtIndex:indexPath.row];
            if([data.SupplierStatus isEqualToString:@"Accepted"] && data.IsGoingStart == YES)
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
            else if ([data.SupplierStatus isEqualToString:@"PaymentProcess"])
            {
                
            }
            else if ([data.SupplierStatus isEqualToString:@"PaymentPending"])
            {
                
            }
            else if([data.SupplierStatus isEqualToString:@"Pending"] && data.IsComplete == NO)
            {
                [self GetSupplierAuctionDetailAPI:data.AuctionCode WithBoolValue:1 withIsScreenFrom:0];
            }
        }
        else if (indexPath.section == 1)
        {
            SellerAuctionDetailData *data  = [arrLiveNotify objectAtIndex:indexPath.row];
            if (data.IsStarted == 1 && [data.SupplierStatus isEqualToString:@"Accepted"])
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
            else if([data.SupplierStatus isEqualToString:@"Pending"] && data.IsComplete == NO)
            {
                [self GetSupplierAuctionDetailAPI:data.AuctionCode WithBoolValue:1 withIsScreenFrom:0];
            }
            else if([data.SupplierStatus isEqualToString:@"PaymentPending"] && data.IsComplete == NO)
            {
                [[UIDevice currentDevice] setValue:
                 [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
                
                TVPaymentScreen *objScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVPaymentScreen"];
                objScreen.strAuctionID = [data.AuctionID stringValue];
                [self.navigationController pushViewController:objScreen animated:YES];
                
            }
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *arrTittle= [[NSMutableArray alloc]initWithObjects:@"Upcomming Negotiation",@"Live Negotiation",@"Pending Orders", nil];
    UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [viewHeader setBackgroundColor:[UIColor clearColor]];
    
    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [viewBG setBackgroundColor:DefaultThemeColor];
    
    UIView *viewBG2 = [[UIView alloc]initWithFrame:CGRectMake(0, viewBG.frame.size.height, SCREEN_WIDTH, 40)];
    [viewBG2 setBackgroundColor:[UIColor whiteColor]];
    
    lblHeaaderTittle = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH-50, 40)];
    [lblHeaaderTittle setText:[arrTittle objectAtIndex:section]];
    [lblHeaaderTittle setTextColor:[UIColor whiteColor]];
    [lblHeaaderTittle setFont:(IS_IPHONE5) ? UI_DEFAULT_FONT_MEDIUM(16):UI_DEFAULT_FONT_MEDIUM(18)];
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 7.5, 25, 25)];
    [imgView setBackgroundColor:[UIColor clearColor]];
    [imgView setImage:IMAGE(@"IconStar")];
    
    if(IS_IPHONE5)
    {
        [self getLableAccordingtoView:viewBG2 withTittle:@"Order No" withFrame:CGRectMake(30, 0, 80, 40) withImageFrame:CGRectMake(5, 10, 20, 20) withAlignMent:NSTextAlignmentLeft];
        [self getLableAccordingtoView:viewBG2 withTittle:@"Status" withFrame:CGRectMake(140, 0, 75, 40) withImageFrame:CGRectMake(115, 10, 20, 20) withAlignMent:NSTextAlignmentCenter];
        [self getLableAccordingtoView:viewBG2 withTittle:@"Time Left" withFrame:CGRectMake(245, 0, 80, 40) withImageFrame:CGRectMake(220, 10, 20, 20) withAlignMent:NSTextAlignmentLeft];
    }
    else
    {
        [self getLableAccordingtoView:viewBG2 withTittle:@"Order No" withFrame:CGRectMake(30, 0, 120, 40) withImageFrame:CGRectMake(5, 10, 20, 20) withAlignMent:NSTextAlignmentLeft];
        [self getLableAccordingtoView:viewBG2 withTittle:@"Status" withFrame:CGRectMake(180, 0, 80, 40) withImageFrame:CGRectMake(155, 10, 20, 20) withAlignMent:NSTextAlignmentCenter];
        [self getLableAccordingtoView:viewBG2 withTittle:@"Time Left" withFrame:CGRectMake(290, 0, 80, 40) withImageFrame:CGRectMake(265, 10, 20, 20) withAlignMent:NSTextAlignmentLeft];
    }
    
    [viewBG addSubview:imgView];
    [viewHeader addSubview:viewBG];
    [viewHeader addSubview:viewBG2];
    [viewHeader addSubview:lblHeaaderTittle];
    
    return viewHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== GET LABLE FOR HEADER HERE ===❉===❉
/*****************************************************************************************************************/

-(void)getLableAccordingtoView:(UIView *)viewBG withTittle:(NSString *)strTittle withFrame:(CGRect)frame withImageFrame:(CGRect)Imgframe withAlignMent:(NSTextAlignment)textAlignment
{
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:Imgframe];
    [imgView setBackgroundColor:[UIColor clearColor]];
    [imgView setImage:IMAGE(@"IconPlayRight")];
    [viewBG addSubview:imgView];
    
    UILabel *lblTittle= [[UILabel alloc]initWithFrame:frame];
    [lblTittle setText:strTittle];
    [lblTittle setFont:(IS_IPHONE5)?UI_DEFAULT_FONT_MEDIUM(13):UI_DEFAULT_FONT_MEDIUM(15)];
    [lblTittle setTextColor:DefaultThemeColor];
    [lblTittle setTextAlignment:textAlignment];
    [lblTittle setBackgroundColor:[UIColor clearColor]];
    
    [viewBG addSubview:lblTittle];
}

/******************************************************************************************************************/
#pragma mark ❉===❉===  BUTTON ACTION EVENT CALLED HERE ===❉===❉
/******************************************************************************************************************/

-(IBAction)btnContactUsCalled:(UIButton *)sender
{
    [self getContactDialNumber];
}

/******************************************************************************************************************/
#pragma mark ❉===❉===  GET DASHBOARD NOTIFICATION API CALLED HERE ===❉===❉
/******************************************************************************************************************/

-(void)getDashboardNotificationAPI
{
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait.."];
        SellerUserDetail *objseller = [MBDataBaseHandler getSellerUserDetailData];
        
        NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
        [dicParams setObject:objseller.APIVerificationCode forKey:@"Token"];
        [dicParams setObject:objseller.VendorID forKey:@"VendorID"];
        
        MBCall_GetDashBoardNotificationDetails(dicParams, ^(id response, NSString *error, BOOL status)
        {
            if (status && [[response valueForKey:@"success"]isEqual:@1])
            {
                if (response != (NSDictionary *)[NSNull null])
                {
                    NSError* Error;
                    DashBoardNotification *objData = [[DashBoardNotification alloc]initWithDictionary:response error:&Error];
                    [MBDataBaseHandler saveDashBoradAuctionDataDetail:objData];
                    
                    self->arrUpCommingNotify = [[NSMutableArray alloc]init];
                    self->arrLiveNotify = [[NSMutableArray alloc]init];
                    self->arrPendingNotify = [[NSMutableArray alloc]init];
                    
                    for (DashBoardNotificationDetail *objdetail in objData.detail)
                    {
                        [self->lblRequestPending setText:[NSString stringWithFormat:@"You have %@ Enquiry Participation request Pending.",objdetail.NotParticipationCount]];
                        
                        for (SellerAuctionDetailData *data in objdetail.SellerAuctionDetail)
                        {
                            if ([data.OrderStatus isEqualToString:@""] && [data.CounterStatus isEqualToString:@""] && [data.PONo isEqualToString:@""] && data.IsStarted == NO && data.IsGoingStart == YES)
                            {
                                [self->arrUpCommingNotify addObject:data];
                            }
                            else  if (data.IsStarted == 1)
                            {
                                [self->arrLiveNotify addObject:data];
                            }
                            else  if (data.IsGoingStart == YES)
                            {
                                // [self->arrPendingNotify addObject:data];
                            }
                        }
                    }
                    [self countdownTimer];
                    [CommonUtility HideProgress];
                    [self->lblMessage setHidden:YES];
                    [self.tbtNotify setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                    [self.tbtNotify reloadData];
                    
                }
            }
            else
            {
                [self->lblMessage setHidden:NO];
                [CommonUtility HideProgress];
                [self.tbtNotify setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                
            }
        });
    }
    else
    {
        [lblMessage setHidden:NO];
        [self.tbtNotify setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
    }
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== GET TIMER COUNT DOWN START ===❉===❉
/******************************************************************************************************************/

-(void)updateCounter:(NSTimer *)theTimer
{
    if(secondsLeft > 0 )
    {
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft % 3600) % 60;
        strTimer = [NSString stringWithFormat:@"%02d : %02d : %02d", hours, minutes, seconds];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CounterTimer" object:strTimer];
        NSLog(@"%@",strTimer);
    }
    else
    {
        if([timer isValid])
        {
            strTimer = @"";
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CounterTimer" object:strTimer];
            [timer invalidate];
            timer = nil;
        }
    }
}
-(void)countdownTimer
{
    secondsLeft = hours = minutes = seconds = (int)getTime();
    
    if([timer isValid])
    {
        strTimer = @"";
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CounterTimer" object:strTimer];
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
}

NSInteger getTime()
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    DashBoardNotification *objData = [MBDataBaseHandler getDashBoardNotificationData];
    for (DashBoardNotificationDetail *objdetail in objData.detail)
    {
        for (SellerAuctionDetailData *data in objdetail.SellerAuctionDetail)
        {
            if ([data.OrderStatus isEqualToString:@""] && [data.CounterStatus isEqualToString:@""] && [data.PONo isEqualToString:@""] && data.IsStarted == NO && data.IsGoingStart == YES)
            {
                NSString *strCalDate = [data.StartDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                
                NSString *strDate = [CommonUtility getDateFromSting:strCalDate fromFromate:@"yyyy/MM/dd hh:mm:ss" withRequiredDateFormate:@"MM/dd/yyyy hh:mm:ss"];
                
                NSDate *dateFrom = [dateFormatter dateFromString:strDate];
                NSTimeInterval aTimeInterval = [dateFrom timeIntervalSinceReferenceDate] + 60;
                NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
                
                NSString *strGiventime = [dateFormatter stringFromDate:newDate];
                NSString *strCurrentTime = [dateFormatter stringFromDate:[NSDate date]];
                
                NSDate* date1 = date(strGiventime);
                NSDate* date2 = date(strCurrentTime);
                
                NSComparisonResult result = [[NSDate date] compare: newDate];
                
                if(result==NSOrderedAscending)
                {
                    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
                    return distanceBetweenDates;
                }
                else if(result==NSOrderedDescending)
                {
                    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
                    return distanceBetweenDates;
                }
                else
                {
                    NSLog(@"Both dates are same");
                }
            }
            else  if (data.IsStarted == 1)
            {
                NSString *strCalDate = [data.EndDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                
                NSString *strDate = [CommonUtility getDateFromSting:strCalDate fromFromate:@"yyyy/MM/dd hh:mm:ss" withRequiredDateFormate:@"MM/dd/yyyy hh:mm:ss"];
                
                NSDate *dateFrom = [dateFormatter dateFromString:strDate];
                NSTimeInterval aTimeInterval = [dateFrom timeIntervalSinceReferenceDate] + 60 ;
                NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
                
                NSString *strGiventime = [dateFormatter stringFromDate:newDate];
                NSString *strCurrentTime = [dateFormatter stringFromDate:[NSDate date]];
                
                NSDate* date1 = date(strGiventime);
                NSDate* date2 = date(strCurrentTime);
                
                NSComparisonResult result = [newDate compare: [NSDate date]];
                
                if(result==NSOrderedAscending)
                {
                    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
                    return distanceBetweenDates;
                }
                else if(result==NSOrderedDescending)
                {
                    NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
                    return distanceBetweenDates;
                }
                else
                {
                    NSLog(@"Both dates are same");
                }
            }
            
        }
    }
    return 0;
}

NSDate *date(NSString *dateStr)
{
    NSString *dateString =  dateStr;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    [date descriptionWithLocale: [NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    return date;
}




@end
/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW CELL METHOD CALLED HERE ===❉===❉
/*****************************************************************************************************************/

@implementation NotificationList
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCounterNotification:)
                                                 name:@"CounterTimer"
                                               object:nil];

}
- (void)ConfigureNotificationListbyCellwithData:(SellerAuctionDetailData *)objSellerAuction withSectionIndex:(NSInteger)section
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [_lblOrderStatus setFont:IS_IPHONE5? UI_DEFAULT_FONT_MEDIUM(13):UI_DEFAULT_FONT_MEDIUM(16)];
    [_lblOrderCode setFont:IS_IPHONE5? UI_DEFAULT_FONT_MEDIUM(13):UI_DEFAULT_FONT_MEDIUM(16)];

    if (objSellerAuction != Nil)
    {
        [_lblOrderTimeLeft setBackgroundColor:[UIColor orangeColor]];

    }
    else
    {
        [_lblOrderTimeLeft setBackgroundColor:[UIColor clearColor]];
    }

    if (section == 0)
    {
        [_lblOrderCode setText:objSellerAuction.AuctionCode];
        if ([objSellerAuction.SupplierStatus isEqualToString:@"Accepted"])
        {
            [_lblOrderStatus setText:@"Activated"];
        }
        else
        {
            [_lblOrderStatus setText:@""];
            
        }
        [_lblOrderStatus setTextColor:GET_COLOR_WITH_RGB(64, 130, 137, 1)];
        
    }
    else if (section == 1)
    {
        [_lblOrderCode setText:objSellerAuction.AuctionCode];
        
        if (objSellerAuction.IsStarted == 1 && ![objSellerAuction.SupplierStatus isEqualToString:@"Pending"]
            && ![objSellerAuction.SupplierStatus isEqualToString:@"PaymentPending"] && ![objSellerAuction.SupplierStatus isEqualToString:@"PaymentProcess"])
        {
            [_lblOrderStatus setText:@"Activated"];
            [_lblOrderStatus setTextColor:GET_COLOR_WITH_RGB(0, 144, 80, 1)];
        }
        else if ([objSellerAuction.SupplierStatus isEqualToString:@"PaymentPending"])
        {
            [_lblOrderStatus setText:@"Pending"];
            [_lblOrderStatus setTextColor:[UIColor redColor]];
        }
        else if ([objSellerAuction.SupplierStatus isEqualToString:@"PaymentProcess"])
        {
            [_lblOrderStatus setText:@"Process"];
            [_lblOrderStatus setTextColor:[UIColor redColor]];
        }
        else {
            [_lblOrderStatus setText:@"New"];
            [_lblOrderStatus setTextColor:[UIColor redColor]];
        }
    }
    else if (section == 2)
    {
        if (objSellerAuction == nil)
        {
            [_lblOrderCode setText:@"No Negotiation Order"];
        }
        
    }
}
- (void) receiveCounterNotification:(NSNotification *) notification
{
    [_lblOrderTimeLeft setText:[NSString stringWithFormat:@"%@",notification.object]];
    [_lblOrderTimeLeft setTextAlignment:NSTextAlignmentCenter];
    [_lblOrderTimeLeft setTextColor:[UIColor whiteColor]];
    [_lblOrderTimeLeft.layer setCornerRadius:5.0f];
    _lblOrderTimeLeft.layer.shadowColor = DefaultThemeColor.CGColor;
    _lblOrderTimeLeft.layer.shadowOpacity = 1.0;
    _lblOrderTimeLeft.layer.shadowRadius = 1.0;
    _lblOrderTimeLeft.layer.masksToBounds = false;

    _lblOrderTimeLeft.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    [_lblOrderTimeLeft setFont:IS_IPHONE5? UI_DEFAULT_FONT_MEDIUM(13):UI_DEFAULT_FONT_MEDIUM(16)];
    [_lblOrderTimeLeft setBackgroundColor:[UIColor orangeColor]];
    
}
@end
