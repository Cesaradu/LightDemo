//
//  ADLightSwitch.h
//  SliderDemo
//
//  Created by user on 2018/11/9.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ADSwitchDidSelectedBlock)(BOOL isOn);

typedef enum {
    SwitchVertical = 0,
    SwitchHorizontal
} SwitchOrientation;

@interface ADLightSwitch : UIView

@property (nonatomic, strong) UIColor *onColor; //开的颜色
@property (nonatomic, strong) UIColor *offColor; //关的颜色
@property (nonatomic, strong) UIColor *headColor; //圆圈颜色
@property (nonatomic, assign) BOOL isOn;

- (void)setADSwitchDidSelectedBlock:(ADSwitchDidSelectedBlock)block;
- (instancetype)initWithFrame:(CGRect)frame WithOrientation:(SwitchOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
