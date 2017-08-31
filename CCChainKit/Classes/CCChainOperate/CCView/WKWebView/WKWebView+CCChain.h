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

@property (nonatomic , class , copy , readonly) WKWebView *(^common)(CGRect frame);
@property (nonatomic , class , copy , readonly) WKWebView *(^commonC)(CGRect frame , WKWebViewConfiguration *configuration);
@property (nonatomic , copy , readonly) WKWebView *(^navigationDelegateT)(id delegate);

@property (nonatomic , copy , readonly) WKWebView *(^script)(CCScriptMessageDelegate *delegate);

/// Only "http://" && "https://" will be loaded online .
/// others will be loading as HTML content .
@property (nonatomic , copy , readonly) WKWebView *(^loading)(NSString *sLink , void (^)(WKNavigation *navigation));

@property (nonatomic , copy , readonly) WKWebView *(^request)(NSString *sLink , void (^)(WKNavigation *navigation)); // loading as links
@property (nonatomic , copy , readonly) WKWebView *(^content)(NSString *sContent , void (^)(WKNavigation *navigation)); // loading as HTML content

@end

#pragma mark - -----

@interface CCScriptMessageDelegate : NSObject < WKScriptMessageHandler >

@property (nonatomic , assign) id < WKScriptMessageHandler > scriptDelegate;

- (instancetype) init:(id < WKScriptMessageHandler > ) scriptDelegate;

@end
