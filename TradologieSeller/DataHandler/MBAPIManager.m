//
//  MBAPIManager.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 11/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "MBAPIManager.h"
#import "MBHTTPClient.h"
#import "MBErrorUtility.h"
#import "AppConstant.h"
#import <AFNetworking/AFURLResponseSerialization.h>

#define getUrlForMethod(v) [[HOST_URL stringByAppendingString:v]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]

@implementation MBAPIManager : NSObject

void MBCall_CancelAllRequest(){
    [[MBHTTPClient  sharedInstance]cancelAllOperation];
}

NSString* checkIfResponseHasErrorMessage(id response){
    if (!response) {
        return @"Issue with server response. Please contact admin.";
    }
    
    if (![response isKindOfClass:[NSDictionary class]]) {
        return @"Issue with server response. Please contact admin.";
    }
    if (!response) {
        return @"Issue with server response. Please contact admin";
    }
    
    if ([response isKindOfClass:[NSDictionary class]] && ![response[@"status"] boolValue]) {
        return response[@"message"];
    }
    
  
    return nil;
}


#pragma mark - Filter error message

NSString *filterErrorMessageUsingResponseRequestOperation(NSURLSessionDataTask *operation, NSError *error)
{
    NSDictionary *jsonResponse;
    
    //return error.localizedDescription;
    NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    
    if (responseData) {
        jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    }
    
    NSInteger errorCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
    
    
    if (errorCode == 401)
    {
        
        if([jsonResponse[@"message"] isEqualToString:@"You have been logged out, please log in again."]){
            
//            [MBDataBaseHandler clearAllDataBase];
//
//            [MBAppInitializer moveToLoginViewController];
//
//            [APP_DELEGATE show_ErrorAlertWithTitle:@"" withMessage:jsonResponse[@"message"]];
        }
        
        return jsonResponse[@"message"];
    }
    
    if(errorCode == 0 && jsonResponse && jsonResponse[@"message"])
    {
        return [MBErrorUtility handlePredefinedErrorCode:error.code andMessage:jsonResponse[@"message"]];
    }
    else if (errorCode == 0)
    {
        return [MBErrorUtility handlePredefinedErrorCode:error.code andMessage:error.localizedDescription];
    }
    
    if (jsonResponse) {
        
//                if (errorCode==401) {
//                    [FlowManager presentLoginScreenAnimatedly:YES];
//                    return @"Your account has been accessed from different device!";
//        
//                }
//        
        
        if (![jsonResponse[@"message"] isEqualToString:@""]&&jsonResponse[@"message"]!=nil) {
            return jsonResponse[@"message"];
        }
        if (![jsonResponse[@"errors"] isEqualToString:@""]&&jsonResponse[@"errors"]!=nil) {
            return jsonResponse[@"errors"];
        }
    }
    
    return [MBErrorUtility handlePredefinedErrorCode:errorCode andMessage:@"Issue with server response. Please contact admin."];
}

void MBCall_LoginUserUsing(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_LOGIN_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
    {

        if (error)
        {
            completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
            return ;
        }
        else if(response)
        {
//            NSHTTPURLResponse *responseTask = (NSHTTPURLResponse*)task.response;
//            SAVE_USER_DEFAULTS([[responseTask allHeaderFields] valueForKey:K_ACCESSTOKEN], K_ACCESSTOKEN);
            completion(response,checkIfResponseHasErrorMessage(response),YES);

        }
    }];
}

void MBCall_RegisterUserWithPostData(NSDictionary *params,TSApiManagerCompletion completion)
{

    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_REGISTER_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
        if(!error && response)
        {
            completion(response,checkIfResponseHasErrorMessage(response),YES);
        }
        else
        {
            completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
            return ;
        }
    }];
}
void MBCall_SupplierLoginControlAPI(NSDictionary *params, TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_LOGIN_CONTROL_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if(!error && response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
         else
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
     }];
}
void MBCall_SupplierSaveLoginControlAPI(NSDictionary *params, TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_SAVE_LOGIN_CONTROL_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if(!error && response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
         else
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
     }];
}

void MBCall_AddUploadVendorImageAPI(NSDictionary *params, NSData * image_data,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTMultipartServiceForImageOnURL:getUrlForMethod(SELLER_UPLOAD_IMAGE_API) withData:image_data withParametes:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
     }];
}
void MBCall_GetSupplierInformationAPI(NSDictionary *params, TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_GET_INFORMATION_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if(!error && response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
         else
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
     }];
}
void MBCall_SaveSupplierInformationAPI(NSDictionary *params, TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_SAVE_INFORMATION_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if(!error && response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
         else
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
     }];
}
void MBCall_GetVendorMemberShipPlanListAPI(NSDictionary *params, TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_MEMBERSHIP_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if(!error && response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
         else
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
     }];
}
void MBCall_GetUpdateMembershipDetailAPI(NSDictionary *params, TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_MEMBERSHIP_UPDATE_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if(!error && response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
         else
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
     }];
}
void MBCall_GetParticularVendorMemberShipPlanAPI(NSDictionary *params, TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_VENDOR_MEMEBERSHIP_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if(!error && response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
         else
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
     }];
}

