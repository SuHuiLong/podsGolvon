
#import <UIKit/UIKit.h>

/**
 * Simple view to display an overlay (a square) over the camera view.
 * @since 2.0.0
 */

@protocol QRCodeReaderViewDelegate <NSObject>
- (void)loadView:(CGRect)rect;
@end

@interface QRCodeReaderView : UIView
@property (nonatomic, weak)   id<QRCodeReaderViewDelegate> delegate;
@property (nonatomic, assign) CGRect innerViewRect;
@end
