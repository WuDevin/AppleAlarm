//
//  ViewController.m
//  DWAppleAlarm
//
//  Created by lg on 2018/9/4.
//  Copyright © 2018年 lg. All rights reserved.
//

#import "ViewController.h"
#import "DWAlarmView.h"

@interface ViewController ()<DWAlarmViewDelegate>

@property (nonatomic,strong) DWAlarmView *alarmView;
@property (nonatomic,strong) UILabel *beginTimeLbl;
@property (nonatomic,strong) UILabel *endTimeLbl;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self addAlarmView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addAlarmView{
    
    self.alarmView = [[DWAlarmView alloc] initWithFrame:CGRectMake(40,200, 350, 350) startAngle:45 endAngle:90];
    self.alarmView.center = self.view.center;
    self.alarmView.alpha = 1;
    self.alarmView.backgroundColor = [UIColor clearColor];
    self.alarmView.delegate = self;
    [self.view addSubview:self.alarmView];
    
    UILabel *beginLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x -130, 100, 120, 30)];
    beginLbl.text = @"开始时间";
    beginLbl.numberOfLines = 1;
    beginLbl.textColor = [UIColor whiteColor];
    beginLbl.font = [UIFont boldSystemFontOfSize:22];;
    beginLbl.textAlignment = 1;
    [self.view addSubview:beginLbl];

    UILabel *endLbl =  [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x +10, 100, 120, 30)];
    endLbl.text = @"结束时间";
    endLbl.numberOfLines = 1;
    endLbl.textColor = [UIColor whiteColor];
    endLbl.font = [UIFont boldSystemFontOfSize:22];;
    endLbl.textAlignment = 1;
    [self.view addSubview:endLbl];

    self.beginTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x -130, 140, 120, 25)];
    self.beginTimeLbl.text = self.alarmView.beginTime;
    self.beginTimeLbl.numberOfLines = 1;
    self.beginTimeLbl.textColor = [UIColor whiteColor];
    self.beginTimeLbl.font = [UIFont systemFontOfSize:20];;
    self.beginTimeLbl.textAlignment = 1;
    [self.view addSubview:self.beginTimeLbl];

    self.endTimeLbl =  [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x +10, 140, 120, 25)];
    self.endTimeLbl.text = self.alarmView.endTime;
    self.endTimeLbl.numberOfLines = 1;
    self.endTimeLbl.textColor = [UIColor whiteColor];
    self.endTimeLbl.font = [UIFont systemFontOfSize:20];;
    self.endTimeLbl.textAlignment = 1;
    [self.view addSubview:self.endTimeLbl];
}

-(void)alramViewIsChangedWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime{
    
    self.beginTimeLbl.text = beginTime;
    self.endTimeLbl.text = endTime;
}




@end
