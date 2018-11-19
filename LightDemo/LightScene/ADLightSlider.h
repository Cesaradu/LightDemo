//
//  ADLightSlider.h
//  SliderDemo
//
//  Created by user on 2018/11/9.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ADSliderDelegate <NSObject>

- (void)getCurrentSliderValue:(CGFloat)value;

@end


@interface ADLightSlider : UIView

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, strong) UIView *slideView;
@property (nonatomic, strong) UIColor *slideColor;

@property (nonatomic, weak) id <ADSliderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
