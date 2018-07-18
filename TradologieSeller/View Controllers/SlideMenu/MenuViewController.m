//
//  MenuViewController.m
//  CherryPop
//
//  Created by Shiv Kumar on 21/12/16.
//  Copyright © 2016 Shiv Kumar. All rights reserved.
//

#import "MenuViewController.h"
#import "Constant.h"
#import "AppConstant.h"
#import "CommonUtility.h"
#import "MBAPIManager.h"
#import "MBDataBaseHandler.h"
#import "SharedManager.h"

#import "VCTradePolicyScreen.h"
#import "VCHomeNotifications.h"
#import "VCNegotiationScreen.h"
#import "VCNegotiationOrderHistory.h"
#import "VCContactTradologie.h"
#import "TvAlreadyUserScreen.h"
#import "TVManageAccountScreen.h"
#import "MBDataBaseHandler.h"
#import "TVLoginControlScreen.h"
#import "TVCompanyDetails.h"
#import "TVSupplierDocument.h"
#import "VCAuthorizedPersonal.h"
#import "TVLegalDocumentScreen.h"
#import "TVBankDetailScreen.h"
#import "VCSellingLocation.h"
#import "VCBulkRetailScreen.h"
#import "VCMemberShipTypeScreen.h"

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
    SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
    [lblUserName setText:objSeller.VendorName];
    
}
//************************************************************************************************
#pragma mark ❉===❉=== USER LOGOUT ===❉===❉
//************************************************************************************************

-(IBAction)clickOnLogoutBtn:(UIButton *)sender
{
    [indicator startAnimating];
    [indicator setColor:[UIColor whiteColor]];
    [sender setTitle:@"" forState:UIControlStateNormal];
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Tradologie"
                                                                  message:@"Are you Sure You want to LogOut"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes, please"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    [self->indicator stopAnimating];
                                    [self->indicator setHidesWhenStopped:YES];
                                    [sender setTitle:@"LogOut" forState:UIControlStateNormal];
                                    [MBDataBaseHandler clearAllDataBase];
                                    
                                    UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    TvAlreadyUserScreen * rootVC = [storyboard instantiateViewControllerWithIdentifier:@"TvAlreadyUserScreen"];
                                    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:rootVC];
                                    
                                    AppDelegate *delegateClass = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                    [delegateClass setRootViewController:nav];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No, thanks"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   [self->indicator stopAnimating];
                                   [self->indicator setHidesWhenStopped:YES];
                                   [sender setTitle:@"LogOut" forState:UIControlStateNormal];
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
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
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
            
            VCNegotiationScreen *objNegotiationScreen=GET_VIEW_CONTROLLER(@"VCNegotiationScreen");
            [self pushViewController:objNegotiationScreen];
            //[self GetNegotiationListUsingAuction];
        }
            break;
        case 2:
        {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
            VCNegotiationOrderHistory *objNegotiationScreen = GET_VIEW_CONTROLLER(@"VCNegotiationOrderHistory");
            [self pushViewController:objNegotiationScreen];
            
        }
            break;
        case 3:
        {
            [self getManageAccountScreenWithPagination];
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
            VCContactTradologie *objContactScreen = GET_VIEW_CONTROLLER(@"VCContactTradologie");
            [self pushViewController:objContactScreen];
        }
            break;
        
        default:
            break;
    }
}

