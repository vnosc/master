//
//  LensThicknessPage.h
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundViewController.h"

@interface LensThicknessPage : BackgroundViewController
{
    NSMutableArray *arrayData;
    NSMutableArray *arrayData1;
    
    NSMutableDictionary *frontLensImages;
    NSMutableDictionary *sideLensImages;
}
@property (retain, nonatomic) IBOutlet UIPickerView *picker;
@property (retain, nonatomic) IBOutlet UIImageView *frontLens;
@property (retain, nonatomic) IBOutlet UIImageView *sideLens;

- (NSString*) imageNameForOrientation:(NSString*)orient pos1:(int)pos1 pos2:(int)pos2;
- (NSString*) imageNameForOrientation:(NSString*)orient index:(NSString*)index rx:(NSString*)rx;
- (void) changeLensImages;

@end
