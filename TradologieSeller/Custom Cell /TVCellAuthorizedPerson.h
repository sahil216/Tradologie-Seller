//
//  TVCellAuthorizedPerson.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 12/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVCellAuthorizedPerson : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *lblTittle;
@property (nonatomic,strong) IBOutlet UITextField *txtInfoField;
@property (nonatomic,strong) IBOutlet UIButton *btnUploadFile;
@property (nonatomic,strong) IBOutlet UISwitch *switchEnable;
@property (nonatomic,strong) IBOutlet UIButton *btnSubmitAuthorized;
@property (nonatomic,strong) IBOutlet UILabel *lblSrNo;
@property (nonatomic,strong) IBOutlet UILabel *lblAuthorizeName;
@property (nonatomic,strong) IBOutlet UILabel *lblDesignation;


- (void)ConfigureAuthorizedPersonInfoCellwithData:(NSString *)strTittle withPlaceholder:(NSString *)strPlaceHolder;
- (void)ConfigureUploadPersonInfoPicCellwithSectionIndex:(NSInteger)index;
- (void)ConfigureListAuthenticatePersonInfoCell:(NSInteger)Count withData:(id)authenticateData;

@end
