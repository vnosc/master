//
//  TOTakePhotoView.h
//  TryOnApp
//
//  Created by nitesh on 1/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TOTakePhotoView : BackgroundViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    
}
-(IBAction)pressTakeMyPhotoButton:(id)sender;

-(IBAction)pressUseModelButton:(id)sender;
@end
