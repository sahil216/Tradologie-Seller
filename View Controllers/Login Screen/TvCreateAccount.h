//
//  TvCreateAccount.h
//  Tradologie
//
//  Created by Chandresh Maurya on 05/05/18.
//  Copyright © 2018 Chandresh Maurya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TvCreateAccount : UITableViewController
{
    __weak IBOutlet UITextField * txtName;
    __weak IBOutlet UITextField * txtEmailID;
    __weak IBOutlet UITextField * txtMobile;
    __weak IBOutlet UITextField * txtPassword;
    __weak IBOutlet UITextField * txtConfirmPassword;
    __weak IBOutlet UIButton    *btnback;
    __weak IBOutlet UIButton    *btnAgreeTerms;
    __weak IBOutlet UIButton    *btnSubmit;
    __weak IBOutlet UILabel     *lbl_logoname;
    __weak IBOutlet UILabel     *lblNewUser;


}

@property(nonatomic,weak)IBOutlet UIView * viewHeader;

@end
