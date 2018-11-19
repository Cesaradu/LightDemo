//
//  ADLightView.m
//  LightDemo
//
//  Created by user on 2018/11/14.
//  Copyright © 2018年 adu. All rights reserved.
//

#import "ADLightView.h"

@interface ADLightView ()



@end

@implementation ADLightView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfig];
        [self buildLightView];
    }
    return self;
}

- (void)initConfig {
    self.backgroundColor = [UIColor clearColor];
    self.lightColor = [UIColor colorWithHexString:@"ffffff" alpha:1.0];
    self.isOn = NO;
}

- (void)setScaleToValue:(CGFloat)scaleToValue {
    _scaleToValue = scaleToValue;
    self.shadowView.scaleToValue = scaleToValue;
    [self.shadowView setNeedsDisplay];
}

- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    self.shadowView.isOn = isOn;
    [self.shadowView setNeedsDisplay];
}

- (void)setLightColor:(UIColor *)lightColor {
    _lightColor = lightColor;
    self.shadowView.shadowColor = lightColor;
    [self.shadowView setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    //绘制半圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    //y填充颜色
    if (self.isOn) {
        CGContextSetFillColorWithColor(context, self.lightColor.CGColor);
    } else {
        CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"DCDCDC" alpha:1.0].CGColor);
    }
    CGContextMoveToPoint(context, self.bounds.size.width/2, self.bounds.size.height - self.bounds.size.width/2);
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height - self.bounds.size.width/2, self.bounds.size.width/2,  M_PI, M_PI * 2, 1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
}

- (void)buildLightView {
    self.lightImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self Suit:150], [self Suit:180])];
    self.lightImage.image = [UIImage imageNamed:@"light"];
    self.lightImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.lightImage];
    
    self.shadowView = [[ADShadowView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lightImage.frame) - [self Suit:55], [self Suit:150], [self Suit:150])];
    self.shadowView.shadowColor = self.lightColor;
    [self addSubview:self.shadowView];
}

/**
 适配 给定375屏尺寸，适配320和414屏尺寸
 */
- (float)Suit:(float)MySuit {
    IS_WIDTH320 ? (MySuit = MySuit / Suit320Width) : (IS_WIDTH414 ? (MySuit = MySuit * Suit414Width) : MySuit);
    return MySuit;
}

/**
 适配 给定375屏字号，适配320和414屏字号
 */
- (float)SuitFont:(float)font {
    IS_WIDTH320 ? (font = font - 1) : (IS_WIDTH414 ? (font = font + 1) : font);
    return font;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
