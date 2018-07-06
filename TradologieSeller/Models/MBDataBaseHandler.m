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

+(SellerUserDetail *)getSellerUserDetailData;
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
         newUser.objId = sellerData.detail.VendorID;
         newUser.objType = [NSNumber numberWithInt:sellerUserDetail];
         newUser.objClass = NSStringFromClass([sellerData class]);
         
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
