//
//  IFTTTAnimatedScrollViewController.m
//  JazzHands
//
//  Created by Devin Foley on 9/27/13.
//  Copyright (c) 2013 IFTTT Inc. All rights reserved.
//

#import "IFTTTAnimatedScrollViewController.h"

static inline CGFloat IFTTTMaxContentOffsetXForScrollView(UIScrollView *scrollView)
{
    return scrollView.contentSize.width + scrollView.contentInset.right - CGRectGetWidth(scrollView.bounds);
}

@interface IFTTTAnimatedScrollViewController ()

@property (nonatomic, assign) BOOL isAtEnd;
@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation IFTTTAnimatedScrollViewController

- (id)init
{
    if ((self = [super init])) {
        [self commonInit];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self commonInit];
}

- (void)commonInit
{
    _isAtEnd = NO;
    self.animator = [IFTTTAnimator new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [self.animator animate:(NSInteger)aScrollView.contentOffset.x];
    
    self.isAtEnd = (aScrollView.contentOffset.x >= IFTTTMaxContentOffsetXForScrollView(aScrollView));
    
    id delegate = self.delegate;

    if (self.isAtEnd && [delegate respondsToSelector:@selector(animatedScrollViewControllerDidScrollToEnd:)]) {
        [delegate animatedScrollViewControllerDidScrollToEnd:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateCurrentPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateCurrentPage];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    id delegate = self.delegate;
    
    if (!decelerate) {
        [self updateCurrentPage];
    }
    
    if (self.isAtEnd && [delegate respondsToSelector:@selector(animatedScrollViewControllerDidEndDraggingAtEnd:)]) {
        [delegate animatedScrollViewControllerDidEndDraggingAtEnd:self];
    }
}

- (void)updateCurrentPage
{
    NSInteger newPage = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    if (newPage != self.currentPage) {
        self.currentPage = newPage;
        if ([self.delegate respondsToSelector:@selector(animatedScrollViewController:didScrollToPage:)]) {
            [self.delegate animatedScrollViewController:self didScrollToPage:self.currentPage];
        }
    }
}

@end
