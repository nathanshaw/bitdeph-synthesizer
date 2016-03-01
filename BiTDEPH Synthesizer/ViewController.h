//
//  ViewController.h
//  BiTDEPH Synthesizer
//
//  Created by Nathan Villicaña-Shaw on 2/11/16.
//  Copyright © 2016 Nathan Villicaña-Shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UILabel *FMModulatorFreqLabel;
    IBOutlet UILabel *FMCarrierFreqLabel;
    IBOutlet UILabel *AMFreqLabel;
    
    IBOutlet UILabel *FMModulatorGainLabel;
    IBOutlet UILabel *FMCarrierGainLabel;
    IBOutlet UILabel *AMGainLabel;
    
    float hertz;
}
@end

