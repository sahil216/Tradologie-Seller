//
//  TVLegalDocumentScreen.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 13/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "TVLegalDocumentScreen.h"
#import "Constant.h"
#import "AppConstant.h"

@interface TVLegalDocumentScreen ()<THSegmentedPageViewControllerDelegate>

@end

@implementation TVLegalDocumentScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [btnSaveDoc setDefaultButtonStyle];
    [btnSaveDoc.titleLabel setFont:IS_IPHONE5? UI_DEFAULT_FONT_BOLD(12):UI_DEFAULT_FONT_BOLD(20)];
    [btnUploadSellerDoc setDefaultButtonStyle];
    [btnUploadSellerDoc.titleLabel setFont:IS_IPHONE5? UI_DEFAULT_FONT_BOLD(12):UI_DEFAULT_FONT_BOLD(18)];


}

- (void)didReceiveMemoryWarning {
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
    return 7;
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
@end
