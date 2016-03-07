//
//  AppDelegate.m
//  BiTDEPH Synthesizer
//
//  Created by Nathan Villicaña-Shaw on 2/11/16.
//  Copyright © 2016 Nathan Villicaña-Shaw. All rights reserved.
//

#import "AppDelegate.h"
#import "AudioManager.h"
#import <CoreMotion/CoreMotion.h>
#import "ViewController.h"

@interface AppDelegate ()
{
}

// fancy property = setter and getter automatically generated
@property CMMotionManager *motionManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[AudioManager instance] startAudio];
    self.motionManager = [CMMotionManager new];
    vc = [ViewController]
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical
                                                            toQueue:[NSOperationQueue mainQueue]
                                                        withHandler:^(CMDeviceMotion * motion, NSError * error) {
                                                            NSLog(@"attitude: %f %f %f",
                                                                  motion.attitude.pitch,
                                                                  motion.attitude.roll,
                                                                  motion.attitude.yaw);
                                                            AudioManager *audioManager = [AudioManager instance];
                                                            [audioManager setFMCarrierFreq:2500+1300*motion.attitude.pitch/(M_PI*2)];
                                                            [audioManager setFMModulatorFreq:2500+1200*motion.attitude.roll/(M_PI*2)];
                                                            [audioManager setAMFreq:300+200*motion.attitude.yaw/(M_PI*2)];
                                                            [ViewController setLabelValue_1];
                                                            [ViewController setLabelValue_2];
                                                            [ViewController setLabelValue_3];
                                                        }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
