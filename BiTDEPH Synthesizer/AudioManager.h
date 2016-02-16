//
//  AudioManager.h
//  WeekThree
//
//  Created by Spencer Salazar on 2/8/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioManager : NSObject

+ (instancetype)instance;

- (void)startAudio;

- (void)setGain1:(float)gain;
- (void)setGain2:(float)gain;
- (void)setGain3:(float)gain;
- (void)setGain4:(float)gain;

- (void)setOT1:(int)overTone;
- (void)setOT2:(int)overTone;
- (void)setOT3:(int)overTone;
- (void)setOT4:(int)overTone;

- (void)setMasterGain:(float)gain;

- (void)setFrequency:(float)frequency;
- (float)getFrequency;

@end