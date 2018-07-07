//
//  VCLoadLiveAuction.m
//  TradologieSeller
//
//  Created by Chandresh Maurya on 06/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import "VCLoadLiveAuction.h"
#import "CommonUtility.h"

@interface VCLoadLiveAuction ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>

@end

@implementation VCLoadLiveAuction

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setNavigationTittleWithLogoforLanscapeMode:@"tradologie.com"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem SetBackButtonWithID:self withSelectorAction:@selector(btnBackFromLiveAuctionScreen:)];
    
    [self SetInitialSetUp];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
}
/******************************************************************************************************************/
#pragma mark ❉===❉=== SET INITIAL SETUP ===❉===❉
/*****************************************************************************************************************/

-(void)SetInitialSetUp
{
    CGRect webViewBounds = self.view.bounds;
    
    WKUserContentController* userContentController = [[WKUserContentController alloc] init];
    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, webViewBounds.size.width,webViewBounds.size.height) configuration:configuration];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrlForLiveAuction]]];
    
    [self.view addSubview:self.webView];
    [self.view sendSubviewToBack:self.webView];
    
    
    CGFloat bottom =  webViewBounds.size.height - 275;
    NSLog(@"%f",bottom);
    
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, bottom, bottom);
    
    [CommonUtility showProgressWithMessage:@"Please Wait"];
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== WKWEBVIEW DELEGATE CALLED HERE ===❉===❉
/*****************************************************************************************************************/

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
    [CommonUtility HideProgress];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
    [CommonUtility HideProgress];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (webView && webView.URL)
    {
        [CommonUtility HideProgress];
        [self.webView.scrollView setMaximumZoomScale:100.0f];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"URL: %@", [navigationAction.request.URL description]);
    decisionHandler(WKNavigationActionPolicyAllow);
}

/******************************************************************************************************************/
#pragma mark ❉===❉=== BUTTON ACTION EVENT CALLED HERE ===❉===❉
/*****************************************************************************************************************/
-(IBAction)btnBackFromLiveAuctionScreen:(UIButton *)sender
{
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    [self.navigationItem setNavigationTittleWithLogo:@"tradologie.com"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        RootViewController * rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
        AppDelegate *delegateClass = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [delegateClass setRootViewController:rootVC];
    });
}
@end
