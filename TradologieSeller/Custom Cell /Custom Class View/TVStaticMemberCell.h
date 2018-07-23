//
//  TVStaticMemberCell.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 18/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVStaticMemberCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *lblStaticValue;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *viewWidth;


-(void)ConfigureStaticMemberTypeCellData:(NSString *)strValue;

@end
