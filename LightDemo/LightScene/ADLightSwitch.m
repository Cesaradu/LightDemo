//
//  ADLightSwitch.m
//  SliderDemo
//
//  Created by user on 2018/11/9.
//  Copyright © 2018年 user. All rights reserved.
//

#import "ADLightSwitch.h"

@interface ADLightSwitch () <CAAnimationDelegate> {
    CGFloat _moveDistance; //移动距离
    BOOL isAnimating; //是否在动画中
    BOOL _isSwitched; //开关操作是否已经执行过
    ADSwitchDidSelectedBlock _adSwitchDidSelectedBlock;
}

//@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) SwitchOrientation orientation; //方向
@property (nonatomic, strong) UISwipeGestureRecognizer *swipe;
@property (nonatomic, strong) CAShapeLayer *headLayer;

@end

const CGFloat kAnimationDuration = 0.4f;

@implementation ADLightSwitch

#pragma mark  set method
- (void)setOnColor:(UIColor *)onColor {
    _onColor = onColor;
    if (_isOn) {
        self.backgroundColor = _onColor;
    }
}

- (void)setOffColor:(UIColor *)offColor {
    _offColor = offColor;
    if (!_isOn) {
        self.backgroundColor = _offColor;
    }
}

- (void)setHeadColor:(UIColor *)headColor {
    _headColor = headColor;
    self.headLayer.fillColor = _headColor.CGColor;
}

- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    self.backgroundColor = _isOn?_onColor:_offColor;
    if (_orientation == SwitchVertical) {
        _headLayer.position = CGPointMake(_headLayer.position.x, _isOn ? _headLayer.position.y + _moveDistance : (_isSwitched ? _headLayer.position.y - _moveDistance : _headLayer.position.y));
        self.swipe.direction = self.isOn ? UISwipeGestureRecognizerDirectionUp : UISwipeGestureRecognizerDirectionDown;
    } else {
        _headLayer.position = CGPointMake(_isOn ? _headLayer.position.x + _moveDistance : (_isSwitched ? _headLayer.position.x - _moveDistance : _headLayer.position.x), _headLayer.position.y);
        self.swipe.direction = self.isOn ? UISwipeGestureRecognizerDirectionLeft : UISwipeGestureRecognizerDirectionRight;
    }
}

- (void)setOrientation:(SwitchOrientation)orientation {
    _orientation = orientation;
    if (_orientation == SwitchVertical) {
        //垂直
        _moveDistance = self.frame.size.height - self.frame.size.width;
        self.layer.cornerRadius = self.frame.size.width/2;
    } else {
        //水平
        _moveDistance = self.frame.size.width - self.frame.size.height;
        self.layer.cornerRadius = self.frame.size.height/2;
    }
}

- (CALayer *)headLayer {
    if (!_headLayer) {
        _headLayer = [CAShapeLayer layer];
        if (_orientation == SwitchVertical) {
            _headLayer.frame = CGRectMake(self.frame.size.width * 0.2, self.frame.size.width * 0.2, self.frame.size.width * 0.6, self.frame.size.width * 0.6);
        } else {
            _headLayer.frame = CGRectMake(self.frame.size.height * 0.2, self.frame.size.height * 0.2, self.frame.size.height * 0.6, self.frame.size.height * 0.6);
        }
        UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:_headLayer.bounds];
        _headLayer.shadowOffset = CGSizeMake(0, 0);
        _headLayer.shadowColor = [UIColor blackColor].CGColor;
        _headLayer.shadowOpacity = 0.3;
        _headLayer.path = path.CGPath;
        
        [self.layer addSublayer:_headLayer];
    }
    return _headLayer;
}

- (void)setADSwitchDidSelectedBlock:(ADSwitchDidSelectedBlock)block {
    _adSwitchDidSelectedBlock = block;
}

