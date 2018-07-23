//
//  TVCellAuthorizePerson.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 20/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVCellAuthorizePerson : UITableViewCell
{
    NSMutableDictionary *dicValue;
}
@property (nonatomic,strong) IBOutlet UILabel *lblTittle;
@property (nonatomic,strong) IBOutlet UITextField *txtInfoField;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *viewWidth;


- (void)ConfigureAuthorizedPersonInfoCellwithData:(NSString *)strTittle withPlaceholder:(NSString *)strPlaceHolder withIndex: (NSIndexPath *)index;

@end
