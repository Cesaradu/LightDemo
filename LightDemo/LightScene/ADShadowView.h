//
//  ShadowView.h
//  SliderDemo
//
//  Created by user on 2018/11/9.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADShadowView : UIView

@property (nonatomic, assign) BOOL isOn; //是否开启

@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat scaleToValue; //光晕放大比例


- (void)turnOn;
- (void)turnOff;

@end

NS_ASSUME_NONNULL_END
