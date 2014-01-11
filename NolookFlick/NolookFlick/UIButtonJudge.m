//  UIButtonJudge.m

#import "UIButtonJudge.h"
#import <math.h>

#define TH_FLICK 21.0  // Threshold: Flick or Tap
#define TH_BACK 250.0  // Threshold: Backspace or Input
#define TH_VER 180     // Threshold: Key boundary (Vertical)
#define TH_CROSS 260   // Threshold: Key boundary (Horizontal)

@implementation UIButtonJudge

- (void)viewDidLoad
{
    status = STATUS_1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Touch point
    UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
    p1x = location.x;
    p1y = location.y;
    
    // Detect which button is pushed
    if( p1x < TH_VER )
    {
        if( p1y < TH_CROSS )       input_button = BUTTON_CONSONANT_1;
        else if( p1y >= TH_CROSS ) input_button = BUTTON_CONSONANT_2;
    }
    else if( p1x >= TH_VER )
    {
        input_button = BUTTON_VOWEL;
    }
    
	[super touchesBegan: touches withEvent: event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved: touches withEvent: event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Touch point
    UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
    p2x = location.x;
    p2y = location.y;
    
    // Displacement
    dx = p2x - p1x;
    dy = p2y - p1y;
    distance = sqrtf( dx*dx + dy*dy );
    
    // Judge kind of input
    if( distance > TH_BACK && p1x > 250 && p2x < 70 )
        input = INPUT_BACKSAPCE;
    else
        [self judgeInput];
    
    // Output string or change consonant
    switch( input ){
        case INPUT_CONSONANT_A:
            consonant = CONSONANT_A;
            status = STATUS_2;
            break;
        case INPUT_CONSONANT_K:
            consonant = CONSONANT_K;
            status = STATUS_2;
            break;
        case INPUT_CONSONANT_S:
            consonant = CONSONANT_S;
            status = STATUS_2;
            break;
        case INPUT_CONSONANT_T:
            consonant = CONSONANT_T;
            status = STATUS_2;
            break;
        case INPUT_CONSONANT_N:
            consonant = CONSONANT_N;
            status = STATUS_2;
            break;
        case INPUT_CONSONANT_H:
            consonant = CONSONANT_H;
            status = STATUS_2;
            break;
        case INPUT_CONSONANT_M:
            consonant = CONSONANT_M;
            status = STATUS_2;
            break;
        case INPUT_CONSONANT_Y:
            consonant = CONSONANT_Y;
            status = STATUS_2;
            break;
        case INPUT_CONSONANT_R:
            consonant = CONSONANT_R;
            status = STATUS_2;
            break;
        case INPUT_CONSONANT_W:
            consonant = CONSONANT_W;
            status = STATUS_2;
            break;
        case INPUT_VOWEL_A:
            [self inputKana];
            break;
        case INPUT_VOWEL_I:
            [self inputKana];
            break;
        case INPUT_VOWEL_U:
            [self inputKana];
            break;
        case INPUT_VOWEL_E:
            [self inputKana];
            break;
        case INPUT_VOWEL_O:
            [self inputKana];
            break;
        case INPUT_BACKSAPCE:
            if( [str length] != 0 )
            {
                str = [str substringToIndex:[str length]-1];
                status = STATUS_1;
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            break;
        default:
            break;
    }
        
	[super touchesEnded: touches withEvent: event];	
}

#pragma mark Judge Input
- (void)judgeInput
{
    if( p1x < TH_VER )
    {
        if( p1y < TH_CROSS )       [self judgeInputAKSTN];
        else if( p1y >= TH_CROSS ) [self judgeInputHMYRW];
    }
    else if( p1x >= TH_VER )       [self judgeInputAIUEO];
    
}

- (void)judgeInputAKSTN
{
    if( distance > TH_FLICK )
    {
        if( fabs(dx) > fabs(dy) )
        {
            if( dx < 0 ) input = INPUT_CONSONANT_K;
            else         input = INPUT_CONSONANT_T;
        }
        else
        {
            if( dy < 0 ) input = INPUT_CONSONANT_S;
            else         input = INPUT_CONSONANT_N;
        }
    }
    else                 input = INPUT_CONSONANT_A;
}

- (void)judgeInputHMYRW
{
    if( distance > TH_FLICK )
    {
        if( fabs(dx) > fabs(dy) )
        {
            if( dx < 0 ) input = INPUT_CONSONANT_M;
            else         input = INPUT_CONSONANT_R;
        }
        else
        {
            if( dy < 0 ) input = INPUT_CONSONANT_Y;
            else         input = INPUT_CONSONANT_W;
        }
    }
    else                 input = INPUT_CONSONANT_H;
}

- (void)judgeInputAIUEO
{
    if( distance > TH_FLICK )
    {
        if( fabs(dx) > fabs(dy) )
        {
            if( dx < 0 ) input = INPUT_VOWEL_I;
            else         input = INPUT_VOWEL_E;
        }
        else
        {
            if( dy < 0 ) input = INPUT_VOWEL_U;
            else         input = INPUT_VOWEL_O;
        }
    }
    else                 input = INPUT_VOWEL_A;
}

#pragma mark Input String
- (void)inputKana
{
    if( status == STATUS_2 )
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        switch( consonant )
        {
            case CONSONANT_A:
                [self inputKanaA];
                break;
            case CONSONANT_K:
                [self inputKanaK];
                break;
            case CONSONANT_S:
                [self inputKanaS];
                break;
            case CONSONANT_T:
                [self inputKanaT];
                break;
            case CONSONANT_N:
                [self inputKanaN];
                break;
            case CONSONANT_H:
                [self inputKanaH];
                break;
            case CONSONANT_M:
                [self inputKanaM];
                break;
            case CONSONANT_Y:
                [self inputKanaY];
                break;
            case CONSONANT_R:
                [self inputKanaR];
                break;
            case CONSONANT_W:
                [self inputKanaW];
                break;
            default:
                break;
        }
    }
    else if( status == STATUS_3 )
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self inputKanaAdditional];
    }
    else if( status == STATUS_1 )
    {
        ;
    }
}

