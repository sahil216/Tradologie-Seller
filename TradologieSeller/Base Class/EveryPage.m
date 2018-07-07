//
//  EveryPage.m
//  Tradologie
//
//  Created by Chandresh Maurya on 09/05/18.
//  Copyright © 2018 Chandresh Maurya. All rights reserved.
//

#import "EveryPage.h"
#import "Constant.h"
#import "SharedManager.h"
#import "MBAPIManager.h"
#import "MBDataBaseHandler.h"
#import "CommonUtility.h"
#import "VCEnquirySellerAccept.h"

@interface EveryPage ()
{

}
@end

@implementation EveryPage

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setNaviagtionStyleWithStatusbar:[UIColor whiteColor]];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)getContactDialNumber
{
    NSString *phNo = @"+911202427244";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
    {
        [CommonUtility OpenURLAccordingToUse:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    }
    else
    {
        [CommonUtility ShowAlertwithTittle:@"Call facility is not available!!!" withID:self];
    }
}

/******************************************************************************************************************/
#pragma mark ❉===❉===  GET AUCTION NEGOTIATION LIST API CALLED HERE ===❉===❉
/******************************************************************************************************************/
-(void)GetSupplierAuctionDetailAPI:(NSString *)strValue WithBoolValue:(NSInteger)isfromCharge
                  withIsScreenFrom:(NSInteger)isScreenFrom
{
    SellerUserDetail *objSellerUser = [MBDataBaseHandler getSellerUserDetailData];
    
    NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
    [dicParams setObject:objSellerUser.detail.APIVerificationCode forKey:@"Token"];
    [dicParams setObject:objSellerUser.detail.VendorID forKey:@"VendorID"];
    [dicParams setObject:strValue forKey:@"AuctionCode"];
    
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait.."];
        
        MBCall_SupplierAuctionDetailAPI(dicParams, ^(id response, NSString *error, BOOL status)
        {
            [CommonUtility HideProgress];
            
            if (status && [[response valueForKey:@"success"]isEqual:@1])
            {
                if (response != (NSDictionary *)[NSNull null])
                {
                    NSError *Error;
                    SellerAuctionDetail *objAuctionDetail = [[SellerAuctionDetail alloc]initWithDictionary:[response valueForKey:@"detail"] error:&Error];
                    [MBDataBaseHandler saveSellerAuctionDetailData:objAuctionDetail];
                    
                    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
                    VCEnquirySellerAccept *objSellerAccept = [self.storyboard instantiateViewControllerWithIdentifier:@"VCEnquirySellerAccept"];
                    objSellerAccept.isfromChargeAccount = isfromCharge;
                    objSellerAccept.isScreenFrom = isScreenFrom;
                    [self.navigationController pushViewController:objSellerAccept animated:YES];
                    
                }
                else{
                    [CommonUtility HideProgress];
                }
            }
            else
            {
                [CommonUtility HideProgress];
                
            }
        });
    }
    else
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
    }
}
@end
