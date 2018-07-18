//
//  AppDelegate.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 07/06/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RootViewController.h"

typedef NS_ENUM(NSUInteger, RootController)
{
    kLoginVC,
    kMenuVC,
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+(AppDelegate *)sharedAppDelegateClass;

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) RootController rootController;
@property (nonatomic, assign) UIInterfaceOrientationMask orientation;


- (void)setRootViewController:(UIViewController *)controller;
+(void)getManageAccountScreenWithPagination:(UIStoryboard *)Mainstory withNavigation:(UINavigationController *)navigation;

@end
