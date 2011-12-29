//
//  LensIndexView.h
//  LENSIndex
//
//  Created by Patel on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainViewController.h"
@interface LensIndexView : UIViewController {
    MainViewController *mainViewController;
    
    NSMutableArray *arrayData;
    NSMutableArray *arrayData1;
    IBOutlet UIPickerView *picker;
    IBOutlet UIPickerView *picker2;
    IBOutlet UIImageView *tample;
    IBOutlet UIImageView *tample2;
    IBOutlet UIImageView *glass;
    IBOutlet UIImageView *glass2;
}
@property(nonatomic,retain)MainViewController *mainViewController;
@property (nonatomic,retain)NSMutableArray *arrayData;
@property (nonatomic,retain)NSMutableArray *arrayData1;
@property (nonatomic,retain)UIImageView *tample;
@property (nonatomic,retain)UIImageView *tample2;
@property (nonatomic,retain)UIImageView *glass;
@property (nonatomic,retain)UIImageView *glass2;

@end
