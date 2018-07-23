//
//  TVBankDetailScreen.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 21/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVBankDetailScreen.h"
#import "Constant.h"
#import "AppConstant.h"
#import "CommonUtility.h"
#import "MBAPIManager.h"
#import "MBDataBaseHandler.h"
#import "SharedManager.h"

@interface TVBankDetailScreen ()<THSegmentedPageViewControllerDelegate,UITextFieldDelegate>

@end

@implementation TVBankDetailScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [txtAccountName setDefaultTextfieldStyleWithPlaceHolder:@"Your Account Name" withTag:0];
    [txtAccountNumber setDefaultTextfieldStyleWithPlaceHolder:@"Your Account Number" withTag:0];
    [txtBankName setDefaultTextfieldStyleWithPlaceHolder:@"Your Bank Name" withTag:0];
    [txtBranch setDefaultTextfieldStyleWithPlaceHolder:@"Your Branch" withTag:0];
    [txtIFSCCode setDefaultTextfieldStyleWithPlaceHolder:@"Your Bank IFSC Code" withTag:0];
    
    UITapGestureRecognizer *recoganize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHandleforBank:)];
    [recoganize setNumberOfTapsRequired:1];
    [self.tableView addGestureRecognizer:recoganize];
    
    [btnSubmit setDefaultButtonShadowStyle:DefaultThemeColor];
    [btnSubmit.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    [btnSubmit addTarget:self action:@selector(btnSubmitBankDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnUploadCheck setDefaultButtonShadowStyle:DefaultThemeColor];
    [btnUploadCheck.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(16): UI_DEFAULT_FONT_MEDIUM(18)];
    
    [self GetBankDetailWithData];
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
    return 8;
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

/******************************************************************************************************************/
#pragma mark ❉===❉=== TAPGESTURE CALLED HERE ===❉===❉
/*****************************************************************************************************************/
-(void)didTapHandleforBank:(UITapGestureRecognizer *)recoganise
{
    [self.view endEditing:YES];
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== TEXTFIELD DELEGATE CALLED HERE ===❉===❉
/******************************************************************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== BUTTON ACTION EVENT CALLED HERE ===❉===❉
/******************************************************************************************************************/
-(IBAction)btnSubmitBankDetail:(UIButton *)sender
{
    
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== GET BANK DETAI DATA CALLED HERE ===❉===❉
/******************************************************************************************************************/
-(void)GetBankDetailWithData
{
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait.."];
        SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
        
        NSMutableDictionary *dicParams = [[NSMutableDictionary alloc]init];
        [dicParams setValue:objSeller.APIVerificationCode forKey:@"Token"];
        [dicParams setValue:objSeller.VendorID forKey:@"VendorID"];
        
        MBCall_GetSupplierBankDetailData(dicParams, ^(id response, NSString *error, BOOL status)
         {
             if (status && [[response valueForKey:@"success"]isEqual:@1])
             {
                 [CommonUtility HideProgress];
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
@end
