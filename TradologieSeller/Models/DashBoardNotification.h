//
//  DashBoardNotification.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 09/06/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@protocol DashBoardNotificationDetail <NSObject>
@end
@protocol SellerAuctionDetailData <NSObject>
@end

@interface DashBoardNotification : JSONModel
@property (nonatomic,strong)NSString *message;
@property (nonatomic,strong)NSMutableArray <DashBoardNotificationDetail> *detail;
@property (assign) BOOL success;
@end

@interface DashBoardNotificationDetail : JSONModel
@property (nonatomic,strong)NSNumber *NotParticipationCount;
@property (nonatomic,strong)NSMutableArray <SellerAuctionDetailData> *SellerAuctionDetail;
@end

@interface SellerAuctionDetailData : JSONModel
@property (nonatomic,strong)NSString *AuctionCode;
@property (nonatomic,strong)NSNumber *AuctionID;
@property (nonatomic,strong)NSString *AuctionName;
@property (nonatomic,strong)NSString *BuyerName;
@property (nonatomic,strong)NSString *BuyerProcessOrderDate;
@property (nonatomic,strong)NSString *BuyerReplyDate;
@property (nonatomic,strong)NSString *CounterStatus;
@property (nonatomic,strong)NSNumber *CustomerID;
@property (nonatomic,strong)NSString *CustomerName;
@property (nonatomic,strong)NSString *DocumentReplyDate;
@property (nonatomic,strong)NSString *EndDate;
@property (nonatomic,strong)NSString *InspectionReplyDate;
@property (assign) BOOL IsComplete;
@property (assign) BOOL IsGoingStart;
@property (assign) BOOL IsStarted;
@property (nonatomic,strong)NSString *OrderStatus;
@property (nonatomic,strong)NSString *PONo;
@property (nonatomic,strong)NSString *POReplyDate;
@property (nonatomic,strong)NSString *SellerCounterOfferDate;
@property (nonatomic,strong)NSString *SellerPOReplyDate;
@property (nonatomic,strong)NSString *SellerPaymentReplyDate;
@property (nonatomic,strong)NSString *SellerReplyDate;
@property (nonatomic,strong)NSString *ServerTime;
@property (nonatomic,strong)NSString *StartDate;
@property (nonatomic,strong)NSString *SupplierStatus;
@property (nonatomic,strong)NSString *TimeLeft;
@property (nonatomic,strong)NSString *TimeRemaining;
@property (nonatomic,strong)NSString *VendorName;

@end
