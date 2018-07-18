//
//  AppConstant.h
//  Tradologie
//
//  Created by Macbook Pro 1 on 07/05/18.
//  Copyright © 2018 Chandresh Maurya. All rights reserved.
//

#ifndef AppConstant_h
#define AppConstant_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MagicalRecord/MagicalRecord.h>
#import <SafariServices/SFSafariViewController.h>
#import <WebKit/WKWebView.h>
#import <WebKit/WKWebViewConfiguration.h>
#import <WebKit/WKUserContentController.h>
#import <WebKit/WKNavigationAction.h>
#import <WebKit/WKUIDelegate.h>
#import <WebKit/WebKit.h>
#import "THSegmentedPageViewControllerDelegate.h"
#import "THSegmentedPager.h"
#import "INSSearchBar.h"


#define SAVE_USER_DEFAULTS(VALUE,KEY) [[NSUserDefaults standardUserDefaults] setObject:VALUE forKey:KEY]; [[NSUserDefaults standardUserDefaults] synchronize]

static NSString *API_DEFAULT_TOKEN = @"2018APR031848";
static NSString *TYPE_OF_ACCOUNT_ID = @"1";

/*********************************************************************************************************/
#pragma Mark- MODEL IMPORT
/*********************************************************************************************************/
#import "SellerUserDetail.h"
#import "SellerLoginControl.h"
#import "DashBoardNotification.h"
#import "SellerAuctionList.h"
#import "SellerAuctionDetail.h"
#import "SellerAuctionOrderHistory.h"

/*********************************************************************************************************/
#pragma Mark- CUSTOM CELL IMPORT
/*********************************************************************************************************/
#import "TvCellEnquiry.h"
#import "ViewEnquiryState.h"
#import "SAuctionDetailCell.h"
#import "EnquirySellerAcceptCell.h"
#import "TVCellOrderHistory.h"
#import "TVCellAuthorizedPerson.h"
#import "TVCellSellingLocation.h"
#import "TVSellerBulkRetailCell.h"
#import "TVCustomBulkRetailCell.h"
#import "TVCellBulkRetailList.h"
#import "TVCellMembershipType.h"
#import "TVCellMemberShipPlan.h"

/*********************************************************************************************************/
#pragma Mark- BASE URL IMPORT
/*********************************************************************************************************/
#define HOST_URL @"http://api.tradologie.com/Supplier/"


/*********************************************************************************************************/
#pragma Mark- Image Name
/*********************************************************************************************************/

static NSString *CHECK_IMAGE = @"IconCheckBox";
static NSString *UNCHECK_IMAGE = @"IconUnCheckBox";

/*********************************************************************************************************/
#pragma Mark- TABLE CELL IDENTIFIERS
/*********************************************************************************************************/

static NSString *COLLECTION_CELL_ID = @"CVcell_Identifier";
static NSString *COMMON_CELL_ID = @"Cell_Identifier";
static NSString *CELL_BULK_RETAIL_ID = @"CellBulkRetailIdentifier";
static NSString *CELL_MEMBERSHIP_ID = @"CellMemberShipPlanIdentifier";
/*********************************************************************************************************/
#pragma Mark - API KEY NAME
/*********************************************************************************************************/
static NSString *SELLER_LOGIN_API = @"Login";
static NSString *SELLER_REGISTER_API = @"Register";
static NSString *SELLER_LOGIN_CONTROL_API = @"GetLoginControl";
static NSString *SELLER_SAVE_LOGIN_CONTROL_API =@"SaveLoginControl";
static NSString *SELLER_UPLOAD_IMAGE_API =@"UploadVendorImage";
static NSString *SELLER_GET_INFORMATION_API = @"GetInformation";
static NSString *SELLER_SAVE_INFORMATION_API = @"SaveInformation";
static NSString *SELLER_MEMBERSHIP_API = @"MemberShipPlanList";





static NSString *DASHBOARD_NOTIFICATION_API =@"DashboardNotification";
static NSString *AUCTION_LIST_API = @"AuctionList";
static NSString *SUPPLIER_AUCTION_DETAIL_API = @"AuctionDetail";
static NSString *SUPPLIER_AUCTION_ACCEPTANCE_API  = @"SupplierAuctionAcceptance";
static NSString *SUPPLIER_AUCTION_CHARGE_DETAIL_API        =@"AuctionChargesDetail";
static NSString *SUPPLIER_AUCTION_OFFLINE_PAYMENT_API      =@"AuctionOffLinePayment";
static NSString *SUPPLIER_AUCTION_ORDER_HISTORY_API        = @"AuctionOrderHistoryList";
/*********************************************************************************************************/
#pragma CONTROLLER IDENTIFIRES
/*********************************************************************************************************/

static NSString *const kRootViewController                  = @"RootViewController";


#endif /* AppConstant_h */
