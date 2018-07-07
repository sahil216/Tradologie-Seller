//
//  EnquirySellerAcceptCell.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 07/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnquirySellerAcceptCellDelegate <NSObject>

- (void)textFieldValueChange:(NSString *)txtAmtValue;

@end

@interface EnquirySellerAcceptCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic)IBOutlet UITextField *txtQtyParticipate;
@property (strong, nonatomic)IBOutlet UILabel *lblAmtPaticipating;
@property (nonatomic,assign) id<EnquirySellerAcceptCellDelegate> delegate;

-(void)ConfigureNotificationListbyCellwithSectionIndex:(NSInteger)section withAmtParticipate:(NSString *)strAmtValue;

@end
