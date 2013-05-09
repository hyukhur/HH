//
//  WheelScrollViewManager.m
//  HH
//
//  Created by hyukhur on 13. 5. 9..
//  Copyright (c) 2013년 CampMobile. All rights reserved.
//

#import "WheelScrollViewManager.h"

#define degreesToRadians(degrees) (M_PI * degrees / 180.0)
#define radiansToDegrees(radians) (radians * 180 / M_PI)

#define ANGLE_TOLERANCE 0.30f
#define ZOOM_DURATION 0.25f

static CGPoint delta;
static float deltaAngle;
static float currentAngle;


@implementation WheelScrollViewManager

@synthesize initialTransform,currentValue,bgImage,fgImage,avatarImage;
@synthesize zoomFactor, angle, noOfVisibleItems,bufferElements,itemsArray,zoomEffect,wheelViewSize,itemSize,radiusOffset,isItemImageLandscape, overlayImage;

#pragma mark - View lifecycle
-(id)initWithFrame:(CGRect)frame andDelegate:(id)_delegate
{
    if((self = [super initWithFrame:frame]))
    {
        delegate = _delegate;
    }
    return self;
}

-(void)loadView
{
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, 320, 480)];
    fgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, 320, 480)];
    avatarImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    avatarImageView.center = CGPointMake(95, avatarImageView.center.y + 10);
    overlayImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:bgImageView];
    [self addSubview:avatarImageView];
    [self addSubview:fgImageView];
    
    self.userInteractionEnabled = YES;
    currentValue = 0;
    currentAngle = 0;
    initialTransformArray = [[NSMutableArray alloc] init];
    
    //zoomEffect = NO;
    wheelScrollView = [[WheelScrollView alloc] initWithFrame:CGRectMake(0, 0, wheelViewSize, wheelViewSize) andRadiusOffset:radiusOffset andAngle:angle andItemsArray:itemsArray andNoOfVisibleItems:noOfVisibleItems andItemSize:itemSize andDelegate:self andZoomEffect:zoomEffect andZoomFactor:zoomFactor andBufferElements:bufferElements];
    [wheelScrollView setIsItemImageLandscape:isItemImageLandscape];
//    wheelScrollView.center = CGPointMake(-160, 230);
    [wheelScrollView loadWheelView];
    for (float i = 0; i<[wheelScrollView.itemsImageViewArray count]; i++) {
        [initialTransformArray insertObject:[NSValue valueWithCGAffineTransform:((UIImageView *)[wheelScrollView.itemsImageViewArray objectAtIndex:i]).transform] atIndex:i];
    }
    [self addSubview:wheelScrollView];
    [self addSubview:overlayImageView];
    
    if(zoomEffect)
    {
        [self setZoomOnItems];
    }
}

-(void)setBgImage:(UIImage *)_bgImage
{
    bgImageView.image = _bgImage;
}

-(void)setFgImage:(UIImage *)_fgImage
{
    fgImageView.image = _fgImage;
}

-(void)setAvatarImage:(UIImage *)_avatarImage
{
    avatarImageView.image = _avatarImage;
}

-(void)setOverlayImage:(UIImage *)_overlayImage
{
    overlayImageView.image = _overlayImage;
}


-(void)resetInitialTransformArray:(NSInteger)indexChangeDiff
{
    NSInteger counter;
    if(indexChangeDiff < 0)
        counter = -indexChangeDiff;
    else
        counter = indexChangeDiff;
    NSInteger count = 0;
    if(counter >= 2)
    {
        NSLog(@"Counter 2");
    }
    while (count < counter) {
        if(indexChangeDiff < 0)
        {
            [initialTransformArray insertObject:(UIImageView *)[initialTransformArray objectAtIndex:([initialTransformArray count] - bufferElements - 1)] atIndex:0];
            [initialTransformArray removeLastObject];
            //((UIImageView *)[itemsImageViewArray objectAtIndex:0]).center = position;
        }
        else if(indexChangeDiff > 0)
        {
            [initialTransformArray addObject:(UIImageView *)[initialTransformArray objectAtIndex:bufferElements]];
            [initialTransformArray removeObjectAtIndex:0];
            //((UIImageView *)[itemsImageViewArray objectAtIndex:[itemsImageViewArray count] - 1]).center = position;
        }
        count++;
    }
}

-(void)refreshInitialTransformArray
{
    [initialTransformArray removeAllObjects];
    
    for (int i = 0; i < [wheelScrollView.itemsImageViewArray count]; i++) {
        [initialTransformArray insertObject:[NSValue valueWithCGAffineTransform:((UIImageView *)[wheelScrollView.itemsImageViewArray objectAtIndex:i]).transform] atIndex:i];
    }
}

- (void)roll
{
}

