//
//  TVLoginControlScreen.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 10/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVLoginControlScreen : UITableViewController
{
    __weak IBOutlet UITextField * txtName;
    __weak IBOutlet UITextField * txtEmailID;
    __weak IBOutlet UITextField * txtMobile;
    __weak IBOutlet UITextField * txtPassword;
    __weak IBOutlet UITextField * txtConfirmPassword;
    __weak IBOutlet UIButton    *btnSubmit;
    __weak IBOutlet UIButton    *btnProfileUpload;
    __weak IBOutlet UIImageView    *imgProfilePic;


}
@property (nonatomic, strong) NSString *strManageAcTittle;

@end
