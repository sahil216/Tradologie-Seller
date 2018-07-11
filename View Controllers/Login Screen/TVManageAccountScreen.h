//
//  TVManageAccountScreen.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 11/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVManageAccountScreen : UITableViewController
{
    __weak IBOutlet UITextField * txtVendorName;
    __weak IBOutlet UILabel * lblVendorCode;
    __weak IBOutlet UITextField * txtAnnualTurnOver;
    __weak IBOutlet UITextField * txtYearOfEstablish;
    __weak IBOutlet UITextField * txtCertifications;
    __weak IBOutlet UITextField * txtAreaOfOperation;
    __weak IBOutlet UITextField * txtDescriptions;
    __weak IBOutlet UISwitch    *btnManufacturer;
    __weak IBOutlet UISwitch    *btnTrader;
    __weak IBOutlet UIButton    *btnSubmit;
    __weak IBOutlet UIButton    *btnVendorUpload;
    __weak IBOutlet UIButton    *btnEBrochure;
    __weak IBOutlet UIImageView    *imgVenderLogo;
    __weak IBOutlet UIImageView    *imgBrochure;

    
}
@property (nonatomic, strong) NSString *strManageAcTittle;

@end
