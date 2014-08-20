//
//  CMTutorialView.h
//
//  Created by Chris Manahan on 8/20/14.
//  Copyright (c) 2014 Chris Manahan All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMTutorialView : UIView

/*!
 *  Rounding to be applied to the view that houses the imageview and label. Default is 10.0
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/*!
 *  Color of the paging control for dots that represent pages that are not the current page. Default color is black
 */
@property (nonatomic, strong) UIColor *pageInactiveColor;

/*!
 *  Color of the paging control for the dot the represents the current page. Default color is grey
 */
@property (nonatomic, strong) UIColor *pageActiveColor;

/*!
 *  Background color of the container view that holds the imageview and description label. Default is a light grey 
 */
@property (nonatomic, strong) UIColor *containerBackgroundColor;

/*!
 *  File extension for images. Default is png
 */
@property (nonatomic, copy) NSString *imageType;

/*!
 *  Adds a slide with an animation from a sequence of images
 *
 *  @param text       Text to be displayed underneath image
 *  @param prefix     Prefix of images that will be used for the animation, upto, but not including the underscore
 *  @param imageCount The total number of images
 *
 *  @discussion The animation images should be in the format of imageName_0, imageName_1, ..., imageName_n-1 where n is the total number of images.
 */
- (void)addSlideWithText:(NSString*)text
    animationImagePrefix:(NSString*)prefix
              imageCount:(NSUInteger)imageCount;

/*!
 *  Adds a slide with an animation from a sequence of images
 *
 *  @param text       Text to be displayed underneath image
 *  @param prefix     Prefix of images that will be used for the animation, upto, but not including the underscore
 *  @param imageCount The total number of images
 *  @param duration   Time in seconds of how long it should take to play through all images in the sequence
 *
 *  @discussion The animation images should be in the format of imageName_0, imageName_1, ..., imageName_n-1 where n is the total number of images
 */
- (void)addSlideWithText:(NSString*)text
    animationImagePrefix:(NSString*)prefix
              imageCount:(NSUInteger)imageCount
                duration:(CGFloat)duration;


@end
