//
//  VCAuthorizedPersonal.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 12/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "VCAuthorizedPersonal.h"
#import "Constant.h"
#import "AppConstant.h"
#import "CommonUtility.h"
#import "MBAPIManager.h"
#import "MBDataBaseHandler.h"
#import "SharedManager.h"

#define K_CUSTOM_WIDTH 200

@interface VCAuthorizedPersonal ()<THSegmentedPageViewControllerDelegate,TVCellAuthorizedPersonDelegate,
UITextFieldDelegate ,TVCellSavePersonDelegate>
{
    NSMutableArray *arrInfoTittle;
    NSMutableArray *arrPlaceHolder;
    NSMutableArray *arrHeaderTittle;
    NSMutableArray *arrAuthorizeData;
    
    BOOL isOpenSection;
    NSInteger isEditCalled;
    
    NSMutableDictionary *dicValue;
    float headerTotalWidth;
    UILabel *headLabel;
    CGFloat height , lblHeight;
    NSInteger count;

}
@property (nonatomic, strong) UIView * contentView;

@end

@implementation VCAuthorizedPersonal

- (void)viewDidLoad
{
    [super viewDidLoad];
     arrInfoTittle = [[NSMutableArray alloc]initWithObjects:@"Authorize Person Name *",@"Email-ID *",@"Mobile *",@"Designation *", nil];
     arrPlaceHolder = [[NSMutableArray alloc]initWithObjects:@"Authorize Person Name",@"Your Email-ID",@"Your Mobile Number",@"Your Designation", nil];
    
    arrHeaderTittle = [[NSMutableArray alloc]initWithObjects:@" Sr.No",@"Authorize Person Name",@"Designation",@"Mobile Number",@"Email ID",@"  Is Active",nil];
    
    lblHeight  = 60;
    count = 0;
    [self setInitialSetupWithUITextfield];
    dicValue = [[NSMutableDictionary alloc]init];
    [self getAuthorizePersonListFromDataBase];
    isEditCalled = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isOpenSection = NO;
    [self.tblPersonInfo reloadData];
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== SET INITIAL SETUP FOR UI ===❉===❉
/*****************************************************************************************************************/

-(void)setInitialSetupWithUITextfield
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0 , SCREEN_WIDTH , SCREEN_HEIGHT - 20)];
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_contentView];
    
    headerTotalWidth =  ([arrHeaderTittle count] * K_CUSTOM_WIDTH);
    
    height = ([SDVersion deviceSize] > Screen4Dot7inch)?_contentView.frame.size.height - 75:([SDVersion deviceSize] < Screen4Dot7inch)?_contentView.frame.size.height - 65:_contentView.frame.size.height - 90;
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, headerTotalWidth, height) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.bounces=NO;
    self.tblPersonInfo = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIScrollView *myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 5, _contentView.frame.size.width, _contentView.frame.size.height)];
    myScrollView.bounces=NO;
    [myScrollView setBackgroundColor:[UIColor whiteColor]];
    [myScrollView addSubview:tableView];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    myScrollView.contentSize = CGSizeMake(headerTotalWidth, 0);
    [_contentView addSubview:myScrollView];
    
    [self.tblPersonInfo registerNib:[UINib nibWithNibName:@"TVCellPersonAuthorize" bundle:nil] forCellReuseIdentifier:@"Cell_Upload_Identifier"];
    
    [self.tblPersonInfo registerNib:[UINib nibWithNibName:@"TVCellAuthorizePerson" bundle:nil] forCellReuseIdentifier:@"CellPersonalIdentifier"];
}


