//
//  XCStarView.h
//  XCStarViewExample
//
//  Created by 樊小聪 on 2017/3/14.
//  Copyright © 2017年 樊小聪. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XCStarViewConfigure : NSObject
/** 👀 点亮的星星的图片 👀 */
@property (strong, nonatomic) IBInspectable UIImage *onStarImage;

/** 👀 没有点亮的星星的图片 👀 */
@property (strong, nonatomic) IBInspectable UIImage *offStarImage;

/** 👀 星星的个数： 默认 5 个 👀 */
@property (assign, nonatomic) IBInspectable NSInteger starCount;

/** 👀 每个星星之间的间距：默认 10 👀 */
@property (assign, nonatomic) CGFloat starMargin;

/** 👀 是否允许编辑：默认 YES 👀 */
@property (assign, nonatomic) BOOL canEdit;

/**
    默认配置
 */
+ (instancetype)defaultConfigure;

@end


/* 🐖 ***************************** 🐖 XCStarView 🐖 *****************************  🐖 */


@interface XCStarView : UIControl

/** 👀 星星的值 0~1（非编辑模式下有效） 👀 */
@property (assign, nonatomic) CGFloat value;

/** 👀 点亮的星星的个数（编辑模式下有效） 👀 */
@property (assign, nonatomic, readonly) NSInteger lightCount;

/** 👀 当前星星的状态发生改变的回调 👀 */
@property (copy, nonatomic) void(^starStateDidChangeHandle)(NSInteger lightCount);


/**
 返回一个评星的视图

 @param frame 尺寸
 @param configure 配置
 */
- (instancetype)initWithFrame:(CGRect)frame configure:(XCStarViewConfigure *)configure;

/**
 返回一个评星的视图
 
 @param frame 尺寸
 @param configure 配置
 */
+ (instancetype)starViewWithFrame:(CGRect)frame configure:(XCStarViewConfigure *)configure;

@end


