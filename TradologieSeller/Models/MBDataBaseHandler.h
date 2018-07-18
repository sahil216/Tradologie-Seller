//
//  MBDataBaseHandler.h
//  Florists
//
//  Created by Anil Khanna on 14/02/15.
//  Copyright (c) 2015 Anil Khanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "AppConstant.h"
#import "OfflineObject.h"

typedef enum
{
    LoggedInUser = 0,
    sellerUserDetail,
    dashBoardNotification,
    sellerAuctionlist,
    SAdetail,
    auctionOrderHistory,
    sellerLC,
    sellerInfo,
} OFFLINEMODE;


@interface MBDataBaseHandler : NSObject

+(void)clearAllDataBase;

+(void) deleteAllRecordsForType:(OFFLINEMODE)type;

#pragma Mark - GETTERS
+(SellerUserDetail *)getSellerUserDetailData;
+(SellerLoginControl *)getSellerLoginControl;

+(DashBoardNotification *)getDashBoardNotificationData;
+(SellerAuctionList *)getSellerAuctionList;
+(SellerAuctionDetail *)getSellerAuctionDetailData;
+(SellerAuctionOrderHistory *)getSellerAuctionOrderHistoryData;
+(SellerGetInformation *)getSellerGetInformationData;


#pragma Mark - SETTERS

+(void)saveDashBoradAuctionDataDetail:(DashBoardNotification *)dashBoardData;
+(void)saveSellerUserDetailData:(SellerUserDetail *)sellerData;
+(void)saveSellerLoginControlData:(SellerLoginControl *)sellerLoginControl;
+(void)saveSellerGetInformationData:(SellerGetInformation *)sellerGetInfo;

+(void)saveSellerAuctionListData:(SellerAuctionList *)AuctionListData;
+(void)saveSellerAuctionDetailData:(SellerAuctionDetail *)objSellerAuctionDetail;
+(void)saveSellerAuctionOrderHistoryData:(SellerAuctionOrderHistory *)objOrderHistory;




@end
