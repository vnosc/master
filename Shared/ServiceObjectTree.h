//
//  ServiceObjectTree.h
//  Smart-i
//
//  Created by Troy Potts on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServiceObject.h"

@interface ServiceObjectTree : ServiceObject
{
    TBXML *xml;
}
@property (nonatomic, retain) TBXML *xml;
@property (nonatomic, retain) NSString *url;

+ (ServiceObjectTree *) fromServiceMethod:(NSString *)serviceString;
+ (ServiceObjectTree *) fromServiceMethod:(NSString *)serviceString url:(NSString*)url;

@end
