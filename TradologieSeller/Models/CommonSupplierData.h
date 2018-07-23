//
//  CommonSupplierData.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 19/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@class DaylightTransStart;

@protocol VendorCompanyType <NSObject>
@end
@protocol VendorTimeZone <NSObject>
@end
@protocol VendorCountryList <NSObject>
@end
@protocol VendorAdjustmentRules <NSObject>
@end

@protocol  DaylightTransStart <NSObject>
@end

@interface CommonSupplierData : JSONModel

@property (nonatomic,strong)NSMutableArray <VendorCompanyType> *CompanyType;
@property (nonatomic,strong)NSMutableArray <VendorTimeZone> *TimeZone;
@property (nonatomic,strong)NSMutableArray <VendorCountryList> *Country;
@property (nonatomic,strong)NSString <Optional>*RegistrationStatus;
@property (nonatomic,strong)NSString *message;

@end

@interface VendorCompanyType : JSONModel
@property (nonatomic,strong)NSNumber *CompanyTypeID;
@property (nonatomic,strong)NSString *CompanyType;


@end

@interface VendorTimeZone : JSONModel

@property (nonatomic,strong)NSString *Id;
@property (nonatomic,strong)NSString *DisplayName;
@property (nonatomic,strong)NSString *StandardName;
@property (nonatomic,strong)NSString *DaylightName;
@property (nonatomic,strong)NSString *BaseUtcOffset;
@property (nonatomic,strong)NSMutableArray <VendorAdjustmentRules> *AdjustmentRules;
@property (assign)BOOL SupportsDaylightSavingTime;

@end

@interface VendorCountryList : JSONModel
@property (nonatomic,strong)NSNumber *CountryID;
@property (nonatomic,strong)NSString *CountryName;
@end

@interface VendorAdjustmentRules : JSONModel
@property (nonatomic,strong)NSString *DateStart;
@property (nonatomic,strong)NSString *DateEnd;
@property (nonatomic,strong)NSString *DaylightDelta;
@property (nonatomic,strong)DaylightTransStart *DaylightTransitionStart;
@property (nonatomic,strong)NSString *BaseUtcOffsetDelta;


@end

@interface DaylightTransStart : JSONModel

@property (nonatomic,strong)NSString *TimeOfDay;
@property (nonatomic,strong)NSNumber *Month;
@property (nonatomic,strong)NSNumber *Week;
@property (nonatomic,strong)NSNumber *Day;
@property (nonatomic,strong)NSNumber *DayOfWeek;

@property (assign)BOOL IsFixedDateRule;

@end
