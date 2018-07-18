
//
//  TVBankDetailScreen.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 13/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVBankDetailScreen.h"
#import "Constant.h"
#import "AppConstant.h"


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
}

- (void)didReceiveMemoryWarning
{
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

@end
