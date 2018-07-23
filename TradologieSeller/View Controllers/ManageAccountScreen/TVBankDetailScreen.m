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

@interface TVBankDetailScreen ()<THSegmentedPageViewControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSData *imageDatatoUpload;
}
@end

@implementation TVBankDetailScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [txtAccountName setDefaultTextfieldStyleWithPlaceHolder:@"Your Bank Account Name" withTag:0];
    [txtAccountNumber setDefaultTextfieldStyleWithPlaceHolder:@"Your Bank Account Number" withTag:0];
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
    [btnUploadCheck addTarget:self action:@selector(btnUploadCheckTapped:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [self.view endEditing:YES];
    
    BOOL isValidate=TRUE;
    
    if ([Validation validateTextField:txtAccountName])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Bank Account Name..!"];
        return;
    }
    else if ([Validation validateTextField:txtAccountNumber])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Bank Account Number..!"];
        return;
    }
    else if ([Validation validateTextField:txtBankName])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter Bank Name..!"];
        return;
    }
    else if ([Validation validateTextField:txtBranch])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter Branch Name..!"];
        return;
    }
    else if ([Validation validateTextField:txtIFSCCode])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter Bank IFSC Code ..!"];
        return;
    }
    
    if (isValidate)
    {
        
        SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
        
        NSMutableDictionary *dicParams = [[NSMutableDictionary alloc]init];
        [dicParams setValue:objSeller.APIVerificationCode forKey:@"Token"];
        [dicParams setValue:objSeller.VendorID forKey:@"VendorID"];
        [dicParams setValue:txtAccountName.text forKey:@"AccountName"];
        [dicParams setValue:txtAccountNumber.text forKey:@"AccountNumber"];
        [dicParams setValue:txtBankName.text forKey:@"BankName"];
        [dicParams setValue:txtBranch.text forKey:@"Branch"];
        [dicParams setValue:txtIFSCCode.text forKey:@"IFSCCode"];
        
        if (SharedObject.isNetAvailable)
        {
            [CommonUtility showProgressWithMessage:@"Please Wait.."];
            
            MBCall_GetSupplierUpdateBankDetailData(dicParams, ^(id response, NSString *error, BOOL status)
            {
                if (status && [[response valueForKey:@"success"]isEqual:@1])
                {
                    [CommonUtility HideProgress];
                    [self GetBankDetailWithData];
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
}
-(IBAction)btnUploadCheckTapped:(UIButton *)sender
{
    [SharedManager ShowCameraWithTittle:@"Choose Image From" withID:self];
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
                
                NSError *Error;
                SellerBankDetailData *objBankDetail = [[SellerBankDetailData alloc]initWithDictionary:[response valueForKey:@"detail"] error:&Error];
                objBankDetail.RegistrationStatus = [response valueForKey:@"RegistrationStatus"];
                [MBDataBaseHandler saveSellerBankDetailWithData:objBankDetail];
                
                [self getValueFromDataBase];
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
-(void)getValueFromDataBase
{
    SellerBankDetailData *objBankDetail = [MBDataBaseHandler getSellerBankDetailData];
    [txtAccountName setText:objBankDetail.AccountName];
    [txtAccountNumber setText:objBankDetail.AccountNo];
    [txtBankName setText:objBankDetail.BankName];
    [txtBranch setText:objBankDetail.Branch];
    [txtIFSCCode setText:objBankDetail.IFSCCode];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:objBankDetail.DocUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         
     }
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if (error)
         {
             [self->imgProfilePic setImage:[UIImage imageNamed:@"IconNoImageAvailable"]];
         }
         else
         {
             
             
             self->imgProfilePic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];;
         }
     }];
    
    [self.tableView reloadData];
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== UI-IMAGE PICKER DELEGATE CALLED ===❉===❉
/******************************************************************************************************************/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:true completion:nil];
    
    UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];
    NSString *strImageName = [[info valueForKey:@"UIImagePickerControllerImageURL"] lastPathComponent];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:strImageName];
    imageDatatoUpload = UIImageJPEGRepresentation(img, 0);
    
    
    if(img != nil)
    {
        [imgProfilePic setImage:img];
        
        SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:objSeller.VendorID forKey:@"VendorID"];
        [dic setValue:@"imageMimeTypes" forKey:@"ContentType"];
        [dic setObject:path forKey:@"File"];
        [dic setObject:@".jpg" forKey: @"Extension"];
        [dic setObject:[path lastPathComponent] forKey: @"FileName"];
        
        MBCall_UploadBankCheque(dic, imageDatatoUpload, ^(id response, NSString *error, BOOL status)
       {
           if (status && [[response valueForKey:@"success"]isEqual:@1])
           {
               [self getValueFromDataBase];
               if (response != (NSDictionary *)[NSNull null])
               {
                   
               }
               else
               {
                   [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:[response valueForKey:@"message"]];
                   
               }
           }
       });
        
    }
    else
    {
        
    }
}
@end
