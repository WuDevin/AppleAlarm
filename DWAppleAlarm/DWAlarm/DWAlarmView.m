//
//  DWAlarmView.m
//  DWAppleAlarm
//
//  Created by lg on 2018/9/4.
//  Copyright © 2018年 lg. All rights reserved.
//

#import "DWAlarmView.h"
#import "UIView+DWAngle.h"
#import "DWRotaionGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


#define kIconViewHW  40
#define kAlarmViewRadius self.bounds.size.width/2
#define kDgreesToRadoans(x) (M_PI * (x) / 180.0) // 将角度转为弧度
#define kAlarmViewWH CGRectGetWidth(self.bounds)

/** 旋转类型 */
typedef NS_ENUM(NSInteger, kRotationType) {
    
    kRotationType_StartAngle = 1,//改变起始角度
    kRotationType_EndAngle = 2,//改变结束角度
    kRotationType_CircularingLocation = 3,//改变圆环位置
    kRotationType_None = 4,//无旋转
};


@interface DWAlarmView()<DWRotaionGestureRecognizerDelegate>
{
    float _currentStartAngle;/** 当前开始角度 */
    float _currentEndAngle;/** 当前结束角度 */
}

@property (nonatomic,strong) UIView *alarmView;
@property (nonatomic,strong) UIView *ringSuperView;
@property (nonatomic,strong) UIView *sleepSuperView;
@property (nonatomic,strong) UIImageView *ringView;
@property (nonatomic,strong) UIImageView *sleepView;
@property (nonatomic,strong) UIImageView *timeView;
@property (nonatomic,strong) CAShapeLayer *alramLayer;

/** 开始角度 Default 0 */
@property (nonatomic,assign) CGFloat startAngle;
/** 结束角度 Default 0 */
@property (nonatomic,assign) CGFloat endAngle;

@property (nonatomic,strong) UILabel *costTimeLbl;

@property (nonatomic,strong) DWRotaionGestureRecognizer *gestureRecognizer;

@property (nonatomic,assign) kRotationType rotationType;


@end


@implementation DWAlarmView


#pragma mark - Init                         - Method -
-(instancetype)initWithFrame:(CGRect)frame startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle{
    
    if (self = [super initWithFrame:frame]) {
        self.startAngle = startAngle;
        self.endAngle = endAngle;
        _currentStartAngle = startAngle;
        _currentEndAngle = endAngle;
        self.circularingColor = UIColor.orangeColor;
        [self setupSubViews];
        [self configure];
    }
    return self;
}

#pragma mark - setupSubView                 - Method -
-(void)setupSubViews{
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.bounds = CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height);;
    layer.path = [self drawAlarmPathWithStartAngle:0 endAngle:360].CGPath;
    layer.fillColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:1].CGColor;
    [self.layer addSublayer:layer];
    
    [self.alarmView.layer addSublayer:self.alramLayer];
    self.alarmView.transform = CGAffineTransformMakeRotation(-M_PI/2);

    [self addSubview:self.alarmView];
    [self addSubview:self.sleepSuperView];
    [self addSubview:self.ringSuperView];
    [self addSubview:self.timeView];
    [self addSubview:self.costTimeLbl];
    
    [self.ringSuperView addSubview:self.ringView];
    [self.sleepSuperView addSubview:self.sleepView];
    
}

#pragma mark - Initialize                   - Method -
-(void)configure{
    
    self.gestureRecognizer = [[DWRotaionGestureRecognizer alloc] initWithCenter:self.alarmView.center];
    self.gestureRecognizer.rotaionGestureRecognizerDelegate = self;
    [self.gestureRecognizer addTarget:self action:@selector(rotationAction:)];
    [self addGestureRecognizer:self.gestureRecognizer];
    
    [self changeStartAngle:0];
    [self changeEndAngle:0];
}

#pragma mark - eventResponse                - Method -
- (void)rotationAction:(DWRotaionGestureRecognizer *)gestureRec {
    
    NSLog(@"旋转角度 == %f",-[gestureRec rotation]*180/M_PI);
    [self beiginRotationWithAngle:(-[gestureRec rotation]*180/M_PI) beiginPiont:[gestureRec beginPoint]];
    
}

