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

@interface CCViewController ()

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CC_WEAK_INSTANCE(self);
//    UIView *v = [[UIView alloc] init];
    UIView *v;
    [v ccS:^id(id object) {
        return CC_TYPE(UIView *, object).leftS(10);
    }];
    CC(v).leftS(10);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
