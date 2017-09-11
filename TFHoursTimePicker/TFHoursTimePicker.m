//
//  TFHoursDatePicker.m
//  leapmotor
//
//  Created by Flame Grace on 16/9/28.
//  Copyright © 2016年 com.flamegrace. All rights reserved.
//

#import "TFHoursTimePicker.h"
#define MAX_SCROLL (25)

@interface TFHoursTimePicker()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *datePicker;
//小时列表
@property (strong, nonatomic) NSMutableArray *hoursList;
//分钟列表
@property (strong, nonatomic) NSMutableArray *minutesList;
//当前选择的小时
@property (strong, nonatomic) NSString *currentHour;
//当前选择的分钟
@property (strong, nonatomic) NSString *currentMinute;

@property (strong, nonatomic) NSString *currentDay;

@end

@implementation TFHoursTimePicker

- (id)init
{
    if(self = [super init])
    {
        [self initSetting];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initSetting];
        self.frame = frame;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.datePicker.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

//初始化数据
- (void)initSetting
{
    if(self.datePicker)
    {
        return;
    }
    //当前日期
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH"];
    self.currentHour = [df stringFromDate:date];
    [df setDateFormat:@"mm"];
    self.currentMinute = [df stringFromDate:date];
    //初始化hoursList
    self.hoursList = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i< 24; i++) {
        NSString *newHour = [NSString stringWithFormat:@"%ld",(long)i];
        if(i<10)newHour= [NSString stringWithFormat:@"0%ld",(long)i];
        [self.hoursList addObject:newHour];
    }
    //初始化minutesList
    self.minutesList = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i< 60; i++) {
        NSString *newMinute = [NSString stringWithFormat:@"%ld",(long)i];
        if(i<10)newMinute= [NSString stringWithFormat:@"0%ld",(long)i];
        [self.minutesList addObject:newMinute];
    }
    
    self.datePicker = [[UIPickerView alloc]init];
    self.datePicker.dataSource =self;
    self.datePicker.delegate = self;
    [self addSubview:self.datePicker];
    self.time = date;
    [df setDateFormat:@"yyyy/MM/dd"];
    NSString *dayString = [df stringFromDate:date];
    self.currentDay = dayString;
    NSString *minDayString = [NSString stringWithFormat:@"%@ 00:00",dayString];
    NSString *maxDayString = [NSString stringWithFormat:@"%@ 23:59",dayString];
    [df setDateFormat:@"yyyy/MM/dd HH:mm"];
    self.minimumTime = [df dateFromString:minDayString];
    self.maxTime = [df dateFromString:maxDayString];
}


- (NSString *)timeStringForDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    return [df stringFromDate:date];
}


//设置选择的日期
- (void)setTime:(NSDate *)time
{
    if(!time)
    {
        return;
    }
    if(time&&_time&&[time isEqualToDate:_time])
    {
        return;
    }
    NSString *timeString = [self timeStringForDate:time];
    NSString *minString = [self timeStringForDate:self.minimumTime];
    NSString *maxString = [self timeStringForDate:self.maxTime];
    if((minString&&[timeString compare:minString]==NSOrderedAscending)||(maxString&&[timeString compare:maxString]==NSOrderedDescending))
    {
        return;
    }
    _time = time;
    [self selectTime:time];
}

//当前日期必须大于设置的最小日期
- (void)setMinimumTime:(NSDate *)minimumTime
{
    if(!minimumTime)
    {
        return;
    }
    if(minimumTime&&_minimumTime&&[minimumTime isEqualToDate:_minimumTime])
    {
        return;
    }
    NSString *minString = [self timeStringForDate:minimumTime];
    NSString *maxString = [self timeStringForDate:self.maxTime];
    if(maxString&&[minString compare:maxString]==NSOrderedDescending)
    {
        return;
    }
    _minimumTime = minimumTime;
    NSString *timeString = [self timeStringForDate:self.time];
    if(timeString&&[timeString compare:minString] ==NSOrderedAscending)
    {
        self.time = minimumTime;
        
    }
}

