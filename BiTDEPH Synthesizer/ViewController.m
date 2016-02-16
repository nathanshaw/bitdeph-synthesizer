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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)slider1Changed:(id)sender
{
    UISlider *slider1 = (UISlider *)sender;
    NSLog(@"Slider 1 value : %f", [slider1 value]);
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setGain1:([slider1 value])];
}

- (IBAction)slider2Changed:(id)sender
{
    UISlider *slider2 = (UISlider *)sender;
    NSLog(@"Slider 2 value : %f", [slider2 value]);
    AudioManager *audioManager = [AudioManager instance];
    //[audioManager setFrequency:([slider1 value]*1000)];
    [audioManager setGain2:[slider2 value]];
}

- (IBAction)slider3Changed:(id)sender
{
    UISlider *slider3 = (UISlider *)sender;
    NSLog(@"Slider 3 value : %f", [slider3 value]);
    //[audioManager setFrequency:([slider1 value]*1500)];
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setGain3:[slider3 value]];
}

- (IBAction)slider4Changed:(id)sender
{
    UISlider *slider4 = (UISlider *)sender;
    NSLog(@"Slider 4 value : %f", [slider4 value]);
    //[audioManager setFrequency:([slider1 value]*2000)];
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setGain4:[slider4 value]];
}

- (IBAction)slider5Changed:(id)sender
{
    UISlider *slider5 = (UISlider *)sender;
    NSLog(@"Slider 5 value : %f", [slider5 value] * 500 + 200);
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setFrequency:([slider5 value] * 500 + 200)];
}

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

- (IBAction)singleFingerTap:(id)sender
{
    UITouch *touchAction = (UITouch *)sender;
    NSLog(@"Single Finger Tap");
    NSLog([touchAction getForce]);
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setMasterGain:1.0];
}

- (IBAction)doubleFingerTap:(id)sender
{
    UITouch *touchAction = (UITouch *)sender;
    NSLog(@"Double Finger Tap");
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setMasterGain:0.0];
}

@end
