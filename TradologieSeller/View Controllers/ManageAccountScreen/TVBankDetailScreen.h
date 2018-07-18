//
//  TVBankDetailScreen.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 13/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVBankDetailScreen : UITableViewController
{
    __weak IBOutlet UITextField * txtAccountName;
    __weak IBOutlet UITextField * txtAccountNumber;
    __weak IBOutlet UITextField * txtBankName;
    __weak IBOutlet UITextField * txtBranch;
    __weak IBOutlet UITextField * txtIFSCCode;
    __weak IBOutlet UIButton    *btnSubmit;
    __weak IBOutlet UIButton    *btnUploadCheck;
    __weak IBOutlet UIImageView    *imgProfilePic;
    
    
}
@property (nonatomic, strong) NSString *strManageAcTittle;

@end
