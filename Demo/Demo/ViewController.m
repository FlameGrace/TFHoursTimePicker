//
//  ViewController.m
//  Demo
//
//  Created by Flame Grace on 2017/9/7.
//  Copyright © 2017年 com.flamegrace. All rights reserved.
//

#import "ViewController.h"
#import "TFHoursTimePicker.h"

@interface ViewController ()

@property (strong, nonatomic) TFHoursTimePicker *datePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker = [[TFHoursTimePicker alloc]initWithFrame:CGRectMake(50, 150, 275, 250)];
    [self.view addSubview:self.datePicker];
    self.datePicker.minimumTime = [NSDate dateWithTimeInterval:-60*60*4 sinceDate:[NSDate date]];
    self.datePicker.maxTime = [NSDate dateWithTimeInterval:60*60*4 sinceDate:[NSDate date]];
}



@end
