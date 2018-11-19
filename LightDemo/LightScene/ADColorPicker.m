//
//  ADColorPicker.m
//  LightDemo
//
//  Created by user on 2018/11/16.
//  Copyright © 2018 adu. All rights reserved.
//

#import "ADColorPicker.h"

#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height
#define CENTER CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5)

@interface ADColorPicker ()

@property (nonatomic, strong) UIImageView *centerImage;//中间的图片

@end

@implementation ADColorPicker

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfig];
        [self buildColorPicker];
    }
    return self;
}

- (void)initConfig {
    self.backgroundColor = [UIColor clearColor];
}

- (void)buildColorPicker {
    UIImageView *palette = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paletteColor"]];
    [self addSubview:palette];
    [palette mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo((self.bounds.size.width > self.bounds.size.height) ? (self.bounds.size.height - [self Suit:20]) : (self.bounds.size.width - [self Suit:20]));
    }];
    
    self.centerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator"]];
    self.centerImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.centerImage];
    [self.centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo([self Suit:30]);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    CGFloat chassRadius = (HEIGHT - 20)*0.5 - [self Suit:15/2];
    CGFloat absDistanceX = fabs(currentPoint.x - CENTER.x);
    CGFloat absDistanceY = fabs(currentPoint.y - CENTER.y);
    CGFloat currentTopointRadius = sqrtf(absDistanceX  * absDistanceX + absDistanceY *absDistanceY);
    
    if(currentTopointRadius < chassRadius) {//实在色盘上面
        self.centerImage.center =  currentPoint;
        UIColor *color = [self getPixelColorAtLocation:currentPoint];
        if(self.delegate && [self.delegate respondsToSelector:@selector(getCurrentColor:)]) {

            [self.delegate getCurrentColor:color];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    CGFloat chassRadius = (HEIGHT - 20)*0.5 - [self Suit:15/2];
    CGFloat absDistanceX = fabs(currentPoint.x - CENTER.x);
    CGFloat absDistanceY = fabs(currentPoint.y - CENTER.y);
    CGFloat currentTopointRadius = sqrtf(absDistanceX * absDistanceX + absDistanceY *absDistanceY);
    
    if (currentTopointRadius < chassRadius) {
        //取色
        self.centerImage.center = currentPoint;
        UIColor *color = [self getPixelColorAtLocation:currentPoint];
        if(self.delegate && [self.delegate respondsToSelector:@selector(getCurrentColor:)]) {
            [self.delegate getCurrentColor:color];
        }
    }
    
}

- (UIColor*)getPixelColorAtLocation:(CGPoint)point {
    UIColor *color = nil;
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef inImage = viewImage.CGImage;
    
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) {
        return nil;
    }
    
    size_t w = self.bounds.size.width;
    size_t h = self.bounds.size.height;
    
    CGRect rect = {{0,0},{w,h}};
    
    CGContextDrawImage(cgctx, rect, inImage);
    
    unsigned char *data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) { free(data); }
    
    return color;
}

- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage {
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    size_t pixelsWide = self.bounds.size.width;
    size_t pixelsHigh = self.bounds.size.height;

    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }

    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    CGColorSpaceRelease( colorSpace );
    
    return context;
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
