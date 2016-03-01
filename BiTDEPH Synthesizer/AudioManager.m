//
//  AudioManager.m
//  WeekThree
//
//  Created by Spencer Salazar on 2/8/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#import "AudioManager.h"
#import "ViewController.h"
#import "TheAmazingAudioEngine/TheAmazingAudioEngine.h"

#define SRATE 44100

@interface AudioManager ()
{
    AEAudioController *_audioController;
    
    // why are these declared here instead of in the .h file?
    float FMCarrierPhase;
    float FMModulatorPhase;
    float AMPhase;
    
    float FMCarrierFreq;
    float FMModulatorFreq;
    float AMFreq;
    
    float masterGain;
    
    float FMCarrierGain;
    float FMModulatorGain;
    float AMGain;
    
    float masterSamp;
    float FMCarrierSamp;
    float FMModulatorSamp;
    float AMSamp;
    
    bool AMActive;
}

@end

@implementation AudioManager

+ (instancetype)instance
{
    static AudioManager *_instance = nil;
    @synchronized(self) {
        if(_instance == nil)
            _instance = [AudioManager new];
    }
    return _instance;
}

- (void)startAudio
{
    AudioStreamBasicDescription audioDescription = [AEAudioController nonInterleavedFloatStereoAudioDescription];
    audioDescription.mSampleRate = SRATE;
    
    _audioController = [[AEAudioController alloc] initWithAudioDescription:audioDescription
                                                              inputEnabled:NO];
    _audioController.preferredBufferDuration = 0.005;
    
    FMCarrierPhase = 0;
    FMModulatorPhase = 0;
    AMPhase = 0;
    
    FMModulatorFreq = 500;
    FMCarrierFreq = 230;
    AMFreq = 10;
    
    masterGain = 0.0;
    FMModulatorGain = 10.0;
    FMCarrierGain = 0.55;
    
    [_audioController addChannels:@[[AEBlockChannel channelWithBlock: ^(const AudioTimeStamp *time,
                                                                       UInt32 frames,
                                                                       AudioBufferList *audio) {
        
        for(int i = 0; i < frames; i++)
        {
            // add in ability for more waveforms in future
            FMCarrierSamp = sin(2*M_PI*FMCarrierPhase) * FMCarrierGain;
            FMModulatorSamp = sin(2*M_PI*FMModulatorPhase) * FMModulatorGain;
            AMSamp = sin(2*M_PI*AMPhase) * AMGain;
            
            FMCarrierPhase += FMCarrierFreq/SRATE;
            FMModulatorPhase += FMModulatorFreq/SRATE;
            AMPhase += AMFreq/SRATE;
            
            if(FMCarrierPhase > 1)
                FMCarrierPhase -= 1;
            if(FMModulatorPhase > 1)
                FMModulatorPhase -= 1;
            if(AMPhase > 1)
                AMPhase -= 1;
            
            // currently AM is disabled
            if(AMActive){
                masterSamp = FMCarrierPhase * FMModulatorPhase * masterGain * 0.75 * AMPhase;
            }
            else {
                masterSamp = FMCarrierPhase * FMModulatorPhase * masterGain * 0.75;
                
            }
            ((float*)(audio->mBuffers[0].mData))[i] = masterSamp;
            ((float*)(audio->mBuffers[1].mData))[i] = masterSamp;
        }
        
    }]]];
    
    [_audioController start:NULL];
}

- (void)setFMCarrierGain:(float)gain
{
    FMCarrierGain = gain;
}

- (void)setFMModulatorGain:(float)gain
{
    FMModulatorGain = gain;
}

- (void)setAMGain:(float)gain
{
    AMGain = gain;
}

- (void)setMasterGain:(float)gain
{
    masterGain = gain;
}

- (void)setFMCarrierFreq:(float)freq
{
    FMCarrierFreq = freq;
}

- (void)setFMModulatorFreq:(float)freq
{
    FMModulatorFreq = freq;
}

- (void)setAMFreq:(float)freq
{
    AMFreq = freq;
}

- (float)getFMCarrierFreq
{
    return FMCarrierFreq;
}

- (float)getFMModulatorFreq
{
    return FMModulatorFreq;
}

- (float)getAMFreq
{
    return AMFreq;
}

- (void)activateAM
{
    AMActive = true;
}

- (void)deactivateAM
{
    AMActive = false;
}
- (void)toggleAM
{
    AMActive = !AMActive;
}
@end








