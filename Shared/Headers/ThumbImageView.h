

@protocol ThumbImageViewDelegate;


@interface ThumbImageView : UIImageView {
    id <ThumbImageViewDelegate> delegate;
    NSString *imageName;
    
    /* ThumbImageViews have a "home," which is their location in the containing scroll view. Keeping this distinct */
    /* from their frame makes it easier to handle dragging and reordering them. We can change their relative       */
    /* positions by changing their homes, without having to worry about whether they have currently been dragged   */
    /* somewhere else. Also, we don't lose track of where they belong while they are being moved.                  */
    CGRect home;
    
    BOOL dragging;
    CGPoint touchLocation; // Location of touch in own coordinates (stays constant during dragging).
}

@property (nonatomic, assign) id <ThumbImageViewDelegate> delegate;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, assign) CGRect home;
@property (nonatomic, assign) CGPoint touchLocation;


- (void)goHome;  // animates return to home location
- (void)moveByOffset:(CGPoint)offset; // change frame lo

@end



@protocol ThumbImageViewDelegate <NSObject>

@optional
- (void)thumbImageViewWasTapped:(ThumbImageView *)tiv;
- (void)thumbImageViewStartedTracking:(ThumbImageView *)tiv;
- (void)thumbImageViewMoved:(ThumbImageView *)tiv;
- (void)thumbImageViewStoppedTracking:(ThumbImageView *)tiv;

@end

