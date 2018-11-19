//
//  ADColorPicker.h
//  LightDemo
//
//  Created by user on 2018/11/16.
//  Copyright © 2018 adu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADColorPickerDelegate <NSObject>

- (void)getCurrentColor:(UIColor *)color;

@end

@interface ADColorPicker : UIView

@property (nonatomic, weak) id <ADColorPickerDelegate> delegate;

@end

