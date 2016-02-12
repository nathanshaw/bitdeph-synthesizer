//
//  AudioManager.h
//  WeekThree
//
//  Created by Spencer Salazar on 2/8/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioManager : NSObject

+ (instancetype)instance;

- (void)startAudio;

- (void)setGain:(float)gain;
- (void)setFrequency:(float)frequency;

@end