/******************************************************************************************************************/
#pragma mark ❉===❉=== TABLEVIEW DELEGATE & DATA SOURCE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if(isOpenSection)
        {
            return arrInfoTittle.count + 1;
        }
        else
        {
            return 0;
        }
    }
    else if (section == 1)
    {
        return (self->arrAuthorizeData.count > 0)?self->arrAuthorizeData.count:0;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"";
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 4)
        {
             cellIdentifier = @"Cell_Upload_Identifier";
            TVCellPersonAuthorize *cell = (TVCellPersonAuthorize *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

            if(!cell)
            {
                cell = [[TVCellPersonAuthorize alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell ConfigureUploadPersonInfoPicCellwithSectionIndex:indexPath.row];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            [cell.btnSubmitAuthorized addTarget:self action:@selector(btnSubmitAuthorizedTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setDelegate:self];
            
            return cell;
        }
        else
        {
            cellIdentifier=@"CellPersonalIdentifier";
            
            TVCellAuthorizePerson *cell = (TVCellAuthorizePerson *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell)
            {
                cell = [[TVCellAuthorizePerson alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            [cell ConfigureAuthorizedPersonInfoCellwithData:[arrInfoTittle objectAtIndex:indexPath.row] withPlaceholder:[arrPlaceHolder objectAtIndex:indexPath.row] withIndex: indexPath];
          
            [cell.txtInfoField setDelegate:self];

            return cell;
        }
    }
    
    cellIdentifier=@"Cell_List_ID";
    
    TVSaveAuthorizePerson *cell = (TVSaveAuthorizePerson *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[TVSaveAuthorizePerson alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier itemSize:CGSizeMake(K_CUSTOM_WIDTH, lblHeight) headerArray:arrHeaderTittle];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [cell setDataDict:[self->arrAuthorizeData objectAtIndex:indexPath.row]];
    [cell setDelegate:self];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.section == 0)
   {
       if (indexPath.row == 4)
       {
           return 175;
       }
       return 80;
   }
    return lblHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
        [viewHeader setBackgroundColor:[UIColor whiteColor]];
        
        UIView *ViewBG = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, 60)];
        [ViewBG setShadowBackGroundWithColor:[UIColor whiteColor]];
        [ViewBG setBackgroundColor:[UIColor whiteColor]];
        [ViewBG.layer setBorderColor:DefaultThemeColor.CGColor];
        
        [self getLableAccordingtoView:ViewBG withTittle:@" ADD NEW AUTHORIZATION" withFrame:CGRectMake(5, 5,ViewBG.frame.size.width - 50, 50) withSize:18 withTextColor:[UIColor orangeColor] withAlignment:NSTextAlignmentLeft];
        
        UIButton *btnCollapse = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCollapse setFrame:CGRectMake(ViewBG.frame.size.width - 50, 15, 30, 30)];
        [btnCollapse setBackgroundColor:[UIColor clearColor]];
        
        if (isOpenSection)
        {
            [btnCollapse setImage:IMAGE(@"IconCloseCell") forState:UIControlStateNormal];
        }
        else
        {
            [btnCollapse setImage:IMAGE(@"IconOpenCell") forState:UIControlStateNormal];

        }
        [btnCollapse addTarget:self action:@selector(touchedSection:) forControlEvents:UIControlEventTouchUpInside];
        btnCollapse.tag = section;
        
        [ViewBG addSubview:btnCollapse];
        [viewHeader addSubview:ViewBG];
        
        return viewHeader;
    }
    UIView *viewHeaderSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, headerTotalWidth, 80)];
    [viewHeaderSection setBackgroundColor:[UIColor clearColor]];
    
    UIView *ViewBG2 = [[UIView alloc]initWithFrame:CGRectMake(5, 5, headerTotalWidth - 50, 60)];
    [ViewBG2 SetDefaultShadowBackGround];
    [ViewBG2 setBackgroundColor:DefaultThemeColor];
    [ViewBG2.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    
    int xx = 5;
    int width = 80;
    
    for(int i = 0 ; i < [arrHeaderTittle count] ; i++)
    {
        headLabel=[[UILabel alloc]initWithFrame:CGRectMake(xx, 5, width, ViewBG2.frame.size.height - 10)];
        [headLabel setText:[arrHeaderTittle objectAtIndex:i]];
        [headLabel setNumberOfLines:0];
        [headLabel setTextColor:[UIColor whiteColor]];
        [headLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [headLabel setFont:UI_DEFAULT_FONT_MEDIUM(18)];
        [ViewBG2 addSubview:headLabel];

        xx = xx + width + 10;
        
        if (i == 0)
        {
            width = K_CUSTOM_WIDTH + 50;
            [headLabel setTextAlignment:NSTextAlignmentLeft];
        }
        else if (i == arrHeaderTittle.count - 2)
        {
            width = K_CUSTOM_WIDTH - 60;
            [headLabel setTextAlignment:NSTextAlignmentLeft];
        }
        else
        {
            width = K_CUSTOM_WIDTH;
            [headLabel setTextAlignment:NSTextAlignmentLeft];
        }
    }
    [viewHeaderSection addSubview:ViewBG2];
    return viewHeaderSection;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 75;
    }
    return 80;
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== GET LABLE FOR HEADER HERE ===❉===❉
/*****************************************************************************************************************/

-(void)getLableAccordingtoView:(UIView *)viewBG withTittle:(NSString *)strTittle withFrame:(CGRect)frame withSize:(NSInteger)fontSize withTextColor:(UIColor *)color withAlignment:(NSTextAlignment )align
{
    UILabel *lblbHeaderTittle= [[UILabel alloc]initWithFrame:frame];
    [lblbHeaderTittle setText:strTittle];
    [lblbHeaderTittle setFont:UI_DEFAULT_FONT_BOLD(fontSize)];
    [lblbHeaderTittle setTextColor:color];
    [lblbHeaderTittle setTextAlignment:align];
    [lblbHeaderTittle setBackgroundColor:[UIColor clearColor]];
    [lblbHeaderTittle setNumberOfLines:0];
    [lblbHeaderTittle setLineBreakMode:NSLineBreakByWordWrapping];
    [viewBG addSubview:lblbHeaderTittle];
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== THSegmentedPageViewControllerDelegate ===❉===❉
/*****************************************************************************************************************/
-(NSString *)viewControllerTitle
{
    return _strManageAcTittle;
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== BUTTON ACTION EVENT CALLED HERE===❉===❉
/*****************************************************************************************************************/

- (IBAction)touchedSection:(id)sender
{
    UIButton *btnSection = (UIButton *)sender;
    
    NSInteger section = btnSection.tag;
    
    if(btnSection.tag == section)
    {
        NSLog(@"Touched Customers header");
        if(!isOpenSection)
        {
            isOpenSection = YES;
            [sender setImage:IMAGE(@"IconCloseCell") forState:UIControlStateNormal];

            [self reloadTableInputViewsWithSection:section];
        }
        else
        {
            isOpenSection = NO;
            [sender setImage:IMAGE(@"IconOpenCell") forState:UIControlStateNormal];
            [self reloadTableInputViewsWithSection:section];
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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    SellerUserDetail *objSeller = [MBDataBaseHandler getSellerUserDetailData];
    [dicValue setValue:objSeller.APIVerificationCode forKey:@"Token"];
    [dicValue setValue:objSeller.VendorID forKey:@"VendorID"];
    
    if (textField.tag == 10)
    {
        [dicValue setValue:textField.text forKey:@"PersonName"];
    }
    else if (textField.tag == 11)
    {
        [dicValue setValue:textField.text forKey:@"Email"];
    }
    else if (textField.tag == 12)
    {
        [dicValue setValue:textField.text forKey:@"Mobile"];
    }
    else if (textField.tag == 13)
    {
        [dicValue setValue:textField.text forKey:@"Designation"];
    }
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== CELL DELEGATE CALLED HERE ===❉===❉
/*****************************************************************************************************************/
-(void)saveAuthorizePersonDetail:(BOOL)isEnable
{
    if (isEnable)
    {
        [dicValue setValue:@1 forKey:@"IsActive"];
    }
    else
    {
        [dicValue setValue:@0 forKey:@"IsActive"];
    }
}
- (void)setAuthorizePersionDetailWithData:(UIButton *)sender withIndex:(NSIndexPath *)index withEdit:(NSInteger)Isslected
{
    AuthorizePersonList *objAuthorize = [MBDataBaseHandler getAuthorizePersonListWithData];
    AuthorizePersonData *objAuthdata = [objAuthorize.detail objectAtIndex:index.row];
    isEditCalled = Isslected;
    if (isEditCalled == 0)
    {
        [dicValue setValue:@"0" forKey:@"AuthorizedPersonID"];
    }
    else
    {
        [dicValue setValue:objAuthdata.AuthorizedPersonID forKey:@"AuthorizedPersonID"];
        isOpenSection = YES;
        [self reloadTableInputViewsWithSection:0];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AuthorizedPersonDetail" object:objAuthdata];

    }
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== BUTTON ACTION EVENT CALLED HERE ===❉===❉
/******************************************************************************************************************/
-(IBAction)btnSubmitAuthorizedTapped:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    BOOL isValidate=TRUE;
    
    if (![Validation textFieldLength:[dicValue valueForKey:@"PersonName"]])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter Authorize Person Name..!"];
        return;
    }
    else if (![Validation textFieldLength:[dicValue valueForKey:@"Email"]])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Brand Name..!"];
        return;
    }
    else if (![Validation validateEmail:[dicValue valueForKey:@"Email"]])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter a valid Email Id..!"];
        return;
    }
    
    else if (![Validation textFieldLength:[dicValue valueForKey:@"Mobile"]])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter your Mobile Number..!"];
        return;
    }
    else if (![Validation validatePhoneNumber:[dicValue valueForKey:@"Mobile"]])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter a valid Mobile Number with Country Code..!"];
        return;
    }
    else if (![Validation textFieldLength:[dicValue valueForKey:@"Designation"]])
    {
        [[CommonUtility new] show_ErrorAlertWithTitle:@"" withMessage:@"Please Enter Designation..!"];
        return;
    }
    
    
    if (isValidate)
    {
        if (SharedObject.isNetAvailable)
        {
            [CommonUtility showProgressWithMessage:@"Please Wait.."];
            
            MBCall_SaveAuthorizePersonDetailAPI(dicValue, ^(id response, NSString *error, BOOL status)
            {
                if (status && [[response valueForKey:@"success"]isEqual:@1])
                {
                    [CommonUtility HideProgress];
                    
                    NSError *error;
                    AuthorizePersonList *objAuthorize = [[AuthorizePersonList alloc]initWithDictionary:response error:&error];
                    [MBDataBaseHandler saveAuthorizePersonListData:objAuthorize];
                    
                    [self getAuthorizePersonListFromDataBase];
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
/******************************************************************************************************************/
#pragma mark ❉===❉=== RELOAD DATA HERE ===❉===❉
/*****************************************************************************************************************/
-(void)reloadTableInputViewsWithSection:(NSInteger )section
{
    NSRange range = NSMakeRange(section, 1);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tblPersonInfo reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
}

-(void)getAuthorizePersonListFromDataBase
{
    AuthorizePersonList *objAuthorize = [MBDataBaseHandler getAuthorizePersonListWithData];
    
    self->arrAuthorizeData = [[NSMutableArray alloc]init];
    
    for (AuthorizePersonData *objAuthdata in objAuthorize.detail)
    {
        NSMutableDictionary *dataDict = [NSMutableDictionary new];
        self->count ++;
        
        [dataDict setObject:[NSString stringWithFormat:@"%ld",(long)self->count] forKey:[self->arrHeaderTittle objectAtIndex:0]];
        [dataDict setObject:objAuthdata.AuthorizePersonName forKey:[self->arrHeaderTittle objectAtIndex:1]];
        [dataDict setObject:objAuthdata.Designation forKey:[self->arrHeaderTittle objectAtIndex:2]];
        [dataDict setObject:objAuthdata.MobileNo forKey:[self->arrHeaderTittle objectAtIndex:3]];
        [dataDict setObject:objAuthdata.EmailID forKey:[self->arrHeaderTittle objectAtIndex:4]];
        [dataDict setObject:objAuthdata.IsActive forKey:[self->arrHeaderTittle objectAtIndex:5]];
        
        [self->arrAuthorizeData addObject:dataDict];
    }
    [self reloadTableInputViewsWithSection:1];
}

@end
