//
//  ViewController2.m
//  View_Drag_Animation_Demo
//
//  Created by Tops on 23/02/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()
{
    UIPanGestureRecognizer *gesture;
    IBOutlet UIView *view1;
}

@end

@implementation ViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan2:)];
    [self.view addGestureRecognizer:gesture];
    
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    CGRect recognizerFrame = recognizer.view.frame;
    recognizerFrame.origin.x += translation.x;
    recognizerFrame.origin.y += translation.y;
    
    // Check if UIImageView is completely inside its superView
    if (CGRectContainsRect(self.view.bounds, recognizerFrame)) {
        recognizer.view.frame = recognizerFrame;
    }
    // Else check if UIImageView is vertically and/or horizontally outside of its
    // superView. If yes, then set UImageView's frame accordingly.
    // This is required so that when user pans rapidly then it provides smooth translation.
    
    else {
        // Check vertically
        if (recognizerFrame.origin.y < self.view.bounds.origin.y) {
            recognizerFrame.origin.y = 0;
        }
        else if (recognizerFrame.origin.y + recognizerFrame.size.height > self.view.bounds.size.height) {
            recognizerFrame.origin.y = self.view.bounds.size.height - recognizerFrame.size.height;
        }
        
        // Check horizantally
        if (recognizerFrame.origin.x < self.view.bounds.origin.x) {
            recognizerFrame.origin.x = 0;
        }
        else if (recognizerFrame.origin.x + recognizerFrame.size.width > self.view.bounds.size.width) {
            recognizerFrame.origin.x = self.view.bounds.size.width - recognizerFrame.size.width;
        }
    }
    
    // Reset translation so that on next pan recognition
    // we get correct translation value
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}
- (IBAction)handlePan2:(UIPanGestureRecognizer *)recognizer
{
    if (gesture.state==UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded){
        UIView *superview = recognizer.view.superview;
        CGSize superviewSize = superview.bounds.size;
        CGSize thisSize = recognizer.view.frame.size;
        CGPoint translation = [recognizer translationInView:self.view];
        CGPoint center = CGPointMake(recognizer.view.center.x + translation.x,
                                     recognizer.view.center.y + translation.y);
        
        CGPoint resetTranslation = CGPointMake(translation.x, translation.y);
        
        if(center.x - thisSize.width/2 < 0)
            center.x = thisSize.width/2;
        else if (center.x + thisSize.width/2 > superviewSize.width)
            center.x = superviewSize.width-thisSize.width/2;
        else
            resetTranslation.x = 0; //Only reset the horizontal translation if the view *did* translate horizontally
        
        if(center.y - thisSize.height/2 < 0)
            center.y = thisSize.height/2;
        else if(center.y + thisSize.height/2 > superviewSize.height)
            center.y = superviewSize.height-thisSize.height/2;
        else
            resetTranslation.y = 0; //Only reset the vertical translation if the view *did* translate vertically
        
        recognizer.view.center = center;
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}
@end
