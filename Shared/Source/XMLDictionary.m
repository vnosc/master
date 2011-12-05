//
//  XMLDictionary.m
//  CyberImaging
//
//  Created by Troy Potts on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLDictionary.h"

@implementation XMLDictionary

@synthesize tbxml;

- (id) initWithTBXML:(TBXML *)tbxmlArg
{
	if ([self init])
	{
		self.tbxml = tbxmlArg;
	}
	return self;
}

- (TBXMLElement *) getTBXMLElementNamed:(NSString *)name
{
	return [TBXML childElementNamed:name parentElement:self.tbxml.rootXMLElement];
}

- (NSString *) getTextValueByName:(NSString *)name
{
	TBXMLElement* ele = [self getTBXMLElementNamed:name];
	return [TBXML textForElement:ele];
}

- (int) getIntValueByName:(NSString *)name
{
	return [[self getTextValueByName:name] intValue];
}

- (BOOL) hasData
{
	return (self.tbxml.rootXMLElement != nil);
}

- (BOOL) updateMobileSessionData
{
	int rowId = [self getIntValueByName:@"rowId"];
	int providerId = [self getIntValueByName:@"providerId"];
	NSString* sessionId = [self getTextValueByName:@"sessionId"];
	int frameId = [self getIntValueByName:@"frameId"];
	int lensTypeId = [self getIntValueByName:@"lensTypeId"];
	int patientId = [self getIntValueByName:@"patientId"];
	int prescriptionId = [self getIntValueByName:@"prescriptionId"];
	
	NSString *updurl=[[NSString alloc]initWithFormat:@"http://smart-i.ws/mobilewebservice.asmx/UpdateMobileSessionInfo?rowId=%d&providerId=%d&sessionId=%@&frameId=%d&lensTypeId=%d&patientId=%d&prescriptionId=%d", rowId, providerId, sessionId, frameId, lensTypeId, patientId, prescriptionId];
	
	
	NSLog(@"%@", updurl);
	
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:updurl]];
	
	[[[NSURLConnection alloc] initWithRequest:req delegate:nil] start];
	
	return YES;
}

@end
