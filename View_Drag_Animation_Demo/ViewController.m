//
//  ViewController.m
//  View_Drag_Animation_Demo
//
//  Created by Ilesh  on 17/02/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *imageViews;
    CGRect rectProfileImage;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createImageViewArray];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan2:)];
    [self.view addGestureRecognizer:gesture];
}
- (void)createImageViewArray
{
            //Add all view in this Array
    imageViews = [NSMutableArray array];
    [imageViews addObject:view1];
    [imageViews addObject:view2];
    [imageViews addObject:view3];
    [imageViews addObject:view4];
    [imageViews addObject:view5];
    [imageViews addObject:view6];
}
- (UIView *)draggedImageView:(UIView *)draggedView toLocation:(CGPoint)location
{ //Check location has anyview
    for (UIView *imageview in imageViews)
        if (CGRectContainsPoint(imageview.frame, location) && imageview != draggedView)
            return imageview;
    
    return nil;
}
        // Image Shake or vibration Animation
-(void) vibrateAnimateBtnTapToProceed:(UIView *)img
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:-0.08];
    shake.toValue = [NSNumber numberWithFloat:+0.08];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = 4;
    [img.layer addAnimation:shake forKey:@"imageView"];
    img.alpha = 0.6;
    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:
     ^(BOOL finished){
         img.alpha = 1.0; ;
     }];
}
- (UIView *)determineImageForLocation:(CGPoint)location
{
    return [self draggedImageView:nil toLocation:location];
}

- (void)handlePan2:(UIPanGestureRecognizer *)gesture
{
    static UIView *draggedImage = nil;
    static CGRect draggedImageOriginalFrame;
    
    CGPoint location = [gesture locationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        // see if we grabbed an imageview
        
        draggedImage = [self determineImageForLocation:location];
        
        // if so, save its old location for future reference and bring it to the front
        
        if (draggedImage)
        {
            draggedImageOriginalFrame = draggedImage.frame;
            [draggedImage.superview bringSubviewToFront:draggedImage];
            [self vibrateAnimateBtnTapToProceed:draggedImage];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged && draggedImage != nil)
    {
        // if we're dragging it, then update its location
        
        CGPoint translation = [gesture translationInView:gesture.view];
        CGRect frame = draggedImageOriginalFrame;
        frame.origin.x += translation.x;
        frame.origin.y += translation.y;
        draggedImage.frame = frame;
    }
    else if (draggedImage != nil && (gesture.state == UIGestureRecognizerStateEnded ||
                                     gesture.state == UIGestureRecognizerStateCancelled ||
                                     gesture.state == UIGestureRecognizerStateFailed))
    {
        // if we let go, let's see if we dropped it over another image view
        
        UIView *droppedOver = nil;
        
        if (gesture.state == UIGestureRecognizerStateEnded)
            droppedOver = [self draggedImageView:draggedImage toLocation:location];
        
        if (droppedOver == nil)
        {
            // fail; animate the restoring of the view back to it's original position
            
            [UIView animateWithDuration:0.25
                             animations:^{
                                 draggedImage.frame = draggedImageOriginalFrame;
                                 draggedImage.alpha=1.0;
                             }];
        }
        else
        {
            // succeed; make sure to bring the view we're about to animate to the front
            
            
    /**  When Imageview then set bringSubview set othervice comment this line **/
           // [droppedOver.superview bringSubviewToFront:droppedOver];
            
            // animate the swapping of the views
            
            [UIView animateWithDuration:0.25
                             animations:^{
                                 draggedImage.frame = droppedOver.frame;
                                 droppedOver.frame = draggedImageOriginalFrame;
                                 droppedOver.alpha=1.0;
                                 draggedImage.alpha=1.0;
                                 
                             }];
        }
    }
}
/**************  Only Drag horizontaly with animation      ***************/

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    static UIView *draggedImage = nil;
    static CGRect draggedImageLastFrame;
    
    CGPoint location = [gesture locationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        // see if we grabbed an imageview
        
        draggedImage = [self determineImageForLocation:location];
        
        // if so, save its old location for future reference and bring it to the front
        
        if (draggedImage)
        {
            draggedImageLastFrame = draggedImage.frame;
            [draggedImage.superview bringSubviewToFront:draggedImage];
            draggedImage.alpha = 0.6f;
            [self vibrateAnimateBtnTapToProceed:draggedImage];
        }
        
    } else if (gesture.state == UIGestureRecognizerStateChanged && draggedImage != nil) {
        
        // if we're dragging it, then update its horizontal location
        
        CGPoint translation = [gesture translationInView:gesture.view];
        CGRect frame = draggedImage.frame;
        frame.origin.x += translation.x;
        draggedImage.frame = frame;
        [gesture setTranslation:CGPointZero inView:gesture.view];
        
        UIView *draggedOver = [self draggedImageView:draggedImage toLocation:location];
        if (draggedOver != nil)
        {
            
            // animate the draggedOver image to the the draggedImage's last location
            
            [UIView animateWithDuration:0.25
                             animations:^{
                                 CGRect currentFrame = draggedOver.frame;
                                 draggedOver.frame = draggedImageLastFrame;
                                 draggedImageLastFrame = currentFrame;
                                 
                             }];
        }
        
    } else if (draggedImage != nil && (gesture.state == UIGestureRecognizerStateEnded ||
                                       gesture.state == UIGestureRecognizerStateCancelled ||
                                       gesture.state == UIGestureRecognizerStateFailed))
    {
        
        // finished, animate the draggedImage into place
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             draggedImage.frame = draggedImageLastFrame;
                             draggedImage.alpha = 1.0f;
                         }];
    }
}
@end
