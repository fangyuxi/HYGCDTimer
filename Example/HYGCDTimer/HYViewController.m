//
//  HYViewController.m
//  HYGCDTimer
//
//  Created by fangyuxi on 06/13/2016.
//  Copyright (c) 2016 fangyuxi. All rights reserved.
//

#import "HYViewController.h"
#import "HYGCDTimer.h"

@interface HYViewController ()

@end

@implementation HYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    HYGCDTimer *timer = [[HYGCDTimer alloc] initWithTimeInterval:2 queue:nil repeats:YES action:^{
        
        NSLog(@"fangyuxi");
        
    } tolerance:0.1 userInfo:nil];
    
    [timer fire];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [timer invalidate];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