void MBCall_GetCommonSupplierDataWithVendorIDAPI(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_COMMON_DATA_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
     }];
}
void MBCall_GetStateCityAreaListAccordingtoCountryNameAPI(NSDictionary *params, NSInteger index,TSApiManagerCompletion completion)
{
    NSString *strValue = @"";
    if (index == 0)
    {
        strValue = SELLER_STATE_LIST_API;
    }
    else if (index == 1)
    {
         strValue = SELLER_CITY_LIST_API;
    }
    else if (index == 2)
    {
         strValue = SELLER_AREA_LIST_API;
    }
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(strValue) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
     }];
}

void MBCall_GetSellerUpdateCompanyDetailsWithAPI(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_UPDATE_COMPANY_DETAILS_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
     }];
}

void MBCall_GetSellerCompanyDetailsWithAPI(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_COMPANY_DETAIL_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
     }];
}

void MBCall_SaveAuthorizePersonDetailAPI(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_SAVE_AUTHORIZE_PERSON_API)
            WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
     }];
}


void MBCall_GetSupplierAgreementFileDetail(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_GET_AGREEMENT_API)
                WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
     }];
}

void MBCall_UpdateAgreementDetailSupplier(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_UPDATE_AGREEMENT_API)
        WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
     }];
}

void MBCall_GetSupplierBankDetailData(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_GET_BANK_API)
                    WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
     }];
}

void MBCall_GetSupplierUpdateBankDetailData(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SELLER_UPDATE_BANKDETAIL_API)
                        WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
     }];
}

void MBCall_UploadBankCheque(NSDictionary* params, NSData *image_data ,TSApiManagerCompletion completion)
{
//    [[MBHTTPClient sharedInstance] requestPOSTMultipartServiceOnURL:getUrlForMethod(SELLER_UPLOAD_BANKCHEQUE_API) withData:image_data withParametes:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
//     {
//         if (error)
//         {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//             return;
//         }
//         else if(response)
//         {
//             completion(response,checkIfResponseHasErrorMessage(response),YES);
//         }
//     }];
    [[MBHTTPClient sharedInstance] requestPOSTMultipartServiceForImageOnURL:getUrlForMethod(SELLER_UPLOAD_BANKCHEQUE_API) withData:image_data withParametes:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
     }];
}


void MBCall_GetDashBoardNotificationDetails(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(DASHBOARD_NOTIFICATION_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
         }
     }];
}
void MBCall_GetAuctionListUsingDashboardApi(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(AUCTION_LIST_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
             
         }
     }];
}
void MBCall_SupplierAuctionDetailAPI(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SUPPLIER_AUCTION_DETAIL_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
             
         }
     }];
}

void MBCall_SupplierAuctionAcceptanceAPI(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SUPPLIER_AUCTION_ACCEPTANCE_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return ;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
             
         }
     }];
}
void MBCall_AuctionChargesDetailAPI(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SUPPLIER_AUCTION_CHARGE_DETAIL_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
             
         }
     }];
}
void MBCall_SupplierAuctionOffLinePaymentWithCustomerIdAPI(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SUPPLIER_AUCTION_OFFLINE_PAYMENT_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
             
         }
     }];
}

void MBCall_SupplierAuctionOrderHistoryWithVendorID(NSDictionary* params,TSApiManagerCompletion completion)
{
    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(SUPPLIER_AUCTION_ORDER_HISTORY_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
     {
         if (error)
         {
             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
             return;
         }
         else if(response)
         {
             completion(response,checkIfResponseHasErrorMessage(response),YES);
             
         }
     }];
}



//void MBCall_RegisterUserWithSocailMedia(NSDictionary *params,NSData *image_data,RMApiManagerCompletion completion)
//{
//
//    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(REGISTER_WITH_SOCAIL_MEDIA) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
//     {
//         if(!error && response){
//             completion(response,checkIfResponseHasErrorMessage(response),YES);
//             // NSHTTPURLResponse *responseTask = (NSHTTPURLResponse*)task.response;
//             // SAVE_USER_DEFAULTS([[responseTask allHeaderFields] valueForKey:K_ACCESSTOKEN], K_ACCESSTOKEN);
//         }
//
//         else {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//             return ;
//         }
//
//     }];
//}
//
//void MBCall_GetAllCategories(RMApiManagerCompletion completion)
//{
//    [[MBHTTPClient sharedInstance] requestGETServiceOnURL:getUrlForMethod(CATEGORY_API_NAME) WithDictionary:nil withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response) {
//         if(error)
//         {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//         }
//        else
//        {
//            completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//        }
//         }];
//}
//void MBCall_GetTimeZoneWithCountryandBuyerInterested(NSDictionary* params,RMApiManagerCompletion completion)
//{
//    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(COMMON_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
//     {
//         if (error)
//         {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//             return ;
//         }
//         else if(response)
//         {
//             completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//         }
//     }];
//
//}
//
//void MBCall_GetStateListWithCountryName(NSDictionary* params,RMApiManagerCompletion completion)
//{
//    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(STATE_LIST_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
//     {
//         if (error)
//         {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//             return ;
//         }
//         else if(response)
//         {
//             completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//         }
//     }];
//    //
//}
//void MBCall_GetCityListWithStateName(NSDictionary* params,RMApiManagerCompletion completion)
//{
//    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(City_LIST_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
//     {
//         if (error)
//         {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//             return ;
//         }
//         else if(response)
//         {
//             completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//         }
//     }];
//    //
//}
//void MBCall_GetUpdateCompulsoryDetails(NSDictionary* params,RMApiManagerCompletion completion)
//{
//    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(UPDATE_COMPULSORY_DETAIL_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
//     {
//         if (error)
//         {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//             return ;
//         }
//         else if(response)
//         {
//             completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//         }
//     }];
//    //
//}





