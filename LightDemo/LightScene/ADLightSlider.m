//
//  ADLightSlider.m
//  SliderDemo
//
//  Created by user on 2018/11/9.
//  Copyright © 2018年 user. All rights reserved.
//

#import "ADLightSlider.h"

@interface ADLightSlider ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) CALayer *shadowLayer;
@property (nonatomic, assign) CGRect orignFrame;

@end

@implementation ADLightSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfig];
        [self buildSliderview];
    }
    return self;
}

- (void)setValue:(CGFloat)value {
    _value = value;
    [self refreshUI];
    self.slideView.alpha = value;
}

- (void)setSlideColor:(UIColor *)slideColor {
    _slideColor = slideColor;
    self.slideView.backgroundColor = self.slideColor;
    self.shadowLayer.shadowColor =  self.slideColor.CGColor;
}

- (void)refreshUI {
    self.slideView.frame = CGRectMake(0, self.bgView.frame.size.height - self.bgView.frame.size.height * self.value, self.bgView.frame.size.width, self.bgView.frame.size.height * self.value);
}

- (void)initConfig {
    self.orignFrame = self.frame;
    self.value = 0.6;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //放大效果
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    } completion:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //缩小效果
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:nil];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:self.bgView];
    int y = point.y;
    if (y <= 0) {
        y = 0;
    }
    if (y >= self.bgView.frame.size.height) {
        y = self.bgView.frame.size.height;
    }
    self.value = (self.bgView.frame.size.height - y) / self.bgView.frame.size.height;
    if(self.delegate && [self.delegate respondsToSelector:@selector(getCurrentSliderValue:)]) {
        [self.delegate getCurrentSliderValue:self.value];
    }
}


- (void)buildSliderview {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.orignFrame.size.width - 10, self.orignFrame.size.height - 10)];
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView.layer.cornerRadius = 12;
    self.bgView.clipsToBounds = YES;
    [self addSubview:self.bgView];
    
    self.shadowLayer = [CALayer layer];
    self.shadowLayer.shadowOpacity = 0.3;
    self.shadowLayer.shadowRadius = 12;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:1.0];
    self.shadowLayer.shadowPath = path.CGPath;
    [self.layer addSublayer:self.shadowLayer];
    
    self.slideView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bgView.frame.size.height - self.bgView.frame.size.height * self.value, self.bgView.frame.size.width, self.bgView.frame.size.height * self.value)];
    self.slideColor = [UIColor colorWithHexString:@"ffffff" alpha:1.0];
    [self.bgView addSubview:self.slideView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
