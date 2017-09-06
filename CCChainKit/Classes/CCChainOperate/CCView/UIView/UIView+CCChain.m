//
//  UIView+CCChain.m
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 02/08/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "UIView+CCChain.h"
#import "UIGestureRecognizer+CCChain.h"

static CGFloat _CC_DEFAULT_SCALE_WIDTH_ = 750.f;
static CGFloat _CC_DEFAULT_SCALE_HEIGHT_ = 1334.f;
CGFloat const _CC_DEFAULT_ANIMATION_COMMON_DURATION_ = .3f;

#pragma mark - Struct
CCPoint CCPointMake(CGFloat x , CGFloat y) {
    CCPoint o;
    o.x = x / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    o.y = y / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    return o;
}
CCPoint CCMakePointFrom(CGPoint point) {
    return CCPointMake(point.x, point.y);
}
CGPoint CGMakePointFrom(CCPoint point) {
    return CGPointMake(point.x, point.y);
}

CCSize CCSizeMake(CGFloat width , CGFloat height) {
    CCSize s;
    s.width = width / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    s.height = height / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    return s;
}
CCSize CCMakeSizeFrom(CGSize size) {
    return CCSizeMake(size.width, size.height);
}
CGSize CGMakeSizeFrom(CCSize size) {
    return CGSizeMake(size.width, size.height);
}

CCRect CCRectMake(CGFloat x , CGFloat y , CGFloat width , CGFloat height) {
    CCRect r;
    r.origin = CCPointMake(x, y);
    r.size = CCSizeMake(width, height);
    return r;
}
CCRect CCMakeRectFrom(CGRect rect) {
    return CCRectMake(rect.origin.x,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}
CGRect CGMakeRectFrom(CCRect rect) {
    return CGRectMake(rect.origin.x,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}

CGRect CGRectFull(){
    return UIScreen.mainScreen.bounds;
}

CCEdgeInsets CCEdgeInsetsMake(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right) {
    CCEdgeInsets i;
    i.top = top / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    i.left = left / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    i.bottom = bottom / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
    i.right = right / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
    return i;
}
CCEdgeInsets CCMakeEdgeInsetsFrom(UIEdgeInsets insets) {
    return CCEdgeInsetsMake(insets.top,
                            insets.left,
                            insets.bottom,
                            insets.right);
}
UIEdgeInsets UIMakeEdgeInsetsFrom(CCEdgeInsets insets) {
    return UIEdgeInsetsMake(insets.top,
                            insets.left,
                            insets.bottom,
                            insets.right);
}

#pragma mark - Scale
CGFloat CCScaleW(CGFloat w) {
    return w / _CC_DEFAULT_SCALE_WIDTH_ * UIScreen.mainScreen.bounds.size.width;
}
CGFloat CCScaleH(CGFloat h) {
    return h / _CC_DEFAULT_SCALE_HEIGHT_ * UIScreen.mainScreen.bounds.size.height;
}
CGPoint CCScaleOrigin(CGPoint origin) {
    return CGPointMake(CCScaleW(origin.x), CCScaleH(origin.y));
}
CGSize CCScaleSize(CGSize size) {
    return CGSizeMake(CCScaleW(size.width), CCScaleH(size.height));
}

CGFloat CCWScale(CGFloat w) {
    return w / _CC_DEFAULT_SCALE_WIDTH_;
}
CGFloat CCHScale(CGFloat h) {
    return h / _CC_DEFAULT_SCALE_HEIGHT_;
}

@implementation UIView (CCChain)

+ (void (^)(CGFloat, CGFloat))scaleSet {
    return ^(CGFloat w , CGFloat h) {
        _CC_DEFAULT_SCALE_WIDTH_ = w;
        _CC_DEFAULT_SCALE_HEIGHT_ = h;
    };
}

+ ( __kindof UIView *(^)(CCRect))common {
    return ^ __kindof UIView *(CCRect r) {
        CGRect g = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height);
        return [[UIView alloc] initWithFrame:g];
    };
}

#pragma mark - Setter
- (void) setSize : (CGSize) size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize) size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat) width {
    return self.frame.size.width;
}

- (void) setHeight : (CGFloat) height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat) height {
    return self.frame.size.height;
}

- (void) setX : (CGFloat) x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat) x {
    return self.frame.origin.x;
}

