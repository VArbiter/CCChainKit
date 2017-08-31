//
//  WKWebView+CCChain.m
//  CCChainKit
//
//  Created by 冯明庆 on 27/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "WKWebView+CCChain.h"

@implementation WKWebView (CCChain)

+ (WKWebView *(^)(CGRect))common {
    return ^WKWebView * (CGRect r) {
        return self.commonC(r , nil);
    };
}

+ (WKWebView *(^)(CGRect, WKWebViewConfiguration *))commonC {
    return ^WKWebView * (CGRect r , WKWebViewConfiguration *c){
        WKWebView *webView = nil;
        if (c) {
            webView = [[WKWebView alloc] initWithFrame:r
                                         configuration:c];
        } else webView = [[WKWebView alloc] initWithFrame:r];
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        webView.autoresizesSubviews = YES;
        webView.allowsBackForwardNavigationGestures = YES;
        webView.scrollView.alwaysBounceVertical = YES;
        webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        return webView;
    };
}

- (WKWebView *(^)(id))navigationDelegateT {
    __weak typeof(self) pSelf = self;
    return ^WKWebView * (id d) {
        if (d) pSelf.navigationDelegate = d;
        return pSelf;
    };
}

- (WKWebView *(^)(NSString *, void (^)(WKNavigation *)))loading {
    __weak typeof(self) pSelf = self;
    return ^WKWebView *(NSString *s , void (^t)(WKNavigation *)) {
        if (![s isKindOfClass:NSString.class] || !s.length) return pSelf;
        if ([s hasPrefix:@"http://"] || [s hasPrefix:@"https://"]) {
            return pSelf.request(s , t);
        } else return pSelf.content(s , t);
    };
}

- (WKWebView *(^)(NSString *, void (^)(WKNavigation *)))request {
    __weak typeof(self) pSelf = self;
    return ^WKWebView *(NSString *s , void (^t)(WKNavigation *)) {
        WKNavigation *n = [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:s]]];
        if (t) t(n);
        return pSelf;
    };
}

- (WKWebView *(^)(NSString *, void (^)(WKNavigation *)))content {
    __weak typeof(self) pSelf = self;
    return ^WKWebView *(NSString *s , void (^t)(WKNavigation *)) {
        WKNavigation *n = [pSelf loadHTMLString:s baseURL:nil];
        if (t) t(n);
        return pSelf;
    };
}

@end

#pragma mark - -----

@implementation CCScriptMessageDelegate

- (instancetype)init:(id<WKScriptMessageHandler>)scriptDelegate{
    if ((self = [super init])) {
        self.scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