- (void)inputKanaA
{
    switch( input )
    {
        case INPUT_VOWEL_A:
            str = [str stringByAppendingString:@"あ"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_I:
            str = [str stringByAppendingString:@"い"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_U:
            str = [str stringByAppendingString:@"う"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_E:
            str = [str stringByAppendingString:@"え"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_O:
            str = [str stringByAppendingString:@"お"];
            status = STATUS_3;
            break;
        default:
            break;
    }
}

- (void)inputKanaK
{
    switch( input )
    {
        case INPUT_VOWEL_A:
            str = [str stringByAppendingString:@"か"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_I:
            str = [str stringByAppendingString:@"き"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_U:
            str = [str stringByAppendingString:@"く"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_E:
            str = [str stringByAppendingString:@"け"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_O:
            str = [str stringByAppendingString:@"こ"];
            status = STATUS_3;
            break;
        default:
            break;
    }
}

- (void)inputKanaS
{
    switch( input )
    {
        case INPUT_VOWEL_A:
            str = [str stringByAppendingString:@"さ"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_I:
            str = [str stringByAppendingString:@"し"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_U:
            str = [str stringByAppendingString:@"す"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_E:
            str = [str stringByAppendingString:@"せ"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_O:
            str = [str stringByAppendingString:@"そ"];
            status = STATUS_3;
            break;
        default:
            break;
    }
}

- (void)inputKanaT
{
    switch( input )
    {
        case INPUT_VOWEL_A:
            str = [str stringByAppendingString:@"た"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_I:
            str = [str stringByAppendingString:@"ち"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_U:
            str = [str stringByAppendingString:@"つ"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_E:
            str = [str stringByAppendingString:@"て"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_O:
            str = [str stringByAppendingString:@"と"];
            status = STATUS_3;
            break;
        default:
            break;
    }
    
}

- (void)inputKanaN
{
    switch( input )
    {
        case INPUT_VOWEL_A:
            str = [str stringByAppendingString:@"な"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_I:
            str = [str stringByAppendingString:@"に"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_U:
            str = [str stringByAppendingString:@"ぬ"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_E:
            str = [str stringByAppendingString:@"ね"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_O:
            str = [str stringByAppendingString:@"の"];
            status = STATUS_1;
            break;
        default:
            break;
    }
}

- (void)inputKanaH
{
    switch( input )
    {
        case INPUT_VOWEL_A:
            str = [str stringByAppendingString:@"は"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_I:
            str = [str stringByAppendingString:@"ひ"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_U:
            str = [str stringByAppendingString:@"ふ"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_E:
            str = [str stringByAppendingString:@"へ"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_O:
            str = [str stringByAppendingString:@"ほ"];
            status = STATUS_3;
            break;
        default:
            break;
    }
    
}

- (void)inputKanaM
{
    switch( input )
    {
        case INPUT_VOWEL_A:
            str = [str stringByAppendingString:@"ま"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_I:
            str = [str stringByAppendingString:@"み"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_U:
            str = [str stringByAppendingString:@"む"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_E:
            str = [str stringByAppendingString:@"め"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_O:
            str = [str stringByAppendingString:@"も"];
            status = STATUS_1;
            break;
        default:
            break;
    }
}

- (void)inputKanaY
{
    switch( input )
    {
        case INPUT_VOWEL_A:
            str = [str stringByAppendingString:@"や"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_I:
            str = [str stringByAppendingString:@"や"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_U:
            str = [str stringByAppendingString:@"ゆ"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_E:
            str = [str stringByAppendingString:@"や"];
            status = STATUS_3;
            break;
        case INPUT_VOWEL_O:
            str = [str stringByAppendingString:@"よ"];
            status = STATUS_3;
            break;
        default:
            break;
    }
    
}

- (void)inputKanaR
{
    switch( input )
    {
        case INPUT_VOWEL_A:
            str = [str stringByAppendingString:@"ら"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_I:
            str = [str stringByAppendingString:@"り"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_U:
            str = [str stringByAppendingString:@"る"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_E:
            str = [str stringByAppendingString:@"れ"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_O:
            str = [str stringByAppendingString:@"ろ"];
            status = STATUS_1;
            break;
        default:
            break;
    }
    
}

- (void)inputKanaW
{
    switch( input ){
        case INPUT_VOWEL_A:
            str = [str stringByAppendingString:@"わ"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_I:
            str = [str stringByAppendingString:@"を"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_U:
            str = [str stringByAppendingString:@"ん"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_E:
            str = [str stringByAppendingString:@"ー"];
            status = STATUS_1;
            break;
        case INPUT_VOWEL_O:
            str = [str stringByAppendingString:@"わ"];
            status = STATUS_1;
            break;
        default:
            break;
    }
}

- (void)inputKanaAdditional
{
    switch( input ){
        case INPUT_VOWEL_A:
            break;
        case INPUT_VOWEL_I:
            [self inputKanaSmallLetter];
            break;
        case INPUT_VOWEL_U:
            [self inputKanaDakuon];
            break;
        case INPUT_VOWEL_E:
            [self inputKanaHandakuon];
            break;
        case INPUT_VOWEL_O:
            [self inputKanaCancel];
        default:
            break;
    }
}

- (void)inputKanaSmallLetter
{
    // the end of string
    NSString *s = [str substringFromIndex:[str length]-1];
    
    if( [s isEqualToString:@"あ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぁ"];
    else if( [s isEqualToString:@"い"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぃ"];
    else if( [s isEqualToString:@"う"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぅ"];
    else if( [s isEqualToString:@"え"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぇ"];
    else if( [s isEqualToString:@"お"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぉ"];
    else if( [s isEqualToString:@"や"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ゃ"];
    else if( [s isEqualToString:@"ゆ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ゅ"];
    else if( [s isEqualToString:@"よ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ょ"];
    else if( [s isEqualToString:@"つ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"っ"];
}

- (void)inputKanaDakuon
{
    // the end of string
    NSString *s = [str substringFromIndex:[str length]-1];
    
    if( [s isEqualToString:@"か"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"が"];
    else if( [s isEqualToString:@"き"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぎ"];
    else if( [s isEqualToString:@"く"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぐ"];
    else if( [s isEqualToString:@"け"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"げ"];
    else if( [s isEqualToString:@"こ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ご"];
    else if( [s isEqualToString:@"さ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ざ"];
    else if( [s isEqualToString:@"し"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"じ"];
    else if( [s isEqualToString:@"す"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ず"];
    else if( [s isEqualToString:@"せ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぜ"];
    else if( [s isEqualToString:@"そ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぞ"];
    else if( [s isEqualToString:@"た"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"だ"];
    else if( [s isEqualToString:@"ち"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぢ"];
    else if( [s isEqualToString:@"つ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"づ"];
    else if( [s isEqualToString:@"て"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"で"];
    else if( [s isEqualToString:@"と"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ど"];
    else if( [s isEqualToString:@"は"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ば"];
    else if( [s isEqualToString:@"ひ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"び"];
    else if( [s isEqualToString:@"ふ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぶ"];
    else if( [s isEqualToString:@"へ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"べ"];
    else if( [s isEqualToString:@"ほ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぼ"];
}

- (void)inputKanaHandakuon
{
    // the end of string
    NSString *s = [str substringFromIndex:[str length]-1];
    
    if( [s isEqualToString:@"は"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぱ"];
    else if( [s isEqualToString:@"ひ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぴ"];
    else if( [s isEqualToString:@"ふ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぷ"];
    else if( [s isEqualToString:@"へ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぺ"];
    else if( [s isEqualToString:@"ほ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ぽ"];
}

- (void)inputKanaCancel
{
    // the end of string
    NSString *s = [str substringFromIndex:[str length]-1];
    
    // Small letter
    if( [s isEqualToString:@"ぁ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"あ"];
    else if( [s isEqualToString:@"ぃ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"い"];
    else if( [s isEqualToString:@"ぅ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"う"];
    else if( [s isEqualToString:@"ぇ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"え"];
    else if( [s isEqualToString:@"ぉ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"お"];
    else if( [s isEqualToString:@"ゃ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"や"];
    else if( [s isEqualToString:@"ゅ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ゆ"];
    else if( [s isEqualToString:@"ょ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"よ"];
    else if( [s isEqualToString:@"っ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"つ"];
    // Dakuten
    else if( [s isEqualToString:@"が"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"か"];
    else if( [s isEqualToString:@"ぎ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"き"];
    else if( [s isEqualToString:@"ぐ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"く"];
    else if( [s isEqualToString:@"げ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"け"];
    else if( [s isEqualToString:@"ご"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"こ"];
    else if( [s isEqualToString:@"ざ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"さ"];
    else if( [s isEqualToString:@"じ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"し"];
    else if( [s isEqualToString:@"ず"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"す"];
    else if( [s isEqualToString:@"ぜ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"せ"];
    else if( [s isEqualToString:@"ぞ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"そ"];
    else if( [s isEqualToString:@"だ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"た"];
    else if( [s isEqualToString:@"ぢ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ち"];
    else if( [s isEqualToString:@"づ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"つ"];
    else if( [s isEqualToString:@"で"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"て"];
    else if( [s isEqualToString:@"ど"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"と"];
    else if( [s isEqualToString:@"ば"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"は"];
    else if( [s isEqualToString:@"び"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ひ"];
    else if( [s isEqualToString:@"ぶ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ふ"];
    else if( [s isEqualToString:@"べ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"へ"];
    else if( [s isEqualToString:@"ぼ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ほ"];
    // Handakuten
    else if( [s isEqualToString:@"ぱ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"は"];
    else if( [s isEqualToString:@"ぴ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ひ"];
    else if( [s isEqualToString:@"ぷ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ふ"];
    else if( [s isEqualToString:@"ぺ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"へ"];
    else if( [s isEqualToString:@"ぽ"] )
        str = [[str substringToIndex:[str length]-1] stringByAppendingString:@"ほ"];
}

@end
