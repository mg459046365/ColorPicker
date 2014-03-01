//
//  ColorViewController.m
//  ColorPicker
//
//  Created by Mango on 14-2-5.
//  Copyright (c) 2014年 Mango. All rights reserved.
//

#import "ColorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorImageView.h"
#import "ColorScrollView.h"

@interface ColorViewController ()

@property (strong, nonatomic) ColorScrollView *scrollView;
@property (strong,nonatomic) UIImageView *selectedColoImageView;
@property (strong, nonatomic) UILabel *red;
@property (strong, nonatomic) UILabel *green;
@property (strong, nonatomic) UILabel *blue;
@property (strong, nonatomic) UILabel *hexRGB;
@property (strong,nonatomic) UIButton *backButton;
@property (strong,nonatomic) UISlider *slider;
//@property (strong, nonatomic) UIImageView *colorPickerView;

@end

@implementation ColorViewController

- (id)initWithImage:(UIImage *)image
{
    if (self = [super init])
    {
        //bug 要注意在赋值前 先要初始化
        _scrollView = [[ColorScrollView alloc]initWithFrame:CGRectMake(0, 128/2 + 64/2, 320, 568/2)];
        self.scrollView.selectedImageView.image = image;
        return self;
    }
    else
        return nil;
}

//设置状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)loadView
{
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:237.0/255 alpha:1.0];
    
    //设置自定义导航条背景
    UIImageView *topButtonBackgroud = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 128/2)];
    topButtonBackgroud.image = [UIImage imageNamed:@"00 B.png"];
    [self.view addSubview:topButtonBackgroud];
    
    //初始化scrollView
    self.scrollView.maximumZoomScale = 100.0;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.contentSize = CGSizeMake(1000, 1000);
    self.scrollView.bounces = NO;
    self.scrollView.bouncesZoom = NO; //禁止缩小至最小比例之下
    self.scrollView.delegate = self;
    //self.scrollView.canCancelContentTouches = YES;//让子view接收到触摸信息
    [self.view addSubview:self.scrollView];
    
    //增加scrollview上的阴影边框
    UIImageView *shawdowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 128/2 + 64/2, 320, 568/2)];
    shawdowView.image = [UIImage imageNamed:@"阴影.png"];
    [self.view addSubview:shawdowView];
    
    //初始化选中颜色view
    _selectedColoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(42/2 , 793/2, 126/2, 126/2)];
    self.selectedColoImageView.backgroundColor = self.scrollView.selectedImageView.selectedColor;
    self.selectedColoImageView.image = [UIImage imageNamed:@"42x793.png"];
    [self.view addSubview:self.selectedColoImageView];
    
    //初始化颜色值框背景
    UIImageView *rgbView = [[UIImageView alloc]initWithFrame:CGRectMake(196/2, 793/2, 396/2, 126/2)];
    rgbView.image = [UIImage imageNamed:@"196x793.png"];
    [self.view addSubview:rgbView];
    
    //初始化RGB标签
    _red = [[UILabel alloc]initWithFrame:CGRectMake(280/2, 800/2 - 2, 30, 20)];
    _green = [[UILabel alloc]initWithFrame:CGRectMake(280/2, 840/2 - 2, 30, 20)];
    _blue = [[UILabel alloc]initWithFrame:CGRectMake(280/2, 880/2 - 2, 30, 20)];
    _hexRGB = [[UILabel alloc]initWithFrame:CGRectMake(456/2, 846/2 - 5, 80, 20)];
    self.red.font = [UIFont systemFontOfSize:12.0];
    self.green.font = [UIFont systemFontOfSize:12.0];
    self.blue.font = [UIFont systemFontOfSize:12.0];
    self.hexRGB.font = [UIFont systemFontOfSize:12.0];
    self.red.textColor = [UIColor colorWithRed:76.0/255 green:103.0/255 blue:122.0/255 alpha:1.0];
    self.green.textColor = [UIColor colorWithRed:76.0/255 green:103.0/255 blue:122.0/255 alpha:1.0];
    self.blue.textColor = [UIColor colorWithRed:76.0/255 green:103.0/255 blue:122.0/255 alpha:1.0];
    self.hexRGB.textColor = self.red.textColor = [UIColor colorWithRed:76.0/255 green:103.0/255 blue:122.0/255 alpha:1.0];

    self.red.text = self.scrollView.selectedImageView.red;
    self.green.text = self.scrollView.selectedImageView.green;
    self.blue.text = self.scrollView.selectedImageView.blue;
    self.hexRGB.text = self.scrollView.selectedImageView.hexRGB;
    [self.view addSubview:self.red];
    [self.view addSubview:self.green];
    [self.view addSubview:self.blue];
    [self.view addSubview:self.hexRGB];

    
    //初始化按钮
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(30/2, 64/2, 20, 20);
    [self.backButton setImage:[UIImage imageNamed:@"30x64.png"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    //初始化Slider
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(130/2 ,130/2 , 380/2, 15)];
    self.slider.maximumValue = 10;
    [self.slider setThumbImage:[UIImage imageNamed:@"y 148.png"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"130x159.png"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册到通知中心用于更新label
    NSString * updateLabel = @"updateLabelAndColorImage";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabelAndColorImage) name:updateLabel object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -touchEventMethod

- (void)back
{
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)valueChanged
{
    [self.scrollView setZoomScale:self.slider.value*10];
    //self.scrollView.selectedImageView.colorPickerView.hidden = YES;
}

//scrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //将要缩放时，将取色指示计隐藏
    //self.scrollView.selectedImageView.colorPickerView.hidden = YES;
    return self.scrollView.selectedImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.slider.value = scrollView.zoomScale/10;
}
-(void)updateLabelAndColorImage
{
    self.red.text = self.scrollView.selectedImageView.red;
    self.green.text = self.scrollView.selectedImageView.green;
    self.blue.text = self.scrollView.selectedImageView.blue;
    self.hexRGB.text = self.scrollView.selectedImageView.hexRGB;
    self.selectedColoImageView.backgroundColor = self.scrollView.selectedImageView.selectedColor;
}


@end
