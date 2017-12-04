//
//  XCStarView.m
//  XCStarViewExample
//
//  Created by 樊小聪 on 2017/3/14.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


#import "XCStarView.h"


/* 🐖 ***************************** 🐖 XCStarView 🐖 *****************************  🐖 */

@implementation XCStarViewConfigure

+ (instancetype)defaultConfigure
{
    XCStarViewConfigure *configure = [[XCStarViewConfigure alloc] init];
    
    configure.onStarImage  = [self imageWithBundleClass:[self class] imageName:@"icon_star_on"];
    configure.offStarImage = [self imageWithBundleClass:[self class] imageName:@"icon_star_off"];
    configure.starCount    = 5;
    configure.starMargin   = 10;
    configure.canEdit      = YES;
    
    return configure;
}

#pragma mark - 🔒 👀 Privite Method 👀
/**
 *  通过 Bundle 所在的目录加载图片
 *
 *  @param cls          Bundle所在的类名
 *  @param imageName    图片名称
 */
+ (UIImage *)imageWithBundleClass:(Class)cls
                        imageName:(NSString *)imageName
{
    NSInteger scale = [UIScreen mainScreen].scale;
    
    NSBundle *currentBundle = [NSBundle bundleForClass:cls];
    NSString *bundleName =  @"XCStarView.bundle";
    NSString *imagePath  = [currentBundle pathForResource: [NSString stringWithFormat:@"%@@%zdx", imageName, scale] ofType:@"png" inDirectory:bundleName];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end

/* 🐖 ***************************** 🐖 XCStarView 🐖 *****************************  🐖 */

@interface XCStarView ()

@property (strong, nonatomic) XCStarViewConfigure *configure;

#pragma mark - 👀 以下字段只在 不可编辑模式下有用 👀 💤
/** 👀 点亮的星星的视图 👀 */
@property (weak, nonatomic) UIView *onStarView;
/** 👀 没有点亮的星星 👀 */
@property (weak, nonatomic) UIView *offStarView;

@end


@implementation XCStarView

#pragma mark - 🔓 👀 Public Method 👀

/**
 返回一个评星的视图
 
 @param frame 尺寸
 @param configure 配置
 */
- (instancetype)initWithFrame:(CGRect)frame configure:(XCStarViewConfigure *)configure
{
    if (self = [super initWithFrame:frame])
    {
        self.configure = configure ?: [XCStarViewConfigure defaultConfigure];
        
        // 设置 UI
        [self setupUI];
    }
    
    return self;
}

/**
 返回一个评星的视图
 
 @param frame 尺寸
 @param configure 配置
 */
+ (instancetype)starViewWithFrame:(CGRect)frame configure:(XCStarViewConfigure *)configure
{
    return [[self alloc] initWithFrame:frame configure:configure];
}

#pragma mark - 🔒 👀 Privite Method 👀

/**
    设置 UI
 */
- (void)setupUI
{
    /*⏰ ----- 创建并添加视图 ----- ⏰*/
    CGFloat starWH = CGRectGetWidth(self.bounds) / self.configure.starCount - self.configure.starMargin;
    
    starWH = MIN(starWH, CGRectGetHeight(self.bounds));
    
    if (self.configure.canEdit)
    {
        /// 可以编辑
        for (NSInteger i = 0; i < self.configure.starCount; i ++)
        {
            UIImageView *starImgView = [[UIImageView alloc] initWithImage:self.configure.offStarImage highlightedImage:self.configure.onStarImage];
            starImgView.bounds = CGRectMake(0, 0, starWH, starWH);
            [self addSubview:starImgView];
        }
        
        /// 默认 满分好评
        [self updateValueWithPoint:CGPointMake(CGRectGetWidth(self.bounds), 0)];
    }
    else
    {
        self.userInteractionEnabled = NO;
        
        /// 不可以编辑
        CGFloat w = (starWH + self.configure.starMargin) * self.configure.starCount;
        CGFloat h = CGRectGetHeight(self.frame);
        
        UIView *onStarView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        UIView *offStarView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        
        self.onStarView   = onStarView;
        self.offStarView  = offStarView;
        
        [self addSubview:offStarView];
        [self addSubview:onStarView];
        
        CGFloat starCenterY = CGRectGetHeight(self.bounds) * 0.5;
        
        for (NSInteger i = 0; i < self.configure.starCount; i ++)
        {
            CGFloat starCenterX = (starWH + self.configure.starMargin) * i + starWH * 0.5;

            UIImageView *onStarImgView = [[UIImageView alloc] initWithImage:self.configure.onStarImage];
            onStarImgView.bounds = CGRectMake(0, 0, starWH, starWH);
            onStarImgView.center = CGPointMake(starCenterX, starCenterY);
            [self.onStarView addSubview:onStarImgView];
            
            UIImageView *offStarImgView = [[UIImageView alloc] initWithImage:self.configure.offStarImage];
            offStarImgView.bounds = CGRectMake(0, 0, starWH, starWH);
            offStarImgView.center = CGPointMake(starCenterX, starCenterY);
            [self.offStarView addSubview:offStarImgView];
        }
    }
}

/**
    更新子控件frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.configure.canEdit)
    {
        /// 如果不可以编辑，直接返回
        return;
    }
    
    /// 可以编辑
    NSInteger count = self.subviews.count;
    
    CGFloat itemW = CGRectGetWidth(self.bounds) / count - self.configure.starMargin;
    
    CGFloat starWH = MIN(itemW, CGRectGetHeight(self.bounds));
    
    CGFloat starCenterY = CGRectGetHeight(self.bounds) * 0.5;
    
    for (NSInteger i = 0; i < count; i ++)
    {
        CGFloat starCenterX = (starWH + self.configure.starMargin) * i + starWH * 0.5;
        
        UIImageView *starImgView = self.subviews[i];
        starImgView.center = CGPointMake(starCenterX, starCenterY);
    }
}

/**
 通过指定坐标更新星星的状态和value

 @param point 对应的坐标
 */
- (void)updateValueWithPoint:(CGPoint)point
{
    /// 至少有 一颗星星是 点亮状态的
    if (point.x <= 0.0001)
    {
        point.x = 1.f;
    }
    
    UIImageView *animationImgView;
    NSInteger lightStarIndex = 0;
    
    /// 指定点 右边 的星星 ---》没有点亮
    /// 指定占 左边 的星星 ---》点亮
    for (UIImageView *imgView in self.subviews)
    {
        if (point.x < CGRectGetMinX(imgView.frame))
        {
            // 指定点 右边 的星星 ---》没有点亮
            imgView.highlighted = NO;
        }
        else
        {
            /// 指定占 左边 的星星 ---》点亮
            imgView.highlighted = YES;
            animationImgView = imgView;
            lightStarIndex ++;
        }
    }
    
    if (_lightCount == lightStarIndex)
    {
        return;
    }
    
    _lightCount = lightStarIndex;
    
    /** 👀 回调 👀 */
    if (self.starStateDidChangeHandle)
    {
        self.starStateDidChangeHandle(lightStarIndex);
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    [UIView animateWithDuration:0.15f
                     animations:^{
                         
                         animationImgView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.1f
                                          animations:^{
                                              animationImgView.transform = CGAffineTransformIdentity;
                                          } completion:nil];
    }];
}

#pragma mark - 👀 Setter Method 👀 💤

- (void)setValue:(CGFloat)value
{
    _value = value;
    
    CGFloat oldOnStarViewW = CGRectGetWidth(self.offStarView.frame);
    CGFloat newOnStarViewW = value * oldOnStarViewW;
    
    CGRect rect = self.offStarView.frame;
    rect.size.width = newOnStarViewW;
    
    self.onStarView.frame = rect;
    self.onStarView.clipsToBounds = YES;
}

#pragma mark - 🎬 👀 Action Method 👀

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.configure.canEdit)
    {
        /// 如果不可以编辑，直接返回
        return NO;
    }
    
    CGPoint point = [touch locationInView:self];
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    [self updateValueWithPoint:point];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.configure.canEdit)
    {
        /// 如果不可以编辑，直接返回
        return NO;
    }
    
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.frame, point))
    {
        [self sendActionsForControlEvents:UIControlEventTouchDragInside];
    }
    else
    {
        [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    }
    [self updateValueWithPoint:point];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.configure.canEdit)
    {
        /// 如果不可以编辑，直接返回
        return;
    }
    
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.frame, point))
    {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}

@end



