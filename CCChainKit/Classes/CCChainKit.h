//
//  CCChainKit.h
//  CCChainKit
//
//  Created by Elwinfrederick on 10/08/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#ifndef CCChainKit_h
    #define CCChainKit_h

    #if __has_include(<CCChainKit/CCChainKit.h>)

        #import <CCChainKit/CCChainProtocol.h>
        #import <CCChainKit/CCChainCommon.h>
        #import <CCChainKit/CCChainData.h>
        #import <CCChainKit/CCChainView.h>
        #import <CCChainKit/CCChainRuntime.h>

        #ifdef _CCChainDataBase_
            #import <CCChainKit/CCChainDataBase.h>
        #endif

        #ifdef _CCChainRouter_
            #import <CCChainKit/CCChainRouter.h>
        #endif

        #ifdef _CCChainCustom_
            #import <CCChainKit/CCChainCustom.h>
        #endif

    #else

        #import "CCChainProtocol.h"
        #import "CCChainCommon.h"
        #import "CCChainData.h"
        #import "CCChainView.h"
        #import "CCChainRuntime.h"

        #ifdef _CCChainDataBase_
            #import "CCChainDataBase.h"
        #endif

        #ifdef _CCChainRouter_
            #import "CCChainRouter.h"
        #endif

        #ifdef _CCChainCustom_
            #import "CCChainCustom.h"
        #endif

    #endif

#endif /* CCChainKit_h */
