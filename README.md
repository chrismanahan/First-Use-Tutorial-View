First-Use-Tutorial-View
=======================

Simple view that you can add sequences of images to, to create tutorial that you can show to your user's on the first launch of the app

`CMTutorialView` is a UIView that can be initialzed either in a storyboard or using `initWithFrame:`. 

Usage is fairly straightforward. Once you have your instance, you can set a few optional properites:
```
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
```

This assumes you're using a sequence of images to display a demonstration for each instruction. Each frame should be named as `frameName_0, frameName_1, ..., frameName_n-1` where n is the total number of frames. 

Adding an instruction: 
```
    [_tutorialView addSlideWithText:@"This is my first instruction for my users!"
               animationImagePrefix:@"firstInstruction"
                         imageCount:20
                           duration:4.0f];
                           
    [_tutorialView addSlideWithText:@"This is my second instruction"
               animationImagePrefix:@"secondInstruction"
                         imageCount:15];        // the default duration is 10 fps, which, for 15 images, comes out to 1.5 seconds
```

Pull requests are always welcome :)