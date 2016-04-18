//
//  AudioManager.h
//

#import <Foundation/Foundation.h>
#include <stdlib.h>

#import "ViewController.h"
#import "TheAmazingAudioEngine/TheAmazingAudioEngine.h"

#define SRATE 44100

@interface AudioManager : NSObject

+ (instancetype)instance;

- (void)startAudio;

- (void)setSynthesisState:(int)state;
- (void)setFMCarrierGain:(float)gain;
- (void)setFMModulatorGain:(float)gain;

- (void)setFMCarrierFreq:(float)carrierFreq;
- (void)setFMModulatorFreq:(float)modulatorFreq;
- (void)setAMFreq:(float)AMFreq;

- (void)setMasterGain:(float)gain;

- (float)getFMCarrierFreq;
- (float)getFMModulatorFreq;
- (float)getAMModulatorFreq;

- (float *)lastAudioBuffer;
- (int)lastAudioBufferSize;

@end