//void MBCall_GetCategoryListForNegotiation(RMApiManagerCompletion completion)
//{
//    [[MBHTTPClient sharedInstance] requestGETServiceOnURL:getUrlForMethod(CATEGORY_NEGOTIATION_API) WithDictionary:nil withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response) {
//        if(error)
//        {
//            completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//        }
//        else
//        {
//            completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//        }
//    }];
//}
//void MBCall_GetSuplierlistWithCategoryID(NSDictionary* params,RMApiManagerCompletion completion)
//{
//    NSString *strvalue = [NSString stringWithFormat:@"%@",[params valueForKey:@"categoryID"]];
//    NSString *strCategoryID = [NSString stringWithFormat:@"%@",[params valueForKey:@"CustomerID"]];
//
//    NSString *strParameters = [[[[SUPPLIER_LIST_API stringByAppendingString:@"/"] stringByAppendingString:strvalue] stringByAppendingString:@"/"] stringByAppendingString:strCategoryID];
//
//
//    [[MBHTTPClient sharedInstance] requestGETServiceOnURL:getUrlForMethod(strParameters) WithDictionary:nil withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response) {
//        if(error)
//        {
//            completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//        }
//        else
//        {
//            completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//        }
//    }];
//}
//
//void MBCall_AddSupplierShortlist(NSDictionary* params,RMApiManagerCompletion completion)
//{
//    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(ADD_SUPPLIER_SHORTLIST_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
//     {
//         if (error)
//         {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//             return ;
//         }
//         else if(response)
//         {
//             completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//         }
//     }];
//}
//void MBCall_RemoveSupplierShortlist(NSDictionary* params,RMApiManagerCompletion completion)
//{
//    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(REMOVE_SUPPLIER_SHORTLIST_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
//     {
//         if (error)
//         {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//             return ;
//         }
//         else if(response)
//         {
//             completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//         }
//     }];
//}
////http://api.tradologie.com/Buyer/createauction
//void MBCall_CreateNegotiationWithAuction(NSDictionary* params,RMApiManagerCompletion completion)
//{
//    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(CREATE_NEGOTIATION_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
//     {
//         if (error)
//         {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//             return;
//         }
//         else if(response)
//         {
//             completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//         }
//     }];
//}
//void MBCall_AddUpdateAuctionforNegotiation(NSDictionary* params,RMApiManagerCompletion completion)
//{
//    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(ADD_UPDATE_NEGOTIATION_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
//     {
//         if (error)
//         {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//             return;
//         }
//         else if(response)
//         {
//             completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//         }
//     }];
//}
//
//void MBCall_GetAuctionOrderHistoryWithID(NSDictionary* params,RMApiManagerCompletion completion)
//{
//    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(AUCTION_ORDER_HISTORY_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
//     {
//         if (error)
//         {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//             return;
//         }
//         else if(response)
//         {
//             completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//         }
//     }];
//}
//
//void MBCall_GetSupplierShortListedWithGroupID(NSDictionary* params,RMApiManagerCompletion completion)
//{
//    NSString *strvalue = [NSString stringWithFormat:@"%@",[params valueForKey:@"GroupID"]];
//    NSString *strCategoryID = [NSString stringWithFormat:@"%@",[params valueForKey:@"CustomerID"]];
//
//    NSString *strParameters = [[[[SUPPLIER_SHORTLIST_API stringByAppendingString:@"/"] stringByAppendingString:strvalue] stringByAppendingString:@"/"] stringByAppendingString:strCategoryID];
//
//
//    [[MBHTTPClient sharedInstance] requestGETServiceOnURL:getUrlForMethod(strParameters) WithDictionary:nil withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response) {
//        if(error)
//        {
//            completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//        }
//        else
//        {
//            completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//        }
//    }];
//}
//
//void MBCall_AuctionDetailForEditNegotiation(NSDictionary* params,RMApiManagerCompletion completion)
//{
//    [[MBHTTPClient sharedInstance] requestPOSTServiceOnURL:getUrlForMethod(AUCTION_DETAIL_FOR_EDIT_API) WithDictionary:params withCompletion:^(NSURLSessionDataTask *task, NSError *error, id response)
//     {
//         if (error)
//         {
//             completion(nil,filterErrorMessageUsingResponseRequestOperation(task, error),NO);
//             return;
//         }
//         else if(response)
//         {
//             completion(response,checkIfResponseHasErrorMessage(response),YES);
//
//         }
//     }];
//}
@end

