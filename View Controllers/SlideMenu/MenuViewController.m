//
//  MenuViewController.m
//  CherryPop
//
//  Created by Shiv Kumar on 21/12/16.
//  Copyright © 2016 Shiv Kumar. All rights reserved.
//

#import "MenuViewController.h"
#import "Constant.h"
#import "CommonUtility.h"
#import "VCTradePolicyScreen.h"
#import "VCHomeNotifications.h"
#import "VCNegotiationScreen.h"
#import "MBDataBaseHandler.h"
#import "AppConstant.h"
#import "MBAPIManager.h"
#import "SharedManager.h"

//#import "VcEnquiryRequestScreen.h"
//#import "VCContactTradologie.h"
//#import "VCAddNegotiation.h"
//#import "VCOrderHistory.h"
//#import "VCSupplierShortlist.h"



static NSString *const  kCellIdentifire = @"MenuViewCell";

@interface MenuViewController ()
{
    NSMutableArray *arrayController;
    NSArray *arrayControllerIMG;
    NSDictionary *dictInfo;
    NSArray *arrayControllerID;
    NSString *notificationType;
}

@end

@implementation MenuViewController

//:: View Life Cycle :://
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self config];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self config];
    [tblView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//************************************************************************************************
#pragma mark ❉===❉=== Config ===❉===❉
//************************************************************************************************

-(void)config
{
    arrayControllerID = @[];
    
    NSArray *arrayTemp = @[@"Dashboard",
                           @"Negotiation",
                           @"Negotiation Order History",
                           @"My Accounts",
                           @"Accounts",
                           @"Notifications",
                           @"Share",
                           @"Settings",
                           @"About Us",
                           @"Privacy Policy",
                           @"Trade Policy",
                           @"Escrow",@"Terms of Use",@"Account Details",@"Contact Tradologie"];
    
    arrayController = [NSMutableArray new];
    arrayControllerIMG = @[@"IconDashBoard",
                           @"IconNegotiation",
                           @"IconOrderHistory",
                           @"IconMyAccounts",
                           @"IconMyAccount",
                           @"IconNotification",
                           @"IconShare",
                           @"IconSettings",
                           @"IconAboutUs", @"IconPrivacyPolicy", @"IconTradePolicy", @"IconEscrow", @"IconTermUse", @"IconAccountDetail", @"IconUser"];
    [arrayController addObjectsFromArray:arrayTemp];
    
    tblView.tableFooterView = [UIView new];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handleSingleTapGesture:)];
    [viewProfile addGestureRecognizer:singleTapGestureRecognizer];
    [imgViewProfile.layer setCornerRadius:imgViewProfile.frame.size.height/2];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->tblView reloadData];
    });
}
//************************************************************************************************
#pragma mark ❉===❉=== USER LOGOUT ===❉===❉
//************************************************************************************************

-(IBAction)clickOnLogoutBtn:(id)sender
{
    [indicator startAnimating];
    [indicator setColor:[UIColor whiteColor]];
    // TODO: Some stuff here...
}

//************************************************************************************************
#pragma mark ❉===❉=== UITapGestureRecognizer Method ===❉===❉
//************************************************************************************************
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognize
{
    //    UIViewController *viewC = GET_VIEW_CONTROLLER(vc);
    //    [self pushViewController:viewC];
}

