//
//  TVLoginControlScreen.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 10/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVLoginControlScreen.h"
#import "Constant.h"
#import "AppConstant.h"
#import "CommonUtility.h"
#import "MBAPIManager.h"
#import "MBDataBaseHandler.h"
#import "SharedManager.h"

@interface TVLoginControlScreen ()<THSegmentedPageViewControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSData *imageDatatoUpload;
}

@end

@implementation TVLoginControlScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    [txtName setDefaultTextfieldStyleWithPlaceHolder:@"Your Name" withTag:0];
    [txtEmailID setDefaultTextfieldStyleWithPlaceHolder:@"Your Email" withTag:0];
    [txtMobile setDefaultTextfieldStyleWithPlaceHolder:@"Your Mobile Number" withTag:0];
    [txtPassword setDefaultTextfieldStyleWithPlaceHolder:@"Password" withTag:0];
    [txtConfirmPassword setDefaultTextfieldStyleWithPlaceHolder:@"Confirm Password" withTag:0];
    
    UITapGestureRecognizer *recoganize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHandle:)];
    [recoganize setNumberOfTapsRequired:1];
    [self.tableView addGestureRecognizer:recoganize];
    
    [btnSubmit setDefaultButtonShadowStyle:DefaultThemeColor];
    [btnSubmit.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    [btnSubmit addTarget:self action:@selector(btnSubmitLoginControl:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnProfileUpload setDefaultButtonShadowStyle:DefaultThemeColor];
    [btnProfileUpload.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    [btnProfileUpload addTarget:self action:@selector(btnProfileUploadClicked:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getSupplierLoginControlServiceCalled];
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW DELEGATE & DATA SOURCE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    SellerLoginControl *objloginControl = [MBDataBaseHandler getSellerLoginControl];
    [txtEmailID setUserInteractionEnabled:NO];
    [txtName setText:objloginControl.VendorName];
    [txtEmailID setText:objloginControl.UserID];
    [txtMobile setText:objloginControl.MobileNo];
    [txtPassword setText:objloginControl.Password];
    [txtConfirmPassword setText:objloginControl.Password];
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
-(IBAction)btnSubmitLoginControl:(UIButton *)sender
{
    
    SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:objSeller.APIVerificationCode forKey:@"Token"];
    [dic setValue:objSeller.VendorID forKey:@"VendorID"];
    [dic setValue:txtName.text forKey:@"VendorName"];
    [dic setValue:objSeller.UserID forKey:@"UserID"];
    [dic setValue:txtPassword.text forKey:@"Password"];
    [dic setValue:txtMobile.text forKey:@"MobileNo"];

    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait...!"];
        
        MBCall_SupplierSaveLoginControlAPI(dic, ^(id response, NSString *error, BOOL status)
        {
            [CommonUtility HideProgress];
            
            if (status && [[response valueForKey:@"success"]  isEqual: @1])
            {
                
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
-(IBAction)btnProfileUploadClicked:(UIButton *)sender
{
    [SharedManager ShowCameraWithTittle:@"Choose Image to UPLOAD" withID:self];
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== UI-IMAGE PICKER DELEGATE CALLED ===❉===❉
/******************************************************************************************************************/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:true completion:nil];
    
    UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];

//NSString    *strUploadImage = [CommonUtility saveImageTODocumentAndGetPath:img];

//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//
//    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"Tradology.png"];
//
//    NSURL *imgURL = [NSURL fileURLWithPath:path];
    
    
    imageDatatoUpload = UIImageJPEGRepresentation(img, 0);
 
    if(img != nil)
    {
        [imgProfilePic setImage:img];
        SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:objSeller.APIVerificationCode forKey:@"Token"];
        [dic setValue:objSeller.VendorID forKey:@"VendorID"];
        
//        MBCall_AddPackingImageUploadAPI(dicImage, self->imageDatatoUpload, ^(id response, NSString *error, BOOL status)
//        {
//            if (status && [[response valueForKey:@"success"]isEqual:@1])
//            {
//                if (response != (NSDictionary *)[NSNull null])
//                {
//
//                }
//            }
//        });
    }
    else
    {

    }
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== SUPPLIER LOGIN CONTROL SERVICE CALLED ===❉===❉
/******************************************************************************************************************/
-(void)getSupplierLoginControlServiceCalled
{
    SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:objSeller.APIVerificationCode forKey:@"Token"];
    [dic setValue:objSeller.VendorID forKey:@"VendorID"];
    
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait...!"];
        
        MBCall_SupplierLoginControlAPI(dic, ^(id response, NSString *error, BOOL status)
        {
            [CommonUtility HideProgress];
            NSError* Error;
            
            if (status && [[response valueForKey:@"success"]  isEqual: @1])
            {                
                SellerLoginControl *objloginControl = [[SellerLoginControl alloc]initWithDictionary:[response valueForKey:@"detail"] error:&Error];
                objloginControl.RegistrationStatus = [response valueForKey:@"RegistrationStatus"];
                [MBDataBaseHandler saveSellerLoginControlData:objloginControl];
                
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
