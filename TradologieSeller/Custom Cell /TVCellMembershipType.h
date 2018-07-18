//
//  TVCellMembershipType.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 18/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVCellMembershipType : UITableViewCell

@property (nonatomic,strong) NSMutableDictionary * dataDict;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemSize:(CGSize)size headerArray:(NSArray*)headerArray;
@end
