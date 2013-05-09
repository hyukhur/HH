//
//  HHModelController.m
//  HH
//
//  Created by hyukhur on 13. 5. 9..
//  Copyright (c) 2013년 CampMobile. All rights reserved.
//

#import "HHModelController.h"

#import "HHDataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface HHModelController()
@property (readonly, strong, nonatomic) NSArray *pageData;
@property (readonly, strong, nonatomic) NSArray *imageData;
@end

@implementation HHModelController


- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        _pageData = [[dateFormatter monthSymbols] copy];
        _pageData = @[@"Camper\nto\nCamper",
                      @"다음 발표자\n지정 전략",
                      @"혈액형",
                      @"MBTI",
                      @"ENTP",
                      @"ENTP이라면",
                      @"어린시절",
                      @"중학교",
                      @" ",
                      @"컴퓨터?",
                      @"PC통신",
                      @"  ",
                      @"전공",
                      ];
        _imageData = @[[UIImage imageNamed:@"0.jpg"],
                       [UIImage imageNamed:@"1.png"],
                       [UIImage imageNamed:@"2.png"],
                       [UIImage imageNamed:@"3.png"],
                       @"발명왕\n해결사\n디테일?\n결과?",
                       [UIImage imageNamed:@"4.png"],
                       @"80년생\n올해 34!\n다들 알지만 관심 없는\n책",
                       [UIImage imageNamed:@"5.png"],
                       [UIImage imageNamed:@"6.png"],
                       [UIImage imageNamed:@"7.png"],
                       [UIImage imageNamed:@"8.png"],
                       [UIImage imageNamed:@"9.png"],
                       [UIImage imageNamed:@"10.png"],
                       ];
    }
    return self;
}

- (HHDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    HHDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"HHDataViewController"];
    dataViewController.dataObject = self.pageData[index];
    dataViewController.imageObject = self.imageData[index];
    dataViewController.index = index;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(HHDataViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(HHDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(HHDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
