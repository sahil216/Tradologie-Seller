//
//  TVSupplierDocument.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 12/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVSupplierDocument.h"
#import "AppConstant.h"
#import "Constant.h"

@interface TVSupplierDocument ()<THSegmentedPageViewControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate>

@end

@implementation TVSupplierDocument

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [btnUploadPC setDefaultButtonStyle];
    [btnUploadRC setDefaultButtonStyle];
    [btnUploadRP setDefaultButtonStyle];
    [btnUploadMOA setDefaultButtonStyle];

    [self setTextViewDefaultStyleWithBorder:txtViewRC];
    [self setTextViewDefaultStyleWithBorder:txtViewRP];
    [self setTextViewDefaultStyleWithBorder:txtViewPC];
    [self setTextViewDefaultStyleWithBorder:txtViewMOA];

    [ViewBGPC SetDefaultShadowBackGround];
    [ViewBGRP SetDefaultShadowBackGround];
    [ViewBGRC SetDefaultShadowBackGround];
    [ViewBGMOA SetDefaultShadowBackGround];

    
   
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
    return 4;
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
-(void)setTextViewDefaultStyleWithBorder:(UITextView *)txtview
{
    txtview.text = @"Enter text here..";
    [txtview setTextColor:GET_COLOR_WITH_RGB(176, 176, 176, 1)];
    [txtview setTintColor:DefaultThemeColor];
    [txtview setKeyboardAppearance:UIKeyboardAppearanceDark];
    [txtview.layer setCornerRadius:5.0f];
    [txtview.layer setBorderWidth:1.0f];
}

//==============================================================================================================
#pragma mark- UITextView Delegates Called here
//==============================================================================================================

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Enter text here.."])
    {
        textView.text = @"";
        [textView setTextColor:[UIColor darkTextColor]];
    }
    [textView becomeFirstResponder];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
    {
        textView.text = @"Enter text here..";
        [textView setTextColor:GET_COLOR_WITH_RGB(176, 176, 176, 1)];
        [textView resignFirstResponder];
    }
    else
    {
        [textView resignFirstResponder];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        if([textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
        {
            textView.text = @"Enter text here..";
            [textView setTextColor:GET_COLOR_WITH_RGB(176, 176, 176, 1)];
            [textView resignFirstResponder];
        }
        return NO;
    }
    return YES;
}
@end
