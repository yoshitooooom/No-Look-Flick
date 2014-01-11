//  UIButtonJudge.h

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>

enum E_Input
{
    INPUT_CONSONANT_A = 0,
    INPUT_CONSONANT_K,
    INPUT_CONSONANT_S,
    INPUT_CONSONANT_T,
    INPUT_CONSONANT_N,
    INPUT_CONSONANT_H,
    INPUT_CONSONANT_M,
    INPUT_CONSONANT_Y,
    INPUT_CONSONANT_R,
    INPUT_CONSONANT_W,
    INPUT_VOWEL_A,
    INPUT_VOWEL_I,
    INPUT_VOWEL_U,
    INPUT_VOWEL_E,
    INPUT_VOWEL_O,
    INPUT_KANA,
    INPUT_ALPHABET,
    INPUT_NUMBER,
    INPUT_BACKSAPCE,
};

enum E_InputButton
{
    BUTTON_CONSONANT_1 = 0,
    BUTTON_CONSONANT_2,
    BUTTON_VOWEL
};

enum E_Status
{
    STATUS_1 = 0,
    STATUS_2,
    STATUS_3
};

enum E_Consonant
{
    CONSONANT_A = 0,
    CONSONANT_K,
    CONSONANT_S,
    CONSONANT_T,
    CONSONANT_N,
    CONSONANT_H,
    CONSONANT_M,
    CONSONANT_Y,
    CONSONANT_R,
    CONSONANT_W
};

NSString *str;       // output String
enum E_Input input;                
enum E_InputButton input_button;
enum E_Status status;
enum E_Consonant consonant;

@interface UIButtonJudge : UIImageView
{
    float p1x, p1y, p2x, p2y, dx, dy, distance;
}

@end
