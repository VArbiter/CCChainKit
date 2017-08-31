//
//  CCEasyWebView.m
//  CCChainKit
//
//  Created by 冯明庆 on 25/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "CCEasyWebView.h"

@interface CCEasyWebView () <WKNavigationDelegate , WKScriptMessageHandler>

@property (nonatomic , strong) WKWebViewConfiguration * config;
@property (nonatomic , assign) CGRect frame ;
@property (nonatomic , strong) WKUserContentController *userContentController ;
@property (nonatomic , strong) CCScriptMessageDelegate *messageDelegate ;

@property (nonatomic , assign) BOOL isTrustWithoutAnyDoubt;
@property (nonatomic , copy) void (^challenge)(WKWebView *webView ,
                NSURLAuthenticationChallenge * challenge,
                void (^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential));
@property (nonatomic , copy) void (^alertS)(UIAlertController *controller);

@property (nonatomic , strong) NSMutableDictionary <NSString * , void (^)(WKUserContentController *, WKScriptMessage *)> *dictionaryMessage ;

- (instancetype) init : (CGRect) frame ;

- (instancetype) init : (CGRect) frame
        configuration : (WKWebViewConfiguration *) configuration ;

@property (nonatomic , copy) void (^progress)(double);
@property (nonatomic , copy) WKNavigationActionPolicy (^decision)(WKNavigationAction * action);
@property (nonatomic , copy) WKNavigationResponsePolicy (^decisionR)(WKNavigationResponse *response);
@property (nonatomic , copy) void (^commit)(WKWebView *webView , WKNavigation *navigation);
@property (nonatomic , copy) void (^start)(WKWebView *webView , WKNavigation *navigation);
@property (nonatomic , copy) void (^provisional)(WKWebView *webView , WKNavigation *navigation , NSError * error);
@property (nonatomic , copy) void (^redirect)(WKWebView *webView , WKNavigation *navigation);
@property (nonatomic , copy) void (^finish)(WKWebView *webView , WKNavigation *navigation);
@property (nonatomic , copy) void (^fail)(WKWebView *webView , WKNavigation *navigation , NSError * error);

@end

@implementation CCEasyWebView

+ (CCEasyWebView *(^)(CGRect))common {
    return ^CCEasyWebView *(CGRect r) {
        return self.commonS(r, nil);
    };
}

+ (CCEasyWebView *(^)(CGRect, WKWebViewConfiguration *))commonS {
    return ^CCEasyWebView *(CGRect r , WKWebViewConfiguration *c) {
        return [[self alloc] init:r configuration:c];
    };
}

- (CCEasyWebView *(^)(NSString *, void (^)(WKNavigation *)))loadR {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView *(NSString * s , void (^t)(WKNavigation *)) {
        if (s && s.length) {
            WKNavigation *n = nil;
            if ([s hasPrefix:@"http://"] || [s hasPrefix:@"https://"]) {
                n = [pSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:s]]];
            } else [pSelf.webView loadHTMLString:s baseURL:nil];
            if (n && t) t(n);
        }
        return pSelf;
    };
}

- (instancetype) init : (CGRect) frame {
    return [self init:frame configuration:nil];
}

- (instancetype) init : (CGRect) frame
        configuration : (WKWebViewConfiguration *) configuration {
    if ((self = [super init])) {
        self.frame = frame;
        self.config = configuration;
        self.isTrustWithoutAnyDoubt = YES;
        [self.webView addSubview:self.progressView];
    }
    return self;
}

- (CCEasyWebView *(^)(BOOL))authChallenge {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView *(BOOL b) {
        pSelf.isTrustWithoutAnyDoubt = b;
        return pSelf;
    };
}

- (CCEasyWebView *(^)(void (^)(WKWebView *, NSURLAuthenticationChallenge *, void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))))dealAuthChallenge {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView * (void (^t)(WKWebView *, NSURLAuthenticationChallenge *, void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))) {
        if (t) pSelf.challenge = [t copy];
        return pSelf;
    };
}

- (CCEasyWebView *(^)(void (^)(UIAlertController *)))decidedByUser {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView *(void (^t)(UIAlertController *)) {
        if (t) pSelf.alertS = [t copy];
        return pSelf;
    };
}

