//
//  SharedManager.m
//  OrderApp
//
//  Created by MMI IOS on 21/02/17.
//  Copyright © 2017 MMI IOS. All rights reserved.
//

#import "SharedManager.h"

static SharedManager *sharedManager;

@implementation SharedManager

@synthesize isNetAvailable = _isNetAvailable;
@synthesize isLoggedIn=_isLoggedIn;
@synthesize userDefaults =_userDefaults;
@synthesize deviceToken;

+(SharedManager *)sharedInstance
{
    if(sharedManager == nil)
    {
        sharedManager = [[SharedManager alloc] init];
        
        sharedManager.userDefaults = [NSUserDefaults standardUserDefaults];
        Reachability *_reachability = [Reachability reachabilityForInternetConnection];
        [_reachability startNotifier];
        
        NetworkStatus internetStatus = [_reachability currentReachabilityStatus];
        if(internetStatus == NotReachable)
        {
            NSLog(@"Internet Disconnected");
            sharedManager.isNetAvailable = NO;  // Internet not Connected
        }
        else if (internetStatus == ReachableViaWiFi)
        {
            NSLog(@"Connected via WIFI");
            sharedManager.isNetAvailable = YES; // Connected via WIFI
        }
        else if (internetStatus == ReachableViaWWAN)
        {
            NSLog(@"Connected via WWAN");
            sharedManager.isNetAvailable = YES; // Connected via WWAN
        }
//        [_reachability setReachableBlock:^(Reachability *reach){
//
//            NSLog(@"Network available");
//            sharedManager.isNetAvailable = YES; // Connected via WIFI
//
//        }];
//
//        [_reachability setUnreachableBlock:^(Reachability *reach){
//
//            NSLog(@"Network unavailable");
//            sharedManager.isNetAvailable = NO;  // Internet not Connected
//
//        }];
        
        sharedManager.isLoggedIn = NO;
        if (sharedManager.deviceToken.length <= 0)
        {
            sharedManager.deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
        }
        sharedManager.dicDefaultCommonData =[[NSMutableDictionary alloc]init];
        sharedManager.arrTimeZone =[[NSMutableArray alloc]init];
        sharedManager.arrCountry =[[NSMutableArray alloc]init];
        sharedManager.arrBuyerInterestedIn =[[NSMutableArray alloc]init];

    }
   
    return sharedManager;
}
+(void)ShowCameraWithTittle:(NSString *)strValue withID:(id)showID
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:strValue message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                            {
                                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                {
                                    UIImagePickerController *pickerView =[[UIImagePickerController alloc]init];
                                    pickerView.allowsEditing = YES;
                                    pickerView.delegate = showID;
                                    pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
                                    [showID presentViewController:pickerView animated:YES completion:nil];
                                }
                                else
                                {
                                    
                                }
                            }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = showID;
        [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [showID presentViewController:pickerView animated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [showID dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [showID presentViewController:actionSheet animated:YES completion:nil];
    });
}

//============================================================================================================
#pragma mark - Release SharedManager
//============================================================================================================
+(void)releaseSharedManager
{
    sharedManager = nil;
}



@end
