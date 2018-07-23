//
//  TVCellMemberShipPlan.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 18/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TVCellMemberShipPlanDelegate <NSObject>

- (void)selectMemberShipPlan:(UIButton *)sender withIndex:(NSIndexPath *)index;
- (void)btnSubmitPlanTapped:(UIButton *)sender;

@end

@interface TVCellMemberShipPlan : UITableViewCell

@property (nonatomic,strong) IBOutlet UITextField *txtMemberType;
@property (nonatomic,strong) IBOutlet UILabel *lblMemberAmount;
@property (nonatomic,strong) IBOutlet UIView *viewBG;
@property (nonatomic,assign) id<TVCellMemberShipPlanDelegate> delegate;
@property (nonatomic,strong) IBOutlet UIButton *btnSubmitPlan;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *viewWidth;

@end
