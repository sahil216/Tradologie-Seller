//
//  TVLegalDocumentScreen.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 13/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVLegalDocumentScreen : UITableViewController
{
    __weak IBOutlet UIButton * btnUploadSellerDoc;
    __weak IBOutlet UIButton * btnloadSellerDoc;
    __weak IBOutlet UIButton * btnloadPrivacy;
    __weak IBOutlet UIButton * btnAcceptSeller;
    __weak IBOutlet UIButton * btnAcceptPrivacy;
    __weak IBOutlet UIButton * btnSaveDoc;

}



@property (nonatomic, strong) NSString *strManageAcTittle;

@end
