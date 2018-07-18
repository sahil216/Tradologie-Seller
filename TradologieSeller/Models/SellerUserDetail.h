//
//  SellerUserDetail.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 08/06/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface SellerUserDetail : JSONModel

@property (nonatomic,strong)NSString *APIVerificationCode;
@property (nonatomic,strong)NSString *ImageExist;
@property (nonatomic,strong)NSString *RegistrationStatus;
@property (nonatomic,strong)NSString <Optional>*SellerTimeZone;
@property (nonatomic,strong)NSString *UserID;
@property (nonatomic,strong)NSNumber *VendorID;
@property (nonatomic,strong)NSString *VendorName;

@end