#pragma mark - Method                  - Method -
-(void)beiginRotationWithAngle:(CGFloat)angle beiginPiont:(CGPoint)point{
    
    switch (self.rotationType) {
        case kRotationType_StartAngle:
            [self changeStartAngle:angle];
            break;
        case kRotationType_EndAngle:
            [self changeEndAngle:angle];
            break;
        case kRotationType_CircularingLocation:
            [self changeCircularingLocation:angle];
            break;
        default:
         break;
    }
}

/** 改变起始时间 */
-(void)changeStartAngle:(CGFloat)startAngle{
      NSLog(@"角度差 = %f",fabs(self.endAngle - self.startAngle - startAngle));
    if (fabs(self.endAngle - self.startAngle - startAngle) >360) {//修复BUG
        if (startAngle > 0) {
            startAngle = startAngle -360;
        }else{
            startAngle = startAngle +360;
        }
    }
    NSLog(@"角度差2 = %f",fabs(self.endAngle - self.startAngle - startAngle));
   self.sleepSuperView.transform = CGAffineTransformMakeRotation(kDgreesToRadoans(self.startAngle+startAngle));//公转
   self.sleepView.transform = CGAffineTransformMakeRotation(-kDgreesToRadoans(self.startAngle+startAngle));//自转
   self.alramLayer.path = [self drawAlarmPathWithStartAngle:startAngle+self.startAngle endAngle:self.endAngle].CGPath;
    
}

/** 改变结束时间 */
-(void)changeEndAngle:(CGFloat)endAngle{
    
    if (fabs(self.startAngle - self.endAngle - endAngle) >360) {
        if (endAngle > 0) {
            endAngle = endAngle -360;
        }else{
            endAngle = endAngle +360;
        }
    }
     NSLog(@"角度差 = %f",fabs(self.endAngle - self.startAngle - endAngle));
    self.ringSuperView.transform = CGAffineTransformMakeRotation(kDgreesToRadoans(self.endAngle+endAngle));
    self.ringView.transform = CGAffineTransformMakeRotation(-kDgreesToRadoans(self.endAngle+endAngle));
    self.alramLayer.path = [self drawAlarmPathWithStartAngle:self.startAngle endAngle:self.endAngle+endAngle].CGPath;
}

/** 改变圆环位置 */
-(void)changeCircularingLocation:(CGFloat)angle{
    
    self.sleepSuperView.transform = CGAffineTransformMakeRotation(kDgreesToRadoans(self.startAngle+angle));//公转
    self.sleepView.transform = CGAffineTransformMakeRotation(-kDgreesToRadoans(self.startAngle+angle));//自转
    self.ringSuperView.transform = CGAffineTransformMakeRotation(kDgreesToRadoans(self.endAngle+angle));
    self.ringView.transform = CGAffineTransformMakeRotation(-kDgreesToRadoans(self.endAngle+angle));
    self.alramLayer.path = [self drawAlarmPathWithStartAngle:self.startAngle+angle endAngle:self.endAngle +angle].CGPath;
}

/** 旋转类型 */
-(kRotationType)rotationTypeWithPiont:(CGPoint)piont{
    
    CGPoint alarmViewCenter = CGPointMake(kAlarmViewRadius, kAlarmViewRadius);
    CGPoint startCenter = CGPointMake(cos(((_currentStartAngle-90)/180)*M_PI)*(kAlarmViewRadius-kIconViewHW/2) +kAlarmViewRadius, sin(((_currentStartAngle-90)/180)*M_PI)*(kAlarmViewRadius-kIconViewHW/2) +kAlarmViewRadius);
    CGPoint endCenter = CGPointMake(cos(((_currentEndAngle-90)/180)*M_PI)*(kAlarmViewRadius-kIconViewHW/2) +kAlarmViewRadius, sin(((_currentEndAngle-90)/180)*M_PI)*(kAlarmViewRadius-kIconViewHW/2) +kAlarmViewRadius);
    
    if ([UIView distanceBetweenPointA:alarmViewCenter AndPiontB:piont] >= kAlarmViewRadius-kIconViewHW && [UIView distanceBetweenPointA:alarmViewCenter AndPiontB:piont] <= kAlarmViewRadius) {
        if ([UIView distanceBetweenPointA:startCenter AndPiontB:piont] < kIconViewHW/2) {
            return kRotationType_StartAngle;
        }else if ([UIView distanceBetweenPointA:endCenter AndPiontB:piont] < kIconViewHW/2){
            return kRotationType_EndAngle;
        }else{
            return kRotationType_CircularingLocation;
        }
    }
    return kRotationType_None;
}

