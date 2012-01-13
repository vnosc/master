//
//  GlobalVariable.m
//  VisionTest
//
//  Created by Patel on 12/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlobalVariable.h"


@implementation GlobalVariable
@synthesize visualAcuityLeftEye,visualAcuityRightEye,astigmatismLeftEye,astigmatismRightEye,duochromeLeftEye,duochromeRightEye,colorTestLeftEye,colorTestRightEye,questionLeftEye,questionRightEye;

+ (GlobalVariable *)sharedInstance
{
    static GlobalVariable *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[GlobalVariable alloc] init];
        myInstance.visualAcuityLeftEye=@"0";
        myInstance.visualAcuityRightEye=@"0";
        myInstance.astigmatismLeftEye=@"0";
        myInstance.astigmatismRightEye=@"0";
        myInstance.duochromeLeftEye=@"0";
        myInstance.duochromeRightEye=@"0";
        myInstance.colorTestLeftEye=@"0";
        myInstance.colorTestRightEye=@"0";
        myInstance.questionLeftEye=@"0";
        myInstance.questionRightEye=@"0";
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}
@end
