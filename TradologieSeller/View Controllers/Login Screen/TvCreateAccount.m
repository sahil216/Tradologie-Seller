//
//  TvCreateAccount.m
//  Tradologie
//
//  Created by Chandresh Maurya on 05/05/18.
//  Copyright © 2018 Chandresh Maurya. All rights reserved.
//

#import "TvCreateAccount.h"
#import "Constant.h"
#import "AppConstant.h"
#import "CommonUtility.h"
#import "MBAPIManager.h"
#import "MBDataBaseHandler.h"
#import "SharedManager.h"

@interface TvCreateAccount ()
{
    NSString *strGender;
    NSMutableArray *selectedID;
    NSMutableArray *selecteValues;
}
@end

@implementation TvCreateAccount

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [txtName setDefaultTextfieldStyleWithPlaceHolder:@"Your Name" withTag:0];
    [txtEmailID setDefaultTextfieldStyleWithPlaceHolder:@"Your Email" withTag:0];
    [txtMobile setDefaultTextfieldStyleWithPlaceHolder:@"Your Mobile Number" withTag:0];
    [txtPassword setDefaultTextfieldStyleWithPlaceHolder:@"Password" withTag:0];
    [txtConfirmPassword setDefaultTextfieldStyleWithPlaceHolder:@"Confirm Password" withTag:0];
    [btnback addTarget:self action:@selector(btnBackTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [lbl_logoname setFont:([SDVersion deviceSize] > Screen4Dot7inch)?UI_DEFAULT_LOGO_FONT_MEDIUM(28):([SDVersion deviceSize] < Screen4Dot7inch)?UI_DEFAULT_LOGO_FONT_MEDIUM(22):UI_DEFAULT_LOGO_FONT_MEDIUM(25)];
    
    UITapGestureRecognizer *recoganize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHandle:)];
    [recoganize setNumberOfTapsRequired:1];
    [self.tableView addGestureRecognizer:recoganize];
    if ([SDVersion deviceSize] > Screen4inch)
    {
        [self.tableView setBounces:NO];
        [self.tableView setScrollEnabled:NO];
        [lblNewUser setFont:UI_DEFAULT_FONT_MEDIUM(15)];
    }
    else
    {
        [self.tableView setBounces:NO];
        [self.tableView setScrollEnabled:YES];
        [lblNewUser setFont:UI_DEFAULT_FONT_MEDIUM(14)];

    }
   
    [btnAgreeTerms addTarget:self action:@selector(btnAgreeTermsTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit addTarget:self action:@selector(btnSubmitUserClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit setDefaultButtonStyleWithHighLightEffect];
    [btnSubmit.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    strGender = @"2";
    
    selecteValues = [NSMutableArray new];
    selectedID = [NSMutableArray new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return _viewHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== BUTTON ACTION EVENT CALLED HERE ===❉===❉
/*****************************************************************************************************************/

-(IBAction)btnBackTapped:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didTapHandle:(UITapGestureRecognizer *)recoganise
{
    [self.view endEditing:YES];
}

-(IBAction)btnAgreeTermsTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

-(IBAction)btnSubmitUserClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
 
    BOOL isValidate=TRUE;

    if ([Validation validateTextField:txtName])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Full Name..!"];
        return;
    }
    else if ([Validation validateTextField:txtEmailID])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Email Address..!"];
        return;
    }
    else if (![Validation validateEmail:txtEmailID.text])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter a valid Email Id..!"];
        return;
    }
    else if ([Validation validateTextField:txtMobile])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Mobile Number..!"];
        return;
    }
    else if (![Validation validatePhoneNumber:txtMobile.text])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter a valid Mobile Number with Country Code..!"];
        return;
    }
    else if ([Validation validateTextField:txtPassword])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Password..!"];
        return;
    }
    else if (![Validation isAlphaNumericAndContainsAtLeastSixDigit:txtPassword.text])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Password between 4 to 10 Digits Alpha Numeric..!"];
        return;
    }
    else if ([Validation validateTextField:txtConfirmPassword])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter Your Confirm Password..!"];
        return;
    }
    else if (![Validation validatePassword:txtPassword ConfirmPassword:txtConfirmPassword])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Opps Your Password Did Not Match..!"];
        return;
    }
    else if(!btnAgreeTerms.isSelected)
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Agree the Term's & Privacy Policy..!"];
        return;
    }
    if (isValidate)
    {
        if (SharedObject.isNetAvailable)
        {
            [CommonUtility showProgressWithMessage:@"Please Wait.."];

            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:API_DEFAULT_TOKEN forKey:@"Token"];
            [dic setValue:txtName.text forKey:@"UserName"];
            [dic setValue:txtEmailID.text forKey:@"EmailID"];
            [dic setValue:txtMobile.text forKey:@"MobileNo"];
            [dic setValue:txtPassword.text forKey:@"Password"];
            [dic setValue:TYPE_OF_ACCOUNT_ID forKey:@"TypeOfAccountID"];
    
            
            MBCall_RegisterUserWithPostData(dic, ^(id response, NSString *error, BOOL status)
            {
                if (status && ![[response valueForKey:@"success"]isEqual:@0])
                {
                    NSLog(@"response == >%@",response);
                    [CommonUtility HideProgress];
                    [self getSupplierLoginServiceCalled];

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
-(void)getSupplierLoginServiceCalled
{
    if (SharedObject.isNetAvailable)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:txtEmailID.text forKey:@"UserID"];
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

            if (status && [[response valueForKey:@"success"]  isEqual: @1])
            {
                NSLog(@"response == >%@",response);

                NSMutableDictionary *dicUserDetail = [[NSMutableDictionary alloc]init];
                dicUserDetail = [[response valueForKey:@"detail"] mutableCopy];
                
                SellerUserDetail *objSellerUser = [[SellerUserDetail alloc]initWithDictionary:response error:&Error];
                [MBDataBaseHandler saveSellerUserDetailData:objSellerUser];
                
                if ([objSellerUser.RegistrationStatus isEqualToString:@"Complete"])
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
            else{
                [CommonUtility HideProgress];
                [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:[response valueForKey:@"message"]];

            }

        });
    }
    else
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
    }
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== TEXTFIELD DELEGATE CALLED HERE ===❉===❉
/******************************************************************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
