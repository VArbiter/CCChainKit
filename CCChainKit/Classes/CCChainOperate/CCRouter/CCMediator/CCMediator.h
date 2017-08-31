//
//  CCMediator.h
//  CCSubModuleMediator
//
//  Created by Elwinfrederick on 24/07/2017.
//  Copyright © 2017 VArbiter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCMediator : NSObject

/// target action , is need a reutrn value , params
@property (nonatomic , class , copy , readonly) id (^perform)(NSString * , NSString * ,  BOOL , id(^)());

@end
