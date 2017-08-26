//
//  WKWebView+CCChain.m
//  CCChainKit
//
//  Created by 冯明庆 on 27/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import "WKWebView+CCChain.h"

@implementation WKWebView (CCChain)

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
