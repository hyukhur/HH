//
//  WheelScrollView.m
//  HH
//
//  Created by hyukhur on 13. 5. 9..
//  Copyright (c) 2013년 CampMobile. All rights reserved.
//

#import "WheelScrollView.h"

#define ANGLE_TOLERANCE 0.15f


@implementation WheelScrollView
@synthesize itemsImageViewArray, collisionView, isItemImageLandscape;

-(UIImage *)imageFromText:(NSString *)text
{
    // set the font type and size
    UIFont *font = [UIFont systemFontOfSize:10.0];
    CGSize sizeByFont  = [text sizeWithFont:font];
    UIGraphicsBeginImageContextWithOptions(sizeByFont,NO,0.0);
    
    // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger
    //
    // CGContextRef ctx = UIGraphicsGetCurrentContext();
    // CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
    
    // draw in context, you can use also drawInRect:withFont:
    [text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (id)initWithFrame:(CGRect)_frame andRadiusOffset:(NSInteger)_radiusOffset andAngle:(CGFloat)_angle andItemsArray :(NSMutableArray *)_itemsArray andNoOfVisibleItems:(NSInteger)_noOfVisibleItems andItemSize:(NSInteger)_size andDelegate:(id)_delegate andZoomEffect:(BOOL)_zoomEffect andZoomFactor:(CGFloat)_zoomFactor andBufferElements:(NSInteger)_bufferElements
{
    self = [super initWithFrame:_frame];
    if (self) {
        frame = _frame;
        radius = (frame.size.width / 2) - _radiusOffset;
        radiusOffset = _radiusOffset;
        angle = _angle;
        itemsArray = [[NSMutableArray alloc] initWithArray:_itemsArray];
        noOfVisibleItems = _noOfVisibleItems;
        delegate = _delegate;
        size = _size;
        zoomEffect = _zoomEffect;
        bufferElements = _bufferElements;
        zoomFactor = _zoomFactor;
    }
    return self;
}

- (void)loadWheelView
{
    [self setUserInteractionEnabled:YES];
    //Load Buffer Elements
    for (int i = 0; i < bufferElements; i++)
    {
        if (i < bufferElements / 2) {
            //[tempArray addObject:[itemsArray objectAtIndex:[itemsArray count] - 1 - i]];
            [itemsArray insertObject:[itemsArray objectAtIndex:[itemsArray count] - (bufferElements/2) + i] atIndex:i];
        }
        else
        {
            [itemsArray addObject:[itemsArray objectAtIndex:i]];
        }
    }
    
    NSLog(@"%@",itemsArray);
    
    itemsImageViewArray = [[NSMutableArray alloc] init];
    CGPoint position = CGPointMake(radius + (self.frame.size.width / 2), (self.frame.size.height / 2));
    
    //Setting up the initial position of the Items
    for (int i = 0; i < [itemsArray count]; i++) {
        position = CGPointMake(radius + (frame.size.width / 2), (frame.size.height / 2));
        //NSLog(@"Index %f", i + 1 - ceilf([itemsArray count] / 2.0f));
        if(i != floor([itemsArray count] / 2.0f) || [itemsArray count] % 2 == 0)
        {
            CGFloat ang = angle * (i + 1 - ceilf([itemsArray count] / 2.0f)) / noOfVisibleItems;
            //NSLog(@"Angle %f",ang);
            CGFloat thisAngle;
            thisAngle = ang * 3.14 / 180;
            CGFloat temp;
            temp = cosf(thisAngle);
            temp = radius * temp;
            CGFloat x = position.x + temp - radius;
            temp = sinf(thisAngle);
            temp = radius * temp;
            CGFloat y = position.y + temp;
            
            position = CGPointMake(x,y);
        }
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[self imageFromText:[itemsArray objectAtIndex:i]]];
        if(isItemImageLandscape)
            imageView.frame = CGRectMake(0, 0, size * 1.5, size);
        else
            imageView.frame = CGRectMake(0, 0, size, size);
        imageView.center = position;
        //Setting up TAG for ImageView
        if (i < bufferElements / 2) {
            imageView.tag = [itemsArray count] - bufferElements - (bufferElements / 2) + 1 + i;
        }
        else if(i >= [itemsArray count] - bufferElements + (bufferElements / 2))
        {
            imageView.tag = i - ([itemsArray count] - bufferElements + (bufferElements / 2));
        }
        else
        {
            imageView.tag = i - (bufferElements / 2);
        }
        //NSLog(@"%d",imageView.tag);
        //Adding the Zoom Effect to the Items
        [imageView setUserInteractionEnabled:YES];
        [self addSubview:imageView];
        [itemsImageViewArray addObject:imageView];
    }
    
    upperBoundIndex = -([itemsArray count] / 2);
    if ([itemsArray count] % 2 == 0)
        upperBoundIndex += 1;
    lowerBoundIndex = [itemsArray count] / 2;
}


-(void)rePositionElements:(NSInteger)indexChangeDiff
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
        NSInteger newIndex;
        if (indexChangeDiff < 0)
        {
            newIndex = upperBoundIndex - 1;
            upperBoundIndex = upperBoundIndex - 1;
            lowerBoundIndex = lowerBoundIndex - 1;
        }
        else
        {
            newIndex = lowerBoundIndex + 1;
            upperBoundIndex = upperBoundIndex + 1;
            lowerBoundIndex = lowerBoundIndex + 1;
        }
        
        CGPoint position = CGPointMake(radius + (frame.size.width / 2), (frame.size.height / 2));
        CGFloat ang = angle * newIndex / noOfVisibleItems;
        CGFloat thisAngle;
        thisAngle = ang * 3.14 / 180;
        CGFloat temp;
        temp = cosf(thisAngle);
        temp = radius * temp;
        CGFloat x = position.x + temp - radius;
        temp = sinf(thisAngle);
        temp = radius * temp;
        CGFloat y = position.y + temp;
        
        position = CGPointMake(x,y);
        
        if(indexChangeDiff < 0)
        {
            [itemsImageViewArray insertObject:(UIImageView *)[itemsImageViewArray objectAtIndex:([itemsImageViewArray count] - bufferElements - 1)] atIndex:0];
            [itemsImageViewArray removeLastObject];
            ((UIImageView *)[itemsImageViewArray objectAtIndex:0]).center = position;
        }
        else if(indexChangeDiff > 0)
        {
            [itemsImageViewArray addObject:(UIImageView *)[itemsImageViewArray objectAtIndex:bufferElements]];
            [itemsImageViewArray removeObjectAtIndex:0];
            ((UIImageView *)[itemsImageViewArray objectAtIndex:[itemsImageViewArray count] - 1]).center = position;
        }
        count++;
    }
}


@end