#pragma mark ===========UIViewDelegate touch events==========
-(void)inertialEffectEnded
{
    isInertialEffectOn = NO;
    previousAngle = 0;
    [self refreshInitialTransformArray];
    if(zoomEffect)
        [self setZoomOnItems];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isInertialEffectOn)
    {
        [inertialTimer invalidate];
        [self inertialEffectEnded];
    }
    UITouch *thisTouch = [touches anyObject];
	delta = [thisTouch locationInView:self];
    lastMovedPoint = delta;
    
	float dx = delta.x  - wheelScrollView.center.x;
	float dy = delta.y  - wheelScrollView.center.y;
	deltaAngle = atan2(dy * 2,dx * 2);
	
	//set an initial transform so we can access these properties through the rotations
	initialTransform = wheelScrollView.transform;
    if (zoomEffect)
        [self resetZoomOnItems];
    [self refreshInitialTransformArray];
    
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 1 && [[touch view] isKindOfClass:[UIImageView class]]) {
        isTapped = YES;
    }
    NSDate *startTime = [NSDate date];
    NSLog(@"Start Time %@",startTime);
	dragStartTime = [startTime timeIntervalSince1970];
    
}

-(void)rotateWheelWithAngleDiff:(float)angleDif
{
    CGAffineTransform newTrans = CGAffineTransformRotate(initialTransform, -angleDif);
    wheelScrollView.transform = newTrans;
    //[self refreshInitialTransformArray];
    for (int i = 0; i < [wheelScrollView.itemsImageViewArray count]; i++) {
        ((UIImageView *)[wheelScrollView.itemsImageViewArray objectAtIndex:i]).transform = CGAffineTransformRotate([(NSValue *)[initialTransformArray objectAtIndex:i] CGAffineTransformValue],angleDif);
        if (i == 3)
        {
            [[wheelScrollView.itemsImageViewArray objectAtIndex:i] setAlpha:1.0f];
        }
        else
        {
            [[wheelScrollView.itemsImageViewArray objectAtIndex:i] setAlpha:0.5f];
        }
    }
    currentValue = [self goodDegrees:radiansToDegrees(angleDif)];
    rotationTotal = rotationTotal + (radiansToDegrees(angleDif) - radiansToDegrees(previousAngle));
    previousAngle = angleDif;
    
    int newItemIndex = round(rotationTotal / (angle / noOfVisibleItems));
    if(itemChangeIndex != newItemIndex)
    {
        itemChangeIndex = newItemIndex;
        //        NSLog(@"Index Changed : %d",itemIndexChangeDiff);
        itemIndexChangeDiff = itemChangeIndex - prevItemIndex;
        prevItemIndex = itemChangeIndex;
        [wheelScrollView rePositionElements:itemIndexChangeDiff];
        [self resetInitialTransformArray:itemIndexChangeDiff];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTapped = NO;
	UITouch *touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
    //	lastMovedPoint = pt;
    
	float dx = pt.x  - wheelScrollView.center.x;
	float dy = pt.y  - wheelScrollView.center.y;
	float ang = atan2(dy * 2,dx * 2);
    //NSLog(@"angle of rotaion of view %f", radiansToDegrees(ang));
    
	//do the rotation
	if (deltaAngle == 0.0) {
		deltaAngle = ang;
		initialTransform = wheelScrollView.transform;
        //[self refreshInitialTransformArray];
	}else
	{
		//from last move to now...
		angleDiff = deltaAngle - ang;
        [self rotateWheelWithAngleDiff:angleDiff];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    rotationTotal +=currentValue;
    //    NSLog(@"%f",rotationTotal);
    float angleDif = 0.25;
    inertialMaxAngle = (itemIndexChangeDiff * angleDif) + angleDiff;
    inertialAngle = angleDiff;
    
	UITouch * touch = [touches anyObject];
    if ([touch tapCount] == 1 && [[touch view] isKindOfClass:[UIImageView class]]) {
        NSLog(@"%d", ((UIImageView *)[touch view]).tag);
        if(selectableIndex == ((UIImageView *)[touch view]).tag)
            [delegate itemSelected:((UIImageView *)[touch view]).tag];
        [self inertialEffectEnded];
    }
    else
    {
        if (isTapped)
            return;
        
        NSDate *endTime = [NSDate date];
        //        NSLog(@"End Time %@",endTime);
		double dragEndTime = [endTime timeIntervalSince1970];
		dragTime = dragEndTime - dragStartTime;
        
        CGPoint endMovePoint = [touch locationInView:self];
        double distance = sqrt(((endMovePoint.x - lastMovedPoint.x)*(endMovePoint.x - lastMovedPoint.x)) + ((endMovePoint.y - lastMovedPoint.y)*(endMovePoint.y - lastMovedPoint.y)));
        
        double speed = distance /dragTime;
        
        if (speed>50)
        {
            isInertialEffectOn = YES;
            inertialTimer = [NSTimer scheduledTimerWithTimeInterval:0.00001 target:self selector:@selector(giveInertialEffect:) userInfo:nil repeats:YES];
        }
        else
        {
            //do nothing since it wasn't a big move
            [self inertialEffectEnded];
        }
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)giveInertialEffect:(NSTimer *)timer
{
    if((int)(inertialMaxAngle * 100) != (int)(inertialAngle * 100))
    {
//        NSLog(@"Inertial Angle : %d",(int)(inertialAngle * 100));
//        NSLog(@"Inertial Max Angle %d",(int)(inertialMaxAngle * 100));
//        NSLog(@"======================");
        if (inertialMaxAngle > 0) {
            if((inertialMaxAngle * 75.0f) / 100.0f > inertialAngle)
                inertialAngle += 0.01;
            else if((inertialMaxAngle * 75.0f) / 100.0f <= inertialAngle && (inertialMaxAngle * 85.0f) / 100.0f > inertialAngle)
                inertialAngle += 0.008;
            else if((inertialMaxAngle * 75.0f) / 100.0f <= inertialAngle && (inertialMaxAngle * 95.0f) / 100.0f > inertialAngle)
                inertialAngle += 0.005;
            else
                inertialAngle += 0.003;
        }
        else
        {
            if((inertialMaxAngle * 75.0f * -1) / 100.0f > inertialAngle * -1)
                inertialAngle -= 0.01;
            else if((inertialMaxAngle * 75.0f * -1) / 100.0f <= inertialAngle * -1 && (inertialMaxAngle * 85.0f * -1) / 100.0f > inertialAngle * -1)
                inertialAngle -= 0.008;
            else if((inertialMaxAngle * 75.0f * -1) / 100.0f <= inertialAngle * -1 && (inertialMaxAngle * 95.0f * -1) / 100.0f > inertialAngle * -1)
                inertialAngle -= 0.005;
            else
                inertialAngle -= 0.003;
        }
        [self rotateWheelWithAngleDiff:inertialAngle];
    }
    else
    {
        [timer invalidate];
        [self inertialEffectEnded];
    }
}

-(float) goodDegrees:(float)degrees
{
	float degOutput = degrees;
	while (degOutput >=360) {
		degOutput -= 360;
	}
	while (degOutput < 0) {
		degOutput += 360;
	}
	return degOutput;
}

-(void)setZoomOnItems
{
    
    NSInteger counter = 0;
    for(int i = ([wheelScrollView.itemsImageViewArray count] - noOfVisibleItems) / 2; i < (([wheelScrollView.itemsImageViewArray count] - noOfVisibleItems) / 2) + noOfVisibleItems;i++)
    {
        NSLog(@"Index i %d",i);
        CGAffineTransform transform = [((NSValue *)[initialTransformArray objectAtIndex:i]) CGAffineTransformValue];
//        if(counter <= noOfVisibleItems/2)
//        {
//            if (counter == noOfVisibleItems / 2)
//                selectableIndex = ((UIImageView *)[wheelScrollView.itemsImageViewArray objectAtIndex:i]).tag;
//            transform = CGAffineTransformScale(transform, 1 + (counter/zoomFactor),1 + (counter/zoomFactor));
//        }
//        else
//            transform = CGAffineTransformScale(transform, 1 + ((noOfVisibleItems/2 - (counter - noOfVisibleItems/2))/zoomFactor),1 + ((noOfVisibleItems/2 - (counter - noOfVisibleItems/2))/zoomFactor));
//        if (i == 2 || i == 4) {
//            transform = CGAffineTransformScale(transform, 1.5f, 1.5f);
//        }
//        else
        if(i == 3)
        {
            transform = CGAffineTransformScale(transform, 2.5f, 2.5f);
            selectableIndex = ((UIImageView *)[wheelScrollView.itemsImageViewArray objectAtIndex:i]).tag;
            double dragEndTime = [[NSDate date] timeIntervalSince1970];
            dragTime = dragEndTime - dragStartTime;
            if (selectableIndex != 3 && dragTime > 1)
            {
                [delegate itemSelected:selectableIndex];
            }
        }
        
        //transform = CGAffineTransformRotate(transform, 0);
        //        if(counter <= noOfVisibleItems/2)
        //            transform = CGAffineTransformMakeScale(1 + (counter/zoomFactor),1 + (counter/zoomFactor));
        //        else
        //            transform = CGAffineTransformMakeScale(1 + ((noOfVisibleItems/2 - (counter - noOfVisibleItems/2))/zoomFactor),1 + ((noOfVisibleItems/2 - (counter - noOfVisibleItems/2))/zoomFactor));
        
        //transform = CGAffineTransformRotate(transform, 0);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:ZOOM_DURATION];
        ((UIImageView *)[wheelScrollView.itemsImageViewArray objectAtIndex:i]).transform = transform;
        [UIView commitAnimations];
        
        counter++;
    }
}


-(void)resetZoomOnItems
{
    
    NSInteger counter = 0;
    for(int i = ([wheelScrollView.itemsImageViewArray count] - noOfVisibleItems) / 2; i < (([wheelScrollView.itemsImageViewArray count] - noOfVisibleItems) / 2) + noOfVisibleItems;i++)
    {
        CGAffineTransform transform = [((NSValue *)[initialTransformArray objectAtIndex:i]) CGAffineTransformValue];
        transform = CGAffineTransformScale(transform, 1,1);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:ZOOM_DURATION];
        ((UIImageView *)[wheelScrollView.itemsImageViewArray objectAtIndex:i]).transform = transform;
        [UIView commitAnimations];
        
        counter++;
    }
}
@end
