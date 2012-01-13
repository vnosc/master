//
//  TestResults.h
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariable.h"
@interface TestResults : UIViewController
{
    GlobalVariable *app;
    NSMutableArray *testNameArray;
    NSMutableArray *testResultArray;
    NSMutableArray *imageArray;
    IBOutlet UITabBar *tabBar;
    IBOutlet UITabBarItem *first;
    IBOutlet UITabBarItem *second;
    IBOutlet UIView *secondView;
   
    NSMutableArray *nextPageNameArray;
    NSMutableArray *nextPageLeftArray;
    NSMutableArray *nextPageRightArray;
    IBOutlet UITableView *table1;
    IBOutlet UITableView *table2;
}
@property (nonatomic,retain) NSMutableArray *nextPageNameArray;
@property (nonatomic,retain) NSMutableArray *nextPageLeftArray;
@property (nonatomic,retain) NSMutableArray *nextPageRightArray;

@property (nonatomic,retain) NSMutableArray *testNameArray;
@property (nonatomic,retain) NSMutableArray *testResultArray;
@property (nonatomic,retain) NSMutableArray *imageArray;
-(IBAction) tabbarFirstBtnClick : (id)sender;
-(IBAction) tabbarSecondBtnClick : (id)sender;
@end
