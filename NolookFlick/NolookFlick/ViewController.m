//
//  ViewController.m
//  NolookFlick
//
//  Created by yoshitooooom on 12/11/27.
//  Copyright (c) 2012年 yoshitooooom. All rights reserved.
//

#import "ViewController.h"

#define FILTERING_FACTOR 0.1

@interface ViewController ()

@end

@implementation ViewController
@synthesize key1, key2, key3, key4, key5, key6, key7, key8, key9, key10,
key11, key12, key13, key14, key15;

#pragma mark 
- (void)viewDidLoad
{
    // Hiding StatusBar and NavigationBar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.navigationController.navigationBarHidden = YES;
    
    // ButtonImage1
    ButtonImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 260)];
	[self.view addSubview:ButtonImage1];
    [self.view sendSubviewToBack:ButtonImage1];
    ButtonImage1.backgroundColor = [UIColor blackColor];
    ButtonImage1.alpha = 0.05;
    
    // ButtonImage2
    ButtonImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 261, 180, 480)];
	[self.view addSubview:ButtonImage2];
    [self.view sendSubviewToBack:ButtonImage2];
    ButtonImage2.backgroundColor = [UIColor blackColor];
    ButtonImage2.alpha = 0.05;
    
    // ButtonImage3
    ButtonImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(181, 0, 181, 480)];
	[self.view addSubview:ButtonImage3];
    [self.view sendSubviewToBack:ButtonImage3];
    ButtonImage3.backgroundColor = [UIColor blackColor];
    ButtonImage3.alpha = 0.05;
    
    // ButtonJudge
    ButtonJudge = [[UIButtonJudge alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[self.view addSubview:ButtonJudge];
    [self.view sendSubviewToBack:ButtonJudge]; // send to back
    ButtonJudge.backgroundColor = [UIColor blackColor];
    ButtonJudge.userInteractionEnabled = YES;
    ButtonJudge.alpha = 0.1;
    
    // Canvas
    canvas = [[UIImageView alloc] initWithImage:nil];
    canvas.frame = self.view.frame;
    [self.view addSubview:canvas];
    [self.view bringSubviewToFront:canvas];
    
    // Output string
    output = [[VerticallyAlignedLabel alloc] init];
    output.frame = CGRectMake(0, 15, 320, 120);
    output.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    output.textColor = [UIColor whiteColor];
    output.font = [UIFont systemFontOfSize:24];
    output.textAlignment = UITextAlignmentLeft;
    output.verticalAlignment = VerticalAlignmentTop;
    output.numberOfLines = 4;
    output.text = @"(insert here)";
    [self.view addSubview:output];
    
    str = @"";
    countShake = 0;
    i = 0;
    j = 0;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // Support Vertical Orientation Only
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)canBecomeFirstResponder
{
    // Becoming FirstResponder to get a motion
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    str = @"";
    output.text = [NSString stringWithFormat:@"%@", str];
}

- (void)showStart
{
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:@""
     message:str
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    
    [alert show];
}

- (void)saveFile
{
    // save as "write.txt"
    NSData* data=[self str2data:str];
    [self data2file:data fileName:@"write.txt"];
    
    // show alert
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:@""
     message:nil
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"Saved", nil
     ];
    
    [alert show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if( input_button == BUTTON_CONSONANT_1 )
    {
        ButtonImage1.backgroundColor = [UIColor whiteColor];
        ButtonImage1.alpha = 0.1;
    }
    else if( input_button == BUTTON_CONSONANT_2 )
    {
        ButtonImage2.backgroundColor = [UIColor whiteColor];
        ButtonImage2.alpha = 0.1;
    }
    else if( input_button == BUTTON_VOWEL )
    {
        ButtonImage3.backgroundColor = [UIColor whiteColor];
        ButtonImage3.alpha = 0.1;
    }
    
    UITouch *touch = [touches anyObject];
    touchStart = [touch locationInView:canvas];
    j = 1;
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // Updating Current Touch Point
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:canvas];
    
    // Drawing settings
    UIGraphicsBeginImageContext(canvas.frame.size);                      
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 50.0);       
    [canvas.image drawInRect:
     CGRectMake(0, 0, canvas.frame.size.width, canvas.frame.size.height)];    
    
    // Draw touch trajectory on canvas
    if (j == 1)
    {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 0.1, 0.15);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchStart.x, touchStart.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    }
    else if (j >= 2)
    {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 0.1, 0.15);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint[0].x, touchPoint[0].y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    }    
    canvas.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Update Touch Point
    if (j == 1)
    {
        touchPoint[1] = touchStart;
        touchPoint[0] = currentPoint;
    }
    else
    {
        for (i = j; i >= 0; i--) touchPoint[i+1] = touchPoint[i];
        touchPoint[0] = currentPoint;
    }
    j++;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Update output string
    output.text = [NSString stringWithFormat:@"%@", str];
    
    ButtonImage1.backgroundColor = [UIColor blackColor];
    ButtonImage2.backgroundColor = [UIColor blackColor];
    ButtonImage3.backgroundColor = [UIColor blackColor];
    ButtonImage1.alpha = 0.05;
    ButtonImage2.alpha = 0.05;
    ButtonImage3.alpha = 0.05;
    
    // Draw settings
    UIGraphicsBeginImageContext(canvas.frame.size);                      
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 50.0);
    [canvas.image drawInRect:
     CGRectMake(0, 0, canvas.frame.size.width, canvas.frame.size.height)];
    
    // Clear touch trajectory on canvas
    for (i = 0; i < j; i++)
    {
        CGContextSaveGState( UIGraphicsGetCurrentContext() );
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 52.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint[i+1].x, touchPoint[i+1].y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), touchPoint[i].x, touchPoint[i].y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextRestoreGState( UIGraphicsGetCurrentContext() );
    }
    canvas.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Change keys
    if (status == STATUS_1)
    {
        key11.alpha = 0.1;
        key12.alpha = 0.1;
        key13.alpha = 0.1;
        key14.alpha = 0.1;
        key15.alpha = 0.1;
        [self changeKeysC1:@"a" C2:@"i" C3:@"u" C4:@"e" C5:@"o"];
    }
    else if (status == STATUS_2)
    {
        key11.alpha = 0.5;
        key12.alpha = 0.5;
        key13.alpha = 0.5;
        key14.alpha = 0.5;
        key15.alpha = 0.5;
        if (input == INPUT_CONSONANT_A) [self changeKeysC1:@"あ" C2:@"い" C3:@"う" C4:@"え" C5:@"お"];
        else if (input == INPUT_CONSONANT_K) [self changeKeysC1:@"か" C2:@"き" C3:@"く" C4:@"け" C5:@"こ"];
        else if (input == INPUT_CONSONANT_S) [self changeKeysC1:@"さ" C2:@"し" C3:@"す" C4:@"せ" C5:@"そ"];
        else if (input == INPUT_CONSONANT_T) [self changeKeysC1:@"た" C2:@"ち" C3:@"つ" C4:@"て" C5:@"と"];
        else if (input == INPUT_CONSONANT_N) [self changeKeysC1:@"な" C2:@"に" C3:@"ぬ" C4:@"ね" C5:@"の"];
        else if (input == INPUT_CONSONANT_H) [self changeKeysC1:@"は" C2:@"ひ" C3:@"ふ" C4:@"へ" C5:@"ほ"];
        else if (input == INPUT_CONSONANT_M) [self changeKeysC1:@"ま" C2:@"み" C3:@"む" C4:@"め" C5:@"も"];
        else if (input == INPUT_CONSONANT_Y) [self changeKeysC1:@"や" C2:@"" C3:@"ゆ" C4:@"" C5:@"よ"];
        else if (input == INPUT_CONSONANT_R) [self changeKeysC1:@"ら" C2:@"り" C3:@"る" C4:@"れ" C5:@"ろ"];
        else if (input == INPUT_CONSONANT_W) [self changeKeysC1:@"わ" C2:@"を" C3:@"ん" C4:@"ー" C5:@""];
    }
    else if (status == STATUS_3)
    {
        key11.alpha = 0.5;
        key12.alpha = 0.5;
        key13.alpha = 0.5;
        key14.alpha = 0.5;
        key15.alpha = 0.5;

        // the end of string
        NSString *s = [str substringFromIndex:[str length]-1];
        if (consonant == CONSONANT_A)
        {
            if( [s isEqualToString:@"あ"] )
                [self changeKeysC1:@"あ" C2:@"ぁ" C3:@"" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ぁ"] )
                [self changeKeysC1:@"ぁ" C2:@"" C3:@"" C4:@"" C5:@"あ"];
            else if( [s isEqualToString:@"い"] )
                [self changeKeysC1:@"い" C2:@"ぃ" C3:@"" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ぃ"] )
                [self changeKeysC1:@"ぃ" C2:@"" C3:@"" C4:@"" C5:@"い"];
            else if( [s isEqualToString:@"う"] )
                [self changeKeysC1:@"う" C2:@"ぅ" C3:@"" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ぅ"] )
                [self changeKeysC1:@"ぅ" C2:@"" C3:@"" C4:@"" C5:@"う"];
            else if( [s isEqualToString:@"え"] )
                [self changeKeysC1:@"え" C2:@"ぇ" C3:@"" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ぇ"] )
                [self changeKeysC1:@"ぇ" C2:@"" C3:@"" C4:@"" C5:@"え"];
            else if( [s isEqualToString:@"お"] )
                [self changeKeysC1:@"お" C2:@"ぉ" C3:@"" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ぉ"] )
                [self changeKeysC1:@"ぉ" C2:@"" C3:@"" C4:@"" C5:@"お"];
        }
        else if (consonant == CONSONANT_K)
        {
            if( [s isEqualToString:@"か"] )
                [self changeKeysC1:@"か" C2:@"" C3:@"が" C4:@"" C5:@""];
            else if( [s isEqualToString:@"が"] )
                [self changeKeysC1:@"が" C2:@"" C3:@"" C4:@"" C5:@"か"];
            else if( [s isEqualToString:@"き"] )
                [self changeKeysC1:@"き" C2:@"" C3:@"ぎ" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ぎ"] )
                [self changeKeysC1:@"ぎ" C2:@"" C3:@"" C4:@"" C5:@"き"];
            else if( [s isEqualToString:@"く"] )
                [self changeKeysC1:@"く" C2:@"" C3:@"ぐ" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ぐ"] )
                [self changeKeysC1:@"ぐ" C2:@"" C3:@"" C4:@"" C5:@"く"];
            else if( [s isEqualToString:@"け"] )
                [self changeKeysC1:@"け" C2:@"" C3:@"げ" C4:@"" C5:@""];
            else if( [s isEqualToString:@"げ"] )
                [self changeKeysC1:@"げ" C2:@"" C3:@"" C4:@"" C5:@"け"];
            else if( [s isEqualToString:@"こ"] )
                [self changeKeysC1:@"こ" C2:@"" C3:@"ご" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ご"] )
                [self changeKeysC1:@"ご" C2:@"" C3:@"" C4:@"" C5:@"こ"];
        }
        else if (consonant == CONSONANT_S)
        {
            if( [s isEqualToString:@"さ"] )
                [self changeKeysC1:@"さ" C2:@"" C3:@"ざ" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ざ"] )
                [self changeKeysC1:@"ざ" C2:@"" C3:@"" C4:@"" C5:@"さ"];
            else if( [s isEqualToString:@"し"] )
                [self changeKeysC1:@"し" C2:@"" C3:@"じ" C4:@"" C5:@""];
            else if( [s isEqualToString:@"じ"] )
                [self changeKeysC1:@"じ" C2:@"" C3:@"" C4:@"" C5:@"し"];
            else if( [s isEqualToString:@"す"] )
                [self changeKeysC1:@"す" C2:@"" C3:@"ず" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ず"] )
                [self changeKeysC1:@"ず" C2:@"" C3:@"" C4:@"" C5:@"す"];
            else if( [s isEqualToString:@"せ"] )
                [self changeKeysC1:@"せ" C2:@"" C3:@"ぜ" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ぜ"] )
                [self changeKeysC1:@"ぜ" C2:@"" C3:@"" C4:@"" C5:@"せ"];
            else if( [s isEqualToString:@"そ"] )
                [self changeKeysC1:@"そ" C2:@"" C3:@"ぞ" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ぞ"] )
                [self changeKeysC1:@"ぞ" C2:@"" C3:@"" C4:@"" C5:@"そ"];
        }
        else if (consonant == CONSONANT_T)
        {
            if( [s isEqualToString:@"た"] )
                [self changeKeysC1:@"た" C2:@"" C3:@"だ" C4:@"" C5:@""];
            else if( [s isEqualToString:@"だ"] )
                [self changeKeysC1:@"だ" C2:@"" C3:@"" C4:@"" C5:@"た"];
            else if( [s isEqualToString:@"ち"] )
                [self changeKeysC1:@"ち" C2:@"" C3:@"ぢ" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ぢ"] )
                [self changeKeysC1:@"ぢ" C2:@"" C3:@"" C4:@"" C5:@"ち"];
            else if( [s isEqualToString:@"つ"] )
                [self changeKeysC1:@"つ" C2:@"っ" C3:@"づ" C4:@"" C5:@""];
            else if( [s isEqualToString:@"づ"] )
                [self changeKeysC1:@"づ" C2:@"っ" C3:@"" C4:@"" C5:@"つ"];
            else if( [s isEqualToString:@"っ"] )
                [self changeKeysC1:@"っ" C2:@"" C3:@"づ" C4:@"" C5:@"つ"];
            else if( [s isEqualToString:@"て"] )
                [self changeKeysC1:@"て" C2:@"" C3:@"で" C4:@"" C5:@""];
            else if( [s isEqualToString:@"で"] )
                [self changeKeysC1:@"で" C2:@"" C3:@"" C4:@"" C5:@"て"];
            else if( [s isEqualToString:@"と"] )
                [self changeKeysC1:@"と" C2:@"" C3:@"ど" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ど"] )
                [self changeKeysC1:@"ど" C2:@"" C3:@"" C4:@"" C5:@"と"];
        }
        else if (consonant == CONSONANT_H)
        {
            if( [s isEqualToString:@"は"] )
                [self changeKeysC1:@"は" C2:@"" C3:@"ば" C4:@"ぱ" C5:@""];
            else if( [s isEqualToString:@"ば"] )
                [self changeKeysC1:@"ば" C2:@"" C3:@"" C4:@"ぱ" C5:@"は"];
            else if( [s isEqualToString:@"ぱ"] )
                [self changeKeysC1:@"ぱ" C2:@"" C3:@"ば" C4:@"" C5:@"は"];
            else if( [s isEqualToString:@"ひ"] )
                [self changeKeysC1:@"ひ" C2:@"" C3:@"び" C4:@"ぴ" C5:@""];
            else if( [s isEqualToString:@"び"] )
                [self changeKeysC1:@"び" C2:@"" C3:@"" C4:@"ぴ" C5:@"ひ"];
            else if( [s isEqualToString:@"ぴ"] )
                [self changeKeysC1:@"ぴ" C2:@"" C3:@"び" C4:@"" C5:@"ひ"];
            else if( [s isEqualToString:@"ふ"] )
                [self changeKeysC1:@"ふ" C2:@"" C3:@"ぶ" C4:@"ぷ" C5:@""];
            else if( [s isEqualToString:@"ぶ"] )
                [self changeKeysC1:@"ぶ" C2:@"" C3:@"" C4:@"ぷ" C5:@"ふ"];
            else if( [s isEqualToString:@"ぷ"] )
                [self changeKeysC1:@"ぷ" C2:@"" C3:@"ぶ" C4:@"" C5:@"ふ"];
            else if( [s isEqualToString:@"へ"] )
                [self changeKeysC1:@"へ" C2:@"" C3:@"べ" C4:@"ぺ" C5:@""];
            else if( [s isEqualToString:@"べ"] )
                [self changeKeysC1:@"べ" C2:@"" C3:@"" C4:@"ぺ" C5:@"へ"];
            else if( [s isEqualToString:@"ぺ"] )
                [self changeKeysC1:@"ぺ" C2:@"" C3:@"べ" C4:@"" C5:@"へ"];
            else if( [s isEqualToString:@"ほ"] )
                [self changeKeysC1:@"ほ" C2:@"" C3:@"ぼ" C4:@"ぽ" C5:@""];
            else if( [s isEqualToString:@"ぼ"] )
                [self changeKeysC1:@"ぼ" C2:@"" C3:@"" C4:@"ぽ" C5:@"ほ"];
            else if( [s isEqualToString:@"ぽ"] )
                [self changeKeysC1:@"ぽ" C2:@"" C3:@"ぼ" C4:@"" C5:@"ほ"];
        }
        else if (consonant == CONSONANT_Y)
        {
            if( [s isEqualToString:@"や"] )
                [self changeKeysC1:@"や" C2:@"ゃ" C3:@"" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ゃ"] )
                [self changeKeysC1:@"ゃ" C2:@"" C3:@"" C4:@"" C5:@"や"];
            else if( [s isEqualToString:@"ゆ"] )
                [self changeKeysC1:@"ゆ" C2:@"ゅ" C3:@"" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ゅ"] )
                [self changeKeysC1:@"ゅ" C2:@"" C3:@"" C4:@"" C5:@"ゆ"];
            else if( [s isEqualToString:@"よ"] )
                [self changeKeysC1:@"よ" C2:@"ょ" C3:@"" C4:@"" C5:@""];
            else if( [s isEqualToString:@"ょ"] )
                [self changeKeysC1:@"ょ" C2:@"" C3:@"" C4:@"" C5:@"よ"];
        }
    }
}

#pragma mark Util (Change key's string)
// Consonant Key 1
- (void)changeKeysA1:(NSString*)k1 A2:(NSString*)k2 A3:(NSString*)k3
                  A4:(NSString*)k4 A5:(NSString*)k5
{
    key1.text = k1;
    key2.text = k2;
    key3.text = k3;
    key4.text = k4;
    key5.text = k5;
}

// Consonant Key 2
- (void)changeKeysB1:(NSString*)k1 B2:(NSString*)k2 B3:(NSString*)k3
                  B4:(NSString*)k4 B5:(NSString*)k5
{
    key6.text = k1;
    key7.text = k2;
    key8.text = k3;
    key9.text = k4;
    key10.text = k5;
}

// Vowel Key
- (void)changeKeysC1:(NSString*)k1 C2:(NSString*)k2 C3:(NSString*)k3
                  C4:(NSString*)k4 C5:(NSString*)k5
{
    key11.text = k1;
    key12.text = k2;
    key13.text = k3;
    key14.text = k4;
    key15.text = k5;
}

#pragma mark Util (Data conversion)
// string to bynary data
- (NSData*)str2data:(NSString*)str
{
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}

// bynary data to string
- (NSString*)data2str:(NSData*)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

// writing bynary data
- (BOOL)data2file:(NSData*)data fileName:(NSString*)fileName
{
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path=[path stringByAppendingPathComponent:fileName];
    return [data writeToFile:path atomically:YES];
}

// reading bynary data
- (NSData*)file2data:(NSString*)fileName
{
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path=[path stringByAppendingPathComponent:fileName];
    return [NSData dataWithContentsOfFile:path];
}

// 階層を調べる
/*
 -(void) dumpAllChildrenOfView:(UIView*) view depth:(int) d buffer:(NSMutableString*) b
 {
 NSString *str = @"";
 for (int i = 0; i < d; i++)
 {
 str = [str stringByAppendingFormat: @"  "];
 }
 
 str = [str stringByAppendingFormat: @"%@%@\n", str, view.class];
 [b appendString: str];
 
 d++;
 for (UIView *child in [view subviews])
 {
 //recursive call
 [self dumpAllChildrenOfView:child depth: d buffer: b];
 }
 }
 */

// 調べた階層を表示
/*
 NSMutableString* ms = [[NSMutableString alloc] init];
 [self dumpAllChildrenOfView:[self view] depth:1 buffer:ms];
 
 UIAlertView* al;
 @try
 {
 al = [[UIAlertView alloc]
 initWithTitle: @""
 message: ms
 delegate: nil
 cancelButtonTitle: @"OK"
 otherButtonTitles:nil];
 [al show];
 }
 @finally
 {
 //[al release];
 NSLog(@"\n%@", ms);
 //[ms release];
 }
 */

@end
