//
//  NSURL+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CCChain)

@property (nonatomic , class , copy , readonly) NSURL *(^urlT)(NSString *sURL);
@property (nonatomic , class , copy , readonly) NSURL *(^local)(NSString *sURL);

@end