- (CCEasyWebView *(^)(WKNavigationActionPolicy (^)(WKNavigationAction *)))policyForAction {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView *(WKNavigationActionPolicy (^t)(WKNavigationAction *)) {
        if (t) pSelf.decision = [t copy];
        return pSelf;
    };
}

- (CCEasyWebView *(^)(WKNavigationResponsePolicy (^)(WKNavigationResponse *)))policyForResponse {
    __weak typeof(self) pSelf = self;
    return ^(WKNavigationResponsePolicy (^t)(WKNavigationResponse *)) {
        if (t) pSelf.decisionR = [t copy];
        return pSelf;
    };
}

- (CCEasyWebView *(^)(void (^)(WKWebView *, WKNavigation *)))didCommit {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView *(void (^t)(WKWebView *, WKNavigation *)) {
        if (t) pSelf.commit = [t copy];
        return pSelf;
    };
}

- (CCEasyWebView *(^)(void (^)(WKWebView *, WKNavigation *)))didStart {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView *(void (^t)(WKWebView *, WKNavigation *)) {
        if (t) pSelf.start = [t copy];
        return pSelf;
    };
}

- (CCEasyWebView *(^)(void (^)(WKWebView *, WKNavigation *, NSError *)))failProvisional {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView *(void (^t)(WKWebView *, WKNavigation *, NSError *)) {
        if (t) pSelf.provisional = [t copy];
        return pSelf;
    };
}

- (CCEasyWebView *(^)(void (^)(WKWebView *, WKNavigation *)))receiveRedirect {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView *(void (^t)(WKWebView *, WKNavigation *)) {
        if (t) pSelf.redirect = [t copy];
        return pSelf;
    };
}

- (CCEasyWebView *(^)(void (^)(WKWebView *, WKNavigation *)))didFinish {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView *(void (^t)(WKWebView *, WKNavigation *)) {
        if (t) pSelf.finish = [t copy];
        return pSelf;
    };
}

- (CCEasyWebView *(^)(void (^)(WKWebView *, WKNavigation *, NSError *)))didFail {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView *(void (^t)(WKWebView *, WKNavigation *, NSError *)) {
        if (t) pSelf.fail = [t copy];
        return pSelf;
    };
}

- (CCEasyWebView *(^)(NSString *, void (^)(WKUserContentController *, WKScriptMessage *)))script {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView *(NSString *s , void (^t)(WKUserContentController *, WKScriptMessage *)) {
        if (s && s.length) {
            [pSelf.userContentController addScriptMessageHandler:self.messageDelegate
                                                            name:s];
            [pSelf.dictionaryMessage setValue:t
                                       forKey:s];
        }
        else if (!t && s && s.length) {
            [pSelf.userContentController removeScriptMessageHandlerForName:s];
            [pSelf.dictionaryMessage removeObjectForKey:s];
        }
        
        return pSelf;
    };
}

- (CCEasyWebView *(^)(void (^)(double)))loadingProgress {
    __weak typeof(self) pSelf = self;
    return ^CCEasyWebView *(void (^t)(double)) {
        pSelf.progress = [t copy];
        return pSelf;
    };
}

