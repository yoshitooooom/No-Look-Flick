//
//  ViewController.h
//  NolookFlick
//
//  Created by yoshitooooom on 12/11/27.
//  Copyright (c) 2012年 yoshitooooom. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CoreGraphics/CGContext.h>
#import "UIButtonJudge.h"
#import "VerticallyAlignedLabel.h"

@class VerticallyAlignedLabel;


@interface ViewController : UIViewController
{
    int countShake; // count of shaking
    
    // Touch Point
    CGPoint touchPoint[1000];
    CGPoint touchStart;
    
    // UI
    UIButtonJudge *ButtonJudge;
    UIImage *backgroundImage;
    UIImageView *canvas;
    UIImageView *ButtonImage1;
    UIImageView *ButtonImage2;
    UIImageView *ButtonImage3;
    
    // Output
    VerticallyAlignedLabel *output;
    
    // Touch trajectory
    int i, j;
    
    char key[15];
}

@property (strong, nonatomic) IBOutlet UILabel *key1;
@property (strong, nonatomic) IBOutlet UILabel *key2;
@property (strong, nonatomic) IBOutlet UILabel *key3;
@property (strong, nonatomic) IBOutlet UILabel *key4;
@property (strong, nonatomic) IBOutlet UILabel *key5;
@property (strong, nonatomic) IBOutlet UILabel *key6;
@property (strong, nonatomic) IBOutlet UILabel *key7;
@property (strong, nonatomic) IBOutlet UILabel *key8;
@property (strong, nonatomic) IBOutlet UILabel *key9;
@property (strong, nonatomic) IBOutlet UILabel *key10;
@property (strong, nonatomic) IBOutlet UILabel *key11;
@property (strong, nonatomic) IBOutlet UILabel *key12;
@property (strong, nonatomic) IBOutlet UILabel *key13;
@property (strong, nonatomic) IBOutlet UILabel *key14;
@property (strong, nonatomic) IBOutlet UILabel *key15;

@end
