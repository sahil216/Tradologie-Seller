//
//  TvAlreadyUserScreen.m
//  Tradologie
//
//  Created by Chandresh Maurya on 04/05/18.
//  Copyright © 2018 Chandresh Maurya. All rights reserved.
//

#import "TvAlreadyUserScreen.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "AppConstant.h"
#import "TVLoginScreen.h"
#import "CommonUtility.h"
#import "MBAPIManager.h"
#import "MBDataBaseHandler.h"
#import "SharedManager.h"

@interface TvAlreadyUserScreen ()
{
    NSMutableAttributedString *attributedString;
}
@end

@implementation TvAlreadyUserScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [txtUserID setDefaultPreferenceTextfieldStyle:[UIImage imageNamed:@"IconUser"] WithPlaceHolder:@"Email Address" withTag:0];
    [txtPassword setTextfieldStyleWithButton:[UIImage imageNamed:@"IconPassword"] WithPlaceHolder:@"Password" withID:self withbuttonImage:[UIImage imageNamed:@"IconHidePassword"] withSelectorAction:@selector(btnViewpasswordClick:)];
    
    [_btnLogin addTarget:self action:@selector(btnloginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnback addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnForgotPwd addTarget:self action:@selector(btnForgotPwdClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.navigationBar setNaviagtionStyleWithStatusbar:[UIColor whiteColor]];
    [self.tableView setScrollEnabled:NO];
    [_btnLogin setDefaultButtonStyleWithHighLightEffect];
    [_btnLogin.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    
    [lbl_logoname setFont:([SDVersion deviceSize] > Screen4Dot7inch)?UI_DEFAULT_LOGO_FONT_MEDIUM(28):([SDVersion deviceSize] < Screen4Dot7inch)?UI_DEFAULT_LOGO_FONT_MEDIUM(22):UI_DEFAULT_LOGO_FONT_MEDIUM(25)];
    
    NSString *string = @"Please visit us at supplier.tradologie.com for more Information.";
    [lblVisitUs setNumberOfLines:0];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:UI_DEFAULT_FONT(16)};
    lblVisitUs.attributedText = [[NSAttributedString alloc]initWithString:string attributes:attributes];
    
    //Step 2: Define a selection handler block
    void(^handler)(FRHyperLabel *label, NSString *substring) = ^(FRHyperLabel *label, NSString *substring)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://supplier.tradologie.com"]])
        {
            if (@available(iOS 10.0, *))
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://supplier.tradologie.com"] options:@{} completionHandler:^(BOOL success) {
                }];
            }
            else
            {
                
            }
        }
    };
    
    [lblVisitUs setLinksForSubstrings:@[@"supplier.tradologie.com",@"supplier.tradologie.com"] withLinkHandler:handler];
    [self SetAttributedStringWithUnderlineTittle];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
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
    return 8;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:
(NSIndexPath *)indexPath
{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return _viewLogo;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _viewBottom;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== BUTTON ACTION EVENT CALLED ===❉===❉
/*****************************************************************************************************************/

-(IBAction)btnBackClicked:(UIButton *)sender
{
    UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TVLoginScreen * rootVC = [storyboard instantiateViewControllerWithIdentifier:@"TVLoginScreen"];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:rootVC];
    
    AppDelegate *delegateClass = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [delegateClass setRootViewController:nav];
    
}
-(IBAction)btnViewpasswordClick:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    if (sender.selected)
    {
        [txtPassword setSecureTextEntry:NO];
        [sender setImage:[UIImage imageNamed:@"IconShowPassword"] forState:UIControlStateNormal];
        
    }
    else
    {
        [txtPassword setSecureTextEntry:YES];
        [sender setImage:[UIImage imageNamed:@"IconHidePassword"] forState:UIControlStateNormal];
        
    }
}
-(IBAction)btnloginClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    BOOL isValidate=TRUE;
    
    //    [txtUserID setText:@"rswsteelmzn@gmail.com"];
    //    [txtPassword setText:@"reset"];
    
