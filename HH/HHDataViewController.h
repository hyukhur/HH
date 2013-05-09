//
//  HHDataViewController.h
//  HH
//
//  Created by hyukhur on 13. 5. 9..
//  Copyright (c) 2013년 CampMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHDataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) id imageObject;
- (IBAction)buttonTapped:(id)sender;
@property (assign, nonatomic) NSInteger index;

@end
