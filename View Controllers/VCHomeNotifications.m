//
//  VCHomeNotifications.m
//  Tradologie
//
//  Created by Chandresh Maurya on 09/05/18.
//  Copyright © 2018 Chandresh Maurya. All rights reserved.
//

#import "VCHomeNotifications.h"
//#import "VcEnquiryRequestScreen.h"
#import "AppConstant.h"
#import "MBAPIManager.h"
#import "SharedManager.h"
#import "CommonUtility.h"
#import "MBDataBaseHandler.h"
//#import "VCAddNegotiation.h"


@interface VCHomeNotifications ()
{
    NSMutableArray *arrNotificationList;
  //  NSMutableDictionary *dicData;
    UILabel *lblMessage;
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

    arrNotificationList = [[NSMutableArray alloc]init];
    [self getDashboardNotificationAPI];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (arrNotificationList.count > 0)?arrNotificationList.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationList *cell =(NotificationList *) [tableView dequeueReusableCellWithIdentifier:COMMON_CELL_ID];
    if (!cell) {
        cell = [[NotificationList alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:COMMON_CELL_ID];
    }
    //[cell ConfigureNotificationListbyCellwithData:[arrNotificationList objectAtIndex:indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 //   NSNumber *selectedvalue = [NSNumber numberWithInteger:[[arrNotificationList objectAtIndex:indexPath.row] intValue]];
//    if ([[dicData valueForKey:@"AuctionDraftCount"] isEqual:selectedvalue])
//    {
//        //[self GetNegotiationListUsingAuction:@"Draft"];
//    }
//    else if ([[dicData valueForKey:@"AuctionNotStartCount"] isEqual:selectedvalue])
//    {
//       // [self GetNegotiationListUsingAuction:@"NotStart"];
//    }
//    else
//    {
//       // [self GetNegotiationListUsingAuction:@""];
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *arrTittle= [[NSMutableArray alloc]initWithObjects:@"Upcomming Negotiation",@"Live Negotiation",@"Pending Orders", nil];
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [viewHeader setBackgroundColor:DefaultThemeColor];
    lblHeaaderTittle = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH-50, viewHeader.frame.size.height)];
    [lblHeaaderTittle setText:[arrTittle objectAtIndex:section]];
    [lblHeaaderTittle setTextColor:[UIColor whiteColor]];
    [lblHeaaderTittle setFont:UI_DEFAULT_FONT_MEDIUM(18)];
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 7.5, 25, 25)];
    [imgView setBackgroundColor:[UIColor clearColor]];
    [imgView setImage:IMAGE(@"IconStar")];
    [viewHeader addSubview:imgView];
    [viewHeader addSubview:lblHeaaderTittle];
    return viewHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
        [dicParams setObject:objseller.detail.APIVerificationCode forKey:@"Token"];
        [dicParams setObject:objseller.detail.VendorID forKey:@"VendorID"];

        MBCall_GetDashBoardNotificationDetails(dicParams, ^(id response, NSString *error, BOOL status)
        {
            if (status && [[response valueForKey:@"success"]isEqual:@1])
            {
                if (response != (NSDictionary *)[NSNull null])
                {
                    NSError* Error;
                    DashBoardNotification *objData = [[DashBoardNotification alloc]initWithDictionary:response error:&Error];
                    [MBDataBaseHandler saveDashBoradAuctionDataDetail:objData];
                    for (DashBoardNotificationDetail *objdetail in objData.detail)
                    {
                        [self->lblRequestPending setText:[NSString stringWithFormat:@"You have %@ Enquiry Participation request Pending.",objdetail.NotParticipationCount]];

                    }
                    [CommonUtility HideProgress];
                    [self->lblMessage setHidden:YES];
                    [self.tbtNotify setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                    //[self.tbtNotify reloadData];

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
#pragma mark ❉===❉===  GET AUCTION NEGOTIATION LIST API CALLED HERE ===❉===❉
/******************************************************************************************************************/
//-(void)GetNegotiationListUsingAuction:(NSString *)strValue
//{
//    BuyerUserDetail *objBuyerdetail = [MBDataBaseHandler getBuyerUserDetail];
//
//    NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
//    [dicParams setObject:objBuyerdetail.detail.APIVerificationCode forKey:@"Token"];
//    [dicParams setObject:objBuyerdetail.detail.CustomerID forKey:@"CustomerID"];
//    [dicParams setObject:strValue forKey:@"FilterAuction"];
//
//    if (SharedObject.isNetAvailable)
//    {
//        [CommonUtility showProgressWithMessage:@"Please Wait.."];
//        MBCall_GetAuctionListUsingDashboardApi(dicParams, ^(id response, NSString *error, BOOL status)
//        {
//            [CommonUtility HideProgress];
//            if (status && [[response valueForKey:@"success"]isEqual:@1])
//            {
//                if (response != (NSDictionary *)[NSNull null])
//                {
//                    NSError* Error;
//                    AuctionDetail *detail = [[AuctionDetail alloc]initWithDictionary:response error:&Error];
//                    [MBDataBaseHandler saveAuctionDetailData:detail];
//
//                    VcEnquiryRequestScreen *requestSc=[self.storyboard instantiateViewControllerWithIdentifier:@"VcEnquiryRequestScreen"];
//                    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
//                    [self.navigationController pushViewController:requestSc animated:YES];
//                }
//                else{
//                    [CommonUtility HideProgress];
//                }
//            }
//            else
//            {
//                [CommonUtility HideProgress];
//
//            }
//        });
//    }
//    else
//    {
//        [lblMessage setHidden:NO];
//        [self.tbtNotify setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
//    }
//}

@end
/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW CELL METHOD CALLED HERE ===❉===❉
/*****************************************************************************************************************/

@implementation NotificationList

- (void)ConfigureNotificationListbyCellwithData:(NSString *)strValue
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self SetAttributedStringWithUnderlineTittle:strValue];
}
-(void)SetAttributedStringWithUnderlineTittle:(NSString *)strValue
{
    [_lblNotifyName setFont:([SDVersion deviceSize] > Screen4Dot7inch)?UI_DEFAULT_FONT(17):([SDVersion deviceSize] < Screen4Dot7inch)?UI_DEFAULT_FONT(14):UI_DEFAULT_FONT(16)];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"You have %@ Enquiry Request in Creation",strValue]];
    
    NSRange range = (strValue.length == 2)?NSMakeRange(9, 2):NSMakeRange(9, 1);
    
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleDouble)
                      range:range];
    [tncString addAttribute:NSUnderlineColorAttributeName value:[UIColor orangeColor] range:range];
    [tncString addAttribute:NSFontAttributeName value:UI_DEFAULT_FONT_MEDIUM(16) range:range];
    
    [_lblNotifyName setAttributedText:tncString];
}
@end
