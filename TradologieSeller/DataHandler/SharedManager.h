//
//  SharedManager.h
//  OrderApp
//
//  Created by MMI IOS on 21/02/17.
//  Copyright © 2017 MMI IOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface SharedManager : NSObject <UIActionSheetDelegate>
{
    
}

@property(assign,readwrite) BOOL isLoggedIn;
@property(assign,readwrite) BOOL isNetAvailable;
@property(nonatomic,retain) NSUserDefaults *userDefaults;
@property(nonatomic,retain) NSString *deviceToken;
@property(nonatomic,retain) NSMutableArray *arrTimeZone;
@property(nonatomic,retain) NSMutableArray *arrCountry;
@property(nonatomic,retain) NSMutableArray *arrBuyerInterestedIn;
@property(nonatomic,retain) NSMutableDictionary *dicDefaultCommonData;
@property (assign) BOOL isfromLogin;

+(SharedManager *)sharedInstance;
+(void)releaseSharedManager;
+(void)ShowCameraWithTittle:(NSString *)strValue withID:(id)showID;

@end
