## CCChainKit

[![Version](https://img.shields.io/cocoapods/v/CCChainKit.svg?style=flat)](http://cocoapods.org/pods/CCChainKit)

[![License](https://img.shields.io/cocoapods/l/CCChainKit.svg?style=flat)](http://cocoapods.org/pods/CCChainKit)

[![Platform](https://img.shields.io/cocoapods/p/CCChainKit.svg?style=iOS)](http://cocoapods.org/pods/CCChainKit)

###提示

**警告**

> 所有的链式操作全部以 block 为开始和结尾 .
> 
> 所以 , 不允许任何空 (nil) 返回值出现在正在执行的 block 中 , 否则 , 会 `崩溃` .
> 
> 我还在寻找这个的解决办法.

**咋使**
> 目前 , 当开启一个链时 , 用宏去包裹开始 `CC(_value_)` (在 `CCCommon.h`中) 去避免 nil 崩溃.
> 在方法 , 函数 , 或者参数中 , 使用
> 
> `- (instancetype) cc : (id (^)(id sameObject)) sameObject;` (in `NSObject+CCProtocol.h`)
> 
> 去做一些详细的操作 , 强转 `id` 类型 , 使用 宏`CC_TYPE(_type_ , _value_)` (在 `CCCommon.h`中) .

**须知**
> 安装时 , 默认是 `CCCore` , `CCCore` 包含 
> 
> `CCCommon` (宏) , `CCProtocol` (协议) , `CCData` (NS 族群), `CCView` (UI 族群), `CCRuntime` (objc/ runtime 相关), `CCChainAssets` (将来可能会使用)
> 
> 如果想安装全部 , 安装`"CCChainKit/CCFull"` (须知 : `CCFull` 依赖了一些第三方)

**说明**
> CCCore : 核心 , 子库的抽象集合
> 
> CCFull : 全部 , 子库的抽象集合
> 
> CCChainAssets : 资源集合 , 为未来使用所保留
> 
> CCCommon : 宏和公共工具
> 
> CCProtocol : 协议 . 为了 丛丛 . 让所有的 NSObject 子类全部以 cc 为开始
> 
> CCRuntime : 一些 runtime 的封装
> 
> CCDataBase : 暂时 , 只是针对 [`Realm`](https://github.com/realm/realm-cocoa) ('~> 2.10.0').
> 
> CCRouter : 一些针对于 [`MGJRouter`](https://github.com/meili/MGJRouter) ('~> 0.9.3') && perform selector 的链式封装 .
> 
> CCData :  一些针对 NS 族群的链式封装
> 
> CCView :  一些针对 UI 族群的链式封装
> 
> CCCustom :  自定义的一些类 , 依赖或者基于一些第三方 .

### 更新
**2017-09-05 14:24:59**

> 👏👏👏
> 
> 终于, `CCChainKit` 第一版完成了 .
> 
> 👏👏👏
> 
> CCChainKit , 第一版 : `2017-07-01 19:49:01` ~ `2017-09-05 14:24:59`
> 

**2017-08-31 11:31:23**

> 移除一些结构体 (CCRect , CCSize ... 等等)
> 
> 使用 **typedef** 来桥接 系统的 结构体 .
> 
> 为啥 ? 因为系统会识别 typedef 的 值作为原值.
> 
> 想回去 , 可回不去了 . 我应该问问能回去么 ?

**2017-08-10 15:03:41**

> 项目起源于 _*[CCLocalLibrary](https://github.com/VArbiter/CCLocalLibrary)*_
> 
> *CC* , *EE* , *EL* . 暂时 , 还是 *CC*.
> 
> 一旦你熟悉了某个人 , 那就永远就改变了.

### 示例

跑测试工程 , 先 clone repo 到本地 , 然后先跑  `pod install`

### 要求

已经在 podspec 中做好了

### 安装

CCChainKit 现以支持 [CocoaPods](http://cocoapods.org). 
安装仅仅需要把下面的代码添加至您的 Podfile :

```ruby
pod "CCChainKit"
```

### 作者

Elwin Frederick, [elwinfrederick@163.com](elwinfrederick@163.com)

### 授权

CCChainKit 受到 MIT 协议保护. 查看 LICENSE 文件以获得更多信息 .
