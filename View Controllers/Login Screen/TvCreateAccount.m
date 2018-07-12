//
//  TvCreateAccount.m
//  Tradologie
//
//  Created by Chandresh Maurya on 05/05/18.
//  Copyright © 2018 Chandresh Maurya. All rights reserved.
//

#import "TvCreateAccount.h"
#import "CommonUtility.h"
#import "Constant.h"
#import "MBAPIManager.h"
#import "AppConstant.h"
#import "SharedManager.h"
#import "TVManageAccountScreen.h"
#import "MBDataBaseHandler.h"
#import "TVLoginControlScreen.h"
#import "TVCompanyDetails.h"
#import "TVSupplierDocument.h"
#import "VCAuthorizedPersonal.h"


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
    [self getManageAccountScreenWithPagination];
    
    
//    [self.view endEditing:YES];
//    BOOL isValidate=TRUE;
//
//    if ([Validation validateTextField:txtName])
//    {
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Full Name..!"];
//        return;
//    }
//    else if ([Validation validateTextField:txtEmailID])
//    {
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Email Address..!"];
//        return;
//    }
//    else if (![Validation validateEmail:txtEmailID.text])
//    {
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter a valid Email Id..!"];
//        return;
//    }
//    else if ([Validation validateTextField:txtMobile])
//    {
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Mobile Number..!"];
//        return;
//    }
//    else if (![Validation validatePhoneNumber:txtMobile.text])
//    {
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter a valid Mobile Number with Country Code..!"];
//        return;
//    }
//    else if ([Validation validateTextField:txtPassword])
//    {
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Password..!"];
//        return;
//    }
//    else if (![Validation isAlphaNumericAndContainsAtLeastSixDigit:txtPassword.text])
//    {
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Password between 4 to 10 Digits Alpha Numeric..!"];
//        return;
//    }
//    else if ([Validation validateTextField:txtConfirmPassword])
//    {
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter Your Confirm Password..!"];
//        return;
//    }
//    else if (![Validation validatePassword:txtPassword ConfirmPassword:txtConfirmPassword])
//    {
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Opps Your Password Did Not Match..!"];
//        return;
//    }
//    else if(!btnAgreeTerms.isSelected)
//    {
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Agree the Term's & Privacy Policy..!"];
//        return;
//    }
//    if (isValidate)
//    {
//        if (SharedObject.isNetAvailable)
//        {
//            [CommonUtility showProgressWithMessage:@"Please Wait.."];
//
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//            [dic setValue:API_DEFAULT_TOKEN forKey:@"Token"];
//            [dic setValue:txtName.text forKey:@"UserName"];
//            [dic setValue:txtEmailID.text forKey:@"EmailID"];
//            [dic setValue:txtMobile.text forKey:@"MobileNo"];
//            [dic setValue:txtPassword.text forKey:@"Password"];
//            [dic setValue:strGender forKey:@"GenderID"];
//            [dic setValue:TYPE_OF_ACCOUNT_ID forKey:@"TypeOfAccountID"];
//            NSString *strID = [selectedID componentsJoinedByString:@","];
//            [dic setValue:strID forKey:@"GroupIDs"];
    
            
//            MBCall_RegisterUserWithPostData(dic, nil, ^(id response, NSString *error, BOOL status)
//            {
//                if (status && ![[response valueForKey:@"success"]isEqual:@0])
//                {
//                    NSLog(@"response == >%@",response);
//                    [CommonUtility HideProgress];
//                    [self getLoginServiceCalles];
//
//                }
//                else
//                {
//                    [CommonUtility HideProgress];
//                    [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:[response valueForKey:@"message"]];
//
//                }
//
//            });
//        }
//        else
//        {
//            [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
//        }
//    }
    
}
//-(void)getLoginServiceCalles
//{
//    if (SharedObject.isNetAvailable)
//    {
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//        [dic setValue:txtEmailID.text forKey:@"UserID"];
//        [dic setValue:txtPassword.text forKey:@"Password"];
//        [dic setValue:DEVICE_OS_MANUFACTURE forKey:@"Manufacturer"];
//        [dic setValue:DEVICE_OS_MODEL forKey:@"Model"];
//        [dic setValue:DEVICE_OS_VERSION forKey:@"OsVersionRelease"];
//        [dic setValue:APP_VERSION forKey:@"AppVersion"];
//        [dic setValue:FIREBASE_TOKEN forKey:@"FcmToken"];
//        [dic setValue:@"IOS" forKey:@"OsType"];
//        [dic setValue:UNIQUE_IDENTIFIER forKey:@"DeviceId"];
//        SAVE_USER_DEFAULTS(txtEmailID.text, @"emailID"); // For Use of popup Message to Resend emails
//
//        MBCall_LoginUserUsing(dic, ^(id response, NSString *error, BOOL status)
//        {
//            if (status && [[response valueForKey:@"success"]  isEqual: @1])
//            {
//                NSLog(@"response == >%@",response);
//
//                NSMutableDictionary *dicUserDetail = [[NSMutableDictionary alloc]init];
//                dicUserDetail = [[response valueForKey:@"detail"] mutableCopy];
//
//                if ([[dicUserDetail valueForKey:@"IsComplete"] isEqualToString:@"N"] && [[dicUserDetail valueForKey:@"VerificationStatus"]isEqual:@0])
//                {
//                    VCMessageScreen * vcpopUp = [self.storyboard instantiateViewControllerWithIdentifier:@"VCMessageScreen"];
//                    [self.navigationController.navigationBar setNaviagtionStyleWithStatusbar:[UIColor whiteColor]];
//                    [self.navigationController.navigationBar setHidden:NO];
//                    [self.navigationController pushViewController:vcpopUp animated:YES];
//
//                }
//                else  if ([[dicUserDetail valueForKey:@"IsComplete"] isEqualToString:@"N"] && [[dicUserDetail valueForKey:@"VerificationStatus"]isEqual:@1])
//                {
//                    NSError* Error;
//                    BuyerUserDetail *detail =[[BuyerUserDetail alloc]initWithDictionary:response error:&Error];
//                    [MBDataBaseHandler saveCommonDataDetail:detail];
//
//                    TVCompanyRegister *objCompanyScreen = GET_VIEW_CONTROLLER(@"TVCompanyRegister");
//                    [self.navigationController pushViewController:objCompanyScreen animated:YES];
//                }
//            }
//            else{
//                [CommonUtility HideProgress];
//                [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:[response valueForKey:@"message"]];
//
//            }
//
//        });
//    }
//    else
//    {
//        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
//    }
//
//}
/******************************************************************************************************************/
#pragma mark ❉===❉=== TEXTFIELD DELEGATE CALLED HERE ===❉===❉
/******************************************************************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)getManageAccountScreenWithPagination
{
    THSegmentedPager *objManageAccountMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"THSegmentedPager"];
    
    NSMutableArray *arrMenuTittle = [[NSMutableArray alloc]initWithObjects:@"LOGIN CONTROL",@"INFORMATION",@"MEMBERSHIP TYPE",@"COMPANY DETAILS",@"DOCUMENTS",@"AUTHORIZED PERSON",@"LEGAL DOCUMENTS",@"BANK DETAILS",@"SELLING LOCATION",@"BULK RETAIL",nil];
    
    NSMutableArray *pages = [NSMutableArray new];
    
    for (NSInteger SceenNo = 0; SceenNo < [arrMenuTittle count]; SceenNo++)
    {
                switch (SceenNo)
                {
                    case 0:
                    {
                        TVLoginControlScreen *objManageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVLoginControlScreen"];
                        objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:0]];
                        [pages addObject:objManageScreen];
                    }
                        break;
                    case 1:
                    {
                        TVManageAccountScreen *objManageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVManageAccountScreen"];
                        objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                        [pages addObject:objManageScreen];
                    }
                        break;
                    case 2:
                    {
                        TVManageAccountScreen *objManageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVManageAccountScreen"];
                        objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                        [pages addObject:objManageScreen];
                    }
                        break;
                    case 3:
                    {
                        TVCompanyDetails *objTVCompanyDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"TVCompanyDetails"];
                        objTVCompanyDetails.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                        [pages addObject:objTVCompanyDetails];
                    }
                        break;
                    case 4:
                    {
                        TVSupplierDocument *objManageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVSupplierDocument"];
                        objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                        [pages addObject:objManageScreen];
                    }
                        break;
                    case 5:
                    {
                        VCAuthorizedPersonal *objAuthorized = [self.storyboard instantiateViewControllerWithIdentifier:@"VCAuthorizedPersonal"];
                        objAuthorized.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                        [pages addObject:objAuthorized];
                    }
                        break;
                    case 6:
                    {
                        TVManageAccountScreen *objManageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVManageAccountScreen"];
                        objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                        [pages addObject:objManageScreen];
                    }
                        break;
                    case 7:
                    {
                        TVManageAccountScreen *objManageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVManageAccountScreen"];
                        objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                        [pages addObject:objManageScreen];
                    }
                        break;
                    case 8:
                    {
                        TVManageAccountScreen *objManageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVManageAccountScreen"];
                        objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                        [pages addObject:objManageScreen];
                    }
                        break;
                    case 9:
                    {
                        TVManageAccountScreen *objManageScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TVManageAccountScreen"];
                        objManageScreen.strManageAcTittle = [NSString stringWithFormat:@"%@",[arrMenuTittle objectAtIndex:SceenNo]];
                        [pages addObject:objManageScreen];
                    }
                        break;
                    default:
                        break;
                }
    }
    [objManageAccountMenu setPages:pages];
    [objManageAccountMenu setSelectIndex:1];
    [self.navigationController pushViewController:objManageAccountMenu animated:YES];
}

@end