- (void)setMaxTime:(NSDate *)maxTime
{
    if(!maxTime)
    {
        return;
    }
    if(maxTime&&_maxTime&&[maxTime isEqualToDate:_maxTime])
    {
        return;
    }
    NSString *minString = [self timeStringForDate:self.minimumTime];
    NSString *maxString = [self timeStringForDate:maxTime];
    if(minString&&[minString compare:maxString]==NSOrderedDescending)
    {
        return;
    }
    _maxTime = maxTime;
    NSString *timeString = [self timeStringForDate:self.time];
    if(timeString&&[timeString compare:maxString] ==NSOrderedDescending)
    {
        self.time = maxTime;
    }
    
}


//根据时间，将pickView跳转到指定row
- (BOOL)selectTime:(NSDate*)time
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH"];
    self.currentHour = [df stringFromDate:time];
    [self selectHour:self.currentHour];
    [df setDateFormat:@"mm"];
    self.currentMinute = [df stringFromDate:time];
    [self selectMinute:self.currentMinute];
    return YES;
}



//根据hour将pickView跳转到指定row
- (BOOL)selectHour:(NSString*)hour
{
    for (NSInteger i = 0; i < [self.hoursList count]; i++) {
        NSString *nowHour = self.hoursList[i];
        if([nowHour isEqualToString:hour])
        {
            NSInteger row = i%[self.hoursList count] +  [self.hoursList count]*MAX_SCROLL;
            [self.datePicker selectRow:row inComponent:0 animated:YES];
            return YES;
        }
    }
    return NO;
    
}
//根据minute将pickView跳转到指定row
- (BOOL)selectMinute:(NSString*)minute
{
    for (NSInteger i = 0; i < [self.minutesList count]; i++) {
        NSString *nowHour = self.minutesList[i];
        if([nowHour isEqualToString:minute])
        {
            NSInteger row = i%[self.minutesList count] +  [self.minutesList count]*MAX_SCROLL;
            [self.datePicker selectRow:row inComponent:1 animated:YES];
            return YES;
        }
    }
    return NO;
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)return [self.hoursList count]*MAX_SCROLL*2;
    if(component == 1)return [self.minutesList count]*MAX_SCROLL*2;
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return self.hoursList[row%[self.hoursList count]];
    }
    if(component == 1)
    {
        return self.minutesList[row%[self.minutesList count]];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //循环显示
    NSInteger count = 0;
    if(component == 0)
    {
        count = [self.hoursList count];
        self.currentHour = self.hoursList[row%count];
    }
    else
    {
        count = [self.minutesList count];
        self.currentMinute = self.minutesList[row%count];
    }
    [pickerView selectRow:(row%count + count*MAX_SCROLL) inComponent:component animated:NO];
    NSString *dateString = [NSString stringWithFormat:@"%@ %@:%@",self.currentDay,self.currentHour,self.currentMinute];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *time = [df dateFromString:dateString];
    NSString *timeString = [self timeStringForDate:time];
    NSString *minString = [self timeStringForDate:self.minimumTime];
    NSString *maxString = [self timeStringForDate:self.maxTime];
    
    if([timeString compare:minString]== NSOrderedAscending)
    {
        [self selectTime:self.minimumTime];
        _time = self.minimumTime;
    }
    else if([timeString compare:maxString]== NSOrderedDescending)
    {
        [self selectTime:self.maxTime];
        _time = self.maxTime;
    }
    else
    {
        _time = time;
    }
    if(self.changedBlock)
    {
        self.changedBlock();
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    if(self.titleColor)
    {
       pickerLabel.textColor = self.titleColor;
    }
    else
    {
        pickerLabel.textColor = [UIColor blueColor];
    }
    return pickerLabel;
    
}












@end
