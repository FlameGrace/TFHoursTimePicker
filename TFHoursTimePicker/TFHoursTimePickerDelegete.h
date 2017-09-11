//
//  TFHoursTimePickerDelegete.h
//  Demo
//
//  Created by 李嘉军 on 2017/9/8.
//  Copyright © 2017年 com.flamegrace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol TFHoursTimePickerDelegete <NSObject>

- (void)timePickerDidSelectDate:(id)timePicker;


@end
