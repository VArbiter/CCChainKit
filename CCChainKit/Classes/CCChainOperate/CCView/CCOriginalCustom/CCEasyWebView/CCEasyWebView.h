//
//  CCEasyWebView.h
//  CCChainKit
//
//  Created by 冯明庆 on 25/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "WKWebView+CCChain.h"

@interface CCEasyWebView : NSObject

@property (nonatomic , class , copy , readonly) CCEasyWebView *(^common)(CGRect frame);
@property (nonatomic , class , copy , readonly) CCEasyWebView *(^commonS)(CGRect frame , WKWebViewConfiguration *configuration);

@property (nonatomic , strong) WKWebView *webView;

/// (CGRect){0,0,Screen Width , 2} , superview : webView
/// alpha will be .0 when progress reach 1.f
@property (nonatomic , strong) UIProgressView *progressView;

// a chain bridge for WKNavigationDelegate

/// default is YES , allow all challenges .
@property (nonatomic , copy , readonly) CCEasyWebView *(^authChallenge)(BOOL isWithoutAnyDoubt);

/// if webview receive a auth challenge
/// note : if not implemented 'dealAuthChallenge' ,
/// webview will trust certificate without any doubt . (non process will be done)
@property (nonatomic , copy , readonly) CCEasyWebView *(^dealAuthChallenge)(void (^challenge)(WKWebView *webView ,
                NSURLAuthenticationChallenge * challenge,
                void (^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential)));

/// if decidedByUser was implemented .
/// then the choice of whether trust a certificate or not , was decided by users .
/// note : use modal to presented a alertcontroller .
@property (nonatomic , copy , readonly) CCEasyWebView *(^decidedByUser)(NSString *sAppName , void (^alert)(UIAlertController *controller));

@property (nonatomic , copy , readonly) CCEasyWebView *(^policyForAction)(WKNavigationActionPolicy(^decision)(WKNavigationAction * action));
@property (nonatomic , copy , readonly) CCEasyWebView *(^policyForResponse)(WKNavigationResponsePolicy(^decisionR)(WKNavigationResponse *response));

@property (nonatomic , copy , readonly) CCEasyWebView *(^didCommit)(void (^commit)(WKWebView *webView , WKNavigation *navigation));
@property (nonatomic , copy , readonly) CCEasyWebView *(^didStart)(void (^start)(WKWebView *webView , WKNavigation *navigation));
@property (nonatomic , copy , readonly) CCEasyWebView *(^failProvisional)(void (^provisional)(WKWebView *webView , WKNavigation *navigation , NSError * error));
@property (nonatomic , copy , readonly) CCEasyWebView *(^receiveRedirect)(void (^redirect)(WKWebView *webView , WKNavigation *navigation));
@property (nonatomic , copy , readonly) CCEasyWebView *(^didFinish)(void (^finish)(WKWebView *webView , WKNavigation *navigation));
@property (nonatomic , copy , readonly) CCEasyWebView *(^didFail)(void (^fail)(WKWebView *webView , WKNavigation *navigation , NSError * error));

// chain for loading , only "http://" && "https://" will be loaded online
// others will be loaded as html content .
// nil to do nothing

@property (nonatomic , copy , readonly) CCEasyWebView *(^loadR)(NSString * sContent , void (^load)(WKNavigation *navigation));

/// pushing the loading progress of current page .
@property (nonatomic , copy , readonly) CCEasyWebView *(^loadingProgress)(void (^progress)(double progress));

// simple two-ways interact with JaveScript && Native in webview.

/// Can deploy it for muti times .
/// deploy nil for message block to unregist a recall
@property (nonatomic , copy , readonly) CCEasyWebView *(^script)(NSString *sKey , void (^message)(WKUserContentController * userContentController, WKScriptMessage *message));

@end