- (void) setY : (CGFloat) y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat) y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}
- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}
- (CGFloat)centerY {
    return self.center.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

+ (CGFloat)sWidth {
    return UIScreen.mainScreen.bounds.size.width;
}
+ (CGFloat)sHeight {
    return UIScreen.mainScreen.bounds.size.height;
}

-(CGFloat)inCenterX{
    return self.frame.size.width*0.5;
}
-(CGFloat)inCenterY{
    return self.frame.size.height*0.5;
}
-(CGPoint)inCenter{
    return CGPointMake(self.inCenterX, self.inCenterY);
}

#pragma mark - Margin
- ( __kindof UIView *(^)(CGSize))sizeS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGSize s) {
        pSelf.size = s;
        return pSelf;
    };
}
- ( __kindof UIView *(^)(CGPoint))originS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGPoint p) {
        pSelf.origin = p;
        return pSelf;
    };
}

- ( __kindof UIView *(^)(CGFloat))widthS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGFloat w) {
        pSelf.width = w;
        return pSelf;
    };
}
- ( __kindof UIView *(^)(CGFloat))heightS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGFloat h) {
        pSelf.height = h;
        return pSelf;
    };
}

- ( __kindof UIView *(^)(CGFloat))yS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGFloat y) {
        pSelf.y = y;
        return pSelf;
    };
}
- ( __kindof UIView *(^)(CGFloat))xS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGFloat x) {
        pSelf.x = x;
        return pSelf;
    };
}

- ( __kindof UIView *(^)(CGFloat))centerXs {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGFloat centerX) {
        pSelf.centerX = centerX;
        return pSelf;
    };
}
- ( __kindof UIView *(^)(CGFloat))centerYs {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGFloat centerY) {
        pSelf.centerY = centerY;
        return pSelf;
    };
}

- ( __kindof UIView *(^)(CGFloat))topS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGFloat top) {
        pSelf.top = top;
        return pSelf;
    };
}
- ( __kindof UIView *(^)(CGFloat))leftS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGFloat left) {
        pSelf.left = left;
        return pSelf;
    };
}
- ( __kindof UIView *(^)(CGFloat))bottomS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGFloat bottom) {
        pSelf.bottom = bottom;
        return pSelf;
    };
}
- ( __kindof UIView *(^)(CGFloat))rightS {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGFloat right) {
        pSelf.right = right;
        return pSelf;
    };
}

#pragma mark - Method (s)

+ (void (^)(void (^)()))disableAnimation {
    return ^ (void (^t)()) {
        if (t) {
            [UIView setAnimationsEnabled:false];
            t();
            [UIView setAnimationsEnabled:YES];
        }
    };
}

+ ( __kindof UIView *(^)())fromXib {
    return ^ __kindof UIView * {
        return UIView.fromXibB(nil);
    };
}

+ ( __kindof UIView *(^)(__unsafe_unretained Class))fromXibC {
    return ^ __kindof UIView * (Class c){
        NSBundle *b = [NSBundle bundleForClass:c];
        return UIView.fromXibB(b);
    };
}

+ ( __kindof UIView *(^)(NSBundle *))fromXibB {
    return ^ __kindof UIView *(NSBundle *b) {
        if (!b) b = NSBundle.mainBundle;
        return [[b loadNibNamed:NSStringFromClass(self)
                          owner:nil
                        options:nil] firstObject];
    };
}

- ( __kindof UIView *(^)( __kindof UIView *))addSub {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *( __kindof UIView *v) {
        if (v) [pSelf addSubview:v];
        return pSelf;
    };
}

- (void (^)(void (^)( __kindof UIView *)))removeFrom {
    __weak typeof(self) pSelf = self;
    return ^(void (^t)( __kindof UIView *)) {
        if (t) t(pSelf.superview);
        if (pSelf.superview) [pSelf removeFromSuperview];
    };
}

- ( __kindof UIView *(^)( __kindof UIView *))bringToFront {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *( __kindof UIView *v) {
        if (v && [pSelf.subviews containsObject:v]) [pSelf bringSubviewToFront:v];
        return pSelf;
    };
}

