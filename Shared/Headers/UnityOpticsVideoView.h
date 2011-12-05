//
//  UnityOpticsVideoView.h
//  CyberImaging
//
//  Created by Troy Potts on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface UnityOpticsVideoView : BackgroundViewController
{
	MPMoviePlayerController *videoPlayer;
}

- (void)videoFinished:(NSNotification*)n;
- (IBAction)backToMainMenu:(id)sender;

@end
