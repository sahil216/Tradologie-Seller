//
//  SellerAuctionList.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 09/06/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"



@protocol SellerAuctionListData <NSObject>
@end

@interface SellerAuctionList : JSONModel

@property (nonatomic,strong)NSString *message;
@property (nonatomic,strong)NSMutableArray <SellerAuctionListData> *detail;
@property (assign) BOOL success;

@end


@interface SellerAuctionListData : JSONModel

@property (nonatomic,strong)NSNumber *AuctionID;
@property (nonatomic,strong)NSString *AuctionCode;
@property (nonatomic,strong)NSString *AuctionName;
@property (nonatomic,strong)NSString *CustomerName;
@property (nonatomic,strong)NSNumber *CustomerID;
@property (nonatomic,strong)NSString *TotalQuantity;
@property (nonatomic,strong)NSString *MinQuantity;
@property (nonatomic,strong)NSString *ParticipateQuantity;
@property (nonatomic,strong)NSString <Optional>*PONo;
@property (nonatomic,strong)NSString *AuctionCharge;
@property (nonatomic,strong)NSString *AcceptanceStatus;
@property (nonatomic,strong)NSString <Optional>*CounterStatus;
@property (nonatomic,strong)NSString <Optional>*OrderStatus;
@property (nonatomic,strong)NSString *Remarks;
@property (assign) BOOL Isclosed;
@property (assign) BOOL IsStarted;
@property (nonatomic,strong)NSString *DeliveryLastDate;
@property (nonatomic,strong)NSString *StartDate;
@property (nonatomic,strong)NSString *EndDate;
@property (nonatomic,strong)NSString *PreferredDate;

@end
