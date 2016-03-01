//
//  AudioManager.h
//  WeekThree
//
//  Created by Spencer Salazar on 2/8/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdlib.h>

@interface AudioManager : NSObject

+ (instancetype)instance;

- (void)startAudio;

- (void)activateAM;
- (void)deactivateAM;
- (void)toggleAM;

- (void)setFMCarrierGain:(float)gain;
- (void)setFMModulatorGain:(float)gain;

- (void)setFMCarrierFreq:(float)carrierFreq;
- (void)setFMModulatorFreq:(float)modulatorFreq;
- (void)setAMFreq:(float)AMFreq;

- (void)setMasterGain:(float)gain;

- (float)getFMCarrierFreq;
- (float)getFMModulatFreq;
- (float)getAMmodularFreq;


@end