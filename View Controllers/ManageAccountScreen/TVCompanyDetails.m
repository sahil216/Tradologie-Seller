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
}
@end

@implementation TVCompanyDetails

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [txtCompanyName setDefaultTextfieldStyleWithPlaceHolder:@"Your Company Name" withTag:0];
    [txtBrandName setDefaultTextfieldStyleWithPlaceHolder:@"Your Brand Name" withTag:0];
    [txtCompanyPAN setDefaultTextfieldStyleWithPlaceHolder:@"Your Company PAN No" withTag:0];
    [txtGSTIN setDefaultTextfieldStyleWithPlaceHolder:@"Your Company Registration No / GSTIN" withTag:0];
    [txtCompanyType setAdditionalInformationTextfieldStyle:@"--- Select Company Type ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnCompanyTypeTaped:) withTag:0];
    
    [txtIncorporateDate setRightViewTextfieldStyleWithCalender:@"--- Select Incorporation Date ---" Withimage:@"IconCalender" withTag:0];

    [txtTimeZone setAdditionalInformationTextfieldStyle:@"--- Select Time Zone ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnCompanyTypeTaped:) withTag:0];
    [txtCountry setAdditionalInformationTextfieldStyle:@"--- Select Country ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnCompanyTypeTaped:) withTag:0];
    [txtCountryOther setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    [txtCountryISD setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    
    [txtState setAdditionalInformationTextfieldStyle:@"--- Select State ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnCompanyTypeTaped:) withTag:0];
    [txtStateOthers setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    
    [txtCity setAdditionalInformationTextfieldStyle:@"--- Select City ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnCompanyTypeTaped:) withTag:0];
    
    [txtCityOthers setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    [txtCitySTD setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    
    [txtArea setAdditionalInformationTextfieldStyle:@"--- Select Area ---" Withimage:IMAGE(@"IconDropDrown") withID:self withSelectorAction:@selector(btnCompanyTypeTaped:) withTag:0];
    
    [txtAreaOthers setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    [txtAddress setDefaultTextfieldStyleWithPlaceHolder:@"Your Address" withTag:0];
    [txtZipCode setDefaultTextfieldStyleWithPlaceHolder:@"Your ZipCode" withTag:0];
    
    [btnSubmit setDefaultButtonShadowStyle:DefaultThemeColor];
    [btnSubmit.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    [btnSubmit addTarget:self action:@selector(btnSubmitCompanyDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setDefaultToolbarAndDatePickerWithTextfield:txtIncorporateDate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
}
-(IBAction)btnToolBarTapped:(UIButton *)sender
{
    [self.view endEditing:YES];
}
-(IBAction)btnCompanyTypeTaped:(UIButton *)sender
{
    NSMutableArray *arrCompanyType = [[NSMutableArray alloc]initWithObjects:@"Limited",@"Private Limited",@"Proprietary",@"Partnership",nil];
    
    if (txtCompanyType.tag == 0)
    {
        [CommonUtility showPopUpWithData:sender withArray:arrCompanyType withCompletion:^(NSInteger response)
         {
             [self->txtCompanyType setText:[arrCompanyType objectAtIndex:response]];
         } withDismissBlock:^{
         }];
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