- ( __kindof UIView *(^)( __kindof UIView *))sendToBack {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *( __kindof UIView *v) {
        if (v && [pSelf.subviews containsObject:v]) [pSelf sendSubviewToBack:v];
        return pSelf;
    };
}

- (__kindof UIView *(^)())makeToFront {
    __weak typeof(self) pSelf = self;
    return ^__kindof UIView * {
        if (pSelf.superview) {
            [pSelf.superview bringSubviewToFront:pSelf];
        }
        return pSelf;
    };
}

- (__kindof UIView *(^)())makeToBack {
    __weak typeof(self) pSelf = self;
    return ^__kindof UIView * {
        if (pSelf.superview) {
            [pSelf.superview sendSubviewToBack:pSelf];
        }
        return pSelf;
    };
}

- ( __kindof UIView *(^)())enableT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView * {
        pSelf.userInteractionEnabled = YES;
        return pSelf;
    };
}

- ( __kindof UIView *(^)())disableT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView * {
        pSelf.userInteractionEnabled = false;
        return pSelf;
    };
}

- ( __kindof UIView *(^)(UIColor *))color {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(UIColor *c) {
        pSelf.layer.backgroundColor = c ? c.CGColor : UIColor.clearColor.CGColor;
        return pSelf;
    };
}

- ( __kindof UIView *(^)(CGFloat, BOOL))radius {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGFloat f , BOOL b) {
        pSelf.layer.cornerRadius = f;
        pSelf.layer.masksToBounds = b;
        return pSelf;
    };
}

- ( __kindof UIView *(^)(UIRectCorner, CGFloat))edgeRound {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(UIRectCorner rc , CGFloat f) {
        UIBezierPath *p = [UIBezierPath bezierPathWithRoundedRect:pSelf.bounds
                                                byRoundingCorners:rc
                                                      cornerRadii:CGSizeMake(CCScaleW(f), CCScaleH(f))];
        CAShapeLayer *l = [[CAShapeLayer alloc] init];
        l.frame = pSelf.bounds;
        l.path = p.CGPath;
        pSelf.layer.mask = l;
        return pSelf;
    };
}

- ( __kindof UIView *(^)(UIViewContentMode))contentModeT {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(UIViewContentMode m) {
        pSelf.contentMode = m;
        return pSelf;
    };
}

- ( __kindof UIView *(^)( __kindof UIGestureRecognizer *))gesture {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *( __kindof UIGestureRecognizer *gr) {
        if (gr) {
            pSelf.userInteractionEnabled = YES;
            [pSelf addGestureRecognizer:gr];
        }
        return pSelf;
    };
}

- ( __kindof UIView *(^)(void (^)( __kindof UIView *, __kindof  UITapGestureRecognizer *)))tap {
    __weak typeof(self) pSelf = self;
    return ^UIView *(void (^t)(UIView *, UITapGestureRecognizer *)) {
        return pSelf.tapC(1, t);
    };
}

- ( __kindof UIView *(^)(NSInteger, void (^)( __kindof UIView *, __kindof UITapGestureRecognizer *)))tapC {
    __weak typeof(self) pSelf = self;
    return ^UIView *(NSInteger i, void(^t)(UIView * , UITapGestureRecognizer *)) {
        return pSelf.gesture(UITapGestureRecognizer.common().tapC(i, ^(UIGestureRecognizer *tapGR) {
            if (t) t(pSelf , (UITapGestureRecognizer *)tapGR);
        }));
    };
}

- ( __kindof UIView *(^)(void (^)( __kindof UIView *, __kindof UILongPressGestureRecognizer *)))press {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(void (^t)( __kindof UIView *, __kindof UILongPressGestureRecognizer *)) {
        return pSelf.pressC(.5f, t);
    };
}

- ( __kindof UIView *(^)(CGFloat, void (^)( __kindof UIView *, __kindof UILongPressGestureRecognizer *)))pressC {
    __weak typeof(self) pSelf = self;
    return ^ __kindof UIView *(CGFloat f, void (^t)( __kindof UIView *, __kindof UILongPressGestureRecognizer *)) {
        return pSelf.gesture(UILongPressGestureRecognizer.common().pressC(f, ^(UIGestureRecognizer *pressGR) {
            if (t) t(pSelf , (UILongPressGestureRecognizer *) pressGR);
        }));
    };
}

@end

#pragma mark - -----

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"