#pragma mark - -----

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    /// trust without any doubt .
    
    void (^t)() = ^ {
        NSString *stringAuthenticationMethod = [[challenge protectionSpace] authenticationMethod];
        if ([stringAuthenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            NSURLCredential *credential = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    };
    
    if (self.isTrustWithoutAnyDoubt) {
        if (t) t();
        return;
    }
    
    if (self.challenge) {
        self.challenge(webView, challenge, completionHandler);
        return;
    }
    
    if (!self.alertS) { if (t) t() ; return ; }
    
    NSString *hostName = webView.URL.host;
    NSString *authenticationMethod = [[challenge protectionSpace] authenticationMethod];
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef secTrustRef = challenge.protectionSpace.serverTrust;
        if (secTrustRef != NULL) {
            SecTrustResultType result;
            OSErr er = SecTrustEvaluate(secTrustRef, &result);
            if (er != noErr) {
                completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace,nil);
                return;
            }
            
            if (result == kSecTrustResultRecoverableTrustFailure) {
                /// certificate can't be trusted
                CFArrayRef secTrustProperties = SecTrustCopyProperties(secTrustRef);
                NSArray *arr = CFBridgingRelease(secTrustProperties);
                NSMutableString *errorStr = [NSMutableString string];
                
                for (int i = 0;i < arr.count; i++){
                    NSDictionary *dic = [arr objectAtIndex:i];
                    if (i != 0) [errorStr appendString:@" "];
                    [errorStr appendString:(NSString *)dic[@"value"]];
                }
                SecCertificateRef certRef = SecTrustGetCertificateAtIndex(secTrustRef, 0);
                CFStringRef cfCertSummaryRef =  SecCertificateCopySubjectSummary(certRef);
                NSString *certSummary = (NSString *)CFBridgingRelease(cfCertSummaryRef);
                NSString *title = @"该服务器无法验证";
                
                NSString *message = [NSString stringWithFormat:@" 是否通过来自%@标识为 %@证书为%@的验证. \n%@" , @"我的app",hostName,certSummary, errorStr];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);}]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSURLCredential* credential = [NSURLCredential credentialForTrust:secTrustRef];
                    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
                }]];
                
                __weak typeof(self) pSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{ // async , has to do it on main thread
                    if (pSelf.alertS) pSelf.alertS(alertController);
                });
                return;
            }
            
            NSURLCredential* credential = [NSURLCredential credentialForTrust:secTrustRef];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
            return;
        }
        completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
    }
    else completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (self.decision) {
        decisionHandler(self.decision(navigationAction));
    } else decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if (self.decisionR) {
        decisionHandler(self.decisionR(navigationResponse));
    } else decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.commit) self.commit(webView, navigation);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.start) self.start(webView, navigation);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    if (self.provisional) self.provisional(webView, navigation, error);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.redirect) self.redirect(webView, navigation);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.finish) self.finish(webView, navigation);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.fail) self.fail(webView, navigation, error);
}

#pragma mark - -----
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    void (^t)(WKUserContentController *, WKScriptMessage *) = self.dictionaryMessage[message.name];
    if (t) t(userContentController , message);
}

#pragma mark - -----

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        if (self.progress) self.progress(self.webView.estimatedProgress);
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress
                              animated:YES];
        if(self.webView.estimatedProgress >= 1.0f)
            [UIView animateWithDuration:0.3
                                  delay:0.3
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progressView setAlpha:0.0f];
                             } completion:^(BOOL finished) {
                                 [self.progressView setProgress:0.0f
                                                       animated:NO];
                             }];
    }
    else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - -----
- (NSMutableDictionary<NSString *,void (^)(WKUserContentController *, WKScriptMessage *)> *)dictionaryMessage {
    if (_dictionaryMessage) return _dictionaryMessage;
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    _dictionaryMessage = d;
    return _dictionaryMessage;
}

- (WKWebView *)webView{
    if (_webView) return _webView;
    if (!self.config) {
        WKWebViewConfiguration * c = [[WKWebViewConfiguration alloc] init];
        if (UIDevice.currentDevice.systemVersion.floatValue >= 9.f) {
            c.allowsAirPlayForMediaPlayback = YES;
        }
        c.allowsInlineMediaPlayback = YES;
        c.selectionGranularity = YES;
        c.processPool = [[WKProcessPool alloc] init];
        c.userContentController = self.userContentController;
        self.config = c;
    }
    else self.config.userContentController = self.userContentController;
    
    WKWebView *v = [[WKWebView alloc] initWithFrame:(CGRect){0,0,self.frame.size.width,self.frame.size.height}
                                      configuration:self.config];
    _webView = v;
    
    [_webView addObserver:self
               forKeyPath:@"estimatedProgress"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
    
    return _webView;
}

- (UIProgressView *)progressView {
    if (_progressView) return _progressView;
    UIProgressView *v = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    v.frame = (CGRect){0,0, self.frame.size.width , 2};
    _progressView = v;
    return _progressView;
}

- (WKUserContentController *)userContentController {
    if (_userContentController) return _userContentController;
    WKUserContentController *c = [[WKUserContentController alloc] init];
    _userContentController = c;
    return _userContentController;
}

- (CCScriptMessageDelegate *)messageDelegate {
    if (_messageDelegate) return _messageDelegate;
    CCScriptMessageDelegate *delegate = [[CCScriptMessageDelegate alloc] init:self];
    _messageDelegate = delegate;
    return _messageDelegate;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"\n_CC_%@_DEALLOC_",NSStringFromClass(self.class));
#endif
    [self.webView removeObserver:self
                      forKeyPath:@"estimatedProgress"
                         context:nil];
}

@end
