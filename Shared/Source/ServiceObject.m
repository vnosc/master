//
//  ServiceObject.m
//  CyberImaging
//
//  Created by Troy Potts on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ServiceObject.h"

@implementation ServiceObject

@synthesize dict;
@synthesize url;

+ (ServiceObject *) fromServiceMethod:(NSString *)serviceString
{
	TBXML *tbxml= [ServiceObject executeRequest:serviceString];
	ServiceObject *so = [[ServiceObject alloc] initWithTBXML:tbxml];
	NSString *url = [ServiceObject urlOfServiceMethod:serviceString];
	so.url = url;
	return so;
}

+ (ServiceObject *) fromServiceMethod:(NSString *)serviceString categoryKey:(NSString*)ck startTag:(NSString*)startTag
{
	TBXML *tbxml= [ServiceObject executeRequest:serviceString];
	ServiceObject *so = [[ServiceObject alloc] initWithTBXML:tbxml categoryKey:ck startTag:startTag];
	NSString *url = [ServiceObject urlOfServiceMethod:serviceString];
	so.url = url;
	return so;
}

+ (NSString *) getStringFromServiceMethod:(NSString *)serviceString
{
	TBXML *tbxml= [ServiceObject executeRequest:serviceString];
	return [TBXML textForElement:tbxml.rootXMLElement];
}

+ (void) executeServiceMethod:(NSString *)serviceString
{
	[ServiceObject executeRequest:serviceString];
}

+ (TBXML *) executeRequest:(NSString *)serviceString
{
	NSString *url = [ServiceObject urlOfServiceMethod:serviceString];
	NSLog(@"Service request: %@", url);
	TBXML *tbxml= [TBXML tbxmlWithURL:[NSURL URLWithString:url]];
	return tbxml;
}

+ (NSString*) urlOfServiceMethod:(NSString *)serviceString
{
#ifdef SMARTI
	NSString* url = [NSString stringWithFormat:@"http://smart-i.ws/mobilewebservice.asmx/%@", serviceString];
#else
	NSString* url = [NSString stringWithFormat:@"http://smart-i.ws/mobilewebservice.asmx/%@", serviceString];
#endif
	return url;
}

- (id) init
{
	if (self = [super init])
	{
		self.dict = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}
- (id) initWithTBXML:(TBXML *)tbxmlArg
{
	if (self = [self init])
	{
		TBXMLElement* root = tbxmlArg.rootXMLElement;
		[self traverseElement:root];
	}
	return self;
}

- (id) initWithTBXML:(TBXML *)tbxmlArg categoryKey:(NSString*)ck startTag:(NSString*)startTag
{
	if (self = [self init])
	{
		TBXMLElement* root = tbxmlArg.rootXMLElement;
		[self traverseElement:root categoryKey:ck startTag:startTag];
	}
	return self;
}

- (NSString *) getTextValueByName:(NSString *)name
{
	return [self.dict objectForKey:name];
}

- (int) getIntValueByName:(NSString *)name
{
	return [[self.dict objectForKey:name] intValue];
}

- (void) setObject:(id)anObject forKey:(id)aKey
{
	[self.dict setObject:anObject forKey:aKey];
}

- (int) count
{
	return self.dict.count;
}

- (BOOL) hasData
{
	return self.count > 0;
}

- (void) traverseElement:(TBXMLElement *)element
{
	[self traverseElement:element categoryKey:@"" startTag:nil];
}

- (void) traverseElement:(TBXMLElement *)element categoryKey:(NSString*)ck startTag:(NSString*)startTag {
	if (element)
	{
    do {
		NSString* eName = [self getNameOfElement:element];
		
        if (element->firstChild) 
		{
			
			NSString* newck = ck;

			if (startTag && ([newck hasPrefix:startTag] || [[NSString stringWithUTF8String:element->name] compare:startTag options:NSLiteralSearch] == NSOrderedSame))
			{
				newck = [NSString stringWithFormat:@"%@%@/", ck, eName];
			}
			
            [self traverseElement:element->firstChild categoryKey:newck startTag:startTag];
		}
		NSString* oValue = [TBXML textForElement:element];
		NSString* oName = [NSString stringWithFormat:@"%@%@", ck, eName];
		
		//if (startTag && [[NSString stringWithUTF8String:element->name] compare:startTag options:NSLiteralSearch] == NSOrderedSame)
		//	oName = [NSString stringWithFormat:@"%@%s", ck, element->name];
		
		NSLog(@"Set: %@ -> %@", oValue, oName);
		
		[self setObject:oValue forKey:oName];
		
    } while ((element = element->nextSibling));  
	}
	else
	{
		NSLog(@"Null element");
	}
 
}

- (NSString*) getNameOfElement:(TBXMLElement*)element
{
	TBXMLAttribute *attr = element->firstAttribute;
	//

	NSString* result = [NSString stringWithFormat:@"%s", element->name];
		
	if (attr && [[NSString stringWithUTF8String:attr->name] compare:@"diffgr:id" options:NSLiteralSearch] == NSOrderedSame)
	{ 
		result = [NSString stringWithFormat:@"%s", attr->value];
		NSLog(@"ATTR: %s -> %s", attr->name, attr->value);
		NSLog(@"comptest: %@", [NSString stringWithUTF8String:attr->name]);
	}
	
	return result;
}


- (BOOL) updateMobileSessionData
{
	int rowId = [self getIntValueByName:@"rowId"];
	int providerIdL = [self getIntValueByName:@"providerId"];
	NSString* sessionId = [self getTextValueByName:@"sessionId"];
	int frameId = [self getIntValueByName:@"frameId"];
	int lensTypeId = [self getIntValueByName:@"lensTypeId"];
	NSString* memberId = [self getTextValueByName:@"memberId"];
	int patientId = [self getIntValueByName:@"patientId"];
	int prescriptionId = [self getIntValueByName:@"prescriptionId"];
	int materialId = [self getIntValueByName:@"materialId"];
	NSString* lensOptionIds = [self getTextValueByName:@"lensOptionIds"];
	int materialColorId = [self getIntValueByName:@"materialColorId"];
	int tintColorId = [self getIntValueByName:@"tintColorId"];
	int lensBrandId = [self getIntValueByName:@"lensBrandId"];
	int lensDesignId = [self getIntValueByName:@"lensDesignId"];
	
	NSString *updurl=[NSString stringWithFormat:@"UpdateMobileSessionInfo?rowId=%d&providerId=%d&sessionId=%@&frameId=%d&lensTypeId=%d&memberId=%@&patientId=%d&prescriptionId=%d&materialId=%d&lensOptionIds=%@&materialColorId=%d&tintColorId=%d&lensBrandId=%d&lensDesignId=%d", rowId, providerIdL, sessionId, frameId, lensTypeId, memberId, patientId, prescriptionId, materialId, lensOptionIds, materialColorId, tintColorId, lensBrandId, lensDesignId];
	
	[ServiceObject executeServiceMethod:updurl];
	
	NSLog(@"%@", updurl);
	
	/*NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:updurl]];
	
	[[[NSURLConnection alloc] initWithRequest:req delegate:nil] start];*/
	
	return YES;
}

@end
