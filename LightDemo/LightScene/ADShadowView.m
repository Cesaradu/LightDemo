//
//  ShadowView.m
//  SliderDemo
//
//  Created by user on 2018/11/9.
//  Copyright © 2018年 user. All rights reserved.
//

#import "ADShadowView.h"

@interface ADShadowView () {
    CGFloat _r;
    CGFloat _g;
    CGFloat _b;
}

@end

@implementation ADShadowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.scaleToValue = 0.6;
    }
    return self;
}

- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    if (isOn) {
        [self turnOn];
    } else {
        [self turnOff];
    }
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    
    const CGFloat  *components = CGColorGetComponents(shadowColor.CGColor);
    _r = components[0];
    _g = components[1];
    _b = components[2];
}

- (void)setScaleToValue:(CGFloat)scaleToValue {
    _scaleToValue = scaleToValue + 1;
    NSLog(@"scaleToValue = %lf", _scaleToValue);
    self.transform = CGAffineTransformMakeScale(_scaleToValue, _scaleToValue);
}

- (void)drawRect:(CGRect)rect {
    // 创建色彩空间对象
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();

    CGGradientRef gradient;
    if (self.isOn) {
        // 创建起点和终点颜色分量的数组
        CGFloat colors[] = {_r,_g,_b,1.0,1.0,1.0,1.0,0.0};
        //形成梯形，渐变的效果
        gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
    } else {
        // 创建起点和终点颜色分量的数组
        CGFloat colors[] = {1.0,1.0,1.0,0.0,1.0,1.0,1.0,0.0}; //关灯状态，全透明不显示
        //形成梯形，渐变的效果
        gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
    }
    // 起点颜色起始圆心
    CGPoint start = CGPointMake(rect.size.width/2, rect.size.height/2);
    // 终点颜色起始圆心
    CGPoint end = CGPointMake(rect.size.width/2, rect.size.height/2);
    // 起点颜色圆形半径
    CGFloat startRadius = 0.0f;
    // 终点颜色圆形半径
    CGFloat endRadius = rect.size.width/2;
    // 获取上下文
    CGContextRef graCtx = UIGraphicsGetCurrentContext();
    // 创建一个径向渐变
    CGContextDrawRadialGradient(graCtx, gradient, start, startRadius, end, endRadius, 0);

    //releas
    CGGradientRelease(gradient);
    gradient = NULL;
    CGColorSpaceRelease(rgb);
    
    [self turnOn];
}

- (void)turnOn {
    //缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:self.scaleToValue];
    animation.toValue = [NSNumber numberWithFloat:self.scaleToValue - 0.1];
    animation.duration = 3.0;
    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"zoom"];
}

- (void)turnOff {
    [self.layer removeAllAnimations];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
