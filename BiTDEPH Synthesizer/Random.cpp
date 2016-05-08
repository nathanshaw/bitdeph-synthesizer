//
//  Random.cpp
//  BiTDEPH Synthesizer
//
//  Created by Nathan Villicaña-Shaw on 5/8/16.
//  Copyright © 2016 Nathan Villicaña-Shaw. All rights reserved.
//

#include "Random.h"
#include <stdlib.h>
#include <time.h>

static Random g_random;

const float RANDOM_MAX = 2147483647;

Random::Random()
{
    srandom(time(NULL));
}

float Random::unit()
{
    return random()/RANDOM_MAX;
}

float Random::range(float min, float max)
{
    return unit()*(max-min)+min;
}
