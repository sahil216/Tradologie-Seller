//
//  DashBoardNotification.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 09/06/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "DashBoardNotification.h"

@implementation DashBoardNotification
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation DashBoardNotificationDetail

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}


@end
/************************ SellerUserDetailData *********************************************/
@implementation SellerAuctionDetailData

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
