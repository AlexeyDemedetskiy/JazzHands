//
//  IFTTTJazzHandsViewController.m
//  JazzHandsDemo
//
//  Created by Devin Foley on 9/27/13.
//  Copyright (c) 2013 IFTTT Inc. All rights reserved.
//

#import "IFTTTJazzHandsViewController.h"

#define NUMBER_OF_PAGES 4

#define timeForPage(page) (NSInteger)(self.view.frame.size.width * (page - 1))

@interface IFTTTJazzHandsViewController ()

@property (strong, nonatomic) UIButton *enableWordmarkButton;
@property (strong, nonatomic) UIButton *enableUnicornButton;

@property (strong, nonatomic) UIImageView *wordmark;
@property (strong, nonatomic) UIImageView *unicorn;
@property (strong, nonatomic) UILabel *lastLabel;
@property (strong, nonatomic) UILabel *firstLabel;

@property (assign, nonatomic) BOOL wordmarkEnabled;
@property (assign, nonatomic) BOOL unicornEnabled;

@end

@implementation IFTTTJazzHandsViewController

- (id)init
{
    if ((self = [super init])) {

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.scrollView.contentSize = CGSizeMake(NUMBER_OF_PAGES * CGRectGetWidth(self.view.frame),
                                             CGRectGetHeight(self.view.frame));
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self placeViews];
    [self configureAnimation];
    [self lockAnimation];
    
    self.delegate = self;
}

- (void)placeViews
{
    // put a unicorn in the middle of page two, hidden
    self.unicorn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unicorn"]];
    self.unicorn.center = self.view.center;
    self.unicorn.frame = CGRectOffset(
        self.unicorn.frame,
        self.view.frame.size.width,
        -100
    );
    self.unicorn.alpha = 0.0f;
    [self.scrollView addSubview:self.unicorn];

    // put a logo on top of it
    self.wordmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IFTTT"]];
    self.wordmark.center = self.view.center;
    self.wordmark.frame = CGRectOffset(
        self.wordmark.frame,
        self.view.frame.size.width,
        -100
    );
    [self.scrollView addSubview:self.wordmark];
    
    self.firstLabel = [[UILabel alloc] init];
    self.firstLabel.text = @"Introducing Jazz Hands";
    [self.firstLabel sizeToFit];
    self.firstLabel.center = self.view.center;
    
    [self.scrollView addSubview:self.firstLabel];
    
    /* Enable watermark */ {
        self.enableWordmarkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.enableWordmarkButton setTitle:@"Enable watermark" forState:UIControlStateNormal];
        [self.enableWordmarkButton sizeToFit];
        self.enableWordmarkButton.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
        [self.enableWordmarkButton addTarget:self action:@selector(enableWatermark)
                             forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:self.enableWordmarkButton];
    }
    
    /* Enable unicorne */ {
        self.enableUnicornButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.enableUnicornButton setTitle:@"Enable unicorn" forState:UIControlStateNormal];
        [self.enableUnicornButton sizeToFit];
        self.enableUnicornButton.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
        [self.enableUnicornButton addTarget:self action:@selector(enableUnicorn) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:self.enableUnicornButton];
    }
    
    UILabel *secondPageText = [[UILabel alloc] init];
    secondPageText.text = @"Brought to you by IFTTT";
    [secondPageText sizeToFit];
    secondPageText.center = self.view.center;
    secondPageText.frame = CGRectOffset(secondPageText.frame, timeForPage(2), 180);
    [self.scrollView addSubview:secondPageText];
    
    UILabel *thirdPageText = [[UILabel alloc] init];
    thirdPageText.text = @"Simple keyframe animations";
    [thirdPageText sizeToFit];
    thirdPageText.center = self.view.center;
    thirdPageText.frame = CGRectOffset(thirdPageText.frame, timeForPage(3), -100);
    [self.scrollView addSubview:thirdPageText];
    
    UILabel *fourthPageText = [[UILabel alloc] init];
    fourthPageText.text = @"Optimized for scrolling intros";
    [fourthPageText sizeToFit];
    fourthPageText.center = self.view.center;
    fourthPageText.frame = CGRectOffset(fourthPageText.frame, timeForPage(4), 0);
    [self.scrollView addSubview:fourthPageText];
    
    self.lastLabel = fourthPageText;
}

- (void)lockAnimation
{
    self.wordmarkEnabled = NO;
    self.unicornEnabled = NO;
    
    self.scrollView.contentSize = CGSizeMake(1 * CGRectGetWidth(self.view.frame),
                                             CGRectGetHeight(self.view.frame));
}

- (void)unlockAnimation
{
    self.scrollView.contentSize = CGSizeMake(NUMBER_OF_PAGES * CGRectGetWidth(self.view.frame),
                                             CGRectGetHeight(self.view.frame));

    [self.scrollView setContentOffset:CGPointMake(timeForPage(2), 0) animated:YES];
}

