//
//  DWAlarmView.h
//  DWAppleAlarm
//
//  Created by lg on 2018/9/4.
//  Copyright © 2018年 lg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWAlarmViewDelegate<NSObject>

-(void)alramViewIsChangedWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime;

@end

@interface DWAlarmView : UIView

/** 圆环颜色 Default UIColor.orangeColor */
@property (nonatomic,strong) UIColor *circularingColor;

-(instancetype)initWithFrame:(CGRect)frame startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;
-(void)beiginRotationWithAngle:(CGFloat)angle beiginPiont:(CGPoint)point;
/** 改变起始时间 */
-(void)changeStartAngle:(CGFloat)startAngle;
/** 改变结束时间 */
-(void)changeEndAngle:(CGFloat)endAngle;
/** 改变圆环位置 */
-(void)changeCircularingLocation:(CGFloat)angle;

@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,weak) id<DWAlarmViewDelegate> delegate;

@end
