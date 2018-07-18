//
//  AppDelegate.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 07/06/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "AppDelegate.h"
#import "Constant.h"
#import "AppConstant.h"

#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <linkedin-sdk/LISDK.h>
#import <MagicalRecord/MagicalRecord.h>

#import "TVManageAccountScreen.h"
#import "MBDataBaseHandler.h"
#import "TVLoginControlScreen.h"
#import "TVCompanyDetails.h"
#import "TVSupplierDocument.h"
#import "VCMemberShipTypeScreen.h"
#import "VCAuthorizedPersonal.h"
#import "TVLegalDocumentScreen.h"
#import "TVBankDetailScreen.h"
#import "VCSellingLocation.h"
#import "VCBulkRetailScreen.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"TradologieSeller"];
    
    [GIDSignIn sharedInstance].clientID = GOOGLE_CLIENT_ID;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

/********************************************************************************************************/
#pragma mark - FACEBOOK SDK LOGIN
/********************************************************************************************************/

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([[url scheme] isEqualToString:FACEBOOK_CLIENT_ID])
    {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                    annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        return handled;
    }
    else if ([[url scheme] isEqualToString:GOOGLE_CLIENT_ID])
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    
    if ([LISDKCallbackHandler shouldHandleUrl:url])
    {
        NSLog(@"%s url=%@","app delegate application openURL called ", [url absoluteString]);
        return [LISDKCallbackHandler application:application openURL:url sourceApplication:UIApplicationOpenURLOptionsSourceApplicationKey annotation:UIApplicationOpenURLOptionsAnnotationKey];
    }
    return YES;
    
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    if ([[url scheme] isEqualToString:FACEBOOK_CLIENT_ID])
    {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                            sourceApplication:sourceApplication
                                                                   annotation:annotation];
        
        return handled;
    }
    else if ([[url scheme] isEqualToString:GOOGLE_CLIENT_ID])
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation] ;
    }
    
    if ([LISDKCallbackHandler shouldHandleUrl:url])
    {
        NSLog(@"%s url=%@","app delegate application openURL called ", [url absoluteString]);
        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return YES;
}

/***********************************************************************************************/
#pragma mark ❉===❉=== Set Root View Controller ===❉===❉
/***********************************************************************************************/

- (void)setRootViewController:(UIViewController *)controller
{
    switch (_rootController)
    {
        case kLoginVC:
        {
            [UIView transitionWithView:self.window
                              duration:0
                               options:UIViewAnimationOptionCurveEaseOut
                            animations:^{
                                self.window.rootViewController = controller;
                            }
                            completion:nil];
        }
            break;
        case kMenuVC:
        {
            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
            [UIView transitionWithView:self.window
                              duration:0.3
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                self.window.rootViewController = navigationController;
                            }
                            completion:nil];
        }
            break;
        default:
            break;
    }
}

+(AppDelegate *)sharedAppDelegateClass
{
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== Manage Account With Pagination  ===❉===❉
/******************************************************************************************************************/

+(void)getManageAccountScreenWithPagination:(UIStoryboard *)Mainstory withNavigation:(UINavigationController *)navigation
{
    THSegmentedPager *objManageAccountMenu = [Mainstory instantiateViewControllerWithIdentifier:@"THSegmentedPager"];
    objManageAccountMenu.isfromMenu = NO;

    NSMutableArray *arrMenuTittle = [[NSMutableArray alloc]initWithObjects:@"LOGIN CONTROL",@"INFORMATION",@"MEMBERSHIP TYPE",@"COMPANY DETAILS",@"DOCUMENTS",@"AUTHORIZED PERSON",@"LEGAL DOCUMENTS",@"BANK DETAILS",@"SELLING LOCATION",@"BULK RETAIL",nil];
    
    NSMutableArray *pages = [NSMutableArray new];
    
    for (NSInteger SceenNo = 0; SceenNo < [arrMenuTittle count]; SceenNo++)
    {
        switch (SceenNo)
        {
            case 0:
            {
                TVLoginControlScreen *objManageScreen = [Mainstory instantiateViewControllerWithIdentifier:@"TVLoginControlScreen"];
                objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:0]];
                [pages addObject:objManageScreen];
            }
                break;
            case 1:
            {
                TVManageAccountScreen *objManageScreen = [Mainstory instantiateViewControllerWithIdentifier:@"TVManageAccountScreen"];
                objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objManageScreen];
            }
                break;
            case 2:
            {
                VCMemberShipTypeScreen *objMemberShipType = [Mainstory instantiateViewControllerWithIdentifier:@"VCMemberShipTypeScreen"];
                objMemberShipType.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objMemberShipType];
            }
                break;
            case 3:
            {
                TVCompanyDetails *objTVCompanyDetails = [Mainstory instantiateViewControllerWithIdentifier:@"TVCompanyDetails"];
                objTVCompanyDetails.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objTVCompanyDetails];
            }
                break;
            case 4:
            {
                TVSupplierDocument *objManageScreen = [Mainstory instantiateViewControllerWithIdentifier:@"TVSupplierDocument"];
                objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objManageScreen];
            }
                break;
            case 5:
            {
                VCAuthorizedPersonal *objAuthorized = [Mainstory instantiateViewControllerWithIdentifier:@"VCAuthorizedPersonal"];
                objAuthorized.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objAuthorized];
            }
                break;
            case 6:
            {
                TVLegalDocumentScreen *objLegalDocument = [Mainstory instantiateViewControllerWithIdentifier:@"TVLegalDocumentScreen"];
                objLegalDocument.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objLegalDocument];
            }
                break;
            case 7:
            {
                TVBankDetailScreen *objBankDetail = [Mainstory instantiateViewControllerWithIdentifier:@"TVBankDetailScreen"];
                objBankDetail.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objBankDetail];
            }
                break;
            case 8:
            {
                VCSellingLocation *objVCSelling = [Mainstory instantiateViewControllerWithIdentifier:@"VCSellingLocation"];
                objVCSelling.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objVCSelling];
            }
                break;
            case 9:
            {
                VCBulkRetailScreen *objVCBulkRetail = [Mainstory instantiateViewControllerWithIdentifier:@"VCBulkRetailScreen"];
                objVCBulkRetail.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                [pages addObject:objVCBulkRetail];
            }
                break;
            default:
                break;
        }
    }
    [objManageAccountMenu setPages:pages];
    [objManageAccountMenu setSelectIndex:1];
    [navigation pushViewController:objManageAccountMenu animated:YES];
}
@end
