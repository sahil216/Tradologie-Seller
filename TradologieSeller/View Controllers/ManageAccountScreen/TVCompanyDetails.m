//
//  TVCompanyDetails.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 11/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVCompanyDetails.h"
#import "Constant.h"
#import "AppConstant.h"
#import "CommonUtility.h"
#import "MBAPIManager.h"
#import "MBDataBaseHandler.h"
#import "SharedManager.h"

@interface TVCompanyDetails ()<THSegmentedPageViewControllerDelegate,UITextFieldDelegate>
{
    UIDatePicker *ObjdatePicker;
    NSMutableArray *arrCountryData;
    NSMutableArray *arrTimeZone;
    NSMutableArray *arrStateData;
    NSMutableArray *arrCityData;
    NSMutableArray *arrAreaData;
    
    NSMutableArray *arrCityID,*arrAreaID;
    NSString *strCountryID,*strCityID,*strStateID,*strAreaID,*strTimeZoneCode;
    
    NSMutableArray *arrCompanyType;
}
@end

@implementation TVCompanyDetails

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setIntialSetUpforUITextfield];
    [self getSupplierCompanyDetailsWithData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== SET INITIAL SETUP FOR UI ===❉===❉
/*****************************************************************************************************************/

-(void)setIntialSetUpforUITextfield
{
    [txtCompanyName setDefaultTextfieldStyleWithPlaceHolder:@"Your Company Name" withTag:0];
    [txtBrandName setDefaultTextfieldStyleWithPlaceHolder:@"Your Brand Name" withTag:0];
    [txtCompanyPAN setDefaultTextfieldStyleWithPlaceHolder:@"Your Company PAN No" withTag:0];
    [txtGSTIN setDefaultTextfieldStyleWithPlaceHolder:@"Your Company Registration No / GSTIN" withTag:0];
    [txtCompanyType setAdditionalInformationTextfieldStyle:@"--- Select Company Type ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnCompanyTypeTaped:) withTag:0];
    
    [txtIncorporateDate setRightViewTextfieldStyleWithCalender:@"--- Select Incorporation Date ---" Withimage:@"IconCalender" withTag:1];
    
    [txtTimeZone setAdditionalInformationTextfieldStyle:@"--- Select Time Zone ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnCompanyTypeTaped:) withTag:2];
    [txtCountry setAdditionalInformationTextfieldStyle:@"--- Select Country ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnCompanyTypeTaped:) withTag:3];
    [txtCountryOther setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    [txtCountryISD setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    
    [txtState setAdditionalInformationTextfieldStyle:@"--- Select State ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnCompanyTypeTaped:) withTag:4];
    [txtStateOthers setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    
    [txtCity setAdditionalInformationTextfieldStyle:@"--- Select City ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnCompanyTypeTaped:) withTag:5];
    
    [txtCityOthers setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    [txtCitySTD setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    
    [txtArea setAdditionalInformationTextfieldStyle:@"--- Select Area ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnCompanyTypeTaped:) withTag:6];
    
    [txtAreaOthers setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    [txtAddress setDefaultTextfieldStyleWithPlaceHolder:@"Your Address" withTag:0];
    [txtZipCode setDefaultTextfieldStyleWithPlaceHolder:@"Your ZipCode" withTag:0];
    
    [btnSubmit setDefaultButtonShadowStyle:DefaultThemeColor];
    [btnSubmit.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    [btnSubmit addTarget:self action:@selector(btnSubmitCompanyDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [txtCompanyType setTag:101];
    [txtTimeZone setTag:102];
    [txtCountry setTag:103];
    [txtState setTag:104];
    [txtCity setTag:105];
    [txtArea setTag:106];
    
    [self setDefaultToolbarAndDatePickerWithTextfield:txtIncorporateDate];
    [self getCommonSupplierDataWithVendorIDfromDataBase];
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== SET TOOlBAR WITH TEXTFIELD ===❉===❉
/*****************************************************************************************************************/

-(void)setDefaultToolbarAndDatePickerWithTextfield:(UITextField *)txtdate
{
    ObjdatePicker = [[UIDatePicker alloc]init];
    [ObjdatePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [ObjdatePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [ObjdatePicker setValue:DefaultThemeColor forKeyPath:@"textColor"];
    [ObjdatePicker setBackgroundColor:DefaultThemeColor];
    [txtdate setInputView:ObjdatePicker];
    
    //**************************************TOOL BAR ADDED ****************************************
    [CommonUtility setTooBarOnTextfield:txtdate withTargetId:self withActionEvent:@selector(btnToolBarTapped:)];
    [CommonUtility setTooBarOnTextfield:txtZipCode withTargetId:self withActionEvent:@selector(btnToolBarTapped:)];
    
}
-(void)dateTextField:(UIDatePicker *)picker
{
    [picker.date descriptionWithLocale: [NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *datestring = [dateFormatter stringFromDate:picker.date];
    [txtIncorporateDate setText:datestring];
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW DELEGATE & DATA SOURCE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:
(NSIndexPath *)indexPath
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

-(void)didTapHandle:(UITapGestureRecognizer *)recoganise
{
    [self.view endEditing:YES];
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== BUTTON ACTION EVENT CALLED HERE ===❉===❉
/******************************************************************************************************************/
-(IBAction)btnSubmitCompanyDetail:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    BOOL isValidate=TRUE;
    
    if ([Validation validateTextField:txtCompanyName])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Company Name..!"];
        return;
    }
    else if (txtCompanyName.text.length < 10)
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Company Name Should be at least 10 Character's..!"];
        return;
    }
    else if ([Validation validateTextField:txtBrandName])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Brand Name..!"];
        return;
    }
    else if ([Validation validateTextField:txtCompanyPAN])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Company PAN Number..!"];
        return;
    }
    else if (txtCompanyPAN.text.length > 10 || txtCompanyPAN.text.length < 10)
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter a Valid 10 digit PAN Number..!"];
        return;
    }
    else if ([Validation validateTextField:txtGSTIN])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Company Registration / GSTN Number..!"];
        return;
    }
    else if ([Validation validateTextField:txtCompanyType])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Select Company Type..!"];
        return;
    }
    else if ([Validation validateTextField:txtIncorporateDate])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Incorporation Date..!"];
        return;
    }
    else if ([Validation validateTextField:txtTimeZone])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Time Zone..!"];
        return;
    }
    else if ([Validation validateTextField:txtCountry])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Select Country OR Enter Your Country Name below..!"];
        return;
    }
    
    else if ([Validation validateTextField:txtState])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your State..!"];
        return;
    }
    else if ([Validation validateTextField:txtCity])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your City..!"];
        return;
    }
    else if ([Validation validateTextField:txtArea])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your City Area..!"];
        return;
    }
    else if ([Validation validateTextField:txtAddress])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Address..!"];
        return;
    }
    else if ([Validation validateTextField:txtZipCode])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Zip / Postal Code..!"];
        return;
    }
    if (isValidate)
    {
        if (SharedObject.isNetAvailable)
        {
            [CommonUtility showProgressWithMessage:@"Please Wait.."];
            SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
            SellerGetInformation *objSellerInfo = [MBDataBaseHandler getSellerGetInformationData];
            
            NSMutableDictionary *dicParams = [[NSMutableDictionary alloc]init];
            [dicParams setValue:objSeller.APIVerificationCode forKey:@"Token"];
            [dicParams setValue:objSeller.VendorID forKey:@"VendorID"];
            [dicParams setValue:objSellerInfo.VendorCode forKey:@"VendorCode"];
            [dicParams setValue:txtBrandName.text forKey:@"VendorShortName"];
            [dicParams setValue:txtAddress.text forKey:@"Address"];
            [dicParams setValue:strAreaID forKey:@"AreaID"];
            [dicParams setValue:strTimeZoneCode forKey:@"TimeZone"];
            [dicParams setValue:txtCompanyName.text forKey:@"CompanyName"];
            [dicParams setValue:txtCompanyType.text forKey:@"CompanyType"];
            [dicParams setValue:txtCompanyPAN.text forKey:@"CompanyPANNo"];
            [dicParams setValue:txtGSTIN.text forKey:@"CompanyGST"];
            
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
             [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
             [dateFormatter setDateFormat:@"dd/MM/yyyy"];
             NSDate *date = [dateFormatter dateFromString:txtIncorporateDate.text];
             [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            
            NSString *datestring = [dateFormatter stringFromDate:date];
            [dicParams setValue:datestring forKey:@"IncorporationDate"];
            
            if ([txtCountryOther.text isEqualToString:[arrCountryData objectAtIndex:0]])
            {
                [dicParams setValue:txtCountryOther.text forKey:@"Country"];
                [dicParams setValue:txtCountryISD.text forKey:@"CountryCode"];
            }
            else if ([txtCity.text isEqualToString:[arrCityData objectAtIndex:0]])
            {
                [dicParams setValue:txtCityOthers.text forKey:@"City"];
                [dicParams setValue:txtCitySTD.text forKey:@"CityCode"];
            }
            else if ([txtState.text isEqualToString:[arrStateData objectAtIndex:0]])
            {
                [dicParams setValue:txtStateOthers.text forKey:@"State"];
            }
            else if ([txtArea.text isEqualToString:[arrAreaData objectAtIndex:0]])
            {
                [dicParams setValue:txtAreaOthers.text forKey:@"Area"];
            }
            else
            {
                [dicParams setValue:strCountryID forKey:@"Country"];
                [dicParams setValue:@"" forKey:@"CountryCode"];
                [dicParams setValue:strStateID forKey:@"State"];
                [dicParams setValue:strCityID forKey:@"City"];
                [dicParams setValue:@"" forKey:@"CityCode"];
                [dicParams setValue:strAreaID forKey:@"Area"];
            }
           
            [dicParams setValue:txtZipCode.text forKey:@"ZipCode"];
            
            MBCall_GetSellerUpdateCompanyDetailsWithAPI(dicParams, ^(id response, NSString *error, BOOL status)
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
}
-(IBAction)btnToolBarTapped:(UIButton *)sender
{
    [self.view endEditing:YES];
}
-(IBAction)btnCompanyTypeTaped:(UIButton *)sender
{
    NSLog(@" %ld ",(long)sender.tag);
    if (sender.tag == 0)
    {
        [CommonUtility showPopUpWithData:sender withArray:arrCompanyType withCompletion:^(NSInteger response)
        {
            [self->txtCompanyType setText:[self->arrCompanyType objectAtIndex:response]];

        } withDismissBlock:^{
        }];
    }
    if (sender.tag == 2)
    {
        NSMutableArray *arrTimeZoneList = [[NSMutableArray alloc]init];
        for (VendorTimeZone *objTimeZone in arrTimeZone)
        {
            [arrTimeZoneList addObject:objTimeZone.DisplayName];
        }
        
        [CommonUtility showPopUpWithData:sender withArray:arrTimeZoneList withCompletion:^(NSInteger response)
        {
            [self->txtTimeZone setText:[arrTimeZoneList objectAtIndex:response]];
            VendorTimeZone *objTimeZone = [self->arrTimeZone objectAtIndex:response];
            self->strTimeZoneCode = [NSString stringWithFormat:@"%@",objTimeZone.Id];
            
        } withDismissBlock:^{
            
        }];
    }
    else if (sender.tag == 3)
    {
        NSMutableArray *arrVendorCountry = [[NSMutableArray alloc]init];
        
        for (VendorCountryList *objCountryData in arrCountryData)
        {
            if ([objCountryData isKindOfClass:[NSString class]])
            {
                [arrVendorCountry insertObject:@"--- Select Country ---" atIndex:0];

            }
            else
            {
                 [arrVendorCountry addObject:objCountryData.CountryName];
            }
        }
        [CommonUtility showPopUpWithData:sender withArray:arrVendorCountry withCompletion:^(NSInteger response)
        {
            [self->txtCountry setText:[NSString stringWithFormat:@"%@",[arrVendorCountry objectAtIndex:response]]];
            if (response == 0)
            {
                self->strCountryID = @"0";
                [self->txtCountryOther setUserInteractionEnabled:YES];
                [self->txtCountryISD setUserInteractionEnabled:YES];
                [self->txtCountry setTextColor:[UIColor lightGrayColor]];
            }
            else
            {
                VendorCountryList *objCountryData = [self->arrCountryData objectAtIndex:response];
                self->strCountryID = [NSString stringWithFormat:@"%@",objCountryData.CountryID];
                [self->txtCountryOther setUserInteractionEnabled:NO];
                [self->txtCountryISD setUserInteractionEnabled:NO];
                [self->txtCountry setTextColor:[UIColor blackColor]];
            }
            [self getStateCityAreaListAccordingtoCountryName:self->txtCountry.text withIndex:0];
        } withDismissBlock:^{
        }];
    }
    else if (sender.tag == 4)
    {
        NSMutableArray *arrVendorState = [[NSMutableArray alloc]init];
        
        for (NSMutableDictionary *dicValue in arrStateData)
        {
            if ([dicValue isKindOfClass:[NSString class]])
            {
                [arrVendorState insertObject:@"--- Select State ---" atIndex:0];
                
            }
            else
            {
                [arrVendorState addObject:[dicValue valueForKey:@"StateName"]];
            }
        }
        if (arrStateData.count > 0)
        {
            [CommonUtility showPopUpWithData:sender withArray:arrVendorState withCompletion:^(NSInteger response)
            {
                [self->txtState setText:[NSString stringWithFormat:@"%@",[arrVendorState objectAtIndex:response]]];
                NSMutableDictionary *dicValue = [self->arrStateData objectAtIndex:response];
                if (response == 0)
                {
                    self->strStateID = @"0";
                    [self->txtStateOthers setUserInteractionEnabled:YES];
                    [self->txtState setTextColor:[UIColor lightGrayColor]];
                }
                else
                {
                    self->strStateID = [NSString stringWithFormat:@"%@",[dicValue valueForKey:@"StateID"]];
                    [self->txtStateOthers setUserInteractionEnabled:NO];
                    [self->txtState setTextColor:[UIColor blackColor]];
                    
                }
            
                [self getStateCityAreaListAccordingtoCountryName:self->txtState.text withIndex:1];
            } withDismissBlock:^{
            }];
        }
    }
    else if (sender.tag == 5)
    {
        NSMutableArray *arrVendorCity = [[NSMutableArray alloc]init];
        
        for (NSMutableDictionary *dicValue in arrCityData)
        {
            if ([dicValue isKindOfClass:[NSString class]])
            {
                [arrVendorCity insertObject:@"--- Select City ---" atIndex:0];
                
            }
            else
            {
                [arrVendorCity addObject:[dicValue valueForKey:@"CityName"]];
            }
        }
        if (arrCityData.count > 0)
        {
            [CommonUtility showPopUpWithData:sender withArray:arrVendorCity withCompletion:^(NSInteger response)
            {
                [self->txtCity setText:[NSString stringWithFormat:@"%@",[arrVendorCity objectAtIndex:response]]];
                 NSMutableDictionary *dicValue = [self->arrCityData objectAtIndex:response];
                
                if (response == 0)
                {
                    self->strCityID = @"0";
                    [self->txtCityOthers setUserInteractionEnabled:YES];
                    [self->txtCitySTD setUserInteractionEnabled:YES];
                    [self->txtCity setTextColor:[UIColor lightGrayColor]];
                }
                else
                {
                    self->strCityID = [NSString stringWithFormat:@"%@",[dicValue valueForKey:@"CityID"]];
                    [self->txtCityOthers setUserInteractionEnabled:NO];
                    [self->txtCitySTD setUserInteractionEnabled:NO];
                    [self->txtCity setTextColor:[UIColor blackColor]];
                }
                [self getStateCityAreaListAccordingtoCountryName:self->txtCity.text withIndex:2];
            } withDismissBlock:^{
            }];
        }
    }
    else if (sender.tag == 6)
    {
        NSMutableArray *arrVendorArea = [[NSMutableArray alloc]init];
        
        for (NSMutableDictionary *dicValue in arrAreaData)
        {
            if ([dicValue isKindOfClass:[NSString class]])
            {
                [arrVendorArea insertObject:@"--- Select Area ---" atIndex:0];
                
            }
            else
            {
                [arrVendorArea addObject:[dicValue valueForKey:@"AreaName"]];
            }
        }
        if (arrAreaData.count > 0)
        {
            [CommonUtility showPopUpWithData:sender withArray:arrVendorArea withCompletion:^(NSInteger response)
            {
                NSMutableDictionary *dicValue = [self->arrAreaData objectAtIndex:response];
                [self->txtArea setText:[NSString stringWithFormat:@"%@",[arrVendorArea objectAtIndex:response]]];
                if (response == 0)
                {
                    self->strAreaID = @"0";
                    [self->txtAreaOthers setUserInteractionEnabled:YES];
                    [self->txtArea setTextColor:[UIColor lightGrayColor]];
                }
                else
                {
                    self->strAreaID = [NSString stringWithFormat:@"%@",[dicValue valueForKey:@"AreaID"]];

                    [self->txtAreaOthers setUserInteractionEnabled:NO];
                    [self->txtArea setTextColor:[UIColor blackColor]];
                }
                
            } withDismissBlock:^{
            }];
        }
        
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 101 || textField.tag == 102 ||textField.tag == 103 || textField.tag == 104
        || textField.tag == 105 || textField.tag == 106)
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * strValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == txtCompanyPAN && strValue.length >= 11)
    {
        [txtCompanyPAN resignFirstResponder];
        return YES;
    }
    return YES;
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== GET COMMON DATA FROM DATABASE  ===❉===❉
/******************************************************************************************************************/

-(void)getCommonSupplierDataWithVendorIDfromDataBase
{
    CommonSupplierData *objCommonSupplierData = [MBDataBaseHandler getCommonSupplierData];
    arrCountryData = [[NSMutableArray alloc]init];
    arrCompanyType = [[NSMutableArray alloc]init];
    arrTimeZone = [[NSMutableArray alloc]init];

    for (VendorCountryList *objCountryData in objCommonSupplierData.Country)
    {
        [arrCountryData addObject:objCountryData];
    }
    [arrCountryData insertObject:@"--- Select Country ---" atIndex:0];

    for (VendorCompanyType *objCompanyData in objCommonSupplierData.CompanyType)
    {
        [arrCompanyType addObject:objCompanyData.CompanyType];
    }
    
    for (VendorTimeZone *objTimeZone in objCommonSupplierData.TimeZone)
    {
        [arrTimeZone addObject:objTimeZone];
    }
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== GET STATE FROM COUNTRY  ===❉===❉
/******************************************************************************************************************/
-(void)getStateCityAreaListAccordingtoCountryName:(NSString *)strName withIndex:(NSInteger)IndexValue
{
    SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
    
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc]init];
    [dicParams setValue:objSeller.APIVerificationCode forKey:@"Token"];
    
    if (IndexValue == 0)
    {
        [dicParams setValue:strName forKey:@"CountryName"];
    }
    else if (IndexValue == 1)
    {
        [dicParams setValue:strName forKey:@"StateName"];
    }
    else if (IndexValue == 2)
    {
        [dicParams setValue:strName forKey:@"CityName"];
    }
    
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait.."];
        
        MBCall_GetStateCityAreaListAccordingtoCountryNameAPI(dicParams,IndexValue,^(id response, NSString *error, BOOL status)
        {
            if (status && [[response valueForKey:@"success"]isEqual:@1])
            {
                [CommonUtility HideProgress];
                
                if (IndexValue == 0)
                {
                    self->arrStateData = [[NSMutableArray alloc]init];
                    
                    for (NSMutableDictionary *dicValue in [response valueForKey:@"detail"])
                    {
                        [self->arrStateData addObject:dicValue];
                        
                    }
                    [self->arrStateData insertObject:@"--- Select State ---" atIndex:0];
                    SAVE_USER_DEFAULTS(self->arrStateData , @"detail");
                }
                else if (IndexValue == 1)
                {
                    self->arrCityData = [[NSMutableArray alloc]init];
                    for (NSMutableDictionary *dicValue in [response valueForKey:@"detail"])
                    {
                        [self->arrCityData addObject:dicValue];
                    }
                    [self->arrCityData insertObject:@"--- Select City ---" atIndex:0];
                    SAVE_USER_DEFAULTS(self->arrCityData , @"CityDetail");
                }
                else if (IndexValue == 2)
                {
                    self->arrAreaData = [[NSMutableArray alloc]init];
                    
                    for (NSMutableDictionary *dicValue in [response valueForKey:@"detail"])
                    {
                        [self->arrAreaData addObject:dicValue];
                    }
                    [self->arrAreaData insertObject:@"--- Select Area ---" atIndex:0];
                    SAVE_USER_DEFAULTS(self->arrAreaData , @"AreaDetail");

                }
                
            }
            else
            {
                [CommonUtility HideProgress];
               // [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:[response valueForKey:@"message"]];
                
            }
        });
    }
    else
    {
        [CommonUtility HideProgress];
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Internet Not Available Please Try Again..!"];
    }
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== GET COMMON DATA FROM DATABASE  ===❉===❉
/******************************************************************************************************************/

-(void)getSupplierCompanyDetailsWithData
{
    SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
    
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc]init];
    [dicParams setValue:objSeller.APIVerificationCode forKey:@"Token"];
    [dicParams setValue:objSeller.VendorID forKey:@"VendorID"];
    
    if (SharedObject.isNetAvailable)
    {
        [CommonUtility showProgressWithMessage:@"Please Wait.."];
        
        MBCall_GetSellerCompanyDetailsWithAPI(dicParams, ^(id response, NSString *error, BOOL status)
      {
          if (status && [[response valueForKey:@"success"]isEqual:@1])
          {
              [CommonUtility HideProgress];
              
              NSMutableDictionary *dicValue = [[NSMutableDictionary alloc]init];
              dicValue = [[response valueForKey:@"detail"] mutableCopy];
              [self->txtCompanyName setText:[dicValue valueForKey:@"CompanyName"]];
              [self->txtBrandName setText:[dicValue valueForKey:@"VendorShortName"]];
              [self->txtCompanyPAN setText:[dicValue valueForKey:@"CompanyPANNo"]];
              [self->txtGSTIN setText:[dicValue valueForKey:@"CompanyIEC"]];
              [self->txtCompanyType setText:[dicValue valueForKey:@"CompanyType"]];
              [self->txtIncorporateDate setText:[dicValue valueForKey:@"DateOfIncorporation"]];
              
              for (VendorTimeZone *objTimeZone in self->arrTimeZone)
              {
                  if ([objTimeZone.Id isEqualToString:[dicValue valueForKey:@"SellerTimeZone"]])
                  {
                       [self->txtTimeZone setText:objTimeZone.DisplayName];
                  }
              }
              for (VendorCountryList *objCountryData in self->arrCountryData)
              {
                  if ([objCountryData isKindOfClass:[NSString class]])
                  {
                      
                  }
                  else
                  {
                      if (objCountryData.CountryID == [dicValue valueForKey:@"CountryID"])
                      {
                          [self->txtCountry setText:objCountryData.CountryName];
                          [self getStateCityAreaListAccordingtoCountryName:objCountryData.CountryName withIndex:0];
                      }
                  }
              }

              if ([[dicValue valueForKey:@"CountryName"] isKindOfClass:[NSNull class]])
              {
                  [self->txtCountryOther setText:@""];
              }
              else
              {
                  [self->txtCountryOther setText:[dicValue valueForKey:@"CountryName"]];
              }
              [self->txtCountryISD setText:[dicValue valueForKey:@""]];
              
              NSMutableArray *arrStateValue = GET_USER_DEFAULTS(@"detail");
              
              for (NSMutableDictionary *dicStateValue in arrStateValue)
              {
                  if ([dicStateValue isKindOfClass:[NSString class]])
                  {
                      
                      
                  }
                  else
                  {
                      if ([dicStateValue valueForKey:@"StateID"] == [dicValue valueForKey:@"StateID"])
                      {
                          [self->txtState setText:[dicStateValue valueForKey:@"StateName"]];
                          [self getStateCityAreaListAccordingtoCountryName:self->txtState.text withIndex:1];
                      }
                  }
              }
              
              [self->txtState setText:[dicValue valueForKey:@""]];
              
              if ([[dicValue valueForKey:@"StateName"] isKindOfClass:[NSNull class]])
              {
                  [self->txtStateOthers setText:@""];
              }
              else
              {
                  [self->txtStateOthers setText:[dicValue valueForKey:@"StateName"]];
              }
              
              NSMutableArray *arrCityValue = GET_USER_DEFAULTS(@"CityDetail");
              
              for (NSMutableDictionary *dicCityValue in arrCityValue)
              {
                  if ([dicCityValue isKindOfClass:[NSString class]])
                  {
                      
                      
                  }
                  else
                  {
                      if ([dicCityValue valueForKey:@"CityID"] == [dicValue valueForKey:@"CityID"])
                      {
                          [self->txtCity setText:[dicCityValue valueForKey:@"CityName"]];
                          [self getStateCityAreaListAccordingtoCountryName:self->txtCity                                                                                                                                                                        .text withIndex:1];
                      }
                  }
              }
              if ([[dicValue valueForKey:@"CityName"] isKindOfClass:[NSNull class]])
              {
                  [self->txtCityOthers setText:@""];
              }
              else
              {
                  [self->txtCityOthers setText:[dicValue valueForKey:@"CityName"]];
              }
              [self->txtCitySTD setText:[dicValue valueForKey:@""]];
              
              NSMutableArray *arrAreaDetail = GET_USER_DEFAULTS(@"AreaDetail");
              
              for (NSMutableDictionary *dicAreaDetail in arrAreaDetail)
              {
                  if ([dicAreaDetail isKindOfClass:[NSString class]])
                  {
                      
                      
                  }
                  else
                  {
                      if ([dicAreaDetail valueForKey:@"AreaID"] == [dicValue valueForKey:@"AreaID"])
                      {
                          [self->txtArea setText:[dicAreaDetail valueForKey:@"AreaName"]];
                          [self getStateCityAreaListAccordingtoCountryName:self->txtCity                                                                                                                                                                        .text withIndex:1];
                      }
                  }
              }
              [self->txtAreaOthers setText:[dicValue valueForKey:@""]];
              
              [self->txtAddress setText:[[dicValue valueForKey:@"Address"]checkIfEmpty]];
              [self->txtZipCode setText:[[dicValue valueForKey:@"ZipCode"]checkIfEmpty]];
              
          }
          else
          {
              [CommonUtility HideProgress];
              [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:[response valueForKey:@"message"]];
              
          }
      });
    }
}



@end
