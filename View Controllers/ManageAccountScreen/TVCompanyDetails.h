//
//  TVCompanyDetails.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 11/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVCompanyDetails : UITableViewController
{
    __weak IBOutlet UITextField * txtCompanyName;
    __weak IBOutlet UITextField * txtBrandName;
    __weak IBOutlet UITextField * txtCompanyPAN;
    __weak IBOutlet UITextField * txtGSTIN;
    __weak IBOutlet UITextField * txtCompanyType;
    __weak IBOutlet UITextField * txtIncorporateDate;
    __weak IBOutlet UITextField * txtTimeZone;
    __weak IBOutlet UITextField * txtCountry;
    __weak IBOutlet UITextField * txtCountryOther;
    __weak IBOutlet UITextField * txtCountryISD;
    __weak IBOutlet UITextField * txtState;
    __weak IBOutlet UITextField * txtStateOthers;
    __weak IBOutlet UITextField * txtCity;
    __weak IBOutlet UITextField * txtCityOthers;
    __weak IBOutlet UITextField * txtCitySTD;
    __weak IBOutlet UITextField * txtArea;
    __weak IBOutlet UITextField * txtAreaOthers;
    __weak IBOutlet UITextField * txtAddress;
    __weak IBOutlet UITextField * txtZipCode;

    __weak IBOutlet UIButton    *btnSubmit;

}
@property (nonatomic, strong) NSString *strManageAcTittle;


@end