//************************************************************************************************
#pragma mark - ❉===❉=== TableView DataSource & Delegate ===❉===❉
//************************************************************************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayController.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (IS_IPHONE_6P)?55:54;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuViewCell *cell = (MenuViewCell *)[tblView dequeueReusableCellWithIdentifier:kCellIdentifire];
    if (cell == nil)
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:kCellIdentifire owner:self options:nil];
        cell = nibArray[0];
    }
    cell.lblTitile.text = (NSString *)arrayController[indexPath.row];
    
    cell.imgView.image = [UIImage imageNamed:arrayControllerIMG[indexPath.row]];
    cell.imgView.image = [cell.imgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cell.imgView setTintColor:[UIColor whiteColor]];
    return cell;
}
//************************************************************************************************
#pragma mark - ❉===❉=== TableView Delegate ===❉===❉
//************************************************************************************************

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    switch (indexPath.row)
    {
        case 0:
        {
            VCHomeNotifications *objScreen = GET_VIEW_CONTROLLER(@"VCHomeNotifications");
            [self pushViewController:objScreen];
        }
            break;
        case 1:
        {
            [self GetNegotiationListUsingAuction];
        }
            break;
        case 2:
        {

        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
//            VCSupplierShortlist *objShortlist =[self.storyboard instantiateViewControllerWithIdentifier:@"VCSupplierShortlist"];
//            [self pushViewController:objShortlist];

        }
            break;
        case 5:
        {
//            UIActivityViewController *activity = [CommonUtility getActivityViewController];
//            [self presentViewController:activity animated:YES completion:^{
//            }];
        }
            break;
        case 6:
        {
            UIActivityViewController *activity = [CommonUtility getActivityViewController];
            [self presentViewController:activity animated:YES completion:^{
            }];
        }
            break;
        case 7:
        {
            
        }
            break;
        case 8:
        {
            [CommonUtility OpenURLAccordingToUse:@"http://tradologie.com/lp/about-us.html"];

        }
            break;
        case 9:
        {
            [CommonUtility OpenURLAccordingToUse:@"http://tradologie.com/lp/privacy.html"];

        }
            break;
        case 10:
        {
            VCTradePolicyScreen *objScreen = GET_VIEW_CONTROLLER(@"VCTradePolicyScreen");
            [self pushViewController:objScreen];
        }
            break;
        case 11:
        {

        }
            break;
        case 12:
        {
            [CommonUtility OpenURLAccordingToUse:@"http://tradologie.com/lp/terms-of-use.html"];
        }
        case 13:
        {
            
        }
            break;
        case 14:
        {
            
        }
            break;
        case 15:
        {
//            VCContactTradologie *objContactScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"VCContactTradologie"];
//            [self pushViewController:objContactScreen];
        }
            break;
        
        default:
            break;
    }
}

/******************************************************************************************************************/
#pragma mark ❉===❉===  GET AUCTION NEGOTIATION LIST API CALLED HERE ===❉===❉
/******************************************************************************************************************/
-(void)GetNegotiationListUsingAuction
{
     SellerUserDetail * objSellerdetail = [MBDataBaseHandler getSellerUserDetailData];
    NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
    [dicParams setObject:objSellerdetail.detail.APIVerificationCode forKey:@"Token"];
    [dicParams setObject:objSellerdetail.detail.VendorID forKey:@"VendorID"];
    [dicParams setObject:@"" forKey:@"FilterAuction"];
    
    if (SharedObject.isNetAvailable)
    {
        MBCall_GetAuctionListUsingDashboardApi(dicParams, ^(id response, NSString *error, BOOL status)
       {
           if (status && [[response valueForKey:@"success"]isEqual:@1])
           {
               if (response != (NSDictionary *)[NSNull null])
               {
                   NSError* Error;
                   SellerAuctionList *objAuctionList = [[SellerAuctionList alloc]initWithDictionary:response error:&Error];
                   [MBDataBaseHandler saveSellerAuctionListData:objAuctionList];
                   
                   VCNegotiationScreen *objNegotiationScreen=[self.storyboard instantiateViewControllerWithIdentifier:@"VCNegotiationScreen"];
                   [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
                   [self pushViewController:objNegotiationScreen];
               }
           }
           else
           {
               
           }
       });
    }
    else
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
    }
}
//************************************************************************************************
#pragma mark ❉===❉=== PUSHVIEW CONTROLLER ===❉===❉
//************************************************************************************************

-(void)pushViewController:(UIViewController *)VC
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *navObj = [[UINavigationController alloc]initWithRootViewController:VC];
        navObj.navigationBar.tintColor = [UIColor whiteColor];
        navObj.navigationBar.hidden = false;
        navObj.navigationBar.translucent = false;
        [navObj.navigationBar setNaviagtionStyleWithStatusbar:[UIColor whiteColor]];
        [self.sideMenuViewController setContentViewController:navObj animated:true];
        [self.sideMenuViewController hideMenuViewController];
    });
}


@end
