//
//  SellerAuctionDetail.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 04/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@protocol SellerAuctionTranList <NSObject>
@end


@interface SellerAuctionDetail : JSONModel

@property (nonatomic,strong)NSNumber *AuctionID;
@property (nonatomic,strong)NSString *AuctionCode;
@property (nonatomic,strong)NSString *AuctionName;
@property (nonatomic,strong)NSNumber *AuctionRefAmt;
@property (nonatomic,strong)NSNumber *AuctionSellerMarginPer;
@property (nonatomic,strong)NSString *LocationOfDelivery;
@property (nonatomic,strong)NSString *PortOfDischarge;
@property (nonatomic,strong)NSString *DeliveryState;
@property (nonatomic,strong)NSString <Optional>*PaymentTerm;
@property (nonatomic,strong)NSString <Optional>*LCDocUrl;
@property (nonatomic,strong)NSString *CurrencyCode;
@property (nonatomic,strong)NSString <Optional>*BankerName;
@property (nonatomic,strong)NSString *PartialDelivery;
@property (nonatomic,strong)NSString *Status;
@property (nonatomic,strong)NSString *PreferredDate;
@property (nonatomic,strong)NSString *StartDate;
@property (nonatomic,strong)NSString *EndDate;
@property (nonatomic,strong)NSNumber *TotalQuantity;
@property (nonatomic,strong)NSNumber *MinQuantity;
@property (nonatomic,strong)NSString *deliveryLastDate;
@property (nonatomic,strong)NSString *Remarks;
@property (nonatomic,strong)NSMutableArray < SellerAuctionTranList > *AuctionTranList;

@end

@interface SellerAuctionTranList : JSONModel

@property (nonatomic,strong)NSNumber *AuctionTranID;
@property (nonatomic,strong)NSNumber *CategoryID;
@property (nonatomic,strong)NSString <Optional>*CustomCategory;
@property (nonatomic,strong)NSString *deliveryLastDate;
@property (nonatomic,strong)NSString *AttributeValue1;
@property (nonatomic,strong)NSString *AttributeValue2;
@property (nonatomic,strong)NSNumber *Quantity;
@property (nonatomic,strong)NSString <Optional>*AuctionDocsUrl;
@property (nonatomic,strong)NSString *PackingType;
@property (nonatomic,strong)NSString *PackingSize;
@property (nonatomic,strong)NSString *PackingImageUrl;
@property (nonatomic,strong)NSString <Optional>*Description;

@end