/** 绘制BezierPath */
-(UIBezierPath *)drawAlarmPathWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle{
    
    CGRect circleRect = CGRectMake(kAlarmViewRadius,kAlarmViewRadius, self.bounds.size.width, self.bounds.size.height);
    UIBezierPath* circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter: CGPointMake(CGRectGetMidX(circleRect), CGRectGetMidY(circleRect)) radius: circleRect.size.width/2 startAngle: kDgreesToRadoans(startAngle) endAngle: kDgreesToRadoans(endAngle) clockwise: YES];
    [circlePath addLineToPoint: CGPointMake(CGRectGetMidX(circleRect), CGRectGetMidY(circleRect))];
    [circlePath closePath];
    
    _currentStartAngle = fmodf(startAngle,360);
    _currentEndAngle = fmodf(endAngle, 360);
    
    self.costTimeLbl.attributedText = [self timeBlockWithAngle:_currentEndAngle - _currentStartAngle];
    self.beginTime = [self beginTimeWithAngle:_currentStartAngle];
    self.endTime = [self endTimeWithAngle:_currentEndAngle];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alramViewIsChangedWithBeginTime:endTime:)]) {
        [self.delegate alramViewIsChangedWithBeginTime:self.beginTime endTime:self.endTime];
    }
    return circlePath;
}

-(NSString *)beginTimeWithAngle:(CGFloat)angle{
    
    angle = angle < 0 ? fmodf(720+angle, 360): fmodf(angle, 360);
    int hour;
    int minute;
    if (fabs(angle) < 30) {
        hour = 0;
        minute = angle/30*60;
    }else{
        hour = angle/30;
        minute = fmodf(angle,30)/30 *60;
    }
    
    hour = hour%12 < 0 ? (48+hour)%12 :hour%12;
    minute = minute%60 < 0 ? (120+minute)%60 :minute%60;
    
   return [NSString stringWithFormat:@"%02d:%02d",hour,minute];
   
}

-(NSString *)endTimeWithAngle:(CGFloat)angle{
    angle = angle < 0 ? fmodf(720+angle, 360): fmodf(angle, 360);
    int hour;
    int minute;
    if (fabs(angle) < 30) {
        hour = 0;
        minute = angle/30*60;
    }else{
        hour = angle/30;
        minute = fmodf(angle,30)/30 *60;
    }
    
    hour = hour%12 < 0 ? (48+hour)%12 :hour%12;
    minute = minute%60 < 0 ? (120+minute)%60 :minute%60;
    
    return [NSString stringWithFormat:@"%02d:%02d",hour,minute];
   
}

-(NSAttributedString *)timeBlockWithAngle:(float)angle{
    
    angle = angle < 0 ? fmodf(720+angle, 360): fmodf(angle, 360);
    int hour;
    int minute;
    if (fabs(angle) < 30) {
        hour = 0;
        minute = angle/30*60;
    }else{
        hour = angle/30;
        minute = fmodf(angle,30)/30 *60;
    }
    
    hour = hour%12 < 0 ? (48+hour)%12 :hour%12;
    minute = minute%60 < 0 ? (120+minute)%60 :minute%60;
    NSLog(@"%d小时 %d分钟",hour ,minute);
    return [self attributeStringWithHour:hour minute:minute];
}


