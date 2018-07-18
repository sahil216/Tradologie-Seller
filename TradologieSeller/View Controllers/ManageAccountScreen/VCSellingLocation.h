//
//  VCSellingLocation.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 13/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCSellingLocation : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
}
@property (nonatomic,strong) IBOutlet UITableView *tblSellingLocation;
@property (nonatomic, strong) NSString *strManageAcTittle;


@end
