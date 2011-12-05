//
//  ProgressiveSelection.h
//  CyberImaging
//
//  Created by Troy Potts on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListsTableViewController.h"

@interface ProgressiveSelection : BackgroundViewController
{
	ListsTableViewController* ltvc;
}
- (void) loadLensBrandData;
- (void) loadLensDesignData:(int)brandId;

- (void) removeLensDesigns;

@property (retain, nonatomic) IBOutlet UIImageView *previewImage;
@property (retain, nonatomic) IBOutlet ListsTableViewController *ltvc;
- (IBAction)selectDesign:(id)sender;

@end
