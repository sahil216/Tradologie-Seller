//
//  TVSupplierDocument.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 12/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVSupplierDocument : UITableViewController
{
    __weak IBOutlet UITextView * txtViewRC;
    __weak IBOutlet UITextView * txtViewRP;
    __weak IBOutlet UITextView * txtViewPC;
    __weak IBOutlet UITextView * txtViewMOA;

    __weak IBOutlet UIButton * btnSaveRC;
    __weak IBOutlet UIButton * btnSaveRP;
    __weak IBOutlet UIButton * btnSavePC;
    __weak IBOutlet UIButton * btnSaveMOA;
    
    __weak IBOutlet UIButton * btnUploadRC;
    __weak IBOutlet UIButton * btnUploadRP;
    __weak IBOutlet UIButton * btnUploadPC;
    __weak IBOutlet UIButton * btnUploadMOA;
    
    __weak IBOutlet UIView * ViewBGRC;
    __weak IBOutlet UIView * ViewBGRP;
    __weak IBOutlet UIView * ViewBGPC;
    __weak IBOutlet UIView * ViewBGMOA;
}
@property (nonatomic, strong) NSString *strManageAcTittle;

@end
