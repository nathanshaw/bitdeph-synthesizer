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
     [audioManager setFMCarrierFreq:(pow([FMCarrierSlider value], 2)* 500 + 200)];
     // FMCarrierFreqLabel.text = [NSString stringWithFormat: @"%02f", [FMCarrierSlider value]];
 }

- (IBAction)FMModulatorFreqSliderChanged:(id)sender
{
 UISlider *FMModulatorSlider = (UISlider *)sender;
 NSLog(@"Slider 2 value : %f", [FMModulatorSlider value]);
 AudioManager *audioManager = [AudioManager instance];
 [audioManager setFMModulatorFreq:(pow([FMModulatorSlider value], 2) * 500 + 200)];
 // FMCarrierFreqLabel.text = [NSString stringWithFormat: @"%02f", [FMCarrierSlider value]];
}

- (IBAction)FMModulatorGainSliderChanged:(id)sender
{
 UISlider *FMModulatorGainSlider = (UISlider *)sender;
 NSLog(@"Slider 4 value : %f", [FMModulatorGainSlider value]);
 AudioManager *audioManager = [AudioManager instance];
 [audioManager setFMModulatorGain:(pow([FMModulatorGainSlider value], 2) * 100 + 50)];
 // FMCarrierFreqLabel.text = [NSString stringWithFormat: @"%02f", [FMCarrierSlider value]];
}

- (IBAction)AMFreqSliderChanged:(id)sender
{
 UISlider *AMFreqSlider = (UISlider *)sender;
 NSLog(@"Slider 3 value : %f", [AMFreqSlider value]);
 AudioManager *audioManager = [AudioManager instance];
 [audioManager setAMFreq:(pow([AMFreqSlider value], 4) * 12500)];
 // FMCarrierFreqLabel.text = [NSString stringWithFormat: @"%02f", [FMCarrierSlider value]];
}

- (IBAction)AMGainSliderChanged:(id)sender
{
 UISlider *AMGainSlider = (UISlider *)sender;
 NSLog(@"Slider 5 value : %f", [AMGainSlider value]);
 AudioManager *audioManager = [AudioManager instance];
 [audioManager setAMFreq:(pow([AMGainSlider value], 2))];
 // FMCarrierFreqLabel.text = [NSString stringWithFormat: @"%02f", [FMCarrierSlider value]];
}

- (IBAction)magicButtonPressed:(id)sender
{
    NSLog(@"Magic Button Pressed");
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setMasterGain:1.0];
}

- (IBAction)magicButtonReleased:(id)sender
{
    NSLog(@"Magic Button Released");
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setMasterGain:0.0];
}

- (IBAction)topButtonPressed:(id)sender
{
    // UIButton *magicButtonUp = (UIButton *)sender;
    NSLog(@"Top Button Released");
    AudioManager *audioManager = [AudioManager instance];
    [audioManager toggleAM];
}

@end
