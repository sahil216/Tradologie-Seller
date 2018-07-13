//
//  TVCellSellingLocation.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 13/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TVCellSellingLocationDelegate <NSObject>

- (void)setSelectItemViewWithData:(UIButton *)sender withIndex:(NSIndexPath *)index;

@end

@interface TVCellSellingLocation : UITableViewCell


@property (nonatomic,strong) IBOutlet UILabel *lblLocationTittle;
@property (nonatomic,strong) IBOutlet UITextField *txtLocations;
@property (nonatomic,strong) IBOutlet UIButton *btnSubmitLocation;
@property (nonatomic,assign) id<TVCellSellingLocationDelegate> delegate;

@property (nonatomic,strong) IBOutlet UILabel *lblSrNo;
@property (nonatomic,strong) IBOutlet UILabel *lblStateName;
@property (nonatomic,strong) IBOutlet UILabel *lblCityName;
@property (nonatomic,strong) IBOutlet UIButton *btnisActive;
@property (nonatomic,strong) IBOutlet UIButton *btnDeleteRecord;


- (void)ConfigureSellingLocationInfoCellData:(NSString *)strTittle withPlaceholder:(NSString *)strPlaceHolder;

@end
