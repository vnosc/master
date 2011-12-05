//
//  XMLDictionary.h
//  CyberImaging
//
//  Created by Troy Potts on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface XMLDictionary : NSObject <NSURLConnectionDelegate>
{
	TBXML* tbxml;
}

@property (nonatomic, retain) TBXML* tbxml;

- (id) initWithTBXML:(TBXML *)tbxmlArg;

- (TBXMLElement *) getTBXMLElementNamed:(NSString *)name;

- (NSString *) getTextValueByName:(NSString *)name;

- (BOOL) hasData;

- (BOOL) updateMobileSessionData;
@end
