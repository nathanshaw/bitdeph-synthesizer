//
//  Random.h
//  BiTDEPH Synthesizer
//
//  Created by Nathan Villicaña-Shaw on 5/8/16.
//  Copyright © 2016 Nathan Villicaña-Shaw. All rights reserved.
//

#ifndef Random_hpp
#define Random_hpp

class Random
{
public:
    Random();
    
    static float unit();
    static float range(float min, float max);
};

#endif /* Random_hpp */
