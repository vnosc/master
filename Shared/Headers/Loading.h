//
//  Loading.h
//  CyberImaging
//
//  Created by Patel on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface Loading : BackgroundViewController {
    MainViewController *mainView;
}
@property (nonatomic,retain)MainViewController *mainView;
@end
