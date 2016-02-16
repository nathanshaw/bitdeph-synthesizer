//
//  AudioManager.m
//  WeekThree
//
//  Created by Spencer Salazar on 2/8/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#import "AudioManager.h"
#import "TheAmazingAudioEngine/TheAmazingAudioEngine.h"

#define SRATE 44100

@interface AudioManager ()
{
    AEAudioController *_audioController;
    
    float phase1;
    float phase2;
    float phase3;
    float phase4;
    
    float mainFreq;
    float freq1;
    float freq2;
    float freq3;
    float freq4;
    
    float masterGain;
    float gain1;
    float gain2;
    float gain3;
    float gain4;
    
    int overtone1;
    int overtone2;
    int overtone3;
    int overtone4;
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
    
    phase1 = 0;
    phase2 = 0;
    phase3 = 0;
    phase4 = 0;
    
    mainFreq = 220;
    freq1 = 220;
    freq2 = freq1 * 2;
    freq3 = freq1 * 3;
    freq4 = freq1 * 4;
    
    masterGain = 0.0;
    gain1 = 0.55;
    gain2 = 0.55;
    gain3 = 0.55;
    gain4 = 0.55;
    
    overtone1 = 1;
    overtone2 = 2;
    overtone3 = 3;
    overtone4 = 4;
    
    [_audioController addChannels:@[[AEBlockChannel channelWithBlock: ^(const AudioTimeStamp *time,
                                                                       UInt32 frames,
                                                                       AudioBufferList *audio) {
        
        for(int i = 0; i < frames; i++)
        {
            float masterSamp = 0;
            float samp1 = 0;
            float samp2 = 0;
            float samp3 = 0;
            float samp4 = 0;
            
            samp1 = sin(2*M_PI*phase1);
            samp2 = sin(2*M_PI*phase2);
            samp3 = sin(2*M_PI*phase3);
            samp4 = sin(2*M_PI*phase4);
            
            phase1 += freq1/SRATE;
            phase2 += freq2/SRATE;
            phase3 += freq3/SRATE;
            phase4 += freq4/SRATE;
            
            if(phase1 > 1)
                phase1 -= 1;
            if(phase2 > 1)
                phase2 -= 1;
            if(phase3 > 1)
                phase3 -= 1;
            if(phase4 > 1)
                phase4 -= 1;
            
            samp1 *= gain1;
            samp2 *= gain2;
            samp3 *= gain3;
            samp4 *= gain4;
            
            masterSamp = samp1 + samp2 + samp3 + samp4;
            masterSamp *= masterGain;
            masterSamp *= 0.25;
            
            ((float*)(audio->mBuffers[0].mData))[i] = masterSamp;
            ((float*)(audio->mBuffers[1].mData))[i] = masterSamp;
        }
        
    }]]];
    
    [_audioController start:NULL];
}

- (void)setGain1:(float)theGain
{
    gain1 = theGain;
}

- (void)setGain2:(float)theGain
{
    gain2 = theGain;
}

- (void)setGain3:(float)theGain
{
    gain3 = theGain;
}

- (void)setGain4:(float)theGain
{
    gain4 = theGain;
}

- (void)setOT1:(int)overTone
{
    overtone1 = overTone;
}

- (void)setOT2:(int)overTone
{
    overtone2 = overTone;
}

- (void)setOT3:(int)overTone
{
    overtone3 = overTone;
}

- (void)setOT4:(int)overTone
{
    overtone4 = overTone;
}

- (void)setMasterGain:(float)theGain
{
    masterGain = theGain;
}

- (void)setFrequency:(float)frequency
{
    mainFreq = frequency;
    freq1 = frequency * overtone1;
    freq2 = frequency * overtone2;
    freq3 = frequency * overtone3;
    freq4 = frequency * overtone4;
}

- (float)getFrequency
{
    return mainFreq;
}

@end








