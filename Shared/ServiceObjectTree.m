//
//  ServiceObjectTree.m
//  Smart-i
//
//  Created by Troy Potts on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// Poor man's implementation of XPath.

#import "ServiceObjectTree.h"

@implementation ServiceObjectTree

@synthesize xml;
@synthesize url;

+ (ServiceObjectTree *) fromServiceMethod:(NSString *)serviceString
{
    TBXML *tbxml= [ServiceObject executeRequest:serviceString];
	ServiceObject *so = [[ServiceObjectTree alloc] initWithTBXML:tbxml];
	NSString *url = [ServiceObject urlOfServiceMethod:serviceString];
	so.url = url;
	return so;
}

+ (ServiceObjectTree *) fromServiceMethod:(NSString *)serviceString url:(NSString*)url
{
    TBXML *tbxml= [ServiceObjectTree executeRequest:serviceString url:url];
	ServiceObjectTree *so = [[ServiceObjectTree alloc] initWithTBXML:tbxml];
	so.url = url;
	return so;
}

- (id) initWithTBXML:(TBXML *)tbxmlArg
{
	if (self = [self init])
	{
        self.xml = tbxmlArg;
	}
	return self;
}

- (TBXMLElement *) getElementByName:(NSString *)name
{
    TBXMLElement *parentElement = self.xml.rootXMLElement;
    int cnt = 0;
    
    NSArray *tokens = [name componentsSeparatedByString:@"/"];
    
    for (NSString *token in tokens)
    {
        int desiredIndex = 0;
        
        NSRange numberRange = [token rangeOfString:@"#"];
        if (numberRange.location != NSNotFound)
        {
            NSString *idxStr = [token substringFromIndex:numberRange.location+1];
            desiredIndex = [idxStr intValue];
            token = [token substringToIndex:numberRange.location];
            NSLog(@"Found # at %d and it's %@", numberRange.location, idxStr);
            NSLog(@"Searching for element '%@' #%d...", token, desiredIndex);
        }
        
        cnt = 0;
        
        TBXMLElement *childElement = [TBXML childElementNamed:token parentElement:parentElement];
  
        if (childElement)
        {
            parentElement = childElement;
            while (cnt < desiredIndex && parentElement)
            {
                parentElement = parentElement->nextSibling;
                if (!parentElement)
                    break;
                cnt++;
            }
        }
        else
        {
            parentElement = nil;
        }
        
        if (parentElement)
        {
            NSLog(@"Found '%@': %@", token, [TBXML textForElement:parentElement]);
        }
        else
        {
            NSLog(@"Couldn't find '%@' element", token);
            break;
        }
    }
    
	return parentElement;
}

- (NSString *) getTextValueByName:(NSString *)name
{
    return [self getTextForElement:[self getElementByName:name]];
}

- (NSString *) getTextForElement:(TBXMLElement*)elem
{
    if (elem)
        return [TBXML textForElement:elem];
    return nil;
}
- (int) getIntValueByName:(NSString *)name
{
    return [[self getTextValueByName:name] intValue];
}

- (BOOL) hasData
{
    return self.xml && self.xml.rootXMLElement;
}

@end
