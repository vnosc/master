//
//  FrameCollectionView.h
//  TryOnApp
//
//  Created by nitesh on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FrameCollectionView : BackgroundViewController 
{
    UILabel *collectionLabel;
    NSString *companyName;
}
@property (nonatomic,retain)NSString *companyName;
@property (nonatomic,retain)IBOutlet UILabel *collectionLabel;
@end
