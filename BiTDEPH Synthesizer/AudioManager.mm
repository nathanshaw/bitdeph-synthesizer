//
//  AudioManager.m
//

#define OFF 0
#define ONLY_CARRIER 1
#define FM_ACTIVE 2
#define AM_ACTIVE 3
#define FOUR_FINGER 4
#define FIVE_FINGER 5
#define SIX_FINGER 6
#define SEVEN_FINGER 7

#import "AudioManager.h"
#import "AudioGenerators.h"

@interface AudioManager ()
{
    AEAudioController *_audioController;
    
    // why are these declared here instead of in the .h file?
    float _masterGain;
    float _masterSamp;
    
    int synthesisState;
    
    float *_lastAudioBuffer;
    int _lastAudioBufferSize;
    
    SinOsc Carrier;
    SinOsc FMModulator;
    SinOsc AMModulator;
    SawOsc LFOSAW;
    SqrOsc LFOSQR;
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
    
    _masterGain = 0.9;
    FMModulator.setGain(100);
    Carrier.setFreq(200);
    AMModulator.setFreq(10);
    LFOSAW.setFreq(5);
    LFOSQR.setFreq(2);
    
    _lastAudioBufferSize = MY_COOL_SRATE * _audioController.preferredBufferDuration * 4;
    _lastAudioBuffer = new float[_lastAudioBufferSize];
    
    [_audioController addChannels:@[[AEBlockChannel channelWithBlock: ^(const AudioTimeStamp *time,
                                                                       UInt32 frames,
                                                                       AudioBufferList *audio) {
        _lastAudioBufferSize = frames;
        for(int i = 0; i < frames; i++)
        {
            // currently AM is disabled
            switch (synthesisState) {
                case OFF:
                    _masterSamp = 0;
                    break;
                    
                case ONLY_CARRIER:
                    //
                    _masterSamp = Carrier.tick();
                    break;
                    
                case FM_ACTIVE:
                    Carrier.setFreq(FMModulator.tick() + 300);
                    _masterSamp = (Carrier.tick());
                    break;
                    
                case AM_ACTIVE:
                    _masterSamp = (Carrier.tick() + FMModulator.tick()) * AMModulator.tick();
                    break;
                    
                case FOUR_FINGER:
                    _masterSamp = (Carrier.tick() + FMModulator.tick()) + (AMModulator.tick() * LFOSQR.tick());
                    break;
                    
                case FIVE_FINGER:
                    _masterSamp = (Carrier.tick() + FMModulator.tick()) * AMModulator.tick() + (LFOSQR.tick() * ((1 + LFOSAW.tick())/2));
                    break;
                    
                default:
                    synthesisState = FIVE_FINGER;
            }
            
            _lastAudioBuffer[i] = _masterSamp;
            ((float*)(audio->mBuffers[0].mData))[i] = _masterSamp * _masterGain;
            ((float*)(audio->mBuffers[1].mData))[i] = _masterSamp * _masterGain;
        }
        
    }]]];
    
    [_audioController start:NULL];
}
     
- (void)setFMCarrierGain:(float)gain
{
    FMModulator.setGain(gain);
}
              
- (void)setFMModulatorGain:(float)gain
{
    FMModulator.setGain(gain);
}
              
- (void)setAMGain:(float)gain
{
    AMModulator.setGain(gain);
}
              
- (void)setMasterGain:(float)gain
{
    _masterGain = gain;
}
              
- (void)setFMCarrierFreq:(float)freq
{
    Carrier.setFreq(freq);
}
              
- (void)setFMModulatorFreq:(float)freq
{
    FMModulator.setFreq(freq);
}
            
- (void)setAMFreq:(float)freq
{
    AMModulator.setFreq(freq);
}
              
- (float)getFMCarrierFreq
{
    return Carrier.getFreq();
}

- (float)getMasterGain
{
    return _masterGain;
}

- (float)getFMModulatorFreq
{
    return FMModulator.getFreq();
}
                  
- (float)getAMModulatorFreq
{
    return AMModulator.getFreq();
}

- (void)setSynthesisState:(int)state
{
    synthesisState = state;
}

- (float *)lastAudioBuffer {
    return _lastAudioBuffer;
}

- (int)lastAudioBufferSize {
    return _lastAudioBufferSize;
}

@end





