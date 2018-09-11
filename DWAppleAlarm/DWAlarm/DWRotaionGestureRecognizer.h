//
//  DWRotaionGestureRecognizer.h
//  DWAppleAlarm
//
//  Created by lg on 2018/9/7.
//  Copyright © 2018年 lg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWRotaionGestureRecognizerDelegate<NSObject>

@optional
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface DWRotaionGestureRecognizer : UIGestureRecognizer

/** 初始化 center：旋转中心点 */
- (instancetype)initWithCenter:(CGPoint)center;
/** 旋转偏移值 */
- (CGFloat)rotation;
/** 起始点 */
-(CGPoint)beginPoint;

@property (nonatomic,weak) id<DWRotaionGestureRecognizerDelegate> rotaionGestureRecognizerDelegate;

@end
