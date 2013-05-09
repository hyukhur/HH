//
//  HHDataViewController.m
//  HH
//
//  Created by hyukhur on 13. 5. 9..
//  Copyright (c) 2013년 CampMobile. All rights reserved.
//

#import "HHDataViewController.h"
#import "HHWheelViewController.h"

@interface HHDataViewController ()

@end

@implementation HHDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.button.imageView setContentMode:(UIViewContentModeScaleAspectFit)];
    [self.button.imageView setBackgroundColor:[UIColor clearColor]];
    [self.button.titleLabel setNumberOfLines:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (([self.imageObject isKindOfClass:[NSString class]]))
    {
        [self.button setTitle:self.imageObject forState:UIControlStateNormal];
    }
    else if ([self.imageObject isKindOfClass:[UIImage class]])
    {
        [self.button setImage:self.imageObject forState:UIControlStateNormal];
    }
    self.dataLabel.text = [self.dataObject description];
}

- (IBAction)buttonTapped:(id)sender
{
    if (self.index == 1)
    {
        HHWheelViewController *vc = [[HHWheelViewController alloc] initWithNibName:nil bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
@end
