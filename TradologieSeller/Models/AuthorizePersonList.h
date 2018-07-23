//
//  AuthorizePersonList.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 21/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol AuthorizePersonData <NSObject>
@end

@interface AuthorizePersonList : JSONModel

@property (nonatomic,strong)NSNumber *AuthorizedPersonID;
@property (nonatomic,strong)NSString *RegistrationStatus;
@property (nonatomic,strong)NSMutableArray <AuthorizePersonData> *detail;
@property (nonatomic,strong)NSString *message;
@property (assign)BOOL success;

@end

@interface AuthorizePersonData : JSONModel

@property (nonatomic,strong)NSString *AuthorizePersonName;
@property (nonatomic,strong)NSNumber *AuthorizedPersonID;
@property (nonatomic,strong)NSString <Optional>*ContentType;
@property (nonatomic,strong)NSString *Designation;
@property (nonatomic,strong)NSString *EmailID;
@property (nonatomic,strong)NSString <Optional>*ExtType;
@property (nonatomic,strong)NSString *MobileNo;
@property (nonatomic,strong)NSNumber *VendorID;
@property (nonatomic,strong)NSNumber *Priority;
@property (nonatomic,strong)NSNumber *IsActive;

@end