//    [txtUserID setText:@"demo326@gmail.com"];
//    [txtPassword setText:@"qwe123"];
    
    
    if ([Validation validateTextField:txtUserID])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Email Address..!"];
        return;
    }
    else if (![Validation validateEmail:txtUserID.text])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter a valid Email Id..!"];
        return;
    }
    else if ([Validation validateTextField:txtPassword])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Password..!"];
        return;
    }
    
    if (isValidate)
    {
        if (SharedObject.isNetAvailable)
        {
            [CommonUtility showProgressWithMessage:@"Please Wait.."];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:txtUserID.text forKey:@"UserID"];
            [dic setValue:txtPassword.text forKey:@"Password"];
            [dic setValue:DEVICE_OS_MANUFACTURE forKey:@"Manufacturer"];
            [dic setValue:DEVICE_OS_MODEL forKey:@"Model"];
            [dic setValue:DEVICE_OS_VERSION forKey:@"OsVersionRelease"];
            [dic setValue:APP_VERSION forKey:@"AppVersion"];
            [dic setValue:FIREBASE_TOKEN forKey:@"FcmToken"];
            [dic setValue:@"IOS" forKey:@"OsType"];
            [dic setValue:UNIQUE_IDENTIFIER forKey:@"DeviceId"];
            
            MBCall_LoginUserUsing(dic, ^(id response, NSString *error, BOOL status)
            {
                NSError* Error;
                
                if (status && [[response valueForKey:@"success"]isEqual:@1])
                {
                    [CommonUtility HideProgress];
                    
                    SellerUserDetail *objSellerdetail = [[SellerUserDetail alloc]initWithDictionary:[response valueForKey:@"detail"] error:&Error];
                    [MBDataBaseHandler saveSellerUserDetailData:objSellerdetail];
                
                    [self getCommonSupplierDataWithVendorID];
                    
                    if ([objSellerdetail.RegistrationStatus isEqualToString:@"Complete"])
                    {
                        RootViewController * rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
                        AppDelegate *delegateClass = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                        [delegateClass setRootViewController:rootVC];
                        
                    }
                    else
                    {
                        [AppDelegate getManageAccountScreenWithPagination:self.storyboard withNavigation:self.navigationController];
                    }
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
-(IBAction)btnForgotPwdClicked:(UIButton *)sender
{
    //    TVForgotPassword *forgotScreen =[self.storyboard instantiateViewControllerWithIdentifier:@"TVForgotPassword"];
    //    [self.navigationController pushViewController:forgotScreen animated:YES];
}

-(void)SetAttributedStringWithUnderlineTittle
{
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"Forgot Password ?"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,0}];
    [tncString addAttribute:NSUnderlineColorAttributeName value:DefaultThemeColor range:NSMakeRange(0, 0)];
    
    
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    
    [btnForgotPwd setAttributedTitle:tncString forState:UIControlStateNormal];
    [btnForgotPwd.titleLabel setFont:UI_DEFAULT_FONT_MEDIUM(16)];
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== TEXTFIELD DELEGATE CALLED HERE ===❉===❉
/*****************************************************************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)getCommonSupplierDataWithVendorID
{
    SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
    
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc]init];
    [dicParams setValue:objSeller.APIVerificationCode forKey:@"Token"];
    [dicParams setValue:objSeller.VendorID forKey:@"VendorID"];
    
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait.."];
        
        MBCall_GetCommonSupplierDataWithVendorIDAPI(dicParams, ^(id response, NSString *error, BOOL status)
        {
            NSError* Error;
            
            if (status && [[response valueForKey:@"success"]isEqual:@1])
            {
                [CommonUtility HideProgress];
                CommonSupplierData *objCommonSupplierData = [[CommonSupplierData alloc]initWithDictionary:[response valueForKey:@"detail"] error:&Error];
                objCommonSupplierData.RegistrationStatus = [response valueForKey:@"RegistrationStatus"];
                objCommonSupplierData.message = [response valueForKey:@"message"];

                [MBDataBaseHandler saveSellerCommonSupplierData:objCommonSupplierData];
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
