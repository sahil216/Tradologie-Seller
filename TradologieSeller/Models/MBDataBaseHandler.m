//
//  MBDataBaseHandler.m
//  Florists
//
//  Created by Anil Khanna on 14/02/15.
//  Copyright (c) 2015 Anil Khanna. All rights reserved.
//

#import "MBDataBaseHandler.h"

@implementation MBDataBaseHandler

/*********************************************************************************************/
#pragma mark ❉===❉=== GETTER METHOD TO GET VALUE FROM DATABASE ❉===❉===
/*********************************************************************************************/

+(SellerUserDetail *)getSellerUserDetailData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objType == %@)",[NSNumber numberWithInt:sellerUserDetail]];
    
    NSArray *array = [OfflineObject MR_findAllWithPredicate:predicate];
    
    if (array.count>0)
    {
        OfflineObject *object = array[0];
        SellerUserDetail *objSellerUser = [[SellerUserDetail alloc] initWithString:object.objData error:nil];
        return objSellerUser;
    }
    return nil;
}
+(SellerLoginControl *)getSellerLoginControl
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objType == %@)",[NSNumber numberWithInt:sellerLC]];
    
    NSArray *array = [OfflineObject MR_findAllWithPredicate:predicate];
    
    if (array.count>0)
    {
        OfflineObject *object = array[0];
        SellerLoginControl *objSellerLogin = [[SellerLoginControl alloc] initWithString:object.objData error:nil];
        return objSellerLogin;
    }
    return nil;
}
+(SellerGetInformation *)getSellerGetInformationData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objType == %@)",[NSNumber numberWithInt:sellerInfo]];
    
    NSArray *array = [OfflineObject MR_findAllWithPredicate:predicate];
    
    if (array.count>0)
    {
        OfflineObject *object = array[0];
        SellerGetInformation *objSellerGetInfo = [[SellerGetInformation alloc] initWithString:object.objData error:nil];
        return objSellerGetInfo;
    }
    return nil;
}

+(DashBoardNotification *)getDashBoardNotificationData;
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objType == %@)",[NSNumber numberWithInt:dashBoardNotification]];
    
    NSArray *array = [OfflineObject MR_findAllWithPredicate:predicate];
    
    if (array.count>0)
    {
        OfflineObject *object = array[0];
        DashBoardNotification *objSellerUser = [[DashBoardNotification alloc] initWithString:object.objData error:nil];
        return objSellerUser;
    }
    
    return nil;
}
+(SellerAuctionList *)getSellerAuctionList;
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objType == %@)",[NSNumber numberWithInt:sellerAuctionlist]];
    
    NSArray *array = [OfflineObject MR_findAllWithPredicate:predicate];
    
    if (array.count>0)
    {
        OfflineObject *object = array[0];
        SellerAuctionList *objSellerAuctionList = [[SellerAuctionList alloc] initWithString:object.objData error:nil];
        return objSellerAuctionList;
    }
    
    return nil;
}
+(SellerAuctionDetail *)getSellerAuctionDetailData;
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objType == %@)",[NSNumber numberWithInt:SAdetail]];
    
    NSArray *array = [OfflineObject MR_findAllWithPredicate:predicate];
    
    if (array.count>0)
    {
        OfflineObject *object = array[0];
        SellerAuctionDetail *objSellerAuctionDetail = [[SellerAuctionDetail alloc] initWithString:object.objData error:nil];
        return objSellerAuctionDetail;
    }
    
    return nil;
}
+(SellerAuctionOrderHistory *)getSellerAuctionOrderHistoryData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objType == %@)",[NSNumber numberWithInt:auctionOrderHistory]];
    
    NSArray *array = [OfflineObject MR_findAllWithPredicate:predicate];
    
    if (array.count>0)
    {
        OfflineObject *object = array[0];
        SellerAuctionOrderHistory *objSellerOrderHistory = [[SellerAuctionOrderHistory alloc] initWithString:object.objData error:nil];
        return objSellerOrderHistory;
    }
    
    return nil;
}
+(CommonSupplierData *)getCommonSupplierData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objType == %@)",[NSNumber numberWithInt:Commonddl]];
    
    NSArray *array = [OfflineObject MR_findAllWithPredicate:predicate];
    
    if (array.count>0)
    {
        OfflineObject *object = array[0];
        CommonSupplierData *objCommonSupplierData = [[CommonSupplierData alloc] initWithString:object.objData error:nil];
        return objCommonSupplierData;
    }
    return nil;
}

