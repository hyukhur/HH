//
//  WheelScrollViewManager.h
//  HH
//
//  Created by hyukhur on 13. 5. 9..
//  Copyright (c) 2013년 CampMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelScrollView.h"

@protocol WheelScrollViewDelegate <NSObject>
@optional
-(void)itemSelected:(NSInteger)index;

@end

@interface WheelScrollViewManager : UIView
{
    
    double dragStartTime;
    double dragTime;
    CGPoint lastMovedPoint;
    float inertialAngle;
    float inertialMaxAngle;
    BOOL isInertialEffectOn;
    float angleDiff;
    NSTimer * inertialTimer;
    NSArray * imageViewArray;
	CGAffineTransform initialTransform;
    
	float currentValue;
    
    float rotationTotal;
    float previousAngle;
    WheelScrollView * wheelScrollView;
    NSInteger itemChangeIndex;
    NSInteger prevItemIndex;
    NSInteger itemIndexChangeDiff;
    
    NSMutableArray * initialTransformArray;
    
    BOOL isTapped;
    
    id <WheelScrollViewDelegate> delegate;
    UIImageView * bgImageView;
    UIImageView * fgImageView;
    UIImageView * avatarImageView;
    
    UIImage * bgImage;
    UIImage * fgImage;
    UIImage * avatarImage;
    
    NSMutableArray * itemsArray;
    BOOL zoomEffect;
    CGFloat zoomFactor;
    NSInteger angle;
    NSInteger noOfVisibleItems;
    NSInteger bufferElements;
    NSInteger wheelViewSize;
    NSInteger itemSize;
    NSInteger radiusOffset;
    BOOL isItemImageLandscape;
    UIImageView *overlayImageView;
    UIImage * overlayImage;
    
    BOOL isZoomed;
    
    int selectableIndex;
    int prevZoom;
}

@property BOOL isItemImageLandscape;
@property NSInteger radiusOffset;
@property NSInteger wheelViewSize;
@property NSInteger itemSize;
@property CGFloat zoomFactor;
@property NSInteger angle;
@property NSInteger noOfVisibleItems;
@property NSInteger bufferElements;
@property BOOL zoomEffect;
@property (nonatomic, retain) NSArray * itemsArray;
@property (nonatomic, retain) UIImage * bgImage;
@property (nonatomic, retain) UIImage * fgImage;
@property (nonatomic, retain) UIImage * avatarImage;
@property (nonatomic, retain) UIImage * overlayImage;
@property CGAffineTransform initialTransform;
@property float currentValue;
-(id)initWithFrame:(CGRect)frame andDelegate:(id)_delegate;
-(void)loadView;
-(float)goodDegrees:(float)degrees;
-(void)setZoomOnItems;
-(void)resetZoomOnItems;
-(void)refreshInitialTransformArray;
-(void)resetInitialTransformArray:(NSInteger)indexChangeDiff;


- (void)roll;
@end
