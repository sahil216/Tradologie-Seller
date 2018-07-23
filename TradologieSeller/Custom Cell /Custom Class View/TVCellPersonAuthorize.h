//
//  TVCellPersonAuthorize.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 20/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TVCellAuthorizedPersonDelegate <NSObject>

- (void)saveAuthorizePersonDetail:(BOOL)isEnable;

@end
@interface TVCellPersonAuthorize : UITableViewCell

@property (nonatomic,strong) IBOutlet UIButton *btnUploadFile;
@property (nonatomic,strong) IBOutlet UISwitch *switchEnable;
@property (nonatomic,strong) IBOutlet UIButton *btnSubmitAuthorized;
@property (nonatomic,assign) id<TVCellAuthorizedPersonDelegate> delegate;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *btnWidth;

- (void)ConfigureUploadPersonInfoPicCellwithSectionIndex:(NSInteger)index;

@end
