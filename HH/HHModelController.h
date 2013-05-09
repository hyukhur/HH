//
//  HHModelController.h
//  HH
//
//  Created by hyukhur on 13. 5. 9..
//  Copyright (c) 2013년 CampMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HHDataViewController;

@interface HHModelController : NSObject <UIPageViewControllerDataSource>

- (HHDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(HHDataViewController *)viewController;

@end
