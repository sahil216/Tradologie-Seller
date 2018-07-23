//
//  MBAPIManager.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 11/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
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
void MBCall_GetVendorMemberShipPlanListAPI(NSDictionary *params, TSApiManagerCompletion completion);
void MBCall_GetUpdateMembershipDetailAPI(NSDictionary *params, TSApiManagerCompletion completion);
void MBCall_GetParticularVendorMemberShipPlanAPI(NSDictionary *params, TSApiManagerCompletion completion);
void MBCall_GetCommonSupplierDataWithVendorIDAPI(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_GetStateCityAreaListAccordingtoCountryNameAPI(NSDictionary *params,
                                                          NSInteger index,TSApiManagerCompletion completion);
void MBCall_GetSupplierAgreementFileDetail(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_UpdateAgreementDetailSupplier(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_GetSupplierBankDetailData(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_GetSupplierUpdateBankDetailData(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_UploadBankCheque(NSDictionary* params, NSData *image_data ,TSApiManagerCompletion completion);

void MBCall_GetSellerUpdateCompanyDetailsWithAPI(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_GetSellerCompanyDetailsWithAPI(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_AddUploadVendorImageAPI(NSDictionary *params, NSData * image_data,TSApiManagerCompletion completion);
//void MBCall_AddUploadVendorImageAPI(NSDictionary *params ,TSApiManagerCompletion completion);
void MBCall_SaveAuthorizePersonDetailAPI(NSDictionary* params,TSApiManagerCompletion completion);

void MBCall_GetDashBoardNotificationDetails(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_GetAuctionListUsingDashboardApi(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_SupplierAuctionDetailAPI(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_SupplierAuctionAcceptanceAPI(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_AuctionChargesDetailAPI(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_SupplierAuctionOffLinePaymentWithCustomerIdAPI(NSDictionary* params,TSApiManagerCompletion completion);
void MBCall_SupplierAuctionOrderHistoryWithVendorID(NSDictionary* params,TSApiManagerCompletion completion);
@end
