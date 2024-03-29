//
//  ServiceObject.h
//  CyberImaging
//
//  Created by Troy Potts on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface ServiceObject : NSObject <NSURLConnectionDelegate>
{
	NSMutableDictionary* dict;
}

@property (nonatomic, retain) NSMutableDictionary* dict;
@property (nonatomic, retain) NSString *url;

- (id) initWithTBXML:(TBXML *)tbxmlArg;
- (id) initWithTBXML:(TBXML *)tbxmlArg categoryKey:(NSString*)ck startTag:(NSString*)startTag;

+ (ServiceObject*) fromServiceMethod:(NSString *)serviceString;
+ (ServiceObject*) fromServiceMethod:(NSString *)serviceString categoryKey:(NSString*)ck startTag:(NSString*)startTag;
+ (ServiceObject *) fromServiceMethod:(NSString *)serviceString categoryKey:(NSString*)ck startTag:(NSString*)startTag url:(NSString*)url;

+ (NSString*) urlOfServiceMethod:(NSString *)serviceString;
+ (NSString*) urlOfWebPage:(NSString *)pageString;

+ (NSString *) getStringFromServiceMethod:(NSString *)serviceString;
+ (void) executeServiceMethod:(NSString *)serviceString;

+ (TBXML *) executeRequest:(NSString *)serviceString;
+ (TBXML *) executeRequest:(NSString *)serviceString url:(NSString*)url;

- (NSString *) getTextValueByName:(NSString *)name;
- (int) getIntValueByName:(NSString *)name;

- (NSString*) getNameOfElement:(TBXMLElement*)element;

- (BOOL) hasData;

- (BOOL) updateMobileSessionData;

- (void) traverseElement:(TBXMLElement *)element;
- (void) traverseElement:(TBXMLElement *)element categoryKey:(NSString*)ck startTag:(NSString*)startTag;

- (int) count;
- (void) setObject:(id)anObject forKey:(id)aKey;

@end
