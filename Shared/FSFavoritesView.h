//
//  FSFavoritesView.h
//  Smart-i
//
//  Created by Logistic on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PatientSearch.h"

@interface FSFavoritesView : BackgroundViewController <UIAlertViewDelegate>
{
    IBOutlet UIView *viewLayer;
    BOOL askedForPatient;
    NSMutableDictionary *_frameTypes;
    UIButton *_clickedBtn;
}
@property (retain, nonatomic) IBOutlet UIScrollView *favoritesSV;
@property (nonatomic,retain)IBOutlet UIView *viewLayer;

@property (retain, nonatomic) IBOutlet UILabel *noFavoritesLabel;

@property (retain, nonatomic) MBProgressHUD *HUD;

@end
