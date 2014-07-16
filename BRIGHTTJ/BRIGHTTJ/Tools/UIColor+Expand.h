//
//  UIColor+Expand.h
//  demo
//
//  Created by 张鹏 on 13-5-15.
//  Copyright (c) 2013年 zhangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Expand)

/**
 * @brief: 获取随机颜色rgba
 *
 * @return: 随机颜色
 */
+ (UIColor *)normalRandomColor;

/**
 * @brief: 获取随机颜色hsba
 *
 * @return: 随机颜色
 */
+ (UIColor *)specialRandomColor;

@end
