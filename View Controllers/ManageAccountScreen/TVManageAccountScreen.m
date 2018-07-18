//
//  TVManageAccountScreen.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 11/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVManageAccountScreen.h"
#import "Constant.h"
#import "AppConstant.h"
#import "CommonUtility.h"
#import "MBAPIManager.h"
#import "MBDataBaseHandler.h"
#import "SharedManager.h"

@interface TVManageAccountScreen ()<THSegmentedPageViewControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSData *imageDatatoUpload;
    NSString *strUploadImage;
    BOOL isfromVendor;
}

@end

@implementation TVManageAccountScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [txtVendorName setDefaultTextfieldStyleWithPlaceHolder:@"Your Name" withTag:0];
    [txtAnnualTurnOver setDefaultTextfieldStyleWithPlaceHolder:@"Your Annual TurnOver" withTag:0];
    [txtDescriptions setDefaultTextfieldStyleWithPlaceHolder:@"Enter Descriptions" withTag:0];
    [txtAreaOfOperation setDefaultTextfieldStyleWithPlaceHolder:@"Your Area Of Operation" withTag:0];
    [txtYearOfEstablish setDefaultTextfieldStyleWithPlaceHolder:@"Your Year of Establishment" withTag:0];
    [txtCertifications setDefaultTextfieldStyleWithPlaceHolder:@"Your Certifications" withTag:0];
    
    UITapGestureRecognizer *recoganize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHandle:)];
    [recoganize setNumberOfTapsRequired:1];
    [self.tableView addGestureRecognizer:recoganize];
    
    [btnSubmit setDefaultButtonShadowStyle:DefaultThemeColor];
    [btnSubmit.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    [btnSubmit addTarget:self action:@selector(btnSubmitVendorInformation:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnEBrochure setDefaultButtonShadowStyle:DefaultThemeColor];
    [btnEBrochure.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    [btnVendorUpload setDefaultButtonShadowStyle:DefaultThemeColor];
    [btnVendorUpload.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    [btnVendorUpload addTarget:self action:@selector(btnCameraVendorUpload:) forControlEvents:UIControlEventTouchUpInside];
    [btnEBrochure addTarget:self action:@selector(btnCameraEBrochure:) forControlEvents:UIControlEventTouchUpInside];
    
    isfromVendor = NO;
    [self getSupplierInformationServiceCalled];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW DELEGATE & DATA SOURCE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    SellerGetInformation *objSellerGetInfo = [MBDataBaseHandler getSellerGetInformationData];
    [txtVendorName setText:objSellerGetInfo.VendorName];
    [txtDescriptions setText:objSellerGetInfo.VendorDescription];
    [txtAnnualTurnOver setText:objSellerGetInfo.AnnualTurnOver];
    [txtCertifications setText:objSellerGetInfo.Certifications];
    [txtAreaOfOperation setText:objSellerGetInfo.AreaOfOperation];
    [txtYearOfEstablish setText:objSellerGetInfo.YearOfEstablishment];
    [lblVendorCode setText:[NSString stringWithFormat:@"Vendor Code :- %@",objSellerGetInfo.VendorCode]];
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

-(void)didTapHandle:(UITapGestureRecognizer *)recoganise
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
-(IBAction)btnSubmitVendorInformation:(UIButton *)sender
{
    SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:objSeller.APIVerificationCode forKey:@"Token"];
    [dic setValue:objSeller.VendorID forKey:@"VendorID"];
    [dic setValue:txtVendorName.text forKey:@"VendorName"];
    [dic setValue:txtAnnualTurnOver.text forKey:@"AnnualTurnover"];
    [dic setValue:txtYearOfEstablish.text forKey:@"YearOfEstablishment"];
    [dic setValue:txtCertifications.text forKey:@"Certifications"];
    [dic setValue:txtAreaOfOperation.text forKey:@"AreaOfOperation"];
    [dic setValue:txtDescriptions.text forKey:@"VendorDscription"];

    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait...!"];
        
        MBCall_SaveSupplierInformationAPI(dic, ^(id response, NSString *error, BOOL status)
        {
            [CommonUtility HideProgress];
            NSError* Error;
            
            if (status && [[response valueForKey:@"success"]  isEqual: @1])
            {
                SellerGetInformation *objSellerGetInfo = [[SellerGetInformation alloc]initWithDictionary:[response valueForKey:@"detail"] error:&Error];
                objSellerGetInfo.RegistrationStatus = [response valueForKey:@"RegistrationStatus"];
                [MBDataBaseHandler saveSellerGetInformationData:objSellerGetInfo];
                
                [self.tableView reloadData];
            }
            else
            {
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
-(IBAction)btnCameraVendorUpload:(UIButton *)sender
{
    isfromVendor = YES;
    [self showAlertShowCameraAndLibrabryToSelectImage];
}
-(IBAction)btnCameraEBrochure:(UIButton *)sender
{
    isfromVendor = NO;
    [self showAlertShowCameraAndLibrabryToSelectImage];
}

- (void)showAlertShowCameraAndLibrabryToSelectImage
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select Image" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *pickerView =[[UIImagePickerController alloc]init];
            pickerView.allowsEditing = YES;
            pickerView.delegate = self;
            pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickerView animated:YES completion:nil];
        }
        else
        {
            
        }
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:pickerView animated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:actionSheet animated:YES completion:nil];
    });
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== UI-IMAGE PICKER DELEGATE CALLED ===❉===❉
/******************************************************************************************************************/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:true completion:nil];
    
    UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];
    strUploadImage = [CommonUtility saveImageTODocumentAndGetPath:img];
    imageDatatoUpload = UIImageJPEGRepresentation(img, 0);
    
    if(isfromVendor)
    {
        if(img != nil)
        {
            [imgVenderLogo setImage:img];
        }
        else
        {
        }
    }
    else
    {
        if(img != nil)
        {
            [imgBrochure setImage:img];
        }
        else
        {
        }
    }
    
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== GET SUPPLIER INFORMATION SERVICE CALLED ===❉===❉
/******************************************************************************************************************/
-(void)getSupplierInformationServiceCalled
{
    SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:objSeller.APIVerificationCode forKey:@"Token"];
    [dic setValue:objSeller.VendorID forKey:@"VendorID"];
    
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait...!"];
        
        MBCall_GetSupplierInformationAPI(dic, ^(id response, NSString *error, BOOL status)
        {
            [CommonUtility HideProgress];
            NSError* Error;
            
            if (status && [[response valueForKey:@"success"]  isEqual: @1])
            {
                SellerGetInformation *objSellerGetInfo = [[SellerGetInformation alloc]initWithDictionary:[response valueForKey:@"detail"] error:&Error];
                objSellerGetInfo.RegistrationStatus = [response valueForKey:@"RegistrationStatus"];
                [MBDataBaseHandler saveSellerGetInformationData:objSellerGetInfo];
                
                [self.tableView reloadData];
            }
            else
            {
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
