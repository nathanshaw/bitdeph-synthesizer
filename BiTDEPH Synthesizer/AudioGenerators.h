//
//  AudioGenerators.hpp
//  WeekFive
//
//  Created by Spencer Salazar on 2/22/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#ifndef AudioGenerators_h
#define AudioGenerators_h

#include <math.h>


#define MY_COOL_SRATE 44100


class UGen
{
public:
    UGen() : _gain(0.1) { }
    
    virtual float tick() { return 0; }
    virtual float tick(float) { return 0; }
    
    void setGain(float gain)
    {
        _gain = gain;
    }
    float getGain()
    {
        return _gain;
    }
    
protected:
    float _gain;
};

class Osc : public UGen
{
public:
    Osc() : _freq(263), _phase(0)
    { }
    
    void setFreq(float freq)
    {
        _freq = freq;
    }
    float getFreq() {
        return _freq;
    }
    
protected:
    float _phase;
    float _freq;
};

class SinOsc : public Osc
{
public:
    SinOsc() { }
    
    virtual float tick()
    {
        
        _phase += _freq/MY_COOL_SRATE;
        
        if(_phase > 1.0)
            _phase -= 1.0;
        
        return _gain*sin(2*M_PI*_phase);
        
    }
};

class SawOsc : public Osc
{
public:
    SawOsc() { }
    
    virtual float tick()
    {
        
        _phase += _freq/MY_COOL_SRATE;
        if(_phase > 1.0)
            _phase -= 1.0;
        
        return _gain*(1.0-2.0*_phase);
    }
};

class SqrOsc : public Osc
{
public:
    SqrOsc() { }
    
    virtual float tick()
    {
        
        _phase += _freq/MY_COOL_SRATE;
        if(_phase > 0.5) {
            if(_phase > 1.0)
                _phase -= 1.0;
            return _gain;
            
        }
        return _gain * -1;
    }
};

#endif /* AudioGenerators_h */