- (void)enableWatermark
{
    self.wordmarkEnabled = YES;
    [self unlockAnimation];
}

- (void)enableUnicorn
{
    self.unicornEnabled = YES;
    [self unlockAnimation];
}

- (void)configureAnimation
{
    CGFloat dy = 240;
    
    // apply a 3D zoom animation to the first label
    IFTTTTransform3DAnimation * labelTransform = [IFTTTTransform3DAnimation animationWithView:self.firstLabel];
    IFTTTTransform3D *tt1 = [IFTTTTransform3D transformWithM34:0.03f];
    IFTTTTransform3D *tt2 = [IFTTTTransform3D transformWithM34:0.3f];
    tt2.rotate = (IFTTTTransform3DRotate){ -(CGFloat)(M_PI), 1, 0, 0 };
    tt2.translate = (IFTTTTransform3DTranslate){ 0, 0, 50 };
    tt2.scale = (IFTTTTransform3DScale){ 1.f, 2.f, 1.f };
    [labelTransform addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(0)
                                                                andAlpha:1.0f]];
    [labelTransform addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1)
                                                          andTransform3D:tt1]];
    [labelTransform addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1.5)
                                                          andTransform3D:tt2]];
    [labelTransform addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1.5) + 1
                                                                andAlpha:0.0f]];

    /* Wordmark animations */ {
        self.wordmark.alpha = 0;
        
        IFTTTAlphaAnimation* alpha = [IFTTTAlphaAnimation animationWithView:self.wordmark];
        [alpha addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:0.0f]];
        [alpha addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:1.0f]];
        [alpha addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:1.0f]];
        [alpha addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f]];

        
        IFTTTFrameAnimation *wordmarkFrameAnimation = [IFTTTFrameAnimation animationWithView:self.wordmark];
        [wordmarkFrameAnimation addKeyFrames:@[
                                               [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(self.wordmark.frame, 200, 0)],
                                               [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:self.wordmark.frame],
                                               [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(self.wordmark.frame, self.view.frame.size.width, dy)],
                                               [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(self.wordmark.frame, 0, dy)],
                                               ]];
        
        // Rotate a full circle from page 2 to 3
        IFTTTAngleAnimation *wordmarkRotationAnimation = [IFTTTAngleAnimation animationWithView:self.wordmark];
        [wordmarkRotationAnimation addKeyFrames:@[
                                                  [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAngle:0.0f],
                                                  [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAngle:(CGFloat)(2 * M_PI)],
                                                  ]];
        
        IFTTTAnimation* wordmarkAnimation = [IFTTTAnimation joinAnimations:@[alpha, wordmarkFrameAnimation, wordmarkRotationAnimation]];
        [self.animator addAnimation:[wordmarkAnimation enabledWhen:^BOOL{
            return self.wordmarkEnabled;
        }]];
    }
    
    /* Let's animate unicorn */ {
        IFTTTFrameAnimation *unicornFrameAnimation = [IFTTTFrameAnimation animationWithView:self.unicorn];
        
        CGFloat ds = 50;
        
        // move down and to the right, and shrink between pages 2 and 3
        [unicornFrameAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:self.unicorn.frame]];
        [unicornFrameAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3)
                                                                           andFrame:CGRectOffset(CGRectInset(self.unicorn.frame, ds, ds), timeForPage(2), dy)]];
        // fade the unicorn in on page 2 and out on page 4
        IFTTTAlphaAnimation *unicornAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.unicorn];
        
        [unicornAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:0.0f]];
        [unicornAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:1.0f]];
        [unicornAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:1.0f]];
        [unicornAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f]];

        [self.animator addAnimation:[[unicornAlphaAnimation joinAnimation:unicornFrameAnimation] enabledWhen:^BOOL{
            return self.unicornEnabled;
        }]];
        
    }

    
    // Fade out the label by dragging on the last page
    IFTTTAlphaAnimation *labelAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.lastLabel];
    [labelAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:1.0f]];
    [labelAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4.35f) andAlpha:0.0f]];
    [self.animator addAnimation:labelAlphaAnimation];
}

#pragma mark - IFTTTAnimatedScrollViewControllerDelegate

- (void)animatedScrollViewControllerDidScrollToEnd:(IFTTTAnimatedScrollViewController *)animatedScrollViewController
{
    NSLog(@"Scrolled to end of scrollview!");
}

- (void)animatedScrollViewControllerDidEndDraggingAtEnd:(IFTTTAnimatedScrollViewController *)animatedScrollViewController
{
    NSLog(@"Ended dragging at end of scrollview!");
}

- (void)animatedScrollViewController:(IFTTTAnimatedScrollViewController *)animatedScrollViewController
                     didScrollToPage:(NSInteger)pageNumber
{
    if (pageNumber == 0) {
        [self lockAnimation];
    }
}

@end
