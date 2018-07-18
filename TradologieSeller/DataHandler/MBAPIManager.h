//
//  EDServices.h
//  Florists
//
//  Created by Anil Khanna on 14/02/15.
//  Copyright (c) 2015 Anil Khanna. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TSApiManagerCompletion)(id response,NSString *error,BOOL status);
typedef void(^EDApiPageCompletion)(id response,NSString *error,NSInteger pageCount);
typedef void(^TSApiPageRequestCompletion)(id response,NSString *error);

@interface MBAPIManager : NSObject

void MBCall_LoginUserUsing(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_RegisterUserWithPostData(NSDictionary *params, TSApiManagerCompletion completion);
void MBCall_SupplierLoginControlAPI(NSDictionary *params, TSApiManagerCompletion completion);
void MBCall_SupplierSaveLoginControlAPI(NSDictionary *params, TSApiManagerCompletion completion);
void MBCall_GetSupplierInformationAPI(NSDictionary *params, TSApiManagerCompletion completion);
void MBCall_SaveSupplierInformationAPI(NSDictionary *params, TSApiManagerCompletion completion);
void MBCall_GetVendorMemberShipPlanAPI(NSDictionary *params, TSApiManagerCompletion completion);


void MBCall_GetDashBoardNotificationDetails(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_GetAuctionListUsingDashboardApi(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_SupplierAuctionDetailAPI(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_SupplierAuctionAcceptanceAPI(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_AuctionChargesDetailAPI(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_SupplierAuctionOffLinePaymentWithCustomerIdAPI(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_SupplierAuctionOrderHistoryWithVendorID(NSDictionary* params,TSApiManagerCompletion completion);
@end
