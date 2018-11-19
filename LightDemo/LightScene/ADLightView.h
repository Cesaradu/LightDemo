//
//  ADLightView.h
//  LightDemo
//
//  Created by user on 2018/11/14.
//  Copyright © 2018年 adu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADShadowView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADLightView : UIView

@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, strong) UIImageView *lightImage;
@property (nonatomic, strong) ADShadowView *shadowView;
@property (nonatomic, strong) UIColor *lightColor;
@property (nonatomic, assign) CGFloat scaleToValue; //光晕放大比例

@end

NS_ASSUME_NONNULL_END
