//
//  UIButton+ButtonExpend.h
//  jverify
//
//  Created by 蔡建喜 on 2021/11/15.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ButtonExpend)

/// 设置扩大button宽和高     Padding为true则width和height相对自身bounds扩大的长度  false则取传进来的宽高
- (void)expendWithWidth:(double)width andHeight:(double)height isPadding:(BOOL)isPadding;

@end

NS_ASSUME_NONNULL_END
