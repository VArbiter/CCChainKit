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

@property (nonatomic , assign) BOOL isTrustWithoutAnyDoubt;
@property (nonatomic , copy) void (^challenge)(WKWebView *webView ,
                NSURLAuthenticationChallenge * challenge,
                void (^completionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential));
@property (nonatomic , copy) void (^alertS)(UIAlertController *controller);

- (instancetype) init : (CGRect) frame ;

- (instancetype) init : (CGRect) frame
        configuration : (WKWebViewConfiguration *) configuration ;

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
        WKNavigation *n = [pSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:s]]];
        if (n && t) t(n);
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
    }
    return self;
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
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    CCLog(@"_START_LOADING_WEBVIEW_");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
//    CCLog(@"%@",error);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    CCLog(@"_FINISH_LOADING_WEBVIEW_");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    CCLog(@"%@",error);
}

@end
