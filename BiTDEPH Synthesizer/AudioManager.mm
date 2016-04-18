//
//  AudioManager.m
//

#define OFF 0
#define ONLY_CARRIER 1
#define FM_ACTIVE 2
#define AM_ACTIVE 3
#define FOUR_FINGER 4
#define FIVE_FINGER 5

#import "AudioManager.h"
#import "AudioGenerators.h"

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
    
    int synthesisState;
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
    
    masterGain = 0.9;
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
            
            FMCarrierPhase += (FMCarrierFreq/SRATE) * FMCarrierGain ;
            FMModulatorPhase += FMModulatorFreq/SRATE * FMModulatorGain;
            AMPhase += AMFreq/SRATE;
            
            if(FMCarrierPhase > 1)
                FMCarrierPhase -= 1;
            if(FMModulatorPhase > 1)
                FMModulatorPhase -= 1;
            if(AMPhase > 1)
                AMPhase -= 1;
            
            // currently AM is disabled
            switch (synthesisState) {
                case OFF:
                    masterSamp = 0;
                    break;
                    
                case ONLY_CARRIER:
                    //
                    masterSamp = FMCarrierPhase * masterGain;
                    break;
                    
                case FM_ACTIVE:
                    masterSamp = (FMCarrierPhase + FMModulatorPhase) * masterGain;
                    break;
                    
                case AM_ACTIVE:
                    masterSamp = (FMCarrierPhase + FMModulatorPhase) * AMPhase * masterGain;
                    break;
                    
                case FOUR_FINGER:
                    masterSamp = (FMCarrierPhase + FMModulatorPhase) * AMPhase * masterGain;
                    break;
                    
                case FIVE_FINGER:
                    masterSamp = (FMCarrierPhase + FMModulatorPhase) * AMPhase * masterGain;
                    break;
                    
                default:
                    masterSamp = 0;
                    break;
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

- (float)getAMModulatorFreq
{
    return AMFreq;
}

- (void)setSynthesisState:(int)state
{
    synthesisState = state;
}

@end








