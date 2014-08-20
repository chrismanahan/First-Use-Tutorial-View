//
//  CMTutorialView.m
//
//  Created by Chris Manahan on 8/20/14.
//  Copyright (c) 2014 Chris Manahan All rights reserved.
//

#import "CMTutorialView.h"

const NSUInteger CMTutorialViewDefaultFPS = 10;

@interface CMTutorialView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *imageReferences;

@end

@implementation CMTutorialView

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initialize];
    }
    
    return self;
}

-(void)initialize
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 40)];
    _scrollView.delegate                       = self;
    _scrollView.pagingEnabled                  = YES;
    _scrollView.contentSize                    = CGSizeZero;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces                        = NO;
    [self addSubview:_scrollView];
    
    _pageControl        = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_scrollView.frame), 50, 37)];
    CGPoint pageCenter  = _pageControl.center;
    pageCenter.y        = CGRectGetMaxY(_scrollView.frame) + 5;
    _pageControl.center = pageCenter;
    
    _pageControl.numberOfPages                 = 0;
    _pageControl.pageIndicatorTintColor        = [UIColor blackColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:_pageControl];
    
    // initialize image refs
    _imageReferences = [[NSMutableArray alloc] init];
    // set defaults
    _cornerRadius = 10.0;
    _imageType = @"png";
    _containerBackgroundColor = [UIColor colorWithWhite:0.8f alpha:1];
}

#pragma mark - Public Interface
- (void)addSlideWithText:(NSString*)text
    animationImagePrefix:(NSString*)prefix
              imageCount:(NSUInteger)imageCount;
{
    [self addSlideWithText:text
      animationImagePrefix:prefix
                imageCount:imageCount
                  duration:(CGFloat)imageCount/CMTutorialViewDefaultFPS];
}

- (void)addSlideWithText:(NSString*)text
    animationImagePrefix:(NSString*)prefix
              imageCount:(NSUInteger)imageCount
                duration:(CGFloat)duration;
{
    if (!prefix)
    {
        @throw [NSException exceptionWithName:@"TutorialViewException"
                                       reason:@"Animation images need to have the prefix"
                                     userInfo:nil];
    }
    
    
    // create view
    NSInteger padding = 10;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame) - 20, CGRectGetHeight(_scrollView.frame) - 40)];
    view.backgroundColor = _containerBackgroundColor;
    view.layer.cornerRadius = _cornerRadius;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding, CGRectGetWidth(view.frame) - 2 * padding, CGRectGetHeight(view.frame) - 110)];
    
    // load initial image
    NSString *imageName = [NSString stringWithFormat:@"%@_0", prefix];
    UIImage *image = [UIImage imageNamed:imageName];
    imageView.image = image;
    imageView.contentMode          = UIViewContentModeScaleAspectFit;
    
    NSDictionary *dict = @{@"imageView": imageView,
                           @"prefix": prefix,
                           @"imageCount": @(imageCount),
                           @"duration": @(duration)};
    [_imageReferences addObject:dict];
    
    [view addSubview:imageView];
    
    if (text)
    {
        // add label underneath images
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(imageView.frame) + 5, CGRectGetWidth(view.frame) - padding * 2, CGRectGetHeight(view.frame) - CGRectGetHeight(imageView.frame) - 5)];
        label.numberOfLines      = 0;
        label.text               = text;
        label.minimumScaleFactor = 0.5;
        label.textAlignment      = NSTextAlignmentCenter;
        [view addSubview:label];
    }
    
    [self p_addView:view
       toScrollView:_scrollView
      pageIndicator:_pageControl];
    
    [self scrollViewDidEndDecelerating:_scrollView];
}

#pragma mark - Private Interface
- (void)p_addView:(UIView*)view toScrollView:(UIScrollView*)scrollView pageIndicator:(UIPageControl*)paging
{
    // find the next available spot
    NSInteger numberOfViews = scrollView.subviews.count;
    NSInteger padding       = 10;
    NSInteger x             = numberOfViews * CGRectGetWidth(scrollView.frame) + padding;
    
    // set view's new frame
    CGRect viewFrame   = view.frame;
    viewFrame.origin.x = x;
    viewFrame.origin.y = 0;
    view.frame         = viewFrame;
    
    // add to scroll view
    [scrollView addSubview:view];
    
    // increase content size of scroll view
    CGSize contentSize     = scrollView.contentSize;
    contentSize.width      += CGRectGetWidth(view.frame) + (padding * 2);
    scrollView.contentSize = contentSize;
    
    // add to paging indicator if available
    if (paging)
    {
        paging.numberOfPages++;
        [paging sizeToFit];
        CGPoint pageCenter = paging.center;
        pageCenter.x       = scrollView.center.x;
        paging.center      = pageCenter;
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page           = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    _pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    NSDictionary *dict = _imageReferences[page];
    
    // clean up the previous animation
    UIImageView *imageView = dict[@"imageView"];
    [imageView stopAnimating];
    
    imageView.animationImages = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    NSDictionary *dict = _imageReferences[page];
    
    // render the new animation
    UIImageView *imageView = dict[@"imageView"];
    NSMutableArray *animPayImages = [[NSMutableArray alloc] init];
    for (int i = 0; i < [dict[@"imageCount"] integerValue]; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"%@_%i", dict[@"prefix"], i];
        NSString *path      = [[NSBundle mainBundle] pathForResource:imageName ofType:_imageType];
        UIImage *image      = [UIImage imageWithContentsOfFile:path];
        [animPayImages addObject:image];
    }
    imageView.animationImages      = animPayImages;
    imageView.animationRepeatCount = 0;
    imageView.animationDuration    = [dict[@"duration"] floatValue];
    // add to view
    [imageView startAnimating];
}

#pragma mark - Properties
- (void)setPageActiveColor:(UIColor *)pageActiveColor
{
    _pageActiveColor                           = pageActiveColor;
    _pageControl.currentPageIndicatorTintColor = pageActiveColor;
}

- (void)setPageInactiveColor:(UIColor *)pageInactiveColor
{
    _pageInactiveColor                  = pageInactiveColor;
    _pageControl.pageIndicatorTintColor = pageInactiveColor;
}

@end
