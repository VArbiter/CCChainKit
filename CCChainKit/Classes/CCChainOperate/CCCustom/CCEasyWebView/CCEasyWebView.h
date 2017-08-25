//
//  CCEasyWebView.h
//  CCChainKit
//
//  Created by 冯明庆 on 25/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

@import UIKit;
@import WebKit;

@interface CCEasyWebView : NSObject

@property (nonatomic , class , copy , readonly) CCEasyWebView *(^common)(CGRect frame);
@property (nonatomic , class , copy , readonly) CCEasyWebView *(^commonS)(CGRect frame , WKWebViewConfiguration *configuration);

@property (nonatomic , strong) WKWebView *webView;
@property (nonatomic , strong) UIProgressView *progressView;

@property (nonatomic , copy , readonly) CCEasyWebView *(^authChallenge)(BOOL isWithoutAnyDoubt); // default is YES
@property (nonatomic , copy , readonly) CCEasyWebView *(^dealAuthChallenge)(void (^challenge)(WKWebView *webView ,
                NSURLAuthenticationChallenge * challenge,
                void (^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential)));
@property (nonatomic , copy , readonly) CCEasyWebView *(^decidedByUser)(void (^alert)(UIAlertController *controller));

@property (nonatomic , copy , readonly) CCEasyWebView *(^loadR)(NSString * sContent , void (^load)(WKNavigation *navigation));
@property (nonatomic , copy , readonly) CCEasyWebView *(^script)(NSString *sKey , void (^message)(WKScriptMessage *message));

@end
