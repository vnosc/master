//
//  PrescriptionTextField.m
//  CyberImaging
//
//  Created by Troy Potts on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PrescriptionTextField.h"

@implementation PrescriptionTextField

@synthesize prescriptionType;
@synthesize eyeName;

@synthesize firstSet;

- (void) setText:(NSString*) text
{
	if (self.firstSet.length == 0 && text.length > 0)
		self.firstSet = text;
	
	[super setText:text];
}
@end
