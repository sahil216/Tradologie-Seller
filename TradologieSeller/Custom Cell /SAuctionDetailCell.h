//
//  SAuctionDetailCell.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 05/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SAuctionDetailCellDelegate <NSObject>

- (void)setSelectItemViewCodeWithData:(NSIndexPath *)selectedIndex;

@end

@interface SAuctionDetailCell : UITableViewCell

@property (nonatomic,strong) NSMutableDictionary * dataDict;
@property (nonatomic,assign) id<SAuctionDetailCellDelegate> delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemSize:(CGSize)size headerArray:(NSArray*)headerArray isWithBoolValue:(NSInteger)IsfromNegotiation;
@end
