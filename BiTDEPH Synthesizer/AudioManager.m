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
#import "AudioSynthesis.h"

@interface AudioManager ()
{
    AEAudioController *_audioController;
    
    // why are these declared here instead of in the .h file?
    float FMCarrierPhase;
    float FMModulatorPhase;
    float AMPhase;
    float SquareLFOPhase;
    float SinLFOPhase;
    
    float FMCarrierFreq;
    float FMModulatorFreq;
    float AMFreq;
    float SquareLFOFreq;
    float SinLFOFreq;
    
    float masterGain;
    
    float FMCarrierGain;
    float FMModulatorGain;
    float AMGain;
    float SquareLFOGain;
    float SinLFOGain;
    
    float masterSamp;
    float FMCarrierSamp;
    float FMModulatorSamp;
    float AMSamp;
    float SquareLFOSamp;
    float SinLFOSamp;
    
    float FMCarrierPhaseRate;
    float FMModulatorPhaseRate;
    float AMPhaseRate;
    float SinLFOPhaseRate;
    float SquareLFOPhaseRate;
    
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
    SquareLFOPhase = 0;
    SinLFOPhase = 0;
    
    FMModulatorFreq = 500;
    FMCarrierFreq = 230;
    AMFreq = 1000;
    SquareLFOFreq = 1;
    SinLFOFreq = 0.5;
    
    masterGain = 0.9;
    FMModulatorGain = 10.0;
    FMCarrierGain = 0.55;
    AMGain = 1.0;
    SquareLFOGain = 1.0;
    SinLFOGain = 1.0;
    
    FMCarrierPhaseRate = (FMCarrierFreq/SRATE);
    FMModulatorPhaseRate = FMModulatorFreq/SRATE;
    AMPhaseRate = AMFreq/SRATE;
    SinLFOPhaseRate = SinLFOFreq/SRATE;
    SquareLFOPhaseRate = SquareLFOFreq/SRATE;
    
    [_audioController addChannels:@[[AEBlockChannel channelWithBlock: ^(const AudioTimeStamp *time,
                                                                       UInt32 frames,
                                                                       AudioBufferList *audio) {
        
        for(int i = 0; i < frames; i++)
        {
            FMCarrierSamp = sin(2*M_PI*FMCarrierPhase) * FMCarrierGain;
            FMModulatorSamp = sin(2*M_PI*FMModulatorPhase) * FMModulatorGain;
            AMSamp = sin(2*M_PI*AMPhase) * AMGain;
            
            if (SquareLFOPhase > 0.5) {
                SquareLFOSamp = SquareLFOGain;
            }
            else {
                SquareLFOSamp = -SquareLFOGain;
            }
            
            SinLFOSamp = sin(2*M_PI*SinLFOPhase) * SinLFOGain;
            
            FMCarrierPhase += FMCarrierPhaseRate;
            FMModulatorPhase += FMModulatorPhaseRate;
            AMPhase += AMPhaseRate;
            SinLFOPhase += SinLFOPhaseRate;
            SquareLFOPhase += SquareLFOPhaseRate;
            
            if(FMCarrierPhase > 1)
                FMCarrierPhase -= 1;
            if(FMModulatorPhase > 1)
                FMModulatorPhase -= 1;
            if(AMPhase > 1)
                AMPhase -= 1;
            if(SquareLFOPhase > 1)
                SquareLFOPhase -= 1;
            if(SinLFOPhase > 1)
                SinLFOPhase -= 1;
            
            switch (synthesisState) {
                case OFF:
                    masterSamp = 0;
                    break;
                    
                case ONLY_CARRIER:
                    //
                    masterSamp = FMCarrierSamp * masterGain;
                    break;
                    
                case FM_ACTIVE:
                    masterSamp = (FMCarrierSamp + FMModulatorSamp) * 0.5 * masterGain;
                    break;
                    
                case AM_ACTIVE:
                    masterSamp = (FMCarrierSamp + FMModulatorSamp) * 0.5 * AMSamp * masterGain;
                    break;
                    
                case FOUR_FINGER:
                    masterSamp = (FMCarrierSamp + FMModulatorSamp) * 0.5 * AMSamp * SquareLFOSamp * masterGain;
                    break;
                    
                case FIVE_FINGER:
                    masterSamp = (FMCarrierSamp+ FMModulatorSamp) * 0.5 *  AMSamp* SinLFOSamp * masterGain;
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