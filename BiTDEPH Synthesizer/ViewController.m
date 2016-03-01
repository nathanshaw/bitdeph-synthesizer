//
//  ViewController.m
//  BiTDEPH Synthesizer
//
//  Created by Nathan Villicaña-Shaw on 2/11/16.
//  Copyright © 2016 Nathan Villicaña-Shaw. All rights reserved.
//

#import "ViewController.h"
#import "AudioManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// - (void)didReceiveMemoryWarning {
//     [super didReceiveMemoryWarning];
//     // Dispose of any resources that can be recreated.
// }
// 
 - (IBAction)FMCarrierFreqSliderChanged:(id)sender
 {
     UISlider *FMCarrierSlider = (UISlider *)sender;
     NSLog(@"Slider 1 value : %f", [FMCarrierSlider value]);
     AudioManager *audioManager = [AudioManager instance];
     [audioManager setFMCarrierFreq:([FMCarrierSlider value])];
     // FMCarrierFreqLabel.text = [NSString stringWithFormat: @"%02f", [FMCarrierSlider value]];
 }
// 
// - (IBAction)slider2Changed:(id)sender
// {
//     UISlider *slider2 = (UISlider *)sender;
//     NSLog(@"Slider 2 value : %f", [slider2 value]);
//     AudioManager *audioManager = [AudioManager instance];
//     //[audioManager setFrequency:([slider1 value]*1000)];
//     //[audioManager setGain2:[slider2 value]];
// }
// 
// - (IBAction)slider3Changed:(id)sender
// {
//     UISlider *slider3 = (UISlider *)sender;
//     NSLog(@"Slider 3 value : %f", [slider3 value]);
//     //[audioManager setFrequency:([slider1 value]*1500)];
//     AudioManager *audioManager = [AudioManager instance];
//     //[audioManager setGain3:[slider3 value]];
// }
// 
// - (IBAction)slider4Changed:(id)sender
// {
//     UISlider *slider4 = (UISlider *)sender;
//     NSLog(@"Slider 4 value : %f", [slider4 value]);
//     //[audioManager setFrequency:([slider1 value]*2000)];
//     AudioManager *audioManager = [AudioManager instance];
//     //[audioManager setGain4:[slider4 value]];
// }
// 
// - (IBAction)slider5Changed:(id)sender
// {
//     UISlider *slider5 = (UISlider *)sender;
//     hertz = [slider5 value] * 500 + 400;
//     NSLog(@"Slider 5 value : %f", hertz);
//     AudioManager *audioManager = [AudioManager instance];
//     hertzLabel.text = [NSString stringWithFormat:@"%.01f", hertz];
//     //[audioManager setFrequency:(hertz)];
// }
// 
// - (IBAction)randomnessSliderChanged:(id)sender
// {
//     UISlider *randomSlider = (UISlider *)sender;
//     NSLog(@"Random slider value : %f", [randomSlider value]);
//     AudioManager *audioManager = [AudioManager instance];
//     //[audioManager setRandomLevel:([randomSlider value])];
// }

- (IBAction)magicButtonPressed:(id)sender
{
    UIButton *magicButtonDown = (UIButton *)sender;
    NSLog(@"Magic Button Pressed");
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setMasterGain:1.0];
}

- (IBAction)magicButtonReleased:(id)sender
{
    UIButton *magicButtonUp = (UIButton *)sender;
    NSLog(@"Magic Button Released");
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setMasterGain:0.0];
}

- (IBAction)secondButtonPressed:(id)sender
{
    // UIButton *magicButtonUp = (UIButton *)sender;
    NSLog(@"Second Button Released");
    AudioManager *audioManager = [AudioManager instance];
}

@end
