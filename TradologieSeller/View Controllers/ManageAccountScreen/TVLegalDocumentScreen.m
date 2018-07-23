//
//  TVLegalDocumentScreen.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 13/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVLegalDocumentScreen.h"
#import "Constant.h"
#import "AppConstant.h"
#import "CommonUtility.h"
#import "MBAPIManager.h"
#import "MBDataBaseHandler.h"
#import "SharedManager.h"
#import "MBHTTPClient.h"

@interface TVLegalDocumentScreen ()<THSegmentedPageViewControllerDelegate>
{
    NSMutableDictionary *dicDocuments;
    NSNumber *isActive;
}
@end

@implementation TVLegalDocumentScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [btnSaveDoc setDefaultButtonStyle];
    [btnSaveDoc.titleLabel setFont:IS_IPHONE5? UI_DEFAULT_FONT_BOLD(12):UI_DEFAULT_FONT_BOLD(20)];
    [btnSaveDoc addTarget:self action:@selector(bntSaveDocumentDetailTapped:) forControlEvents:UIControlEventTouchUpInside];

    [btnUploadSellerDoc setDefaultButtonStyle];
    [btnUploadSellerDoc.titleLabel setFont:IS_IPHONE5? UI_DEFAULT_FONT_BOLD(12):UI_DEFAULT_FONT_BOLD(18)];
    [btnloadSellerDoc addTarget:self action:@selector(downloadFileWithManager:) forControlEvents:UIControlEventTouchUpInside];
    [btnloadPrivacy addTarget:self action:@selector(downloadPrivacyManager:) forControlEvents:UIControlEventTouchUpInside];
    [btnAcceptSeller addTarget:self action:@selector(btnisActiveTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnAcceptPrivacy addTarget:self action:@selector(btnisActiveTapped:) forControlEvents:UIControlEventTouchUpInside];
    isActive = @0;
    [self GetDocumentFileWithAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW DELEGATE & DATA SOURCE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== THSegmentedPageViewControllerDelegate ===❉===❉
/*****************************************************************************************************************/
-(NSString *)viewControllerTitle
{
    return _strManageAcTittle;
}

-(void)GetDocumentFileWithAPI
{
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait.."];
        SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
       
        NSMutableDictionary *dicParams = [[NSMutableDictionary alloc]init];
        [dicParams setValue:objSeller.APIVerificationCode forKey:@"Token"];
        [dicParams setValue:objSeller.VendorID forKey:@"VendorID"];
        
        MBCall_GetSupplierAgreementFileDetail(dicParams, ^(id response, NSString *error, BOOL status)
        {
            if (status && [[response valueForKey:@"success"]isEqual:@1])
            {
                [CommonUtility HideProgress];
                self->dicDocuments = [[NSMutableDictionary alloc]init];
                self->dicDocuments = [[response valueForKey:@"detail"] mutableCopy];
                
                BOOL IsPrivacyAgreement = [[self->dicDocuments valueForKey:@"IsPrivacyAgreement"] boolValue];
                BOOL IsSellerAgree = [[self->dicDocuments valueForKey:@"IsSellerAgreement"] boolValue];

                (IsPrivacyAgreement)?[self->btnAcceptPrivacy setSelected:YES]:[self->btnAcceptPrivacy setSelected:NO];
                (IsSellerAgree)?[self->btnAcceptSeller setSelected:YES]:[self->btnAcceptSeller setSelected:NO];

                [self.tableView reloadData];
            }
            else
            {
                [CommonUtility HideProgress];
                [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:[response valueForKey:@"message"]];
            }
        });
    }
    else
    {
        [CommonUtility HideProgress];
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
    }
}

- (IBAction)downloadFileWithManager:(UIButton *)sender
{
    [[MBHTTPClient sharedInstance]downloadDocumentFileFromURL:[self->dicDocuments valueForKey:@"SellerAgreement"] withProgress:^(CGFloat progress)
    {
        [CommonUtility showProgress:progress];
    }
    completion:^(NSURL *filePath)
    {
        [CommonUtility HideProgress];
        
    } onError:^(NSError *error)
    {
         [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:error.description];
    }];
}
- (IBAction)downloadPrivacyManager:(UIButton *)sender
{
    [[MBHTTPClient sharedInstance]downloadDocumentFileFromURL:[self->dicDocuments valueForKey:@"PrivacyAgreement"] withProgress:^(CGFloat progress)
     {
         [CommonUtility showProgress:progress];
     }
     completion:^(NSURL *filePath)
     {
         [CommonUtility HideProgress];
     } onError:^(NSError *error)
     {
         [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:error.description];
     }];
}
- (IBAction)btnisActiveTapped:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    if (sender.isSelected)
    {
        isActive = @1;
    }
    else
    {
        isActive = @0;
    }

}
-(IBAction)bntSaveDocumentDetailTapped:(UIButton *)sender
{
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait.."];
        SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
        
        NSMutableDictionary *dicParams = [[NSMutableDictionary alloc]init];
        [dicParams setValue:objSeller.APIVerificationCode forKey:@"Token"];
        [dicParams setValue:objSeller.VendorID forKey:@"VendorID"];
        [dicParams setValue:isActive forKey:@"IsSellerAgreement"];
        [dicParams setValue:isActive forKey:@"IsPrivacyAgreement"];
        
        MBCall_UpdateAgreementDetailSupplier(dicParams, ^(id response, NSString *error, BOOL status)
        {
            if (status && [[response valueForKey:@"success"]isEqual:@1])
            {
                [CommonUtility HideProgress];
            }
            else
            {
                [CommonUtility HideProgress];
                [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:[response valueForKey:@"message"]];
            }
        });
    }
    else
    {
        [CommonUtility HideProgress];
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
    }
    
}

@end
