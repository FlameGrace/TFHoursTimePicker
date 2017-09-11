//
//  TFHoursDatePicker.h
//  leapmotor
//
//  Created by Flame Grace on 16/9/28.
//  Copyright © 2016年 com.flamegrace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHoursTimePickerDelegete.h"

typedef void(^TFHoursTimePickerChangedBlock)();

//二十四小时制的DatePicker
@interface TFHoursTimePicker : UIView

@property (copy, nonatomic) TFHoursTimePickerChangedBlock changedBlock;

@property (strong, nonatomic) UIColor *titleColor;
//datePicker的当前选择的时间
@property (strong, nonatomic) NSDate *time;
//datePicker的最小时间，年月日没有意义
@property (strong, nonatomic) NSDate *minimumTime;
//datePicker的最大时间，年月日没有意义
@property (strong, nonatomic) NSDate *maxTime;

@end
