//
//  NSURLRequest+CCChain.h
//  CCChainKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (CCChain)

@property (nonatomic , class , copy , readonly) NSURLRequest *(^requestT)(NSString *s);
@property (nonatomic , class , copy , readonly) NSURLRequest *(^localT)(NSString *s);

@end

#pragma mark - -----

@interface NSMutableURLRequest (CCChain)

@property (nonatomic , class , copy , readonly) NSMutableURLRequest *(^requestT)(NSString *s);
@property (nonatomic , class , copy , readonly) NSMutableURLRequest *(^localT)(NSString *s);

@end