-(NSAttributedString *)attributeStringWithHour:(int)hour minute:(int)minute{
    
    //初始化NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
    //设置字体格式和大小
    NSDictionary *dictAttr0 = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSDictionary *dictAttr1 = @{NSFontAttributeName:[UIFont systemFontOfSize:25],
                                NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSAttributedString *attr0 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %2d",hour] attributes:dictAttr1];
    NSAttributedString *attr1 = [[NSAttributedString alloc]initWithString:@" 小时" attributes:dictAttr0];
    NSAttributedString *attr2 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %2d",minute] attributes:dictAttr1];
    NSAttributedString *attr3 = [[NSAttributedString alloc]initWithString:@" 分钟" attributes:dictAttr0];
    [attributedString appendAttributedString:attr0];
    [attributedString appendAttributedString:attr1];
    [attributedString appendAttributedString:attr2];
    [attributedString appendAttributedString:attr3];
    return attributedString;
}


#pragma mark - customDelegate               - Method -
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    CGPoint startPiont = [[touches anyObject] locationInView:self];
    NSLog(@"%f--%f",startPiont.x,startPiont.y);
    
    self.rotationType = [self rotationTypeWithPiont:startPiont];
    
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.rotationType = kRotationType_None;
    self.startAngle = _currentStartAngle;
    self.endAngle = _currentEndAngle;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.rotationType = kRotationType_None;
    self.startAngle = _currentStartAngle;
    self.endAngle = _currentEndAngle;
}

#pragma mark - getters and setters          - Method -
-(void)setCircularingColor:(UIColor *)circularingColor{
    _circularingColor = circularingColor;
    self.alramLayer.fillColor = UIColor.orangeColor.CGColor;
}

-(CAShapeLayer *)alramLayer{
    
    if (!_alramLayer) {
        _alramLayer = [[CAShapeLayer alloc] init];
         _alramLayer.bounds = CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height);
        _alramLayer.path = [self drawAlarmPathWithStartAngle:self.startAngle endAngle:self.endAngle].CGPath;
        _alramLayer.fillColor = UIColor.orangeColor.CGColor;
    }
    return _alramLayer;
}

-(UIImageView *)ringView{
    
    if (!_ringView) {
        _ringView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kIconViewHW, kIconViewHW)];
        _ringView.center = CGPointMake(cos((self.endAngle/180)*M_PI)*(kAlarmViewRadius-kIconViewHW/2) +kAlarmViewRadius, sin((self.endAngle/180)*M_PI)*(kAlarmViewRadius-kIconViewHW/2) +kAlarmViewRadius);
        _ringView.center = CGPointMake(kAlarmViewRadius,kIconViewHW/2);
        _ringView.image = [UIImage imageNamed:@"ring"];
    }
    return _ringView;
}

-(UIImageView *)sleepView{
    
    if (!_sleepView) {
        _sleepView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconViewHW, kIconViewHW)];
//        _sleepView.center =  CGPointMake(cos((self.startAngle/180)*M_PI)*(kAlarmViewRadius-kIconViewHW/2) +kAlarmViewRadius, sin((self.startAngle/180)*M_PI)*(kAlarmViewRadius-kIconViewHW/2) +kAlarmViewRadius);
        _sleepView.center = CGPointMake(kAlarmViewRadius,kIconViewHW/2);
        _sleepView.image = [UIImage imageNamed:@"sleepTime"];
    }
    return _sleepView;
}

-(UIImageView *)timeView{
    
    if (!_timeView) {
        _timeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kAlarmViewRadius -kIconViewHW)*2,  (kAlarmViewRadius -kIconViewHW)*2)];
        _timeView.center =  CGPointMake(kAlarmViewRadius, kAlarmViewRadius);
        _timeView.image = [UIImage imageNamed:@"clock"];
    }
    return _timeView;
}


-(UIView *)ringSuperView{
    
    if (!_ringSuperView) {
        _ringSuperView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _ringSuperView;
}

-(UIView *)sleepSuperView{
    
    if (!_sleepSuperView) {
        _sleepSuperView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _sleepSuperView;
}

-(UIView *)alarmView{
    
    if (!_alarmView) {
        _alarmView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _alarmView;
}

-(UILabel *)costTimeLbl{
    
    if (!_costTimeLbl) {
        _costTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        _costTimeLbl.center =  CGPointMake(kAlarmViewRadius, kAlarmViewRadius);
        _costTimeLbl.numberOfLines = 1;
        _costTimeLbl.textColor =[UIColor whiteColor];
        _costTimeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _costTimeLbl;
}


@end
