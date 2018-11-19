//
//  ViewController.m
//  LightDemo
//
//  Created by user on 2018/11/14.
//  Copyright © 2018年 adu. All rights reserved.
//

#import "LightViewController.h"
#import "ADLightSwitch.h"
#import "ADLightSlider.h"
#import "ADLightView.h"
#import "ADColorPicker.h"

@interface LightViewController () <ADColorPickerDelegate, ADSliderDelegate>

@property (nonatomic, strong) ADLightSlider *slider;
@property (nonatomic, strong) ADLightView *lightView;

@end

@implementation LightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initConfig];
    [self buildLightScene];
}

- (void)initConfig {
    self.view.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:1.0];
}

- (void)buildLightScene {
    //灯泡
    self.lightView = [[ADLightView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - [self Suit:75], 64 + [self Suit:40], [self Suit:150], [self Suit:255])];
    self.lightView.isOn = YES;
    self.lightView.scaleToValue = 0.8;
    [self.view addSubview:self.lightView];
    
    //灯泡线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"DCDCDC" alpha:1.0];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lightView.mas_centerX);
        make.bottom.equalTo(self.lightView.mas_top);
        make.width.mas_equalTo([self Suit:3]);
        make.top.equalTo(self.view.mas_top);
    }];
    
    //开关
    ADLightSwitch *lightSwitch = [[ADLightSwitch alloc] initWithFrame:CGRectMake(ScreenWidth - [self Suit:60], [self Suit:100], [self Suit:36], [self Suit:90])];
    lightSwitch.isOn = self.lightView.isOn;
    [lightSwitch setADSwitchDidSelectedBlock:^(BOOL isOn) {
        if (isOn) {
            NSLog(@"开");
            self.lightView.isOn = YES;
            [self.lightView setNeedsDisplay];
        } else {
            NSLog(@"关");
            self.lightView.isOn = NO;
            [self.lightView setNeedsDisplay];
        }
    }];
    [self.view addSubview:lightSwitch];
    
    //滑杆
    self.slider = [[ADLightSlider alloc] initWithFrame:CGRectMake([self Suit:30], ScreenHeight - [self Suit:180], [self Suit:60], [self Suit:160])];
    self.slider.delegate = self;
    self.slider.value = self.lightView.scaleToValue;
    [self.view addSubview:self.slider];
    
    //颜色选择
    ADColorPicker *colorPicker = [[ADColorPicker alloc] initWithFrame:CGRectMake(ScreenWidth - [self Suit:210], ScreenHeight - [self Suit:200], [self Suit:180], [self Suit:180])];
    colorPicker.delegate = self;
    [self.view addSubview:colorPicker];
}

#pragma mark - ADColorPickerDelegate
- (void)getCurrentColor:(UIColor *)color {
    self.slider.slideColor = color;
    self.lightView.lightColor = color;
    [self.lightView setNeedsDisplay];
}

#pragma mark - ADSliderDelegate
- (void)getCurrentSliderValue:(CGFloat)value {
    self.lightView.scaleToValue = value;
    [self.lightView setNeedsDisplay];
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


@end
