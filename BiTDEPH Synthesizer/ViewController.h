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
    IBOutlet UILabel *overtoneLabel1;
    IBOutlet UILabel *overtoneLabel2;
    IBOutlet UILabel *overtoneLabel3;
    IBOutlet UILabel *overtoneLabel4;
    IBOutlet UILabel *hertzLabel;

    float hertz;
}
@end

