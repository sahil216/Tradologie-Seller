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

#import "INSSearchBar.h"

#define SAVE_USER_DEFAULTS(VALUE,KEY) [[NSUserDefaults standardUserDefaults] setObject:VALUE forKey:KEY]; [[NSUserDefaults standardUserDefaults] synchronize]

static NSString *API_DEFAULT_TOKEN = @"2018APR031848";
static NSString *TYPE_OF_ACCOUNT_ID = @"1";

/*********************************************************************************************************/
#pragma Mark- MODEL IMPORT
/*********************************************************************************************************/
#import "SellerUserDetail.h"
#import "DashBoardNotification.h"
#import "SellerAuctionList.h"
#import "SellerAuctionDetail.h"


/*********************************************************************************************************/
#pragma Mark- CUSTOM CELL IMPORT
/*********************************************************************************************************/
#import "TvCellEnquiry.h"
#import "ViewEnquiryState.h"
#import "SAuctionDetailCell.h"
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


/*********************************************************************************************************/
#pragma Mark - API KEY NAME
/*********************************************************************************************************/
static NSString *SELLER_LOGIN_API = @"Login";
static NSString *DASHBOARD_NOTIFICATION_API =@"DashboardNotification";
static NSString *AUCTION_LIST_API = @"AuctionList";
static NSString *SUPPLIER_AUCTION_DETAIL_API = @"AuctionDetail";


/*********************************************************************************************************/
#pragma CONTROLLER IDENTIFIRES
/*********************************************************************************************************/

static NSString *const kRootViewController                  = @"RootViewController";


#endif /* AppConstant_h */
