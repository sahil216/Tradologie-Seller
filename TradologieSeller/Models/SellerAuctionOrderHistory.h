//
//  SellerAuctionOrderHistory.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 09/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@protocol SellerAuctionOrderHistoryData <NSObject>
@end

@interface SellerAuctionOrderHistory : JSONModel
@property (nonatomic,strong)NSString *message;
@property (nonatomic,strong)NSMutableArray <SellerAuctionOrderHistoryData> *detail;
@property (assign) BOOL success;

@end


@interface SellerAuctionOrderHistoryData : JSONModel

@property (nonatomic,strong)NSNumber *AuctionID;
@property (nonatomic,strong)NSString *AuctionCode;
@property (nonatomic,strong)NSString *AuctionName;
@property (nonatomic,strong)NSNumber *CustomerID;
@property (nonatomic,strong)NSString *CustomerName;
@property (nonatomic,strong)NSNumber *TotalQuantity;
@property (nonatomic,strong)NSNumber *MinQuantity;
@property (nonatomic,strong)NSNumber *ParticipateQuantity;
@property (nonatomic,strong)NSNumber *TotalOrderQuantity;
@property (nonatomic,strong)NSString *PONo;
@property (nonatomic,strong)NSNumber *AuctionCharge;
@property (nonatomic,strong)NSString *AcceptanceStatus;
@property (nonatomic,strong)NSString <Optional>*CounterStatus;
@property (nonatomic,strong)NSString <Optional>*OrderStatus;
@property (nonatomic,strong)NSString <Optional>*Remarks;
@property (assign) BOOL Isclosed;
@property (assign) BOOL IsStarted;
@property (nonatomic,strong)NSString *DeliveryLastDate;
@property (nonatomic,strong)NSString *StartDate;
@property (nonatomic,strong)NSString *EndDate;
@property (nonatomic,strong)NSString *PreferredDate;

@end
