//
//  BillingTypeSelection.h
//  CyberImaging
//
//  Created by Troy Potts on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListsTableViewController.h"
#import "PackageSelection.h"

@interface BillingTypeSelection : BackgroundViewController
@property (retain, nonatomic) IBOutlet ListsTableViewController *ltvc;
@property (retain, nonatomic) IBOutlet UIButton *btn;

@end
