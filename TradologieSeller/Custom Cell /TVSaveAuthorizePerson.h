//
//  TVSaveAuthorizePerson.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 20/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TVCellSavePersonDelegate <NSObject>

- (void)setAuthorizePersionDetailWithData:(UIButton *)sender withIndex:(NSIndexPath *)index withEdit:(NSInteger )Isslected;

@end



@interface TVSaveAuthorizePerson : UITableViewCell

@property (nonatomic,strong) NSMutableDictionary * dataDict;
@property (nonatomic,assign) id<TVCellSavePersonDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemSize:(CGSize)size headerArray:(NSArray*)headerArray;

@end