@import WebKit;

@implementation UIView (CCChain_Force)

- ( __kindof UILabel *)asUILabel {
    if ([self isKindOfClass:UILabel.class]) return (UILabel *) self;
    return self;
}

- ( __kindof UIScrollView *)asUIScrollView {
    if ([self isKindOfClass:UIScrollView.class]) return (UIScrollView *) self;
    return self;
}

- ( __kindof UITableView *)asUITableView {
    if ([self isKindOfClass:UITableView.class]) return (UITableView *) self;
    return self;
}

- ( __kindof UICollectionView *)asUICollectionView {
    if ([self isKindOfClass:UICollectionView.class]) return (UICollectionView *) self;
    return self;
}

- ( __kindof UIImageView *)asUIImageView {
    if ([self isKindOfClass:UIImageView.class]) return (UIImageView *) self;
    return self;
}

- ( __kindof WKWebView *)asWKWebView {
    if ([self isKindOfClass:WKWebView.class]) return (WKWebView *) self;
    return self;
}

- ( __kindof UIButton *)asUIButton {
    if ([self isKindOfClass:UIButton.class]) return (UIButton *) self;
    return self;
}

- ( __kindof UIControl *)asUIControl {
    if ([self isKindOfClass:UIControl.class]) return (UIControl *) self;
    return self;
}

- ( __kindof UITextView *)asUITextView {
    if ([self isKindOfClass:UITextView.class]) return (UITextView *) self;
    return self;
}

- ( __kindof UITextField *)asUITextField {
    if ([self isKindOfClass:UITextField.class]) return (UITextField *) self;
    return self;
}

- ( __kindof UIProgressView *)asUIProgressView {
    if ([self isKindOfClass:UIProgressView.class]) return (UIProgressView *) self;
    return self;
}

@end

#pragma clang diagnostic pop

#pragma mark - -----

@implementation UIView (CCChain_FitHeight) 

CGFloat CC_TEXT_HEIGHT_S(CGFloat fWidth , CGFloat fEstimateHeight , NSString *string) {
    return CC_TEXT_HEIGHT_C(fWidth,
                            fEstimateHeight ,
                            string,
                            [UIFont systemFontOfSize:UIFont.systemFontSize],
                            NSLineBreakByWordWrapping);
}
CGFloat CC_TEXT_HEIGHT_C(CGFloat fWidth ,
                         CGFloat fEstimateHeight ,
                         NSString *string ,
                         UIFont *font ,
                         NSLineBreakMode mode) {
    return CC_TEXT_HEIGHT_AS(fWidth,
                             fEstimateHeight,
                             string,
                             font,
                             mode,
                             -1,
                             -1);
}

CGFloat CC_TEXT_HEIGHT_A(CGFloat fWidth , CGFloat fEstimateHeight , NSAttributedString *aString) {
    CGRect rect = [aString boundingRectWithSize:(CGSize){fWidth , CGFLOAT_MAX}
                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                        context:nil];
    return rect.size.height >= fEstimateHeight ? rect.size.height : fEstimateHeight;
}
CGFloat CC_TEXT_HEIGHT_AS(CGFloat fWidth ,
                          CGFloat fEstimateHeight ,
                          NSString *aString ,
                          UIFont *font ,
                          NSLineBreakMode mode ,
                          CGFloat fLineSpacing ,
                          CGFloat fCharacterSpacing) {
    NSMutableParagraphStyle *style = NSMutableParagraphStyle.alloc.init;
    style.lineBreakMode = mode;
    if (fLineSpacing >= 0) style.lineSpacing = fLineSpacing;
    NSMutableDictionary *d = NSMutableDictionary.dictionary;
    [d setValue:style forKey:NSParagraphStyleAttributeName];
    [d setValue:font forKey:NSFontAttributeName];
    
    if (fCharacterSpacing >= 0) [d setValue:@(fCharacterSpacing) forKey:NSKernAttributeName];
    
    NSDictionary *dV = [NSDictionary dictionaryWithDictionary:d];
    
    CGRect rect = [aString boundingRectWithSize:(CGSize){fWidth , CGFLOAT_MAX}
                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                     attributes:dV
                                        context:nil];
    return rect.size.height >= fEstimateHeight ? rect.size.height : fEstimateHeight;
}

@end
