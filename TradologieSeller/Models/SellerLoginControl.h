//
//  SellerLoginControl.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 14/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol SellerGetInformation <NSObject>
@end

@protocol SellerBankDetailData <NSObject>
@end

@interface SellerLoginControl : JSONModel

@property (nonatomic,strong)NSNumber *VendorID;
@property (nonatomic,strong)NSString *VendorName;
@property (nonatomic,strong)NSString <Optional>*Email;
@property (nonatomic,strong)NSString *UserID;
@property (nonatomic,strong)NSString *Password;
@property (nonatomic,strong)NSString <Optional>*VendorImage;
@property (nonatomic,strong)NSString <Optional>*MobileNo;
@property (nonatomic,strong)NSString *FileType;
@property (nonatomic,strong)NSString *RegistrationStatus;

@end

@interface SellerGetInformation : JSONModel

@property (nonatomic,strong)NSString <Optional>*AnnualTurnOver;
@property (nonatomic,strong)NSString <Optional>*AreaOfOperation;
@property (nonatomic,strong)NSString <Optional>*Certifications;
@property (nonatomic,strong)NSString <Optional>*IsActive;
@property (nonatomic,strong)NSString *VendorCode;
@property (nonatomic,strong)NSString <Optional>*VendorDescription;
@property (nonatomic,strong)NSString <Optional>*VendorDocument;
@property (nonatomic,strong)NSString <Optional>*VendorDocumentExt;
@property (nonatomic,strong)NSString <Optional>*VendorDocumentUrl;
@property (nonatomic,strong)NSNumber *VendorID;
@property (nonatomic,strong)NSString <Optional>*VendorName;
@property (nonatomic,strong)NSString <Optional>*YearOfEstablishment;
@property (nonatomic,strong)NSString *RegistrationStatus;

@end

@interface SellerBankDetailData : JSONModel

@property (nonatomic,strong)NSString *RegistrationStatus;
@property (nonatomic,strong)NSString <Optional>*AccountName;
@property (nonatomic,strong)NSString <Optional>*AccountNo;
@property (nonatomic,strong)NSString <Optional>*BankDocument;
@property (nonatomic,strong)NSString <Optional>*BankName;
@property (nonatomic,strong)NSString <Optional>*Branch;
@property (nonatomic,strong)NSString <Optional>*ContentType;
@property (nonatomic,strong)NSString <Optional>*DocUrl;
@property (nonatomic,strong)NSString <Optional>*ExtType;
@property (nonatomic,strong)NSString <Optional>*IFSCCode;
@property (nonatomic,strong)NSNumber *VendorID;
@property (nonatomic,strong)NSString <Optional>*VendorName;

@end
