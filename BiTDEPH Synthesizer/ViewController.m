//
//  ViewController.m
//  BiTDEPH Synthesizer
//
//  Created by Nathan Villicaña-Shaw on 2/11/16.
//  Copyright © 2016 Nathan Villicaña-Shaw. All rights reserved.
//

#import "ViewController.h"

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
}

- (IBAction)slider2Changed:(id)sender
{
    UISlider *slider2 = (UISlider *)sender;
    NSLog(@"Slider 2 value : %f", [slider2 value]);
}

- (IBAction)slider3Changed:(id)sender
{
    UISlider *slider3 = (UISlider *)sender;
    NSLog(@"Slider 3 value : %f", [slider3 value]);
}

- (IBAction)slider4Changed:(id)sender
{
    UISlider *slider4 = (UISlider *)sender;
    NSLog(@"Slider 4 value : %f", [slider4 value]);
}

- (IBAction)magicButtonPressed:(id)sender
{
    UIButton *magicButtonDown = (UIButton *)sender;
    NSLog(@"Magic Button Pressed");
}

- (IBAction)magicButtonReleased:(id)sender
{
    UIButton *magicButtonUp = (UIButton *)sender;
    NSLog(@"Magic Button Released");
}
@end
