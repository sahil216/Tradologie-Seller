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

@interface TVCompanyDetails ()<THSegmentedPageViewControllerDelegate>

@end

@implementation TVCompanyDetails

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [txtCompanyName setDefaultTextfieldStyleWithPlaceHolder:@"Your Company Name" withTag:0];
    [txtBrandName setDefaultTextfieldStyleWithPlaceHolder:@"Your Brand Name" withTag:0];
    [txtCompanyPAN setDefaultTextfieldStyleWithPlaceHolder:@"Your Company PAN No" withTag:0];
    [txtGSTIN setDefaultTextfieldStyleWithPlaceHolder:@"Your Company Registration No / GSTIN" withTag:0];
    [txtCompanyType setDefaultTextfieldStyleWithPlaceHolder:@"--- Select Company Type ---" withTag:0];
    [txtIncorporateDate setDefaultTextfieldStyleWithPlaceHolder:@"--- Select Incorporation Date ---" withTag:0];
    [txtTimeZone setDefaultTextfieldStyleWithPlaceHolder:@"--- Select Time Zone ---" withTag:0];
    [txtCountry setDefaultTextfieldStyleWithPlaceHolder:@"--- Select Country ---" withTag:0];
    [txtCountryOther setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    [txtCountryISD setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    [txtState setDefaultTextfieldStyleWithPlaceHolder:@"--- Select State ---" withTag:0];
    [txtStateOthers setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    [txtCity setDefaultTextfieldStyleWithPlaceHolder:@"--- Select City ---" withTag:0];
    [txtCityOthers setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    [txtCitySTD setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    [txtArea setDefaultTextfieldStyleWithPlaceHolder:@"--- Select Area ---" withTag:0];
    [txtAreaOthers setDefaultTextfieldStyleWithPlaceHolder:@"" withTag:0];
    [txtAddress setDefaultTextfieldStyleWithPlaceHolder:@"Your Address" withTag:0];
    [txtZipCode setDefaultTextfieldStyleWithPlaceHolder:@"Your ZipCode" withTag:0];
    
    [btnSubmit setDefaultButtonShadowStyle:DefaultThemeColor];
    [btnSubmit.titleLabel setFont:IS_IPHONE5?UI_DEFAULT_FONT_MEDIUM(18): UI_DEFAULT_FONT_MEDIUM(20)];
    [btnSubmit addTarget:self action:@selector(btnSubmitCompanyDetail:) forControlEvents:UIControlEventTouchUpInside];
    
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
@end
