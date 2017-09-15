# CCChainKit

[![Version](https://img.shields.io/cocoapods/v/CCChainKit.svg?style=flat)](http://cocoapods.org/pods/CCChainKit)

[![License](https://img.shields.io/cocoapods/l/CCChainKit.svg?style=flat)](http://cocoapods.org/pods/CCChainKit)

[![Platform](https://img.shields.io/cocoapods/p/CCChainKit.svg?style=flat)](http://cocoapods.org/pods/CCChainKit)

#### 中文说明请[[点击这里](https://github.com/VArbiter/CCChainKit/blob/master/README_CN.md)]

### Note

**Warning**

> All the actions within CCChainKit was started and ended in blocks .
> 
> That is , non of nil ( for return value) was allowed when chain is actived . otherwise , `went crash` .
> 
> Still working to find a proper solution on it.

**How To Use**
> For now , when intial a chain , begin with a wrapper of macro `CC(_value_)` (in `CCCommon.h`) to avoid nil-crash .
> in methods , functions or params , use 
> 
> `- (instancetype) cc : (id (^)(id sameObject)) sameObject;` (in `NSObject+CCProtocol.h`)
> 
> to do some more adjustments , for force transfer with `id` type , use macro `CC_TYPE(_type_ , _value_)` (in `CCCommon.h`) deal with it .

**Note**
> when install , default is `CCCore` , `CCCore` contains 
> 
> `CCCommon` (Macros) , `CCProtocol` (Protocol) , `CCData` (NS Family), `CCView` (UI Family), `CCRuntime` (objc/ runtime associate)
> 
> when you wanna get to Full , install with `"CCChainKit/CCFull"` (note: `CCFull` had dependend on other vendors.)

**Instructions**
> CCCore : Core chains . a abstract collection .
> 
> CCFull : Full chains . a abstract collection .
> 
> CCChainAssets : Assets collection , preserve for future needs . (not available for now).
> 
> CCCommon : Macros && Common tools .
> 
> CCProtocol : CCProtocol . for CC . make all the sub-class of NSObject conforms to it .
> 
> CCRuntime : Packaged for some runtime functions .
> 
> CCDataBase : For now , only for [`Realm`](https://github.com/realm/realm-cocoa) ('~> 2.10.0').
> 
> CCRouter : a chain Package Router for [`MGJRouter`](https://github.com/meili/MGJRouter) ('~> 0.9.3') && perform actions .
> 
> CCData :  a chain actions for NS family .
> 
> CCView :  a chain actions for UI family .
> 
> CCCustom :  Custom classes or functions , dependend or based on other vendors .

### What's New

**2017-09-15 18:00:20**
>
> adjust a few , updated to '0.2.1' .
>

**2017-09-05 14:24:59**

> 👏👏👏
> 
> finally , the first version of `CCChainKit` has finally completed .
> 
> 👏👏👏
> 
> CCChainKit , first version : `2017-07-01 19:49:01` ~ `2017-09-05 14:24:59`
> 

**2017-08-31 11:31:23**

> remove custom struct (CCRect , CCSize ... etc)
> 
> make them as a **typedef** for system structs .
> 
> Why ? cause system will recognize a typedef value as its origin .
> 
> wanna go back , can't go back . should I ask for it ?

**2017-08-10 15:03:41**

> intial commit from _*[CCLocalLibrary](https://github.com/VArbiter/CCLocalLibrary)*_
> 
> *CC* , *EE* , *EL* . for now , just *CC*.
> 
> once get used to someone , forever changed for her .

### Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Requirements

Already done in pod spec.

### Installation

CCChainKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CCChainKit"
```

### Author

ElwinFrederick, elwinfrederick@163.com

### License

CCChainKit is available under the MIT license. See the LICENSE file for more info.
