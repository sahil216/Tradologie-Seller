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
   
} OFFLINEMODE;


@interface MBDataBaseHandler : NSObject

+(void)clearAllDataBase;

+(void) deleteAllRecordsForType:(OFFLINEMODE)type;

#pragma Mark - GETTERS
+(SellerUserDetail *)getSellerUserDetailData;
+(DashBoardNotification *)getDashBoardNotificationData;
+(SellerAuctionList *)getSellerAuctionList;
+(SellerAuctionDetail *)getSellerAuctionDetailData;


#pragma Mark - SETTERS

+(void)saveDashBoradAuctionDataDetail:(DashBoardNotification *)dashBoardData;
+(void)saveSellerUserDetailData:(SellerUserDetail *)sellerData;
+(void)saveSellerAuctionListData:(SellerAuctionList *)AuctionListData;
+(void)saveSellerAuctionDetailData:(SellerAuctionDetail *)objSellerAuctionDetail;




@end