+(AuthorizePersonList *)getAuthorizePersonListWithData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objType == %@)",[NSNumber numberWithInt:authorizePerson]];
    
    NSArray *array = [OfflineObject MR_findAllWithPredicate:predicate];
    
    if (array.count>0)
    {
        OfflineObject *object = array[0];
        AuthorizePersonList *objAuthorizelist = [[AuthorizePersonList alloc] initWithString:object.objData error:nil];
        return objAuthorizelist;
    }
    return nil;

}
+(SellerBankDetailData *)getSellerBankDetailData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objType == %@)",[NSNumber numberWithInt:sellerBankDetail]];
    
    NSArray *array = [OfflineObject MR_findAllWithPredicate:predicate];
    
    if (array.count>0)
    {
        OfflineObject *object = array[0];
        SellerBankDetailData *objBankDetail = [[SellerBankDetailData alloc] initWithString:object.objData error:nil];
        return objBankDetail;
    }
    return nil;
    
}


/*********************************************************************************************/
#pragma mark ❉===❉=== SETTER METHOD TO SET VALUE IN DATABASE ❉===❉===
/*********************************************************************************************/


+(void)saveDashBoradAuctionDataDetail:(DashBoardNotification *)dashBoardData;
{
    [self deleteAllRecordsForType:dashBoardNotification];

    if (!dashBoardData)
    {
        return;
    }

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext)
     {
         OfflineObject *newUser = [OfflineObject MR_createEntityInContext:localContext];
         newUser.objData = dashBoardData.toJSONString;
         newUser.objType = [NSNumber numberWithInt:dashBoardNotification];
         newUser.objClass = NSStringFromClass([dashBoardData class]);
     }];
}
+(void)saveSellerUserDetailData:(SellerUserDetail *)sellerData;
{
    [self deleteAllRecordsForType:sellerUserDetail];
    
    if (!sellerData) {
        return;
    }
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext)
     {
         OfflineObject *newUser = [OfflineObject MR_createEntityInContext:localContext];
         newUser.objData = sellerData.toJSONString;
         newUser.objId = sellerData.VendorID;
         newUser.objType = [NSNumber numberWithInt:sellerUserDetail];
         newUser.objClass = NSStringFromClass([sellerData class]);
         
     }];
}
+(void)saveSellerLoginControlData:(SellerLoginControl *)sellerLoginControl
{
    [self deleteAllRecordsForType:sellerLC];
    
    if (!sellerLoginControl)
    {
        return;
    }
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext)
     {
         OfflineObject *newUser = [OfflineObject MR_createEntityInContext:localContext];
         newUser.objData = sellerLoginControl.toJSONString;
         newUser.objId = sellerLoginControl.VendorID;
         newUser.objType = [NSNumber numberWithInt:sellerLC];
         newUser.objClass = NSStringFromClass([sellerLoginControl class]);
     }];
}
+(void)saveSellerGetInformationData:(SellerGetInformation *)sellerGetInfo
{
    [self deleteAllRecordsForType:sellerInfo];
    
    if (!sellerGetInfo)
    {
        return;
    }
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext)
     {
         OfflineObject *newUser = [OfflineObject MR_createEntityInContext:localContext];
         newUser.objData = sellerGetInfo.toJSONString;
         newUser.objId = sellerGetInfo.VendorID;
         newUser.objType = [NSNumber numberWithInt:sellerInfo];
         newUser.objClass = NSStringFromClass([sellerGetInfo class]);
     }];
}
+(void)saveSellerAuctionListData:(SellerAuctionList *)AuctionListData
{
    [self deleteAllRecordsForType:sellerAuctionlist];
    
    if (!AuctionListData)
    {
        return;
    }
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext)
     {
         OfflineObject *newUser = [OfflineObject MR_createEntityInContext:localContext];
         newUser.objData = AuctionListData.toJSONString;
         newUser.objType = [NSNumber numberWithInt:sellerAuctionlist];
         newUser.objClass = NSStringFromClass([AuctionListData class]);
         
     }];
}
+(void)saveSellerAuctionDetailData:(SellerAuctionDetail *)objSellerAuctionDetail
{
    [self deleteAllRecordsForType:SAdetail];
    
    if (!objSellerAuctionDetail)
    {
        return;
    }
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext)
     {
         OfflineObject *newUser = [OfflineObject MR_createEntityInContext:localContext];
         newUser.objData = objSellerAuctionDetail.toJSONString;
         newUser.objId = objSellerAuctionDetail.AuctionID;
         newUser.objType = [NSNumber numberWithInt:SAdetail];
         newUser.objClass = NSStringFromClass([objSellerAuctionDetail class]);
         
     }];
}
+(void)saveSellerAuctionOrderHistoryData:(SellerAuctionOrderHistory *)objOrderHistory
{
    [self deleteAllRecordsForType:auctionOrderHistory];
    
    if (!objOrderHistory)
    {
        return;
    }
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext)
     {
         OfflineObject *newUser = [OfflineObject MR_createEntityInContext:localContext];
         newUser.objData = objOrderHistory.toJSONString;
         newUser.objType = [NSNumber numberWithInt:auctionOrderHistory];
         newUser.objClass = NSStringFromClass([objOrderHistory class]);
     }];
}
+(void)saveAuthorizePersonListData:(AuthorizePersonList *)authorizePersonList
{
    [self deleteAllRecordsForType:authorizePerson];
    
    if (!authorizePersonList)
    {
        return;
    }
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext)
     {
         OfflineObject *newUser = [OfflineObject MR_createEntityInContext:localContext];
         newUser.objData = authorizePersonList.toJSONString;
         newUser.objId = authorizePersonList.AuthorizedPersonID;
         newUser.objType = [NSNumber numberWithInt:authorizePerson];
         newUser.objClass = NSStringFromClass([authorizePersonList class]);
     }];
}
+(void)saveSellerBankDetailWithData:(SellerBankDetailData *)bankDetail
{
    [self deleteAllRecordsForType:sellerBankDetail];
    
    if (!bankDetail)
    {
        return;
    }
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext)
     {
         OfflineObject *newUser = [OfflineObject MR_createEntityInContext:localContext];
         newUser.objData = bankDetail.toJSONString;
         newUser.objId = bankDetail.VendorID;
         newUser.objType = [NSNumber numberWithInt:sellerBankDetail];
         newUser.objClass = NSStringFromClass([bankDetail class]);
     }];
    
}
+(void)saveSellerCommonSupplierData:(CommonSupplierData *)commonSupplier
{
    [self deleteAllRecordsForType:Commonddl];
    
    if (!commonSupplier)
    {
        return;
    }
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext)
     {
         OfflineObject *newUser = [OfflineObject MR_createEntityInContext:localContext];
         newUser.objData = commonSupplier.toJSONString;
         newUser.objType = [NSNumber numberWithInt:Commonddl];
         newUser.objClass = NSStringFromClass([commonSupplier class]);
     }];
}


/*********************************************************************************************/
#pragma mark ❉===❉=== DELETE ALL RECORD"S FROM DATABASE ❉===❉===
/*********************************************************************************************/

+ (void) deleteAllRecordsForType:(OFFLINEMODE)type{
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objType == %@)",[NSNumber numberWithInt:type]];
        [OfflineObject MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    }];
    
}


+(void)clearAllDataBase
{
    [OfflineObject MR_truncateAll];

}
@end
