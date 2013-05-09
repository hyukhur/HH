//
//  HHWheelViewController.m
//  HH
//
//  Created by hyukhur on 13. 5. 9..
//  Copyright (c) 2013년 CampMobile. All rights reserved.
//

#import "HHWheelViewController.h"
#import "WheelScrollViewManager.h"
#import "WheelScrollView.h"

@interface HHWheelViewController ()
@property (strong, nonatomic) WheelScrollViewManager *wheelScrollViewManager;
@end

@implementation HHWheelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _wheelScrollViewManager = [[WheelScrollViewManager alloc] initWithFrame:CGRectMake(30, 100, self.view.bounds.size.width, self.view.bounds.size.height) andDelegate:self];
    
    [_wheelScrollViewManager setItemsArray:[@[  @"6", @"7", @"8", @"31",@"9",
                                            @"10", @"12", @"15", @"16",
                                            @"21", @"23", @"25", @"26",
                                            @"29",  @"32", @"41",
                                            @"60", @"61", @"62", @"64",
                                            @"65", @"67", @"68", @"69",
                                            @"71", @"72", @"73", @"95",
                                            @"75", @"78", @"81", @"83",
                                            @"84", @"86", @"87", @"90",
                                            @"93", @"94", @"56", @"57",
                                            @"103", @"105", @"106", @"108",
                                            @"109", @"110", @"114", @"115",
                                            ] mutableCopy]];
    [_wheelScrollViewManager setAngle:360];
    [_wheelScrollViewManager setNoOfVisibleItems:47];
    [_wheelScrollViewManager setWheelViewSize:250];
    [_wheelScrollViewManager setItemSize:47];
    [_wheelScrollViewManager setZoomEffect:YES];
    [_wheelScrollViewManager setZoomFactor:5.0];
    [_wheelScrollViewManager setRadiusOffset:5];
    [_wheelScrollViewManager setIsItemImageLandscape:NO];

    
    //Change the Center of the Circle
//    [_wheelScrollViewManager setCircleCenter:CGPointMake(160, 230)];
//    [_wheelScrollViewManager setWheelFace:kWheelFaceRight];
    [_wheelScrollViewManager loadView];
//    [_wheelScrollViewManager setBgImage:[UIImage imageNamed:@"1.jpg"]];
    //[wheelScrollViewManager setOverlayImage:[UIImage imageNamed:@"topOverlay.png"]];
    [self.view addSubview:_wheelScrollViewManager];
//    [self.view sendSubviewToBack:_wheelScrollViewManager];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [_wheelScrollViewManager roll];
}

-(void)itemSelected:(NSInteger)index
{
    NSString *selected = [_wheelScrollViewManager.itemsArray objectAtIndex:index];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"당첨!" message:[NSString stringWithFormat:@"%@번 축하합니다!", selected] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
