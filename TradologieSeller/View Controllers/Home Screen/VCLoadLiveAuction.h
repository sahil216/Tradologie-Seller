//
//  VCLoadLiveAuction.h
//  TradologieSeller
//
//  Created by Chandresh Maurya on 06/07/18.
//  Copyright © 2018 Tradologie.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstant.h"

@interface VCLoadLiveAuction : UIViewController

@property (nonatomic, strong) NSString *strUrlForLiveAuction;
@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) id <WKUIDelegate> webViewUIDelegate;

@end