///******************************************************************************************************************/
//#pragma mark ❉===❉===  GET AUCTION NEGOTIATION LIST API CALLED HERE ===❉===❉
///******************************************************************************************************************/
//-(void)GetNegotiationListUsingAuction
//{
//    SellerUserDetail * objSellerdetail = [MBDataBaseHandler getSellerUserDetailData];
//    NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
//    [dicParams setObject:objSellerdetail.detail.APIVerificationCode forKey:@"Token"];
//    [dicParams setObject:objSellerdetail.detail.VendorID forKey:@"VendorID"];
//    [dicParams setObject:@"" forKey:@"FilterAuction"];
//
//    if (SharedObject.isNetAvailable)
//    {
//        MBCall_GetAuctionListUsingDashboardApi(dicParams, ^(id response, NSString *error, BOOL status)
//       {
//           if (status && [[response valueForKey:@"success"]isEqual:@1])
//           {
//               if (response != (NSDictionary *)[NSNull null])
//               {
//                   NSError* Error;
//                   SellerAuctionList *objAuctionList = [[SellerAuctionList alloc]initWithDictionary:response error:&Error];
//                   [MBDataBaseHandler saveSellerAuctionListData:objAuctionList];
//
//                   dispatch_async(dispatch_get_main_queue (), ^{
//
//                   });
//               }
//           }
//           else
//           {
//               [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:error];
//           }
//       });
//    }
//    else
//    {
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
//    }
//}
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

-(void)getManageAccountScreenWithPagination
{
    THSegmentedPager *objManageAccountMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"THSegmentedPager"];
    objManageAccountMenu.isfromMenu = YES;
    NSMutableArray *arrMenuTittle = [[NSMutableArray alloc]initWithObjects:@"LOGIN CONTROL",@"INFORMATION",@"MEMBERSHIP TYPE",@"COMPANY DETAILS",@"DOCUMENTS",@"AUTHORIZED PERSON",@"LEGAL DOCUMENTS",@"BANK DETAILS",@"SELLING LOCATION",@"BULK RETAIL",nil];
    
    NSMutableArray *pages = [NSMutableArray new];
    
    for (NSInteger SceenNo = 0; SceenNo < [arrMenuTittle count]; SceenNo++)
    {
        switch (SceenNo)
        {
            case 0:
            {
                TVLoginControlScreen *objManageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVLoginControlScreen"];
                objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:0]];
                [pages addObject:objManageScreen];
            }
                break;
            case 1:
            {
                TVManageAccountScreen *objManageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVManageAccountScreen"];
                objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objManageScreen];
            }
                break;
            case 2:
            {
                VCMemberShipTypeScreen *objMemberShipType = [self.storyboard instantiateViewControllerWithIdentifier:@"VCMemberShipTypeScreen"];
                objMemberShipType.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objMemberShipType];
            }
                break;
            case 3:
            {
                TVCompanyDetails *objTVCompanyDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"TVCompanyDetails"];
                objTVCompanyDetails.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objTVCompanyDetails];
            }
                break;
            case 4:
            {
                TVSupplierDocument *objManageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVSupplierDocument"];
                objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objManageScreen];
            }
                break;
            case 5:
            {
                VCAuthorizedPersonal *objAuthorized = [self.storyboard instantiateViewControllerWithIdentifier:@"VCAuthorizedPersonal"];
                objAuthorized.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objAuthorized];
            }
                break;
            case 6:
            {
                TVLegalDocumentScreen *objLegalDocument = [self.storyboard instantiateViewControllerWithIdentifier:@"TVLegalDocumentScreen"];
                objLegalDocument.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objLegalDocument];
            }
                break;
            case 7:
            {
                TVBankDetailScreen *objBankDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"TVBankDetailScreen"];
                objBankDetail.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objBankDetail];
            }
                break;
            case 8:
            {
                VCSellingLocation *objVCSelling = [self.storyboard instantiateViewControllerWithIdentifier:@"VCSellingLocation"];
                objVCSelling.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objVCSelling];
            }
                break;
            case 9:
            {
                VCBulkRetailScreen *objVCBulkRetail = [self.storyboard instantiateViewControllerWithIdentifier:@"VCBulkRetailScreen"];
                objVCBulkRetail.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objVCBulkRetail];
            }
                break;
            default:
                break;
        }
    }
    [objManageAccountMenu setPages:pages];
    [objManageAccountMenu setSelectIndex:1];
    [self pushViewController:objManageAccountMenu];
}

@end
