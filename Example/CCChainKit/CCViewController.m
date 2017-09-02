//
//  CCViewController.m
//  CCChainKit
//
//  Created by ElwinFrederick on 08/10/2017.
//  Copyright (c) 2017 ElwinFrederick. All rights reserved.
//

#import "CCViewController.h"

#import "CCChainKit.h"

//#import "NSObject+CCChain.h"
#import "NSObject+CCProtocol.h"
#import "UIView+CCChain.h"

#import "CCChainRuntime.h"

#import <objc/runtime.h>

@protocol CCChainP <NSObject>

@end

CC_PROXY_DEALER_INTERFACE(TEST,CCChainP)
CC_PROXY_DEALER_IMPLEMENTATION(TEST)

@interface CCViewController ()

@property (nonatomic , copy) void (^test)(id t);

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CC_WEAK_INSTANCE(self);
//    UIView *v = [[UIView alloc] init];
    UIView *v;
    [v cc:^id(id object) {
        return CC_TYPE(UIView *, object).leftS(10);
    }];
    CC(v).leftS(10); // not
    if (self.test) self.test([v cc:^id(id sameObject) {
        return CC_TYPE(UIView *, sameObject).leftS(1);
    }]); // not
    v.leftS(10); // crash , nil for block .
    
    CC(v).leftS(10).rightS(10).topS(10).bottomS(10).endT();
    
    CCProxy_t_TEST.common.registMethods(@[]);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