#pragma mark
- (instancetype)initWithFrame:(CGRect)frame WithOrientation:(SwitchOrientation)orientation {
    if(self = [super initWithFrame:frame]) {
        [self setOrientation:orientation];
        [self initADSwitch];
        [self addGestures];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (self.frame.size.width > self.frame.size.height) {
            [self setOrientation:SwitchHorizontal];
        } else {
            [self setOrientation:SwitchVertical];
        }
        [self initADSwitch];
        [self addGestures];
    }
    return self;
}

- (void)addGestures {
    //点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchAnimate)];
    [self addGestureRecognizer:tap];
    
    //滑动
    self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchAnimate)];
    if (_orientation == SwitchVertical) {
        self.swipe.direction = self.isOn ? UISwipeGestureRecognizerDirectionUp : UISwipeGestureRecognizerDirectionDown;
    } else {
        self.swipe.direction = self.isOn ? UISwipeGestureRecognizerDirectionLeft : UISwipeGestureRecognizerDirectionRight;
    }
    [self addGestureRecognizer:self.swipe];
}

- (void)initADSwitch {
    isAnimating = NO;
    _isOn = NO;
    _isSwitched = NO;
    
    self.onColor = [UIColor colorWithHexString:@"ffffff" alpha:1.0];
    self.offColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1.0];
    self.headColor = [UIColor colorWithHexString:@"F8F8FF" alpha:1.0];
}

#pragma mark   Tap GestureRecognizer
- (void)switchAnimate {
    if (isAnimating) {
        return;
    }
    
    isAnimating = YES;
    
    CABasicAnimation *headLayerPositionAnimation;
    if (self.orientation == SwitchVertical) {
        headLayerPositionAnimation = [self animationForHeadLayerWithBeginPosition:self.headLayer.position endPosition:CGPointMake(self.headLayer.position.x, _isOn?self.headLayer.position.y - _moveDistance:self.headLayer.position.y + _moveDistance)];
    } else {
        headLayerPositionAnimation = [self animationForHeadLayerWithBeginPosition:self.headLayer.position endPosition:CGPointMake(_isOn?self.headLayer.position.x - _moveDistance:self.headLayer.position.x + _moveDistance, self.headLayer.position.y)];
    }
    headLayerPositionAnimation.delegate = self;
    [self.headLayer addAnimation:headLayerPositionAnimation forKey:@"kHeadLayerPositionAnimationKey"];
    
    CABasicAnimation * backgroundAnimation = [self animationForBackgroundColorWithBeginColor:_isOn?_onColor:_offColor endColor:_isOn?_offColor:_onColor];
    [self.layer addAnimation:backgroundAnimation forKey:@"kBackgroundAnimationKey"];
}

#pragma mark   animation
- (CABasicAnimation *)animationForHeadLayerWithBeginPosition:(CGPoint)beginPosition endPosition:(CGPoint)endPosition {
    CABasicAnimation * headLayerAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    headLayerAnimation.fromValue = [NSValue valueWithCGPoint:beginPosition];
    headLayerAnimation.toValue = [NSValue valueWithCGPoint:endPosition];
    headLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    headLayerAnimation.duration = kAnimationDuration * 2 /3;
    headLayerAnimation.removedOnCompletion = NO;
    headLayerAnimation.fillMode = kCAFillModeForwards;
    
    return headLayerAnimation;
}

- (CABasicAnimation *)animationForBackgroundColorWithBeginColor:(UIColor *)beginColor endColor:(UIColor *)endColor {
    CABasicAnimation * backgroundColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColorAnimation.fromValue = (id)beginColor.CGColor;
    backgroundColorAnimation.toValue = (id)endColor.CGColor;
    backgroundColorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    backgroundColorAnimation.duration = kAnimationDuration * 2 /3;
    backgroundColorAnimation.removedOnCompletion = NO;
    backgroundColorAnimation.fillMode = kCAFillModeForwards;
    
    return backgroundColorAnimation;
}

#pragma mark   Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        isAnimating = NO;
        _isSwitched = YES;
        self.isOn = !self.isOn;
        if (_adSwitchDidSelectedBlock) {
            _adSwitchDidSelectedBlock(self.isOn);
        }
        return;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
