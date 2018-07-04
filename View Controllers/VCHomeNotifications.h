//
//  VCHomeNotifications.h
//  Tradologie
//
//  Created by Chandresh Maurya on 09/05/18.
//  Copyright © 2018 Chandresh Maurya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EveryPage.h"

@interface VCHomeNotifications : EveryPage<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *lblHeaaderTittle;
    UIView *viewHeader;
    __weak IBOutlet UIButton *btnContactUs;
    __weak IBOutlet UILabel *lblRequestPending;

}
@property (strong, nonatomic) IBOutlet UITableView *tbtNotify;

@end

@interface NotificationList : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblNotifyName;

- (void)ConfigureNotificationListbyCellwithData:(NSString *)strValue;
@end
