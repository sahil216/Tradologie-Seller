//
//  VCHomeNotifications.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 09/05/18.
//  Copyright © 2018 Chandresh Maurya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EveryPage.h"
#import "AppConstant.h"

@interface VCHomeNotifications : EveryPage <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *lblHeaaderTittle;
    __weak IBOutlet UIButton *btnContactUs;
    __weak IBOutlet UILabel *lblRequestPending;

}
@property (strong, nonatomic) IBOutlet UITableView *tbtNotify;

@end

@interface NotificationList : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblOrderCode;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderTimeLeft;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;

- (void)ConfigureNotificationListbyCellwithData:(SellerAuctionDetailData *)objSellerAuction withSectionIndex:(NSInteger)section;
@end
