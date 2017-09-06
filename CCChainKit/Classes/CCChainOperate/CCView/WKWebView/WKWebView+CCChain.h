//
//  WKWebView+CCChain.h
//  CCChainKit
//
//  Created by 冯明庆 on 27/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <WebKit/WebKit.h>

@class CCScriptMessageDelegate;

@interface WKWebView (CCChain)

@property (nonatomic , class , copy , readonly) __kindof WKWebView *(^common)(CGRect frame);
@property (nonatomic , class , copy , readonly) __kindof WKWebView *(^commonC)(CGRect frame , WKWebViewConfiguration *configuration);
@property (nonatomic , copy , readonly) __kindof WKWebView *(^navigationDelegateT)(id <WKNavigationDelegate> delegate);

@property (nonatomic , copy , readonly) __kindof WKWebView *(^script)(CCScriptMessageDelegate *delegate , NSString *sKey);

/// Only "http://" && "https://" will be loaded online .
/// others will be loading as HTML content .
@property (nonatomic , copy , readonly) __kindof WKWebView *(^loading)(NSString *sLink , void (^)(WKNavigation *navigation));

@property (nonatomic , copy , readonly) __kindof WKWebView *(^request)(NSString *sLink , void (^)(WKNavigation *navigation)); // loading as links
@property (nonatomic , copy , readonly) __kindof WKWebView *(^content)(NSString *sContent , void (^)(WKNavigation *navigation)); // loading as HTML content

@end

#pragma mark - -----

@interface CCScriptMessageDelegate : NSObject < WKScriptMessageHandler >

@property (nonatomic , assign) id < WKScriptMessageHandler > scriptDelegate;

- (instancetype) init:(id < WKScriptMessageHandler > ) scriptDelegate;

@end
