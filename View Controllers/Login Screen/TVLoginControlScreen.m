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

@interface TVLoginControlScreen ()<THSegmentedPageViewControllerDelegate,UITextFieldDelegate>

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
    
}

@end
