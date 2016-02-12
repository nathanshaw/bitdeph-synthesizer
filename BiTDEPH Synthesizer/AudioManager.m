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
    
    float phase;
    float freq;
    float gain;
    float pulsewidth;
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
    
    phase = 0;
    freq = 220;
    gain = 0;
    pulsewidth = 0.1;
    
    [_audioController addChannels:@[[AEBlockChannel channelWithBlock: ^(const AudioTimeStamp *time,
                                                                       UInt32 frames,
                                                                       AudioBufferList *audio) {
        
        for(int i = 0; i < frames; i++)
        {
            float samp = 0;
            
            samp = sin(2*M_PI*phase);
            samp = 1-2*phase; // saw
            // square/pulse
            if(phase < pulsewidth) samp = 1;
            else samp = -1;
            
            phase += freq/SRATE;
            if(phase > 1)
                phase -= 1;
            
            samp *= gain;
            
            ((float*)(audio->mBuffers[0].mData))[i] = samp;
            ((float*)(audio->mBuffers[1].mData))[i] = samp;
        }
        
    }]]];
    
    [_audioController start:NULL];
}

- (void)setGain:(float)the_gain
{
    gain = the_gain;
}

- (void)setFrequency:(float)frequency
{
    freq = frequency;
}

@end








